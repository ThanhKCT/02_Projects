' run_full_campaign_startup.vbs -- dat vao thu muc Startup cua Windows de
' tu dong chay lai run_full_campaign.ps1 (AN, khong hien cua so) moi khi
' dang nhap - thay the cho Task Scheduler (bi chan boi phan mem bao mat
' tren may nay). run_full_campaign.ps1 tu resume dung tu checkpoint gan
' nhat nho co che idempotent-skip + checkpoint da co san, nen goi lai bao
' nhieu lan cung an toan (khong chay lai tu dau, khong chay trung).
Set objShell = CreateObject("WScript.Shell")
objShell.Run "powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File ""D:\ResearchLab\02_Projects\02_Projects\MOSFOA paper 2\code\run_full_campaign.ps1""", 0, False
