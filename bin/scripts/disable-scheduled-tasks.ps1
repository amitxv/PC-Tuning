function is_admin() {
    $current_principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $current_principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (!(is_admin)) {
    Write-Host "error: administrator privileges required"
    exit
}

$wildcards = @(
    "update",
    "maps",
    "helloface",
    "customer experience improvement program",
    "microsoft compatibility appraiser",
    "startupapptask",
    "dssvccleanup",
    "bitlocker",
    "chkdsk",
    "data integrity scan",
    "defrag",
    "diskcleanup",
    "diskfootprint",
    "languagecomponentsinstaller",
    "memorydiagnostic",
    "registry",
    "time synchronization",
    "time zone",
    "upnp",
    "windows filtering platform",
    "tpm",
    "systemrestore",
    "speech",
    "spacePort",
    "power efficiency",
    "cloudexperiencehost",
    "diagnosis",
    "file history",
    "bgtaskregistrationmaintenancetask",
    "autochk\\proxy",
    "siuf",
    "device information",
    "edp policy manager"
)

$scheduled_tasks = schtasks /query /fo list
$task_names = [System.Collections.ArrayList]@()

foreach ($line in $scheduled_tasks) {
    if ($line.contains("TaskName:")) {
        $task_names.Add($line.Split(":")[1].Trim().ToLower()) | Out-Null
    }
}

foreach ($wildcard in $wildcards) {
    Write-Output "info: searching for $wildcard"
    foreach ($task in $task_names) {
        if ($task.contains($wildcard)) {
            schtasks.exe /change /disable /tn `"$task`" | Out-Null
            C:\bin\NSudo.exe -U:T -P:E -ShowWindowMode:Hide schtasks.exe /change /disable /tn `"$task`"
        }
    }
}
