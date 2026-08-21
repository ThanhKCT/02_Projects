@echo off
REM ============================================================
REM MPJ-only pilot30: verify real convergence at Npop=30 (the ACTUAL
REM campaign population size) before committing Nrun=30 x 2 objectives.
REM 2026-08-17: BD/MD dropped from paper scope; freed budget used to
REM re-verify Max_it at Npop=30 instead of trusting the Npop=100
REM extrapolation. Max_it=250 (generous), Nrun=1 each objective.
REM Detached process pattern (see SESSION_HANDOFF 2026-08-15 sec.4) --
REM survives chat-session interruption.
REM ============================================================
set MATLAB="C:\Program Files\MATLAB\R2023b\bin\matlab.exe"

echo === MPJ PILOT30 START %date% %time% ===

echo === MPJ-Cost pilot30 start %date% %time% ===
cd /d "D:\ResearchLab\02_Projects\02_Projects\Tap chi XD_SFOA\code\SOO_MPJ"
%MATLAB% -batch "objCol=1; runMode='pilot30'; Nrun=1; runIdOffset=0; run('SOO_MPJ_run.m')"
echo === MPJ-Cost pilot30 end %date% %time%, exit=%errorlevel% ===

echo === MPJ-Displacement pilot30 start %date% %time% ===
cd /d "D:\ResearchLab\02_Projects\02_Projects\Tap chi XD_SFOA\code\SOO_MPJ"
%MATLAB% -batch "objCol=2; runMode='pilot30'; Nrun=1; runIdOffset=0; run('SOO_MPJ_run.m')"
echo === MPJ-Displacement pilot30 end %date% %time%, exit=%errorlevel% ===

echo === MPJ PILOT30 DONE %date% %time% ===
