@echo off
setlocal EnableDelayedExpansion

:: Requirements
:: - Python 3.8.6 preferred
:: - 7-Zip

set "err=0"
for %%a in (
    "python.exe"
    "pip.exe"
) do (
    where %%a
    if not !errorlevel! == 0 (
        set "err=1"
        echo error: %%a not found in path
    )
)
if not !err! == 0 exit /b 1

set "CURRENT_DIR=%~dp0"
set "CURRENT_DIR=!CURRENT_DIR:~0,-1!"

set "BUILD_ENV=!CURRENT_DIR!\BUILD_ENV"
set "PROJECT_DIR=!BUILD_ENV!\main"
set "PUBLISH_DIR=!BUILD_ENV!\install-firefox"

if exist "!BUILD_ENV!" (
    rd /s /q "!BUILD_ENV!"
)
mkdir "!BUILD_ENV!"
mkdir "!PROJECT_DIR!"

python -m venv "!BUILD_ENV!"
call "!BUILD_ENV!\Scripts\activate.bat"

pip install -r ".\requirements.txt"

copy /y "!CURRENT_DIR!\install-firefox.py" "!PROJECT_DIR!"
cd "!PROJECT_DIR!"

pyinstaller ".\install-firefox.py" --onefile

call "!BUILD_ENV!\Scripts\deactivate.bat"

cd "!CURRENT_DIR!"

if exist ".\install-firefox.exe" (
    del /f /q ".\install-firefox.exe"
)

move "!PROJECT_DIR!\dist\install-firefox.exe" "!CURRENT_DIR!"

rd /s /q "!BUILD_ENV!"

exit /b 0
