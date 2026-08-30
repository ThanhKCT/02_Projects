# watchdog_test_timing.ps1 -- adapted from code/SOO_Ke/run_sap_watchdog.ps1.
# This session's failure mode differs from that script's target (COM hang
# with FLAT CPU): here, SAP2000 sits in OpenFile with CPU actively climbing
# but memory ballooning to several GB without ever completing -- observed
# repeatedly today, cause not fully diagnosed (does not reproduce for
# precompute_wall_setup.m / verify_grouped_model.m opening the SAME file,
# only for test_timing.m; suspected cumulative COM/session state after many
# SAP2000 launches in a short window, not the script itself). So this
# watchdog kills on LOW FREE RAM regardless of CPU activity, not just on
# flat CPU, and gives each attempt a hard wall-clock cap.
param(
    [int]$PollSeconds = 20,
    [double]$MinFreeGB = 2.5,
    [int]$MaxAttemptSeconds = 400,
    [int]$MaxRestarts = 15
)
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptDir
$LogPath = Join-Path $ScriptDir 'test_timing_log.txt'
$DebugPath = Join-Path $ScriptDir 'sapkesau_debug.txt'
$WatchdogLog = Join-Path $ScriptDir 'watchdog_test_timing.log'

function Log($msg) {
    $line = "[{0}] {1}" -f (Get-Date -Format 'HH:mm:ss'), $msg
    Add-Content -Path $WatchdogLog -Value $line
}
function KillAll {
    Get-Process SAP2000 -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Get-Process MATLAB -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Get-Process matlab -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 3
}

Log "=== watchdog_test_timing start ==="
Remove-Item -Path $LogPath -ErrorAction SilentlyContinue
Remove-Item -Path $DebugPath -ErrorAction SilentlyContinue
KillAll

$restarts = 0
while ($true) {
    if ($restarts -ge $MaxRestarts) {
        Log "MaxRestarts ($MaxRestarts) exceeded -- giving up."
        exit 1
    }
    KillAll
    $matlabCmd = "addpath('D:\ResearchLab\04_Tap chi trong nc\Truong CTT 51\code\Functions'); addpath('D:\ResearchLab\04_Tap chi trong nc\Truong CTT 51\Ke sau cau\code\SOO_KeSauCau\Ke_Sap'); test_timing"
    $argStr = "-batch `"$matlabCmd`""
    Log "Launching MATLAB (attempt $($restarts+1))"
    $proc = Start-Process -FilePath 'C:\Program Files\MATLAB\R2023b\bin\matlab.exe' -ArgumentList $argStr `
        -WorkingDirectory $ScriptDir -PassThru -WindowStyle Hidden
    $restarts++
    $attemptStart = Get-Date

    while ($true) {
        Start-Sleep -Seconds $PollSeconds
        $elapsed = ((Get-Date) - $attemptStart).TotalSeconds

        if (Test-Path $LogPath) {
            $content = Get-Content $LogPath -Raw -ErrorAction SilentlyContinue
            if ($content -and $content.Contains('DONE OK')) {
                Log "SUCCESS: test_timing_log.txt shows DONE OK."
                Start-Sleep -Seconds 3  # let MATLAB exit cleanly
                exit 0
            }
        }

        $matlabAlive = (Get-Process MATLAB -ErrorAction SilentlyContinue) -or (Get-Process matlab -ErrorAction SilentlyContinue)
        if (-not $matlabAlive) {
            Log "MATLAB process ended without DONE OK marker (crashed/errored) -- will relaunch."
            break
        }

        $freeGB = [math]::Round((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory/1MB, 2)
        Log "poll: elapsed=$([math]::Round($elapsed))s freeGB=$freeGB"
        if ($freeGB -lt $MinFreeGB) {
            Log "Free RAM too low ($freeGB GB < $MinFreeGB GB) -- killing and restarting."
            break
        }
        if ($elapsed -gt $MaxAttemptSeconds) {
            Log "Attempt exceeded $MaxAttemptSeconds s wall-clock -- killing and restarting."
            break
        }
    }
}
