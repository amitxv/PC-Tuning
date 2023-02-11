@echo off
setlocal EnableDelayedExpansion

sc query Winmgmt | findstr "RUNNING" > nul 2>&1
if not !errorlevel! == 0 (
    echo error: WMI Service is disabled
    exit /b
)

if "%1"=="" (
    echo error: class identifier required as argument
    exit /b
)

for /f "delims=" %%a in ('wmic path %~1 get PnPDeviceID ^| findstr /l "PCI\VEN_"') do (
    for /f "tokens=3" %%b in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\%%a" /v "Driver"') do (
        echo %~1: %%b
    )
)

exit /b
