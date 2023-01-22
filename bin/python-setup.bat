@echo off
setlocal EnableDelayedExpansion

:: Requirements
:: - 7-Zip
:: - cURL

echo info: checking for an internet connection
ping 1.1.1.1 > nul 2>&1
if not !errorlevel! == 0 (
    echo error: no internet connection
    echo info: press any key to continue
    pause > nul 2>&1
    exit /b
)

set "err=0"
for %%a in (
    "curl.exe"
    "7z.exe"
) do (
    where %%~a > nul 2>&1
    if not !errorlevel! == 0 (
        set "err=1"
        echo error: %%~a not found in path
    )
)
if not !err! == 0 exit /b

set "current_dir=%~dp0"
set "current_dir=!current_dir:~0,-1!"

for %%a in ("python-embed.zip" "get-pip.py") do (
    if exist "!temp!\%%~a" (
        del /f /q "!temp!\%%~a"
    )
)

curl.exe -l "https://www.python.org/ftp/python/3.8.6/python-3.8.6-embed-amd64.zip" -o "!temp!\python-embed.zip"
curl.exe -l "https://bootstrap.pypa.io/get-pip.py" -o "!temp!\get-pip.py"

set "err=0"
for %%a in ("python-embed.zip" "get-pip.py") do (
    if not exist "!temp!\%%~a" (
        set "err=1"
        echo error: %%~a download failed
    )
)
if not !err! == 0 exit /b

for /f "delims=" %%a in ('certutil -hashfile "!temp!\python-embed.zip" SHA1 ^| find /i /v "SHA1" ^| find /i /v "Certutil"') do (
    set "file_sha1=%%a"
)
set "file_sha1=!file_sha1: =!"

if not "!file_sha1!" == "855de5c4049ee9469da03d0aac8d3b4ca3e29af5" (
    echo error: sha1 mismatch, binary may be corrupted
    pause > nul 2>&1
    exit /b
)

if exist "!current_dir!\python" (
    rd /s /q "!current_dir!\python"
)
mkdir "!current_dir!\python"

7z x "!temp!\python-embed.zip" -o"!current_dir!\python"

"!current_dir!\python\python.exe" "!temp!\get-pip.py"

>> "!current_dir!\python\python38._pth" echo Lib\site-packages

for %%a in ("python-embed.zip" "get-pip.py") do (
    if exist "!temp!\%%~a" (
        del /f /q "!temp!\%%~a"
    )
)

echo info: done
echo info: press any key to continue
pause > nul 2>&1
exit /b