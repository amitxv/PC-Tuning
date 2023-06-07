@echo off

DISM > nul 2>&1 || echo error: administrator privileges required && exit /b 1

where xperf.exe > nul 2>&1
if not %errorlevel% == 0 (
    echo error: xperf not found in path
    exit /b 1
)

set "record_delay=3"
set "record_duration=5"

echo info: starting in %record_delay%s
timeout -t %record_delay%

echo info: recording for %record_duration%s
xperf -on base+interrupt+dpc
timeout -t %record_duration%

xperf -stop
xperf -i "C:\kernel.etl" -o "C:\report.txt" -a dpcisr
echo info: report saved in C:\

exit /b 0
