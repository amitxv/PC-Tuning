@echo off

DISM > nul 2>&1 || echo error: administrator privileges required >&2 && exit /b 1

set "DWM_IFEO=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dwm.exe"

reg.exe query "%DWM_IFEO%" /v "Debugger" > nul 2>&1

if %errorlevel% == 0 (
    echo info: enabling dwm
    reg.exe delete "%DWM_IFEO%" /v "Debugger" /f
) else (
    echo info: disabling dwm
    reg.exe add "%DWM_IFEO%" /v "Debugger" /t REG_SZ /d "\"C:\Windows\System32\rundll32.exe\"" /f > nul 2>&1
)

for %%a in ("UIRibbon" "UIRibbonRes" "Windows.UI.Logon" "DWMInit" "WSClient") do (
    if exist "%windir%\System32\%%~a.dll" (
        call :take_ownership "%windir%\System32\%%~a.dll"
        ren "%windir%\System32\%%~a.dll" "%%~a.dlll"
    ) else (
        ren "%windir%\System32\%%~a.dlll" "%%~a.dll"
    )
)

shutdown /r /f /t 0
exit /b 0

:take_ownership file_path
takeown /F "%~1" /A
icacls "%~1" /grant Administrators:F
exit /b
