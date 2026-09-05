# watchdog_run.ps1 -- generic version of watchdog_test_timing.ps1, takes the
# MATLAB script name + its own log file + success marker as parameters so
# the same watchdog covers precompute_wall_setup.m, test_timing.m, etc.
# See watchdog_test_timing.ps1's header comment for the failure mode this
# targets (OpenFile ballooning SAP2000 memory with climbing-not-flat CPU).
param(
    [Parameter(Mandatory=$true)][string]$MFile,
    [Parameter(Mandatory=$true)][string]$LogFileName,
    [string]$SuccessMarker = 'DONE OK',
    [int]$PollSeconds = 20,
    [double]$MinFreeGB = 2.5,
    [int]$MaxAttemptSeconds = 400,
    [int]$MaxRestarts = 15,
    # 2026-08-29 (may nay): mac dinh doi sang 'matlab -r' thay cho '-batch'.
    # Ly do: Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md muc 6.6 (du an
    # Wharf100DWT, 27/08/2026) ghi nhan '-batch' lam COM STA cua SAP2000 OAPI
    # (SM.*) crash im lang, khong on dinh, khong log -- do -batch khong chay
    # Windows message pump ma COM STA can. '-batch' tung "on dinh" o du an Ke
    # sau cau nay TRUOC KHI phat hien loi tren -- can kiem chung lai bang mot
    # script nho (vd test_timing.m) truoc khi tin tuong cho campaign lon.
    # Dat -UseLegacyBatch de quay lai '-batch' cu neu '-r' gay van de moi.
    [switch]$UseLegacyBatch,
    # 2026-08-30: phat hien file .sdb TU THOAI HOA sau nhieu gio RunAnalysis
    # lien tuc (nhieu attempt, hang gio) -- OpenFile treo vo han (CPU dung
    # yen, khong loi, khong crash) tren file .sdb "gia" nay, nhung mo lai
    # NGAY LAP TUC (~3s) khi phuc hoi tu ban backup .sbk cua chinh SAP2000
    # (tao tu dong sau lan luu/dong sach truoc do). Khong lien quan gi den
    # viec kill process (da loai tru bang thuc nghiem: cho hang phut sau
    # kill van treo y het, phuc hoi file moi la thu thuc su het).
    # Neu 2 tham so nay duoc dat, watchdog se COPY $SdbBaselinePath DE
    # $SdbTargetPath TRUOC MOI LAN launch (khong chi lan dau) -- dam bao moi
    # attempt luon mo mot ban .sdb "sach" bat ke da chay bao nhieu gio truoc
    # do. State cua SFOA (Xpos/checkpoint) nam rieng trong file .mat, khong
    # phu thuoc noi dung .sdb (SetShell_1 luon ghi de truoc RunAnalysis) nen
    # ghi de .sdb truoc moi attempt la an toan.
    [string]$SdbBaselinePath = '',
    [string]$SdbTargetPath = ''
)
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptDir
$LogPath = Join-Path $ScriptDir $LogFileName
$WatchdogLog = Join-Path $ScriptDir "watchdog_$MFile.log"

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

Log "=== watchdog_run start ($MFile) ==="
Remove-Item -Path $LogPath -ErrorAction SilentlyContinue
KillAll

