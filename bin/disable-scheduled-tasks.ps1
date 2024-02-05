function Is-Admin() {
    $current_principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $current_principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Toggle-Task($task, $enable) {
    $toggle = if ($enable) { "/enable" } else { "/disable" }

    $user_task_result = (Start-Process "schtasks.exe" -ArgumentList "/change $($toggle) /tn `"$($task)`"" -PassThru -Wait -WindowStyle Hidden).ExitCode
    $trustedinstaller_task_result = [int](.\MinSudo.exe --NoLogo --TrustedInstaller --Privileged cmd /c "schtasks.exe /change $($toggle) /tn `"$($task)`" > nul 2>&1 && echo 0 || echo 1")

    return $user_task_result -band $trustedinstaller_task_result
}

function main() {
    if (-not (Is-Admin)) {
        Write-Host "error: administrator privileges required"
        return 1
    }

    Set-Location $PSScriptRoot

    $wildcards = @(
        "update",
        "helloface",
        "customer experience improvement program",
        "microsoft compatibility appraiser",
        "startupapptask",
        "dssvccleanup",
        "bitlocker",
        "chkdsk",
        "data integrity scan",
        "defrag",
        "languagecomponentsinstaller",
        "upnp",
        "windows filtering platform",
        "tpm",
        "speech",
        "spaceport",
        "power efficiency",
        "cloudexperiencehost",
        "diagnosis",
        "file history",
        "bgtaskregistrationmaintenancetask",
        "autochk\proxy",
        "siuf",
        "device information",
        "edp policy manager",
        "defender",
        "marebackup"
    )

    Write-Host "info: please wait..."

    $scheduled_tasks = schtasks /query /fo list
    $task_names = [System.Collections.ArrayList]@()

    foreach ($line in $scheduled_tasks) {
        if ($line.contains("TaskName:")) {
        ($task_names.Add($line.Split(":")[1].Trim().ToLower())) 2>&1 > $null
        }
    }

    foreach ($wildcard in $wildcards) {
        Write-Host "info: searching for $($wildcard)"
        foreach ($task in $task_names) {
            if ($task.contains($wildcard)) {
                if ((Toggle-Task -task $task -enable $false) -ne 0) {
                    Write-Host "error: failed toggling one or more scheduled tasks"
                    return 1
                }
            }
        }
    }

    return 0
}

$_exit_code = main
Write-Host # new line
exit $_exit_code
