# run_full_campaign.ps1 -- wrapper chay TUAN TU watchdog_campaign.ps1 cho ca
# 2 cong trinh (B truoc, A sau - dung thu tu da lam trong toan bo du an).
#
# THIET KE DE PHONG MAT DIEN: script nay duoc dang ky chay TU DONG moi khi
# nguoi dung dang nhap Windows (Task Scheduler, trigger ONLOGON) - xem
# register_autostart.ps1. Vi watchdog_campaign.ps1 co "idempotent-skip"
# (kiem tra file *_FINAL.mat da co chua truoc khi chay lai moi RunTag) VA
# run_mosfoa2_parallel.m tu resume tu checkpoint trong tung lan chay, nen
# goi lai script nay BAO NHIEU LAN CUNG DUOC (sau mat dien, restart Windows,
# hay bat ky ly do gi khien tien trinh cu bi giet) - no se tu tiep tuc DUNG
# CHO DA DUNG LAI, khong lam lai tu dau, khong chay trung 2 lan cung 1 RunTag.
#
# CO CHE KHOA (lock) chong chay TRUNG neu task ONLOGON kich hoat trong khi
# 1 phien cu VAN DANG CHAY THAT (vd nguoi dung khoa/mo man hinh - KHONG
# kich hoat lai ONLOGON that su, nhung de an toan van kiem tra):
$LockFile = 'D:\ResearchLab\02_Projects\02_Projects\MOSFOA paper 2\code\run_full_campaign.lock'
$MyPid = $PID

if (Test-Path $LockFile) {
    $oldPid = Get-Content $LockFile -ErrorAction SilentlyContinue | Select-Object -First 1
    $oldProc = if ($oldPid) { Get-Process -Id $oldPid -ErrorAction SilentlyContinue } else { $null }
    if ($oldProc -and $oldProc.ProcessName -eq 'powershell') {
        Write-Host "[run_full_campaign] Phat hien 1 phien khac (PID $oldPid) co the dang chay - THOAT de tranh chay trung."
        exit 0
    } else {
        Write-Host "[run_full_campaign] Lock file cu (PID $oldPid) da chet - tiep tuc (day chinh la truong hop sau mat dien/restart)."
    }
}
Set-Content -Path $LockFile -Value $MyPid

$ScriptDir = 'D:\ResearchLab\02_Projects\02_Projects\MOSFOA paper 2\code'
$MasterLog = Join-Path $ScriptDir 'run_full_campaign.log'
function MLog($msg) {
    $line = "[{0}] {1}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $msg
    Add-Content -Path $MasterLog -Value $line
    Write-Host $line
}

MLog "=== run_full_campaign BAT DAU (PID $MyPid) - se chay B roi A, tu resume neu bi ngat quang ==="

try {
    MLog "--- Cong trinh B: goi watchdog_campaign.ps1 -Proj B ---"
    & powershell.exe -ExecutionPolicy Bypass -File (Join-Path $ScriptDir 'watchdog_campaign.ps1') -Proj B
    if ($LASTEXITCODE -ne 0) {
        MLog "!!! watchdog_campaign.ps1 -Proj B ket thuc voi loi (exit $LASTEXITCODE) - DUNG, khong chuyen sang A. Can kiem tra thu cong."
        Remove-Item -Path $LockFile -ErrorAction SilentlyContinue
        exit 1
    }
    MLog "--- Cong trinh B: HOAN THANH ---"

    MLog "--- Cong trinh A: goi watchdog_campaign.ps1 -Proj A ---"
    & powershell.exe -ExecutionPolicy Bypass -File (Join-Path $ScriptDir 'watchdog_campaign.ps1') -Proj A
    if ($LASTEXITCODE -ne 0) {
        MLog "!!! watchdog_campaign.ps1 -Proj A ket thuc voi loi (exit $LASTEXITCODE). Can kiem tra thu cong."
        Remove-Item -Path $LockFile -ErrorAction SilentlyContinue
        exit 1
    }
    MLog "--- Cong trinh A: HOAN THANH ---"

    MLog "=== TOAN BO CAMPAIGN (B + A, 20 lan/cong trinh) DA HOAN THANH ==="
} finally {
    Remove-Item -Path $LockFile -ErrorAction SilentlyContinue
}
