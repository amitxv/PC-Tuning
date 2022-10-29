@echo off
setlocal EnableDelayedExpansion

dism > nul 2>&1 || echo error: administrator privileges required && pause && exit /b 1

pushd "%~dp0"

set "install_wim="
if exist ".\sources\install.wim" (
    set "install_wim=.\sources\install.wim"
) else (
    if exist ".\sources\install.esd" (
        set "install_wim=.\sources\install.esd"
    ) else (
        echo error: directory does not appear to be a windows image
        echo info: press any key to continue
        pause > nul 2>&1
        exit /b 1
    )
)

:select_drive
set /p install_dir="Enter the drive letter you created to install windows on: "

set "err=0"
if defined install_dir (
    if exist "!install_dir!:" (
        if exist ".\autounattend.xml" (
            DISM /Apply-Image /ImageFile:"!install_wim!" /Apply-Unattend:".\autounattend.xml" /Index:1 /ApplyDir:"!install_dir!:"
            if not !errorlevel! == 0 (
                set "err=1"
            ) else (
                if exist "!install_dir!:\Windows\System32\Sysprep" (
                    copy /y ".\autounattend.xml" "!install_dir!:\Windows\System32\Sysprep" > nul 2>&1
                ) else (
                    echo error: sysprep folder does not exist
                    set "err=1"
                )
            )
        ) else (
            DISM /Apply-Image /ImageFile:"!install_wim!" /Index:1 /ApplyDir:"!install_dir!:"
            if not !errorlevel! == 0 (
                set "err=1"
            ) 
        )

        if !err! == 0 (
            bcdboot "!install_dir!:\Windows" > nul 2>&1
            echo info: restart pc
        ) else (
            echo error: dism apply-image unsuccessful
        )

        echo info: press any key to continue
        pause > nul 2>&1
        exit /b !err!
    )
)

echo error: invalid input
goto :select_drive