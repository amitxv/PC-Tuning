@echo off

DISM > nul 2>&1 || echo error: administrator privileges required >&2 && exit /b 1

set "err=0"

for %%a in ("xperf", "wpr") do (
    where %%~a > nul 2>&1
    if not %errorlevel% == 0 (
        set "err=1"
    )
)

if %err% == 1 (
    echo error: install "Windows Performance Toolkit" from the ADK in the link below >&2
    echo https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install
    exit /b 1
)

set "record_delay=3"
set "record_duration=5"
set "trace=C:\trace.etl"
set "report=C:\report.txt"

echo info: starting in %record_delay%s
timeout -t %record_delay% > nul 2>&1

echo info: recording for %record_duration%s
wpr -start Registry
timeout -t %record_duration% > nul 2>&1

echo info: saving %trace%
wpr -stop "%trace%"

echo info: saving %report%
xperf -quiet -i "%trace%" -o "%report%" -a dpcisr

exit /b 0
