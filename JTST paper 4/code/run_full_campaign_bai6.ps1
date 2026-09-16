# run_full_campaign_bai6.ps1 -- wrapper idempotent goi watchdog_campaign_bai6.ps1.
# Cung co che chong mat dien nhu MOSFOA paper 2 (lock file PID, an toan goi
# lai bao nhieu lan cung duoc nho idempotent-skip trong watchdog +
# checkpoint/resume trong run_mosfoa6_parallel.m).
param(
    [int]$Nrun = 20,
    [int]$Num_work = 4,
    [int]$Npop = 30,
    [int]$Max_it = 100
)

$LockFile = 'D:\ResearchLab\02_Projects\02_Projects\JTST paper 4\code\run_full_campaign_bai6.lock'
$MyPid = $PID

if (Test-Path $LockFile) {
    $oldPid = Get-Content $LockFile -ErrorAction SilentlyContinue | Select-Object -First 1
    $oldProc = if ($oldPid) { Get-Process -Id $oldPid -ErrorAction SilentlyContinue } else { $null }
    if ($oldProc -and $oldProc.ProcessName -eq 'powershell') {
        Write-Host "[run_full_campaign_bai6] Phat hien 1 phien khac (PID $oldPid) co the dang chay - THOAT de tranh chay trung."
        exit 0
    } else {
        Write-Host "[run_full_campaign_bai6] Lock file cu (PID $oldPid) da chet - tiep tuc."
    }
}
Set-Content -Path $LockFile -Value $MyPid

$ScriptDir = 'D:\ResearchLab\02_Projects\02_Projects\JTST paper 4\code'
$MasterLog = Join-Path $ScriptDir 'run_full_campaign_bai6.log'
function MLog($msg) {
    $line = "[{0}] {1}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $msg
    Add-Content -Path $MasterLog -Value $line
    Write-Host $line
}

MLog "=== run_full_campaign_bai6 BAT DAU (PID $MyPid) - Nrun=$Nrun Npop=$Npop Max_it=$Max_it Num_work=$Num_work ==="

try {
    & powershell.exe -ExecutionPolicy Bypass -File (Join-Path $ScriptDir 'watchdog_campaign_bai6.ps1') -Nrun $Nrun -Num_work $Num_work -Npop $Npop -Max_it $Max_it
    if ($LASTEXITCODE -ne 0) {
        MLog "!!! watchdog_campaign_bai6.ps1 ket thuc voi loi (exit $LASTEXITCODE). Can kiem tra thu cong."
        Remove-Item -Path $LockFile -ErrorAction SilentlyContinue
        exit 1
    }
    MLog "=== TOAN BO CAMPAIGN BAI 6 ($Nrun lan) DA HOAN THANH ==="
} finally {
    Remove-Item -Path $LockFile -ErrorAction SilentlyContinue
}
