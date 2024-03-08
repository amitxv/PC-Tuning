function Is-Admin() {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function main() {
    if (-not (Is-Admin)) {
        Write-Host "error: administrator privileges required"
        return 1
    }

    if (Test-Path ".\tmp\") {
        Remove-Item -Path ".\tmp\" -Recurse -Force
    }

    mkdir ".\tmp\"

    $urls = @{
        "NanaRun" = "https://github.com/M2Team/NanaRun.git"
    }

    # =============
    # Setup MinSudo
    # =============

    # clone NanaRun repo
    git clone $urls["NanaRun"] ".\tmp\NanaRun\"
    git -C .\tmp\NanaRun\ submodule update --init --recursive

    # build binaries
    MSBuild.exe ".\tmp\NanaRun\NanaRun.sln" /t:Restore /p:Configuration=Release /p:Platform=x86 /p:PreferredToolArchitecture=x64
    MSBuild.exe ".\tmp\NanaRun\NanaRun.sln" -p:Configuration=Release -p:Platform=x64

    # copy MinSudo to bin directory
    Copy-Item ".\tmp\NanaRun\Output\Binaries\Release\x64\MinSudo.exe" ".\bin\"

    return 0
}

$_exitCode = main
Write-Host # new line
exit $_exitCode
