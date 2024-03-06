function main() {
    if (Test-Path ".\tmp\") {
        Remove-Item -Path ".\tmp\" -Recurse
    }

    $urls = @{
        "NanaRun" = "https://github.com/M2Team/NanaRun.git"
    }

    # =============
    # Setup MinSudo
    # =============
    git clone $urls["NanaRun"] ".\tmp\NanaRun\"
    Push-Location ".\tmp\NanaRun\"

    # build MinSudo
    git submodule update --init --recursive
    MSBuild.exe ".\NanaRun.sln" /t:Restore /p:Configuration=Release /p:Platform=x86 /p:PreferredToolArchitecture=x64
    MSBuild.exe ".\NanaRun.sln" -p:Configuration=Release -p:Platform=x64

    Pop-Location

    Copy-Item ".\tmp\NanaRun\Output\Binaries\Release\x64\MinSudo.exe" ".\bin\"

    return 0
}

$_exitCode = main
Write-Host # new line
exit $_exitCode
