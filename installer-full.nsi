; iot-master Windows Installer Script (Complete with MongoDB)
; 使用 NSIS 编译: makensis installer-full.nsi

!include "MUI2.nsh"

; 基本信息
!define APPNAME "iot-master"
!define COMPANYNAME "iot-master"
!define DESCRIPTION "物联大师 - 物联网数据中台"
!define VERSIONMAJOR 1
!define VERSIONMINOR 0
!define VERSIONBUILD 0
!define INSTALLSIZE 150000

; 安装程序属性
Name "${APPNAME}"
OutFile "iot-master-setup.exe"
InstallDir "$PROGRAMFILES\${APPNAME}"
InstallDirRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "InstallLocation"
RequestExecutionLevel admin

; 界面设置
!define MUI_ABORTWARNING

; 页面设置
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

; 卸载页面
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

; 语言设置
!insertmacro MUI_LANGUAGE "SimpChinese"

; 安装部分
Section "install"
    ; 设置输出目录
    SetOutPath $INSTDIR

    ; 安装主程序文件
    File "iot-master.exe"
    File /r "www\*.*"
    File "iot-master.yaml"
    File "start.bat"

    ; 安装 MongoDB
    SetOutPath $INSTDIR\mongodb\bin
    File "mongodb\bin\mongod.exe"
    File "mongodb\bin\vc_redist.x64.exe"

    ; 创建 MongoDB 数据目录
    CreateDirectory "$INSTDIR\mongodb\data"
    CreateDirectory "$INSTDIR\mongodb\log"

    ; 安装 VC++ 运行库
    ExecWait '"$INSTDIR\mongodb\bin\vc_redist.x64.exe" /q /norestart'

    ; 创建桌面快捷方式
    CreateShortcut "$DESKTOP\${APPNAME}.lnk" "$INSTDIR\start.bat" "" "" 0

    ; 创建开始菜单
    CreateDirectory "$SMPROGRAMS\${APPNAME}"
    CreateShortcut "$SMPROGRAMS\${APPNAME}\启动 ${APPNAME}.lnk" "$INSTDIR\start.bat" "" "" 0
    CreateShortcut "$SMPROGRAMS\${APPNAME}\安装目录.lnk" "$INSTDIR" "" "" 0
    CreateShortcut "$SMPROGRAMS\${APPNAME}\卸载 ${APPNAME}.lnk" "$INSTDIR\uninstall.exe" "" "" 0

    ; 创建卸载程序
    WriteUninstaller "$INSTDIR\uninstall.exe"

    ; 写入卸载注册表
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayName" "${APPNAME}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "UninstallString" "$\"$INSTDIR\uninstall.exe$\""
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "QuietUninstallString" "$\"$INSTDIR\uninstall.exe$\" /S"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "InstallLocation" "$\"$INSTDIR$\""
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "Publisher" "${COMPANYNAME}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayVersion" "${VERSIONMAJOR}.${VERSIONMINOR}.${VERSIONBUILD}"
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "VersionMajor" ${VERSIONMAJOR}
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "VersionMinor" ${VERSIONMINOR}
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "NoModify" 1
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "NoRepair" 1
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "EstimatedSize" ${INSTALLSIZE}

    ; 启动服务
    ExecShell "" "$INSTDIR\start.bat" "$INSTDIR" SW_SHOW

SectionEnd

; 卸载部分
Section "uninstall"
    ; 删除文件
    Delete "$INSTDIR\iot-master.exe"
    Delete "$INSTDIR\iot-master.yaml"
    Delete "$INSTDIR\start.bat"
    Delete "$INSTDIR\uninstall.exe"
    Delete "$INSTDIR\mongodb\bin\mongod.exe"
    Delete "$INSTDIR\mongodb\bin\vc_redist.x64.exe"

    ; 删除目录
    RMDir /r "$INSTDIR\www"
    RMDir /r "$INSTDIR\mongodb"

    ; 删除桌面快捷方式
    Delete "$DESKTOP\${APPNAME}.lnk"

    ; 删除开始菜单
    RMDir /r "$SMPROGRAMS\${APPNAME}"

    ; 删除安装目录
    RMDir "$INSTDIR"

    ; 删除注册表
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"
SectionEnd
