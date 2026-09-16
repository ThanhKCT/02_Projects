' run_full_campaign_bai6_startup.vbs -- dat vao thu muc Startup cua Windows de
' tu dong chay lai run_full_campaign_bai6.ps1 (AN, khong hien cua so) moi khi
' dang nhap - thay the cho Task Scheduler (bi chan boi phan mem bao mat tren
' may nay, xem Kinh nghiem MOSFOA Paper 2.md muc 3.2). idempotent-skip +
' checkpoint da co san nen goi lai bao nhieu lan cung an toan.
Set objShell = CreateObject("WScript.Shell")
objShell.Run "powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File ""D:\ResearchLab\02_Projects\02_Projects\JTST paper 4\code\run_full_campaign_bai6.ps1""", 0, False
