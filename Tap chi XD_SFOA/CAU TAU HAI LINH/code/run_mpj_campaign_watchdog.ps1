# run_mpj_campaign_watchdog.ps1
# ============================================================
# Resilience wrapper for the MPJ campaign (2026-08-17).
# Keeps relaunching SOO_MPJ_run.m (runMode='campaign') until every run
# of both objectives (Cost, Displacement) is complete, surviving:
#   - a MATLAB/SAP2000 crash or forced kill (relaunches automatically)
#   - a machine reboot from a power outage (IF this script is triggered
#     again -- see the paired Task Scheduler "at log on" entry; this
#     script itself is idempotent so re-running it from scratch after a
#     reboot just continues from wherever the .mat files say we are)
#
# Data-loss guarantee this depends on (see SOO_MPJ_run.m 2026-08-17
# changes): each run's final .mat is written atomically (tmp+rename) and
# a run already on disk is skipped instead of redone; a mid-run
# checkpoint (every 20 iterations, also atomic) lets an interrupted run
# resume instead of restarting from iteration 1. So no matter when this
# process or the machine dies, at most ~20 iterations of the ONE run in
# progress are lost -- never any of the already-completed runs.
#
# Gated by a flag file so this is inert until the campaign is actually
# started (registering the Task Scheduler entry ahead of time is safe).
# ============================================================
param(
    [int]$Nrun = 30
)

$codeDir   = "D:\ResearchLab\02_Projects\02_Projects\Tap chi XD_SFOA\code"
$mpjDir    = Join-Path $codeDir "SOO_MPJ"
$resultsDir= Join-Path $mpjDir "results"
$matlab    = "C:\Program Files\MATLAB\R2023b\bin\matlab.exe"
$flagFile  = Join-Path $codeDir "CAMPAIGN_ACTIVE.flag"
$doneFlag  = Join-Path $codeDir "CAMPAIGN_DONE.flag"
$wdLog     = Join-Path $codeDir "mpj_campaign_watchdog_log.txt"

function Log($msg) {
    $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $msg"
    Add-Content -Path $wdLog -Value $line
    Write-Output $line
}

if (-not (Test-Path $flagFile)) {
    Log "Flag file $flagFile not found -- campaign not active, watchdog exiting (no-op)."
    exit 0
}
if (Test-Path $doneFlag) {
    Log "Done-flag $doneFlag already present -- campaign already completed, watchdog exiting (no-op)."
    exit 0
}

function Count-Done($objName) {
    $pattern = Join-Path $resultsDir "MPJ_SOO_${objName}_run*_CAMPAIGN.mat"
    return (Get-ChildItem -Path $pattern -ErrorAction SilentlyContinue | Measure-Object).Count
}

$cases = @(
    @{ ObjCol = 1; ObjName = "Cost" },
    @{ ObjCol = 2; ObjName = "Displacement" }
)

Log "=== Watchdog session start (Nrun target=$Nrun) ==="

foreach ($c in $cases) {
    $objCol = $c.ObjCol
    $objName = $c.ObjName
    $consecutiveNoProgress = 0

    while ($true) {
        $done = Count-Done $objName
        if ($done -ge $Nrun) {
            Log "Case $objName COMPLETE: $done/$Nrun runs on disk."
            break
        }
        Log "Case ${objName}: $done/$Nrun done so far. Launching MATLAB (Nrun=$Nrun, runIdOffset=0 -- script auto-skips completed runs and resumes any mid-run checkpoint)."

        $cmd = "objCol=$objCol; runMode='campaign'; Nrun=$Nrun; runIdOffset=0; run('SOO_MPJ_run.m')"
        $stdout = Join-Path $codeDir "mpj_campaign_${objName}_stdout.txt"
        $stderr = Join-Path $codeDir "mpj_campaign_${objName}_stderr.txt"

        # IMPORTANT (found 2026-08-17): Windows PowerShell 5.1's Start-Process
        # -ArgumentList, when given an ARRAY (e.g. @("-batch", $cmd)), just
        # space-joins the elements into one string WITHOUT re-quoting each
        # one -- unlike .NET Core's ProcessStartInfo.ArgumentList. Since $cmd
        # itself contains spaces (after each ";"), the joined string gets
        # re-split by Windows' own whitespace-based argv parsing into many
        # separate arguments, so matlab.exe's -batch only ever received the
        # first fragment (e.g. "objCol=1;") and silently exited after ~12s
        # with no output and exit code 0 -- looked like a clean run of
        # nothing. Fix: pass ONE pre-quoted string so -batch gets the whole
        # command as a single token.
        $argStr = "-batch `"$cmd`""
        $proc = Start-Process -FilePath $matlab -ArgumentList $argStr `
            -WorkingDirectory $mpjDir -PassThru -Wait -WindowStyle Hidden `
            -RedirectStandardOutput $stdout -RedirectStandardError $stderr

        $exitCode = $proc.ExitCode
        $doneAfter = Count-Done $objName
        Log "MATLAB exited (code=$exitCode) for $objName. Runs now: $doneAfter/$Nrun."

        if ($doneAfter -le $done) {
            $consecutiveNoProgress++
            Log "WARNING: no new completed run from this launch (consecutive no-progress attempts: $consecutiveNoProgress)."
            if ($consecutiveNoProgress -ge 5) {
                Log "ERROR: 5 consecutive launches made zero progress on $objName -- stopping to avoid a crash loop. This looks like a real bug, not a transient interruption. Manual investigation needed (check $stderr)."
                exit 1
            }
            Start-Sleep -Seconds 30
        } else {
            $consecutiveNoProgress = 0
        }
    }
}

Log "=== ALL CASES COMPLETE (Cost + Displacement, $Nrun runs each) ==="
Rename-Item -Path $flagFile -NewName (Split-Path $doneFlag -Leaf) -Force
Log "Flag renamed to $doneFlag -- future reboots/logons will no-op."
