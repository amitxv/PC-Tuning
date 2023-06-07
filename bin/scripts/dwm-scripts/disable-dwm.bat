@echo off

DISM > nul 2>&1 || echo error: administrator privileges required && exit /b 1

echo info: disabling dwm
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dwm.exe" /v "Debugger" /t REG_SZ /d "\"C:\Windows\System32\rundll32.exe\"" /f > nul 2>&1

for %%a in ("UIRibbon" "UIRibbonRes" "Windows.UI.Logon" "DWMInit" "WSClient") do (
    if exist "%windir%\System32\%%~a.dll" (
        takeown /F "%windir%\System32\%%~a.dll" /A
        icacls "%windir%\System32\%%~a.dll" /grant Administrators:F
        ren "%windir%\System32\%%~a.dll" "%%~a.dlll"
    )
)

shutdown /r /f /t 0
exit /b 0
