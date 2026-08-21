@echo off
REM ============================================================
REM SOO-SFOA full campaign: 6 cases (BD-C, BD-D, MD-C, MD-D, MPJ-C, MPJ-D)
REM Confirmed 2026-08-15: Npop=30, Nrun=10, runMode='campaign'
REM   Max_it: BD=50, MD=40, MPJ=150 (from real pilot convergence evidence)
REM Detached process pattern (see SESSION_HANDOFF 2026-08-15 sec.4) --
REM survives chat-session interruption. Progress in results/*_progress.log.
REM ============================================================
set MATLAB="C:\Program Files\MATLAB\R2023b\bin\matlab.exe"

echo === CAMPAIGN START %date% %time% ===

echo === BD-Cost start %date% %time% ===
cd /d "D:\ResearchLab\02_Projects\02_Projects\Tap chi XD_SFOA\code\SOO_BD"
%MATLAB% -batch "objCol=1; runMode='campaign'; Nrun=10; runIdOffset=0; run('SOO_BD_run.m')"
echo === BD-Cost end %date% %time%, exit=%errorlevel% ===

echo === BD-Displacement start %date% %time% ===
cd /d "D:\ResearchLab\02_Projects\02_Projects\Tap chi XD_SFOA\code\SOO_BD"
%MATLAB% -batch "objCol=2; runMode='campaign'; Nrun=10; runIdOffset=0; run('SOO_BD_run.m')"
echo === BD-Displacement end %date% %time%, exit=%errorlevel% ===

echo === MD-Cost start %date% %time% ===
cd /d "D:\ResearchLab\02_Projects\02_Projects\Tap chi XD_SFOA\code\SOO_MD"
%MATLAB% -batch "objCol=1; runMode='campaign'; Nrun=10; runIdOffset=0; run('SOO_MD_run.m')"
echo === MD-Cost end %date% %time%, exit=%errorlevel% ===

echo === MD-Displacement start %date% %time% ===
cd /d "D:\ResearchLab\02_Projects\02_Projects\Tap chi XD_SFOA\code\SOO_MD"
%MATLAB% -batch "objCol=2; runMode='campaign'; Nrun=10; runIdOffset=0; run('SOO_MD_run.m')"
echo === MD-Displacement end %date% %time%, exit=%errorlevel% ===

echo === MPJ-Cost start %date% %time% ===
cd /d "D:\ResearchLab\02_Projects\02_Projects\Tap chi XD_SFOA\code\SOO_MPJ"
%MATLAB% -batch "objCol=1; runMode='campaign'; Nrun=10; runIdOffset=0; run('SOO_MPJ_run.m')"
echo === MPJ-Cost end %date% %time%, exit=%errorlevel% ===

echo === MPJ-Displacement start %date% %time% ===
cd /d "D:\ResearchLab\02_Projects\02_Projects\Tap chi XD_SFOA\code\SOO_MPJ"
%MATLAB% -batch "objCol=2; runMode='campaign'; Nrun=10; runIdOffset=0; run('SOO_MPJ_run.m')"
echo === MPJ-Displacement end %date% %time%, exit=%errorlevel% ===

echo === CAMPAIGN ALL 6 CASES DONE %date% %time% ===
