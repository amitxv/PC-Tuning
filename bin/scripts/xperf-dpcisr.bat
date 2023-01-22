@echo off
setlocal EnableDelayedExpansion

DISM > nul 2>&1 || echo error: administrator privileges required && pause && exit /b

where xperf.exe > nul 2>&1
if not !errorlevel! == 0 (
    echo error: xperf not found in path
    echo info: press any key to continue
    pause > nul 2>&1
    exit /b
)

echo info: starting in 5s
timeout -t 5
xperf -on base+interrupt+dpc
echo info: recording for 5s
timeout -t 5
xperf -d "!userprofile!\Desktop\kernel.etl"
echo info: recording stopped
xperf -quiet -i "!userprofile!\Desktop\kernel.etl" -o "!userprofile!\Desktop\report.txt" -a dpcisr
echo info: press any key to continue
pause > nul 2>&1
exit /b
