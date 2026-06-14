@echo off
chcp 65001 >nul
echo ========================================
echo   iot-master Downloader
echo ========================================
echo.

set REPO=Zhangpengfei816/iot-master
set BRANCH=trae/solo-agent-jqD7h7
set BASE=https://cdn.jsdelivr.net/gh/%REPO%@%BRANCH%/

echo Downloading part 1/4 (20MB)...
powershell -Command "Invoke-WebRequest -Uri '%BASE%iot-master-part-aa' -OutFile 'iot-master-part-aa'"

echo Downloading part 2/4 (20MB)...
powershell -Command "Invoke-WebRequest -Uri '%BASE%iot-master-part-ab' -OutFile 'iot-master-part-ab'"

echo Downloading part 3/4 (20MB)...
powershell -Command "Invoke-WebRequest -Uri '%BASE%iot-master-part-ac' -OutFile 'iot-master-part-ac'"

echo Downloading part 4/4 (6MB)...
powershell -Command "Invoke-WebRequest -Uri '%BASE%iot-master-part-ad' -OutFile 'iot-master-part-ad'"

echo.
echo ========================================
echo   Merging files...
echo ========================================
copy /b iot-master-part-aa + iot-master-part-ab + iot-master-part-ac + iot-master-part-ad iot-master-setup.exe

echo.
echo ========================================
echo   Cleanup...
echo ========================================
del iot-master-part-aa
del iot-master-part-ab
del iot-master-part-ac
del iot-master-part-ad

echo.
echo ========================================
echo   Done!
echo ========================================
echo.
echo   iot-master-setup.exe is ready!
echo   Right click and select "Run as administrator"
echo.
pause
