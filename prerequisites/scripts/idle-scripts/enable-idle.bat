@echo off

powercfg -setacvalueindex scheme_current sub_processor 5d76a2ca-e8c0-402f-a133-2158492d58ad 0
powercfg -setactive scheme_current

echo info: done
echo info: press any key to continue
pause > nul 2>&1
exit /b 0
