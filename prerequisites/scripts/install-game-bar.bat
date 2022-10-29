@echo off
setlocal EnableDelayedExpansion

dism > nul 2>&1 || echo error: administrator privileges required && pause && exit /b 1

set "err=0"
for %%a in (
    Microsoft.UI.Xaml.2.7_7.2208.15002.0_x64__8wekyb3d8bbwe.appx
    Microsoft.VCLibs.140.00.UWPDesktop_14.0.30704.0_x64__8wekyb3d8bbwe.appx
    Microsoft.VCLibs.140.00_14.0.30704.0_x64__8wekyb3d8bbwe.appx
    Microsoft.XboxGamingOverlay_5.822.9161.0_neutral_~_8wekyb3d8bbwe.appxbundle
) do (
    if exist "C:\prerequisites\appx-packages\%%a" (
        PowerShell Add-AppxPackage -Path "C:\prerequisites\appx-packages\%%a"
    ) else (
        echo error: %%a not found
        set "err=1"
    )
)
if not !err! == 0 exit /b 1

echo info: done
echo info: press any key to continue
pause > nul 2>&1
exit /b 0