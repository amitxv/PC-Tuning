function main() {
    if (Test-Path ".\tmp\") {
        Remove-Item -Path ".\tmp\" -Recurse -Force
    }

    $urls = @{
        "NanaRun" = "https://github.com/M2Team/NanaRun.git"
    }

    # =============
    # Setup MinSudo
    # =============
    git clone $urls["NanaRun"] ".\tmp\NanaRun\"
    git -C .\tmp\NanaRun\ submodule update --init --recursive

    MSBuild.exe ".\tmp\NanaRun\NanaRun.sln" /t:Restore /p:Configuration=Release /p:Platform=x86 /p:PreferredToolArchitecture=x64
    MSBuild.exe ".\tmp\NanaRun\NanaRun.sln" -p:Configuration=Release -p:Platform=x64

    Copy-Item ".\tmp\NanaRun\Output\Binaries\Release\x64\MinSudo.exe" ".\bin\"

    return 0
}

$_exitCode = main
Write-Host # new line
exit $_exitCode
