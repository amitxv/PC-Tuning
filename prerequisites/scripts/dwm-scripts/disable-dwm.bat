@echo off
setlocal EnableDelayedExpansion

dism > nul 2>&1 || echo error: administrator privileges required && pause && exit /b 1

echo info: nobody is responsible for damage caused to your operating system or computer, run at your own RISK
echo info: windows 8+ only
echo info: press any key to continue
pause > nul 2>&1

echo info: disabling dwm
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dwm.exe" /v "Debugger" /t REG_SZ /d "\"C:\WINDOWS\SYSTEM32\RUNDLL32.EXE\"" /f > nul 2>&1

for %%a in (UIRibbon, UIRibbonRes, Windows.UI.Logon) do (
    if exist "!windir!\System32\%%a.dll" (
        takeown /F "!windir!\System32\%%a.dll" /A
        icacls "!windir!\System32\%%a.dll" /grant Administrators:F
        ren "!windir!\System32\%%a.dll" "%%a.dlll"
    )
)

shutdown /r /f /t 0
