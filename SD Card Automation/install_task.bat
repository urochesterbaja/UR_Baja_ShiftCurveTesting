@echo off

:: --- Auto Elevate ---
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting Administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

set TASK_NAME=Move SdioLogger
set SCRIPT_DIR=%~dp0
set PS_SCRIPT=%SCRIPT_DIR%move_from_SD.ps1

echo Installing scheduled task for storage arrival events...

schtasks /Create ^
 /TN "%TASK_NAME%" ^
 /TR "powershell.exe -ExecutionPolicy Bypass -File \"%PS_SCRIPT%\"" ^
 /SC ONEVENT ^
 /EC "Microsoft-Windows-Storage-ClassPnP/Operational" ^
 /MO "*[System[(EventID=507)]]" ^
 /RL HIGHEST ^
 /F

echo Adjusting task power conditions...

powershell -Command ^
"$task = Get-ScheduledTask -TaskName '%TASK_NAME%'; ^
$task.Settings.DisallowStartIfOnBatteries = $false; ^
$task.Settings.StopIfGoingOnBatteries = $false; ^
Set-ScheduledTask -InputObject $task"

echo.
echo Installation complete.
pause
