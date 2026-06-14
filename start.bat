@echo off
chcp 65001
title iot-master 物联大师
color 0A

echo ========================================
echo    iot-master 物联大师 正在启动
echo ========================================
echo.

REM 设置路径
set APPDIR=%~dp0
set MONGODIR=%APPDIR%mongodb\bin
set DATADIR=%APPDIR%mongodb\data
set LOGDIR=%APPDIR%mongodb\log

REM 创建数据目录
if not exist "%DATADIR%" mkdir "%DATADIR%"
if not exist "%LOGDIR%" mkdir "%LOGDIR%"

REM 启动 MongoDB
echo [1/2] 启动数据库...
start "" /B "%MONGODIR%\mongod.exe" --dbpath "%DATADIR%" --logpath "%LOGDIR%\mongodb.log" --bind_ip 127.0.0.1 --port 27017

timeout /t 3 /nobreak >nul

REM 启动 iot-master
echo [2/2] 启动应用服务...
echo.
echo ========================================
echo  启动完成！
echo ========================================
echo.
echo 请访问: http://localhost:8888
echo 默认账号: admin
echo 默认密码: 123456
echo.
echo 注意: 关闭此窗口将导致服务停止
echo ========================================
echo.

cd /d "%APPDIR%"
iot-master.exe

pause
