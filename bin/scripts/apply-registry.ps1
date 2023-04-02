param(
    [Parameter(Mandatory = $true)]
    [ValidateSet(7, 8, 10, 11)]
    [int]$winver
)

function is_admin() {
    $current_principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $current_principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function apply_registry($file_path) {
    # user privileges
    Start-Process -FilePath "regedit.exe" -ArgumentList "/s $file_path" -Wait
    # trustedinstaller privileges
    Start-Process -FilePath "C:\bin\NSudo.exe" -ArgumentList "-U:T -P:E -Wait regedit.exe /s $file_path" -Wait
}

if (!(is_admin)) {
    Write-Host "error: administrator privileges required"
    exit
}

foreach ($file in @("7+.reg", "7-8.reg", "8.reg", "8+.reg", "10+.reg", "11+.reg")) {
    $file_name = $file.replace(".reg", "")
    $file = "C:\bin\registry\$file"

    if ($file_name.Contains("+")) {
        if ([int]$file_name.replace("+", "") -le $winver) {
            apply_registry($file)
        }
    } elseif ($file_name.Contains("-")) {
        $lower, $upper = $file_name.Split("-")
        if (($winver -ge $lower) -and ($winver -le $upper)) {
            apply_registry($file)
        }
    } elseif ([int]$file_name -eq $winver) {
        apply_registry($file)
    }
}

Write-Host "info: successfully applied registry settings for windows $winver"
