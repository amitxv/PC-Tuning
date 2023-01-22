@echo off
setlocal EnableDelayedExpansion

DISM > nul 2>&1 || echo error: administrator privileges required && pause && exit /b

echo info: disabling fast startup
powercfg /hibernate off

echo info: setting PowerShell executionpolicy to unrestricted
PowerShell Set-ExecutionPolicy Unrestricted -force

echo info: setting the password to never expire
net accounts /maxpwage:unlimited > nul 2>&1

echo info: disabling automatic repair
bcdedit /set recoveryenabled no > nul 2>&1
fsutil repair set C: 0 > nul 2>&1

echo info: cleaning the winsxs folder
DISM /Online /Cleanup-Image /StartComponentCleanup /ResetBase

echo info: disabling reserved storage, ignore errors
DISM /Online /Set-ReservedStorageState /State:Disabled

echo info: disabling sleepstudy
> nul 2>&1 (
    wevtutil sl Microsoft-Windows-SleepStudy/Diagnostic /e:false
    wevtutil sl Microsoft-Windows-Kernel-Processor-Power/Diagnostic /e:false
    wevtutil sl Microsoft-Windows-UserModePowerService/Diagnostic /e:false
)

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
) else (
    if exist "!windir!\System32\OneDriveSetup.exe" (
        echo info: uninstalling onedrive
        "!windir!\System32\OneDriveSetup.exe" /uninstall
    )
)

echo info: done
echo info: press any key to continue
pause > nul 2>&1
exit /b
