@echo off
setlocal EnableDelayedExpansion

set "aria2c=C:\prerequisites\aria2c.exe"
set "link=https://gitlab.com/librewolf-community/browser/windows/uploads/d96a60d617eb1c8ddd5fb91c665eaab5/librewolf-103.0-3.en-US.win64-setup.exe"
set "sha1=2e750bb589f3952061de989efe8ebca56bd6fd4c"
set "file_name=librewolf-103.0-3.en-US.win64-setup.exe"
set "working_dir=!temp!\librewolf"

ping archlinux.org > nul 2>&1
if not !errorlevel! == 0 (
    echo error: no internet connection
	echo info: press any key to continue
	pause > nul 2>&1
    exit /b 1
)

if not exist "!aria2c!" (
    echo error: !aria2c! not exists
	echo info: press any key to continue
	pause > nul 2>&1
    exit /b 1
)

if exist !working_dir! (
    rd /s /q "!working_dir!"
)
mkdir "!working_dir!"

echo info: downloading librewolf
"!aria2c!" "!link!" -d "!working_dir!" -o "!file_name!"

if not exist "!working_dir!\!file_name!" (
    echo error: download unsuccessful, please download librewolf manually
	echo info: press any key to continue
	pause > nul 2>&1
    exit /b 1
)

for /f "delims=" %%a in ('certutil -hashfile "!working_dir!\!file_name!" SHA1 ^| find /i /v "SHA1" ^| find /i /v "Certutil"') do (
    set "file_sha1=%%a"
)
set "file_sha1=!file_sha1: =!"

if not "!file_sha1!" == "!sha1!" (
    echo error: sha1 mismatch, binary may be corrupted
)

start "" "!working_dir!\!file_name!"

echo info: press any key to continue
pause > nul 2>&1
exit /b 0

