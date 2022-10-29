@echo off
setlocal EnableDelayedExpansion

dism > nul 2>&1 || echo error: administrator privileges required && pause && exit /b 1

where xperf.exe
if not !errorlevel! == 0 (
    echo error: xperf not found in path
    echo info: press any key to continue
    pause > nul 2>&1
    exit /b 1
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
exit /b 0
