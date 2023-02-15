@echo off
setlocal EnableDelayedExpansion

DISM > nul 2>&1 || echo error: administrator privileges required && pause && exit /b

echo info: disabling fast startup
powercfg /hibernate off

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

echo info: done
pause
exit /b
