@echo off
chcp 65001
title iot-master 启动器
color 0A

echo ========================================
echo    iot-master 物联大师
echo ========================================
echo.

REM 检查 Go
where go >nul 2>nul
if %errorlevel% neq 0 (
    echo [错误] 未检测到 Go，请先安装: https://go.dev/dl/
    echo 安装后请重启电脑，然后重新运行此脚本
    pause
    exit /b 1
)

echo [OK] Go 已安装: 
go version
echo.

REM 检查 Node.js
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo [错误] 未检测到 Node.js，请先安装: https://nodejs.org/
    echo 安装后请重启电脑，然后重新运行此脚本
    pause
    exit /b 1
)

echo [OK] Node.js 已安装:
node --version
echo.

echo ----------------------------------------
echo 正在编译后端...
echo ----------------------------------------
go build -o iot-master.exe cmd/main.go
if %errorlevel% neq 0 (
    echo [错误] 后端编译失败
    pause
    exit /b 1
)
echo [OK] 后端编译完成
echo.

echo ----------------------------------------
echo 正在安装前端依赖...
echo ----------------------------------------
call npm install
if %errorlevel% neq 0 (
    echo [错误] npm install 失败
    pause
    exit /b 1
)
echo [OK] 依赖安装完成
echo.

echo ----------------------------------------
echo 正在构建前端...
echo ----------------------------------------
call npm run build
if %errorlevel% neq 0 (
    echo [错误] 前端构建失败
    pause
    exit /b 1
)
echo [OK] 前端构建完成
echo.

echo ========================================
echo  启动完成！
echo ========================================
echo.
echo 请访问: http://localhost:8888
echo 默认账号: admin
echo 默认密码: 123456
echo.
echo 注意: 需要先安装并启动 MongoDB
echo MongoDB 下载: https://www.mongodb.com/try/download/community
echo MongoDB 默认连接: localhost:27017
echo.
echo 按任意键启动服务...
pause >nul

REM 启动服务
iot-master.exe

pause
