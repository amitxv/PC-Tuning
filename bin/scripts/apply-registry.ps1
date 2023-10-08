param(
    [Parameter(Mandatory = $true)][ValidateSet(7, 8, 10, 11)]
    [int]$winver,
    [switch]$ui_cleanup
)

function Is-Admin() {
    $current_principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $current_principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Apply-Registry($file_path) {
    $user_merge_result = (Start-Process "reg.exe" -ArgumentList "import $file_path" -PassThru -Wait -WindowStyle Hidden).ExitCode
    $trustedinstaller_merge_result = [int](C:\bin\MinSudo.exe --NoLogo --TrustedInstaller --Privileged cmd /c "reg import $file_path > nul 2>&1 && echo 0 || echo 1")

    return $user_merge_result -band $trustedinstaller_merge_result
}

function main() {
    if (-not (Is-Admin)) {
        Write-Host "error: administrator privileges required"
        return 1
    }

    Write-Host "info: please wait..."

    foreach ($file in @("7+.reg", "7-8.reg", "8.reg", "8+.reg", "10.reg", "10+.reg", "11+.reg")) {
        $file_name = $file.replace(".reg", "")
        $file = "C:\bin\registry\$file"
        $is_successful = 0

        if ($file_name.Contains("+")) {
            if ([int]$file_name.replace("+", "") -le $winver) {
                $is_successful = Apply-Registry -file_path $file
            }
        } elseif ($file_name.Contains("-")) {
            $lower, $upper = $file_name.Split("-")
            if (($winver -ge $lower) -and ($winver -le $upper)) {
                $is_successful = Apply-Registry -file_path $file
            }
        } elseif ([int]$file_name -eq $winver) {
            $is_successful = Apply-Registry -file_path $file
        }

        if ($is_successful -ne 0) {
            Write-Host "error: failed merging one or more registry files"
            return 1
        }
    }

    if ($ui_cleanup -and (Apply-Registry("C:\bin\registry\ui-cleanup.reg") -ne 0)) {
        Write-Host "error: failed merging ui_cleanup.reg"
        return 1
    }

    Write-Host "info: successfully applied registry settings for windows $($winver)"
    return 0
}

exit main
