@echo off
setlocal EnableDelayedExpansion

:: Requirements
:: - cURL

echo info: checking for an internet connection
ping 1.1.1.1 > nul 2>&1
if not !errorlevel! == 0 (
    echo error: no internet connection
    exit /b
)

set "current_dir=%~dp0"
set "current_dir=!current_dir:~0,-1!"

for %%a in ("python-embed.zip" "get-pip.py") do (
    if exist "!temp!\%%~a" (
        del /f /q "!temp!\%%~a"
    )
)

echo info: downloading python
curl.exe -l "https://www.python.org/ftp/python/3.8.6/python-3.8.6-embed-amd64.zip" -o "!temp!\python-embed.zip"
echo info: downloading get-pip.py
curl.exe -l "https://bootstrap.pypa.io/get-pip.py" -o "!temp!\get-pip.py"

set "err=0"
for %%a in (
    "python-embed.zip" 
    "get-pip.py"
) do (
    if not exist "!temp!\%%~a" (
        set "err=1"
        echo error: %%~a download failed
    )
)
if not !err! == 0 exit /b

echo info: verifying hash
for /f "delims=" %%a in ('certutil -hashfile "!temp!\python-embed.zip" ^| find /i /v "SHA1" ^| find /i /v "Certutil"') do (
    set "file_sha1=%%a"
)
set "file_sha1=!file_sha1: =!"

if not "!file_sha1!" == "855de5c4049ee9469da03d0aac8d3b4ca3e29af5" (
    echo error: sha1 mismatch, binary may be corrupted
    exit /b
)

if exist "!current_dir!\python" (
    rd /s /q "!current_dir!\python"
)
mkdir "!current_dir!\python"

echo info: extracting python
PowerShell "Expand-Archive -Force '!temp!\python-embed.zip' '!current_dir!\python'"

echo info: installing pip
"!current_dir!\python\python.exe" "!temp!\get-pip.py"

>> "!current_dir!\python\python38._pth" echo Lib\site-packages

:: install modules with "!python!\python.exe" -m pip install <module>

for %%a in (
    "python-embed.zip" 
    "get-pip.py"
) do (
    if exist "!temp!\%%~a" (
        del /f /q "!temp!\%%~a"
    )
)

echo info: done
exit /b