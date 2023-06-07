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
    (reg.exe import `"$file_path`") 2>&1 > $null
    $normal_call = $LASTEXITCODE

    (C:\bin\NSudo.exe -U:T -P:E -ShowWindowMode:Hide reg.exe import `"$file_path`") 2>&1 > $null
    $nsudo_call = $LASTEXITCODE

    return $normal_call -band $nsudo_call
}

if (!(Is-Admin)) {
    Write-Host "error: administrator privileges required"
    exit
}

foreach ($file in @("7.reg", "7+.reg", "7-8.reg", "8.reg", "8+.reg", "10.reg", "10+.reg", "11+.reg")) {
    $file_name = $file.replace(".reg", "")
    $file = "C:\bin\registry\$file"
    $is_successful = 0

    if ($file_name.Contains("+")) {
        if ([int]$file_name.replace("+", "") -le $winver) {
            $is_successful = Apply-Registry($file)
        }
    } elseif ($file_name.Contains("-")) {
        $lower, $upper = $file_name.Split("-")
        if (($winver -ge $lower) -and ($winver -le $upper)) {
            $is_successful = Apply-Registry($file)
        }
    } elseif ([int]$file_name -eq $winver) {
        $is_successful = Apply-Registry($file)
    }

    if ($is_successful -ne 0) {
        Write-Host "error: failed merging one or more registry files"
        exit
    }
}

Write-Host "info: successfully applied registry settings for windows $winver"
