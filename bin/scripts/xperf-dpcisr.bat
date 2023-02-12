@echo off
setlocal EnableDelayedExpansion

DISM > nul 2>&1 || echo error: administrator privileges required && pause && exit /b

where xperf.exe > nul 2>&1
if not !errorlevel! == 0 (
    echo error: xperf not found in path
    pause
    exit /b
)

set "output_dir=C:"

echo info: starting in 5s
timeout -t 5
xperf -on base+interrupt+dpc
echo info: recording for 5s
timeout -t 5
xperf -stop
echo info: recording stopped
xperf -i "!output_dir!\kernel.etl" -o "!output_dir!\report.txt" -a dpcisr
echo info: report saved in !output_dir!
pause
exit /b
