@echo off

DISM > nul 2>&1 || echo error: administrator privileges required && exit /b 1

echo info: enabling dwm
reg.exe delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dwm.exe" /v "Debugger" /f

for %%a in ("UIRibbon" "UIRibbonRes" "Windows.UI.Logon" "DWMInit" "WSClient") do (
    if exist "%windir%\System32\%%~a.dlll" (
        takeown /F "%windir%\System32\%%~a.dlll" /A
        icacls "%windir%\System32\%%~a.dlll" /grant Administrators:F
        ren "%windir%\System32\%%~a.dlll" "%%~a.dll"
    )
)

shutdown /r /f /t 0
exit /b 0
