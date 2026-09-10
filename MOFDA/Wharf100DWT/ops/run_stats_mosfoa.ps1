$matlab = "C:\Program Files\MATLAB\R2023b\bin\matlab.exe"
$logFile = "D:\ResearchLab\02_Projects\02_Projects\MOFDA\Wharf100DWT\results\campaign_mosfoa_stats_30runs.log"
$cmd = "cd('D:\ResearchLab\02_Projects\02_Projects\MOFDA\Wharf100DWT'); run_mosfoa_stats_wharf100dwt(30, 8, 50, 250); exit;"
$argStr = "-r `"$cmd`" -logfile `"$logFile`""
Start-Process -FilePath $matlab -ArgumentList $argStr -WindowStyle Hidden
