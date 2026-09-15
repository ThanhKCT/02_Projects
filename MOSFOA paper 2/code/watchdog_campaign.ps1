# watchdog_campaign.ps1 -- watchdog TU DONG cho campaign MOSFOA2 (Bai 2).
# Hoc theo dung co che da kiem chung o du an SFOA
# (Tap chi XD_SFOA/KE SAU CAU/code/SOO_KeSauCau/Ke_Sap/watchdog_run.ps1):
#   - dung `matlab -r` (KHONG `-batch`) vi COM STA cua SAP2000 OAPI can
#     Windows message pump ma `-batch` khong chay.
#   - goi script bang run('...') KHONG bareword (bareword treo vo han duoi -r).
#   - kill ca MATLAB lan SAP2000 truoc moi lan relaunch.
#   - dua tren "co che phat hien treo bang do LOG KHONG CAP NHAT" (staleness)
#     thay vi doc CPU (kinh nghiem Wharf100DWT 4080-combo, dang tin cay hon:
#     bat duoc ca 2 kieu treo "1 worker CPU cao" lan "moi worker gan 0% CPU
#     ket dinh do loi IPC" bang 1 phep kiem tra duy nhat).
#
# KHAC voi watchdog_run.ps1 goc: chay TUAN TU Nrun lan (moi lan 1 tien trinh
# MATLAB rieng, KHONG phai 1 vong lap for trong 1 phien MATLAB duy nhat) --
# neu treo o lan chay thu 5, KHONG chan cac lan 6..20 mai mai (khac han neu
# dung run_mosfoa2_campaign.m goc, vi no la 1 vong lap for BEN TRONG 1 phien
# MATLAB, treo giua chung se treo CA CAMPAIGN vo thoi han).
#
# Moi lan chay (RunTag) da co checkpoint/resume rieng (run_mosfoa2_parallel.m
# tu luu _CKPT.mat sau MOI the he) -- kill+relaunch giua chung CHI mat toi da
# 1 the he (~2-3 phut), khong mat ca lan chay.
#
# CACH DUNG:
#   powershell -ExecutionPolicy Bypass -File watchdog_campaign.ps1 -Proj B
#   powershell -ExecutionPolicy Bypass -File watchdog_campaign.ps1 -Proj A

param(
    [Parameter(Mandatory=$true)][ValidateSet('A','B')][string]$Proj,
    [int]$Nrun = 20,
    [int]$Num_work = 8,
    [int]$Npop = 8,
    [int]$Max_it = 20,
    [int]$PollSeconds = 20,
    [int]$StaleThresholdSeconds = 360,   # ~3x thoi gian 1 the he binh thuong (~100-130s) - du du de khong bao dong gia
    [int]$MaxRestartsPerRun = 20,        # rong rai cho chay qua dem khong nguoi giam sat - checkpoint lam restart "mien phi", chi cham
    # BO SUNG (11/09/2026, theo Cach ket noi_SAP2000_MATLAB_OPTIMIZATION.md
    # muc 5.4): dem so lan restart LIEN TIEP KHONG TIEN TRIEN (checkpoint
    # lastIter khong doi so voi lan truoc) rieng voi tong so restart - neu
    # thuc su la loi treo tam thoi (COM/IPC), moi lan restart se tien them
    # it nhat 1 the he truoc khi treo lai; neu la loi that (vd bug logic
    # khien MOI lan deu treo dung tai 1 diem) thi lastIter se dung yen qua
    # nhieu lan restart lien tiep - dung lai som thay vi mu quang thu du
    # MaxRestartsPerRun lan (co the ton hang gio khong ich gi).
    [int]$MaxConsecutiveNoProgress = 5
)

$ScriptDir = 'D:\ResearchLab\02_Projects\02_Projects\MOSFOA paper 2\code'
Set-Location $ScriptDir
$ResultsDir = Join-Path $ScriptDir 'results'
$SapDir = 'D:\ResearchLab\02_Projects\02_Projects\MOSFOA paper 2\SapV24'
$WatchdogLog = Join-Path $ScriptDir "watchdog_campaign_$Proj.log"

# Ten file model theo tung cong trinh (khop project_config.m)
$SdbBaseName = if ($Proj -eq 'A') { 'Ben100kDWT_sensitivity' } else { 'Cau tau dau vao' }

function Log($msg) {
    $line = "[{0}] {1}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $msg
    Add-Content -Path $WatchdogLog -Value $line
    Write-Host $line
}

function KillAll {
    Get-Process SAP2000 -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Get-Process MATLAB -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 3
}

function Clear-StaleByproducts {
    # Don file ket qua phan tich CU (khong phai .s2k/.$2k/.sbk/.ico/.sdb) o CA
    # thu muc goc SapV24 LAN cac thu muc rieng cua tung worker (W01..W08, do
    # open_Sap2000_worker_v2.m tao) - kinh nghiem SFOA: file rac nay gay hop
    # thoai "recent analysis results not flagged as compatible" chan tu dong
    # hoa vo thoi han neu khong don truoc moi lan mo lai model.
    $resultExts = @('K_0','K_I','K_J','K_M','LOG','OUT','Y','Y$$','Y00','Y01','Y02','Y03','Y04','Y05','Y06','Y07','Y08','Y_','Y_1','msh')
    $dirsToClean = @($SapDir) + (Get-ChildItem -Path $SapDir -Directory -Filter 'W*' -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName })
    foreach ($dir in $dirsToClean) {
        foreach ($ext in $resultExts) {
            $p = Join-Path $dir "$SdbBaseName.$ext"
            if (Test-Path $p) { Remove-Item -Path $p -Force -ErrorAction SilentlyContinue }
        }
    }
}

