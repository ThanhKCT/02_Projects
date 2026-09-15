# register_autostart.ps1 -- dang ky Task Scheduler de TU DONG chay lai
# run_full_campaign.ps1 moi khi nguoi dung dang nhap Windows (trigger
# ONLOGON). Muc dich: neu mat dien giua chung campaign (may tat han, moi
# tien trinh dang chay deu bi giet), ban CHI CAN bat may + dang nhap lai
# nhu binh thuong - campaign se TU DONG tiep tuc dung tu checkpoint gan
# nhat, KHONG can go lai bat ky lenh nao.
#
# Khong dong den auto-login/mat khau Windows (khong an toan, khong lam) -
# nen ban van phai tu dang nhap 1 lan sau khi bat may, nhung tu do tro di
# moi thu tu dong.
#
# CACH DUNG: chi can chay 1 LAN (khong can chay lai moi ngay):
#   powershell -ExecutionPolicy Bypass -File register_autostart.ps1

$TaskName = 'MOSFOA2_CampaignAutoResume'
$User = "$env:USERDOMAIN\$env:USERNAME"

# LUU Y: duong dan co dau cach ("MOSFOA paper 2") lam PowerShell tach nham
# doi so khi truyen chuoi /TR co long dau ngoac kep cho native exe (loi da
# gap: "Invalid argument/option - 'paper'"). Dung `--%` (stop-parsing) de
# PowerShell KHONG dong gi vao chuoi phia sau, giu nguyen cho schtasks tu
# parse - phai HARDCODE duong dan sau `--%` (khong dung bien $ScriptPath).
# SUA lan 2: bo ca /RU (Access is denied ngay ca khong /RL HIGHEST - co
# the do phien nay chay duoi 1 tai khoan/context khac tai khoan desktop
# tuong tac "$User", nen khong the tao task "thay mat" tai khoan do). Bo
# /RU de schtasks tu dung context hien tai cua chinh no.
schtasks /Create /TN $TaskName /SC ONLOGON /F --% /TR "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File \"D:\ResearchLab\02_Projects\02_Projects\MOSFOA paper 2\code\run_full_campaign.ps1\""

Write-Host ""
Write-Host "Da dang ky task '$TaskName' - se tu dong chay lai run_full_campaign.ps1 moi khi $User dang nhap Windows."
Write-Host "Kiem tra: schtasks /Query /TN $TaskName /V /FO LIST"
Write-Host "Go bo (khi khong can nua): schtasks /Delete /TN $TaskName /F"
