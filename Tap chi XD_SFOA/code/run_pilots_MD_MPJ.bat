@echo off
echo === MD pilot start %date% %time% ===
cd /d "D:\ResearchLab\02_Projects\02_Projects\Tap chi XD_SFOA\code\SOO_MD"
"C:\Program Files\MATLAB\R2023b\bin\matlab.exe" -batch "objCol=1; runMode='pilot'; Nrun=1; runIdOffset=900; run('SOO_MD_run.m')"
echo === MD pilot end %date% %time%, exit=%errorlevel% ===
echo === MPJ pilot start %date% %time% ===
cd /d "D:\ResearchLab\02_Projects\02_Projects\Tap chi XD_SFOA\code\SOO_MPJ"
"C:\Program Files\MATLAB\R2023b\bin\matlab.exe" -batch "objCol=1; runMode='pilot'; Nrun=1; runIdOffset=900; run('SOO_MPJ_run.m')"
echo === MPJ pilot end %date% %time%, exit=%errorlevel% ===
echo === ALL PILOTS DONE ===