Log "=== watchdog_campaign start: Proj=$Proj Nrun=$Nrun Npop=$Npop Max_it=$Max_it Num_work=$Num_work ==="
KillAll

for ($r = 1; $r -le $Nrun; $r++) {
    $RunTag = "run{0:D2}" -f $r
    $finalFile = Join-Path $ResultsDir "MOSFOA2_${Proj}_Np${Npop}_Maxit${Max_it}_${RunTag}_FINAL.mat"

    if (Test-Path $finalFile) {
        Log "$RunTag : da co ket qua ($finalFile) - BO QUA."
        continue
    }

    Log "----- Bat dau $RunTag ($r/$Nrun) -----"
    $logFile = Join-Path $ScriptDir "campaign_${Proj}_${RunTag}.log"
    $ckptFile = Join-Path $ResultsDir "MOSFOA2_${Proj}_Np${Npop}_Maxit${Max_it}_${RunTag}_CKPT.mat"
    $restarts = 0
    $noProgressCount = 0
    $lastSeenIter = -1
    $success = $false

    while (-not $success) {
        if ($restarts -ge $MaxRestartsPerRun) {
            Log "$RunTag : vuot qua MaxRestartsPerRun ($MaxRestartsPerRun) - DUNG CAMPAIGN, can kiem tra thu cong."
            KillAll
            exit 1
        }
        # Kiem tra tien do checkpoint TRUOC khi relaunch (chi co y nghia tu
        # lan restart thu 2 tro di - lan dau chua co checkpoint de so sanh).
        if ($restarts -gt 0) {
            $curIter = -1
            if (Test-Path $ckptFile) {
                try {
                    # File .m rieng (khong dinh nghia inline) de tranh loi
                    # escaping duong dan (dau \ , dau ') giua PowerShell va
                    # chuoi lenh MATLAB - script nay CHI doc file .mat, KHONG
                    # dung SM.*/COM nen `-batch` an toan (khac voi cac lenh
                    # goi SAP2000, luon phai dung `-r`).
                    $out = & 'C:\Program Files\MATLAB\R2023b\bin\matlab.exe' -nosplash -nodesktop -batch "addpath('$ScriptDir'); get_ckpt_lastiter('$ckptFile')" 2>$null
                    $lastLine = ($out | Select-String -Pattern '^-?\d+$' | Select-Object -Last 1)
                    if ($lastLine) { $curIter = [int]$lastLine.Line }
                } catch { $curIter = -1 }
            }
            if ($curIter -ge 0 -and $curIter -eq $lastSeenIter) {
                $noProgressCount++
                Log "$RunTag : checkpoint KHONG tien them (van o vong $curIter) - lan khong tien trien lien tiep thu $noProgressCount/$MaxConsecutiveNoProgress."
                if ($noProgressCount -ge $MaxConsecutiveNoProgress) {
                    Log "$RunTag : $MaxConsecutiveNoProgress lan restart LIEN TIEP khong tien trien - nghi la LOI THAT (khong phai treo tam thoi) - DUNG CAMPAIGN, can kiem tra thu cong."
                    KillAll
                    exit 1
                }
            } else {
                if ($curIter -ge 0) {
                    Log "$RunTag : checkpoint da tien tu vong $lastSeenIter len vong $curIter - reset dem khong-tien-trien."
                }
                $noProgressCount = 0
            }
            $lastSeenIter = $curIter
        }
        KillAll
        Clear-StaleByproducts
        Remove-Item -Path $logFile -ErrorAction SilentlyContinue

        $addpaths = "addpath('$ScriptDir');"
        $mfileCall = "run_mosfoa2_parallel('$Proj','$RunTag',$Num_work,$Npop,$Max_it)"
        $argStr = "-nosplash -nodesktop -logfile `"$logFile`" -r `"$addpaths $mfileCall; exit;`""

        Log "$RunTag : launching MATLAB (attempt $($restarts+1))"
        $proc = Start-Process -FilePath 'C:\Program Files\MATLAB\R2023b\bin\matlab.exe' -ArgumentList $argStr `
            -WorkingDirectory $ScriptDir -PassThru -WindowStyle Hidden
        $restarts++
        $attemptStart = Get-Date

        while ($true) {
            Start-Sleep -Seconds $PollSeconds

            if (Test-Path $finalFile) {
                Log "$RunTag : THANH CONG - $finalFile da xuat hien."
                $success = $true
                break
            }

            $matlabAlive = Get-Process MATLAB -ErrorAction SilentlyContinue
            if (-not $matlabAlive) {
                Log "$RunTag : tien trinh MATLAB da ket thuc nhung KHONG co file ket qua (loi/crash) - se relaunch."
                break
            }

            if (Test-Path $logFile) {
                $lastWrite = (Get-Item $logFile).LastWriteTime
                $staleSec = ((Get-Date) - $lastWrite).TotalSeconds
            } else {
                $staleSec = ((Get-Date) - $attemptStart).TotalSeconds
            }
            $elapsed = [math]::Round(((Get-Date) - $attemptStart).TotalSeconds)
            Log "$RunTag : poll - elapsed=${elapsed}s log_stale=$([math]::Round($staleSec))s"

            if ($staleSec -gt $StaleThresholdSeconds) {
                Log "$RunTag : LOG KHONG CAP NHAT qua $StaleThresholdSeconds s - NGHI TREO - kill + relaunch (checkpoint se tu resume)."
                break
            }
        }
    }
}

Log "=== HOAN THANH TOAN BO CAMPAIGN cho cong trinh $Proj ($Nrun lan chay) ==="
KillAll
