@echo off
setlocal EnableDelayedExpansion

DISM > nul 2>&1 || echo error: administrator privileges required && pause && exit /b

if exist "C:\Program Files (x86)\Microsoft\Edge\Application" (
    echo info: uninstalling chromium microsoft edge
    for /f "delims=" %%a in ('where /r "C:\Program Files (x86)\Microsoft\Edge\Application" *setup.exe*') do (
        if exist "%%a" (
            "%%a" --uninstall --system-level --verbose-logging --force-uninstall
        )
    )
)

for %%a in (
    "SysWOW64"
    "System32"
) do (
    if exist "!windir!\%%~a\OneDriveSetup.exe" (
        echo info: uninstalling onedrive
        "!windir!\%%~a\OneDriveSetup.exe" /uninstall
    )
)

echo info: done
pause
exit /b
