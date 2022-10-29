<# :
@echo off
setlocal EnableDelayedExpansion

dism > nul 2>&1 || echo error: administrator privileges required && pause && exit /b 1

mode 300, 1000

:set_binary_path
echo info: select the main game exe you would like to configure
for /f "delims=" %%a in ('PowerShell "iex (${%~f0} | out-string)"') do set "binary_path=%%a"

if defined binary_path (
    if exist "!binary_path!" (

        for /f "usebackq delims=" %%a in ('"!binary_path!"') do (
            set "program_name=%%~na"
        )

        echo info: program path: "!binary_path!"
        echo info: program name: "!program_name!"

        choice /c yn /n /m "set DSCP 46 QoS policy? [Y/N]"
        if !errorlevel! == 1 (
            > nul 2>&1 (
                reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\!program_name!" /v "Version" /t REG_SZ /d "1.0" /f
                reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\!program_name!" /v "Application Name" /t REG_SZ /d "!binary_path!" /f
                reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\!program_name!" /v "Protocol" /t REG_SZ /d "*" /f
                reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\!program_name!" /v "Local Port" /t REG_SZ /d "*" /f
                reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\!program_name!" /v "Local IP" /t REG_SZ /d "*" /f
                reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\!program_name!" /v "Local IP Prefix Length" /t REG_SZ /d "*" /f
                reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\!program_name!" /v "Remote Port" /t REG_SZ /d "*" /f
                reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\!program_name!" /v "Remote IP" /t REG_SZ /d "*" /f
                reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\!program_name!" /v "Remote IP Prefix Length" /t REG_SZ /d "*" /f
                reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\!program_name!" /v "DSCP Value" /t REG_SZ /d "46" /f
                reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS\!program_name!" /v "Throttle Rate" /t REG_SZ /d "-1" /f
            )
            echo info: DSCP 46 QoS policy applied

        )

        choice /c yn /n /m "disable fullscreen optimizations? (Windows 10 1703+ Only) [Y/N]"
        if !errorlevel! == 1 (
            reg.exe add "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "!binary_path!" /t REG_SZ /d "~ DISABLEDXMAXIMIZEDWINDOWEDMODE" /f > nul 2>&1
            echo info: fullscreen optimizations disabled
        )

        echo info: press any key to continue
        pause > nul 2>&1
        exit /b 0
    )
)

echo error: invalid input
goto set_binary_path

goto :EOF
PS #>

Add-Type -AssemblyName System.Windows.Forms
$f = new-object Windows.Forms.OpenFileDialog
$f.InitialDirectory = pwd
$f.Filter = "Image Files (*.exe)|*.exe|All Files (*.*)|*.*"
$f.ShowHelp = $true
$f.Multiselect = $true
[void]$f.ShowDialog()
if ($f.Multiselect) { $f.FileNames } else { $f.FileName }
