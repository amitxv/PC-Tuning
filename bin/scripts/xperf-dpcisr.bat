@echo off
setlocal EnableDelayedExpansion

DISM > nul 2>&1 || echo error: administrator privileges required && exit /b

where xperf.exe > nul 2>&1
if not !errorlevel! == 0 (
    echo error: xperf not found in path
    exit /b
)

set "output_dir=C:"
set "record_delay=5"
set "record_duration=30"

echo info: starting in !record_delay!s then recording for !record_duration!s
timeout -t !record_delay!
xperf -on base+interrupt+dpc
timeout -t !record_duration!
xperf -stop
xperf -i "!output_dir!\kernel.etl" -o "!output_dir!\report.txt" -a dpcisr
echo info: report saved in !output_dir!
