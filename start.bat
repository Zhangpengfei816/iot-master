@echo off
cd /d "%~dp0"

echo ========================================
echo    iot-master starting...
echo ========================================
echo.

set APPDIR=%~dp0
set MONGODIR=%APPDIR%mongodb\bin
set DATADIR=%APPDIR%mongodb\data
set LOGDIR=%APPDIR%mongodb\log

if not exist "%DATADIR%" mkdir "%DATADIR%"
if not exist "%LOGDIR%" mkdir "%LOGDIR%"

echo [1/2] Starting MongoDB...
start "" /B "%MONGODIR%\mongod.exe" --dbpath "%DATADIR%" --logpath "%LOGDIR%\mongodb.log" --bind_ip 127.0.0.1 --port 27018

ping 127.0.0.1 -n 4 > nul

echo [2/2] Starting iot-master service...
echo.
echo ========================================
echo   Started successfully!
echo ========================================
echo.
echo   URL: http://localhost:8888
echo   Username: admin
echo   Password: 123456
echo.
echo   NOTE: Closing this window stops the service
echo ========================================
echo.

iot-master.exe
pause
