@echo off

dism > nul 2>&1 || echo error: administrator privileges required && pause && exit /b 1

for %%a in (
    EnhancedPowerManagementEnabled
    AllowIdleIrpInD3
    EnableSelectiveSuspend
    DeviceSelectiveSuspended
    SelectiveSuspendEnabled
    SelectiveSuspendOn
    WaitWakeEnabled
    D3ColdSupported
    WdfDirectedPowerTransitionEnable
    EnableIdlePowerManagement
    IdleInWorkingState
) do (
    echo info: configuring %%a
    for /f "delims=" %%b in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum" /s /f "%%a" ^| findstr "HKEY"') do (
        reg.exe add "%%b" /v "%%a" /t REG_DWORD /d "0" /f > nul 2>&1
    )
)

for %%a in (WakeEnabled WdkSelectiveSuspendEnable) do (
    echo info: configuring %%a
    for /f "delims=" %%b in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class" /s /f "%%a" ^| findstr "HKEY"') do (
        reg.exe add "%%b" /v "%%a" /t REG_DWORD /d "0" /f > nul 2>&1
    )
)

echo info: done
echo info: press any key to continue
pause > nul 2>&1
exit /b 0
