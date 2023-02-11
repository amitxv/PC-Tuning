@echo off
setlocal EnableDelayedExpansion

sc query Winmgmt | findstr "RUNNING" > nul 2>&1
if not !errorlevel! == 0 (
    echo error: WMI Service is disabled
    pause
    exit /b
)

for %%a in ("Win32_VideoController" "Win32_NetworkAdapter") do (
    for /f "delims=" %%b in ('wmic path %%~a get PnPDeviceID ^| findstr /l "PCI\VEN_"') do (
        for /f "tokens=3" %%c in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\%%b" /v "Driver"') do (
            echo %%~a : %%c
        )
    )
    echo.
)

pause
exit /b
