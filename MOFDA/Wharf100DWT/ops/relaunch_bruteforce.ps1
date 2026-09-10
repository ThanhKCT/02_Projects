$matlab = "C:\Program Files\MATLAB\R2023b\bin\matlab.exe"
$logFile = "D:\ResearchLab\02_Projects\02_Projects\MOFDA\Wharf100DWT\results\campaign_bruteforce_4080_FINAL.log"
$cmd = "cd('D:\ResearchLab\02_Projects\02_Projects\MOFDA\Wharf100DWT'); run_bruteforce_wharf100dwt(8,100,6); exit;"
$argStr = "-r `"$cmd`" -logfile `"$logFile`""
Start-Process -FilePath $matlab -ArgumentList $argStr -WindowStyle Hidden
