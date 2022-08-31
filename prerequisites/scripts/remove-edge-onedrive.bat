@echo off
setlocal EnableDelayedExpansion

dism > nul 2>&1 || echo error: administrator privileges required && pause && exit /b 1

if exist "C:\Program Files (x86)\Microsoft\Edge\Application" (
    echo info: uninstalling chromium microsoft edge
    for /f "delims=" %%a in ('where /r "C:\Program Files (x86)\Microsoft\Edge\Application" *setup.exe*') do (
        if exist "%%a" (
            "%%a" --uninstall --system-level --verbose-logging --force-uninstall
        )
    )
)

if exist "!windir!\SysWOW64\OneDriveSetup.exe" (
    echo info: uninstalling onedrive
    "!windir!\SysWOW64\OneDriveSetup.exe" /uninstall
)

echo info: done
echo info: press any key to continue
pause > nul 2>&1
exit /b 0
