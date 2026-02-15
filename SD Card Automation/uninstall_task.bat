@echo off

:: --- Auto Elevate ---
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting Administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

set TASK_NAME=Move SdioLogger

echo Removing scheduled task...

schtasks /Delete /TN "%TASK_NAME%" /F

echo.
echo Task removed.
pause
