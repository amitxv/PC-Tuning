param(
    [Parameter(Mandatory = $true)]
    [ValidateSet(7, 8, 10, 11)]
    [int]$winver
)

function Is-Admin() {
    $current_principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $current_principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Apply-Registry($file_path) {
    regedit.exe /s `"$file_path`"
    C:\bin\NSudo.exe -U:T -P:E -ShowWindowMode:Hide regedit.exe /s `"$file_path`"
}

if (!(Is-Admin)) {
    Write-Host "error: administrator privileges required"
    exit
}

foreach ($file in @("7.reg", "7+.reg", "7-8.reg", "8.reg", "8+.reg", "10.reg", "10+.reg", "11+.reg")) {
    $file_name = $file.replace(".reg", "")
    $file = "C:\bin\registry\$file"

    if ($file_name.Contains("+")) {
        if ([int]$file_name.replace("+", "") -le $winver) {
            Apply-Registry($file)
        }
    } elseif ($file_name.Contains("-")) {
        $lower, $upper = $file_name.Split("-")
        if (($winver -ge $lower) -and ($winver -le $upper)) {
            Apply-Registry($file)
        }
    } elseif ([int]$file_name -eq $winver) {
        Apply-Registry($file)
    }
}

Write-Host "info: successfully applied registry settings for windows $winver"