$restarts = 0
while ($true) {
    if ($restarts -ge $MaxRestarts) {
        Log "MaxRestarts ($MaxRestarts) exceeded -- giving up."
        KillAll
        exit 1
    }
    KillAll
    if ($SdbBaselinePath -and $SdbTargetPath) {
        Copy-Item -Path $SdbBaselinePath -Destination $SdbTargetPath -Force
        Log "Restored .sdb from pristine baseline before this attempt."
        # 2026-09-04: ALSO delete stale analysis-RESULT byproduct files that
        # share $SdbTargetPath's base name. Root cause found this date: the
        # earlier assumption ("baseline .sdb itself carries an incompatible-
        # results flag") was WRONG -- opening PRISTINE_BASELINE.sdb directly
        # in an independent SAP2000 instance returned ret=0 immediately, no
        # dialog. The REAL cause is that SAP2000 regenerates a set of
        # analysis-result byproduct files (.K_0/.K_I/.K_J/.K_M/.LOG/.OUT/.Y/
        # .Y$$/.Y00-.Y03/.Y_/.Y_1/.msh) matching whatever model state was
        # last RunAnalysis'd under this SAME base name (ke pd 10.*) -- if a
        # crash/restart happens, those files linger from the PRE-crash model
        # state while this Copy-Item just overwrote .sdb back to the
        # baseline's (different) state. SAP2000's own OpenFile then finds
        # results present but not flagged compatible with the just-restored
        # model and raises a native modal "recover these results?" dialog --
        # this BLOCKS unattended automation indefinitely (watchdog has no
        # way to answer it; confirmed to hang past MaxAttemptSeconds). This
        # is NOT limited to the first restore -- it can recur on EVERY
        # future restart unless these byproducts are cleared each time.
        # Deleting them here forces a from-scratch analysis with nothing to
        # flag. Does NOT touch .s2k/.$2k/.sbk/.ico (not result byproducts).
        $targetBase = Join-Path (Split-Path $SdbTargetPath -Parent) ([System.IO.Path]::GetFileNameWithoutExtension($SdbTargetPath))
        $resultExts = @('K_0','K_I','K_J','K_M','LOG','OUT','Y','Y$$','Y00','Y01','Y02','Y03','Y_','Y_1','msh')
        foreach ($ext in $resultExts) {
            $p = "$targetBase.$ext"
            if (Test-Path $p) { Remove-Item -Path $p -Force -ErrorAction SilentlyContinue }
        }
        Log "Cleared stale analysis-result byproduct files for '$targetBase.*' (prevents the incompatible-results dialog on this OpenFile)."
    }
    # Duong dan may nay (khac may cu "Truong CTT 51" da khong con ton tai):
    # thu vien ham SFOA (Functions/) nam o project chi em "CAU TAU HAI LINH".
    $addpaths = "addpath('D:\ResearchLab\02_Projects\02_Projects\Tap chi XD_SFOA\CAU TAU HAI LINH\code\Functions'); addpath('D:\ResearchLab\02_Projects\02_Projects\Tap chi XD_SFOA\KE SAU CAU\code\SOO_KeSauCau\Ke_Sap');"
    if ($UseLegacyBatch) {
        $argStr = "-batch `"$addpaths $MFile`""
    } else {
        # '-r' khong tu exit sau khi chay xong nhu '-batch' -- phai them exit.
        # QUAN TRONG (kiem chung 2026-08-29): goi script kieu bareword co duoi
        # '.m' (vd "test_timing.m;") TREO VO HAN duoi '-r' che do desktop day
        # du -- MATLAB dung o dung truoc khi chay dong dau tien cua script,
        # khong loi, khong crash, RAM on dinh (khac han '-batch', noi cu phap
        # nay chay binh thuong). Phai goi qua run('...') thay vi bareword.
        $argStr = "-r `"$addpaths run('$MFile'); exit;`""
    }
    Log "Launching MATLAB (attempt $($restarts+1)) [$(if ($UseLegacyBatch) {'-batch'} else {'-r'})]"
    $proc = Start-Process -FilePath 'C:\Program Files\MATLAB\R2023b\bin\matlab.exe' -ArgumentList $argStr `
        -WorkingDirectory $ScriptDir -PassThru -WindowStyle Hidden
    $restarts++
    $attemptStart = Get-Date

    while ($true) {
        Start-Sleep -Seconds $PollSeconds
        $elapsed = ((Get-Date) - $attemptStart).TotalSeconds

        if (Test-Path $LogPath) {
            $content = Get-Content $LogPath -Raw -ErrorAction SilentlyContinue
            if ($content -and $content.Contains($SuccessMarker)) {
                Log "SUCCESS: $LogFileName shows '$SuccessMarker'."
                Start-Sleep -Seconds 3
                exit 0
            }
        }

        $matlabAlive = (Get-Process MATLAB -ErrorAction SilentlyContinue) -or (Get-Process matlab -ErrorAction SilentlyContinue)
        if (-not $matlabAlive) {
            Log "MATLAB process ended without success marker (crashed/errored) -- will relaunch."
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
