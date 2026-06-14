@echo off
chcp 65001
title iot-master 物联大师 - 编译版
color 0A

echo ========================================
echo    iot-master 编译打包脚本
echo ========================================
echo.

REM 检查 Go
where go >nul 2>nul
if %errorlevel% neq 0 (
    echo [错误] 未检测到 Go，请先安装: https://go.dev/dl/
    pause
    exit /b 1
)

echo [OK] Go 已安装
echo.

REM 检查 Node.js
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo [错误] 未检测到 Node.js，请先安装: https://nodejs.org/
    pause
    exit /b 1
)

echo [OK] Node.js 已安装
echo.

REM 创建 output 文件夹
if not exist "iot-master-portable" mkdir "iot-master-portable"

echo ----------------------------------------
echo 正在编译后端...
echo ----------------------------------------
call go build -o iot-master-portable\iot-master.exe cmd\main.go
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

echo ----------------------------------------
echo 正在复制配置文件...
echo ----------------------------------------
copy iot-master.yaml iot-master-portable\ >nul
echo [OK] 配置文件已复制
echo.

echo ----------------------------------------
echo 正在复制启动脚本...
echo ----------------------------------------
(
echo @echo off
echo chcp 65001
echo title iot-master 物联大师
echo color 0A
echo echo ========================================
echo echo    iot-master 物联大师
echo echo ========================================
echo echo.
echo echo 正在启动服务...
echo echo.
echo echo 请访问: http://localhost:8888
echo echo 默认账号: admin
echo echo 默认密码: 123456
echo echo.
echo echo 注意: 需要先启动 MongoDB
echo echo.
echo iot-master.exe
echo pause
) > iot-master-portable\启动.bat

echo [OK] 启动脚本已创建
echo.

echo ========================================
echo  打包完成！
echo ========================================
echo.
echo 完整的可移植版本已生成: iot-master-portable
echo.
echo 此文件夹包含:
echo   - iot-master.exe    (后端程序)
echo   - www\              (前端界面)
echo   - iot-master.yaml   (配置文件)
echo   - 启动.bat          (启动脚本)
echo.
echo 使用方法:
echo   1. 将整个 iot-master-portable 文件夹拷贝到其他电脑
echo   2. 确保那台电脑已安装 MongoDB
echo   3. 双击 启动.bat 即可运行
echo.
echo ========================================
echo.
pause
