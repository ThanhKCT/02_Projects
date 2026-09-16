# watchdog_campaign_bai6.ps1 -- watchdog TU DONG cho campaign MOSFOA Bai 6.
# Copy kien truc tu MOSFOA paper 2/code/watchdog_campaign.ps1 (da kiem chung
# song, kill deliberate MATLAP giua chung de xac nhan detect->clean->relaunch
# ->resume dung), chi doi: (1) 1 "cong trinh" duy nhat (khong co vong lap A/B),
# (2) goi run_mosfoa6_parallel(Num_work,Npop,Max_it,RunTag) dung thu tu tham
# so cua ham nay (KHAC thu tu cua run_mosfoa2_parallel(Proj,RunTag,...)).
#
# CACH DUNG:
#   powershell -ExecutionPolicy Bypass -File watchdog_campaign_bai6.ps1 -Nrun 20 -Npop 30 -Max_it 100 -Num_work 4

param(
    [int]$Nrun = 20,
    [int]$Num_work = 4,
    [int]$Npop = 30,
    [int]$Max_it = 100,
    [int]$PollSeconds = 30,
    [int]$StaleThresholdSeconds = 900,   # model lon hon Bai 2 (747 frame+1750 area) - RunAnalysis cham hon, nguong rong rai hon
    [int]$MaxRestartsPerRun = 20,
    [int]$MaxConsecutiveNoProgress = 5
)

$ScriptDir = 'D:\ResearchLab\02_Projects\02_Projects\JTST paper 4\code'
Set-Location $ScriptDir
$ResultsDir = Join-Path $ScriptDir 'results'
if (-not (Test-Path $ResultsDir)) { New-Item -ItemType Directory -Path $ResultsDir | Out-Null }
$ModelDir = Join-Path $ScriptDir 'model'
$WatchdogLog = Join-Path $ScriptDir 'watchdog_campaign_bai6.log'
$SdbBaseName = 'Ben so 1 Chan May'

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
    # Don file ket qua phan tich CU o CA thu muc model/ goc LAN cac thu muc
    # con rieng cua tung worker (W01..W0N, do open_Sap2000_worker_v2.m tao).
    $resultExts = @('K_0','K_I','K_J','K_M','LOG','OUT','Y','Y$$','Y00','Y01','Y02','Y03','Y04','Y05','Y06','Y07','Y08','Y_','Y_1','msh')
    $dirsToClean = @($ModelDir) + (Get-ChildItem -Path $ModelDir -Directory -Filter 'W*' -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName })
    foreach ($dir in $dirsToClean) {
        foreach ($ext in $resultExts) {
            $p = Join-Path $dir "$SdbBaseName.$ext"
            if (Test-Path $p) { Remove-Item -Path $p -Force -ErrorAction SilentlyContinue }
        }
    }
}

Log "=== watchdog_campaign_bai6 start: Nrun=$Nrun Npop=$Npop Max_it=$Max_it Num_work=$Num_work ==="
KillAll

for ($r = 1; $r -le $Nrun; $r++) {
    $RunTag = "run{0:D2}" -f $r
    $finalFile = Join-Path $ResultsDir "Bai6_MOSFOA_Np${Npop}_Maxit${Max_it}_${RunTag}_FINAL.mat"

    if (Test-Path $finalFile) {
        Log "$RunTag : da co ket qua ($finalFile) - BO QUA."
        continue
    }

    Log "----- Bat dau $RunTag ($r/$Nrun) -----"
    $logFile = Join-Path $ScriptDir "campaign_bai6_${RunTag}.log"
    $ckptFile = Join-Path $ResultsDir "Bai6_MOSFOA_Np${Npop}_Maxit${Max_it}_${RunTag}_CKPT.mat"
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
        if ($restarts -gt 0) {
            $curIter = -1
            if (Test-Path $ckptFile) {
                try {
                    $out = & 'C:\Program Files\MATLAB\R2023b\bin\matlab.exe' -nosplash -nodesktop -batch "addpath('$ScriptDir'); get_ckpt_lastiter('$ckptFile')" 2>$null
                    $lastLine = ($out | Select-String -Pattern '^-?\d+$' | Select-Object -Last 1)
                    if ($lastLine) { $curIter = [int]$lastLine.Line }
                } catch { $curIter = -1 }
            }
            if ($curIter -ge 0 -and $curIter -eq $lastSeenIter) {
                $noProgressCount++
                Log "$RunTag : checkpoint KHONG tien them (van o vong $curIter) - lan khong tien trien lien tiep thu $noProgressCount/$MaxConsecutiveNoProgress."
                if ($noProgressCount -ge $MaxConsecutiveNoProgress) {
                    Log "$RunTag : $MaxConsecutiveNoProgress lan restart LIEN TIEP khong tien trien - nghi la LOI THAT - DUNG CAMPAIGN, can kiem tra thu cong."
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

        $addpaths = "addpath('$ScriptDir'); addpath('$ScriptDir\MOSFOA_core');"
        $mfileCall = "run_mosfoa6_parallel($Num_work,$Npop,$Max_it,'$RunTag')"
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

Log "=== HOAN THANH TOAN BO CAMPAIGN BAI 6 ($Nrun lan chay) ==="
KillAll
