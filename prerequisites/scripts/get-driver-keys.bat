@echo off
setlocal EnableDelayedExpansion

sc query Winmgmt | findstr "RUNNING" > nul 2>&1
if not !errorlevel! == 0 (
    echo error: WMI Service is disabled
    echo info: press any key to continue
    pause > nul 2>&1
    exit /b 1
)

for %%a in (Win32_VideoController, Win32_NetworkAdapter ) do (
    for /f "delims=" %%b in ('wmic path %%a get PnPDeviceID ^| findstr /l "PCI\VEN_"') do (
        for /f "tokens=3" %%c in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\%%b" /v "Driver"') do (
            for /f %%d in ('echo %%c ^| findstr "{"') do (
                echo %%a : %%d
            )
        )
    )
    echo.
)

echo info: press any key to continue
pause > nul 2>&1
exit /b 0
