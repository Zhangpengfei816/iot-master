; iot-master Windows Installer Script
; 使用 NSIS 编译: makensis installer.nsi

!include "MUI2.nsh"

; 基本信息
!define APPNAME "iot-master"
!define COMPANYNAME "iot-master"
!define DESCRIPTION "物联大师 - 物联网数据中台"
!define VERSIONMAJOR 1
!define VERSIONMINOR 0
!define VERSIONBUILD 0
!define INSTALLSIZE 40000

; 安装程序属性
Name "${APPNAME}"
OutFile "iot-master-setup.exe"
InstallDir "$PROGRAMFILES\${APPNAME}"
InstallDirRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "InstallLocation"
RequestExecutionLevel admin

; 界面设置
!define MUI_ICON "www\favicon.ico"
!define MUI_UNICON "www\favicon.ico"
!define MUI_ABORTWARNING

; 欢迎页面
!insertmacro MUI_PAGE_WELCOME

; 许可协议页面（可选）
; !insertmacro MUI_PAGE_LICENSE "LICENSE.txt"

; 安装目录页面
!insertmacro MUI_PAGE_DIRECTORY

; 安装过程页面
!insertmacro MUI_PAGE_INSTFILES

; 完成页面
!insertmacro MUI_PAGE_FINISH

; 卸载欢迎页面
!insertmacro MUI_UNPAGE_WELCOME

; 卸载确认页面
!insertmacro MUI_UNPAGE_CONFIRM

; 卸载过程页面
!insertmacro MUI_UNPAGE_INSTFILES

; 完成后页面
!insertmacro MUI_UNPAGE_FINISH

; 语言设置
!insertmacro MUI_LANGUAGE "SimpChinese"

; 安装部分
Section "install"
    ; 设置输出目录
    SetOutPath $INSTDIR

    ; 安装文件
    File "iot-master.exe"
    File /r "www\*.*"
    File "iot-master.yaml"

    ; 创建启动脚本
    WriteIniStr "$INSTDIR\iot-master.ini" "Desktop" "Shortcut" "$DESKTOP\${APPNAME}.lnk"

    ; 创建开始菜单快捷方式
    CreateDirectory "$SMPROGRAMS\${APPNAME}"
    CreateShortcut "$SMPROGRAMS\${APPNAME}\${APPNAME}.lnk" "$INSTDIR\iot-master.exe" "" "$INSTDIR\iot-master.exe" 0
    CreateShortcut "$SMPROGRAMS\${APPNAME}\卸载.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0

    ; 创建桌面快捷方式
    CreateShortcut "$DESKTOP\${APPNAME}.lnk" "$INSTDIR\iot-master.exe" "" "$INSTDIR\iot-master.exe" 0

    ; 创建卸载程序
    WriteUninstaller "$INSTDIR\uninstall.exe"

    ; 写入注册表（用于卸载）
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayName" "${APPNAME}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "UninstallString" "$\"$INSTDIR\uninstall.exe$\""
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "QuietUninstallString" "$\"$INSTDIR\uninstall.exe$\" /S"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "InstallLocation" "$\"$INSTDIR$\""
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayIcon" "$\"$INSTDIR\iot-master.exe$\""
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "Publisher" "${COMPANYNAME}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayVersion" "${VERSIONMAJOR}.${VERSIONMINOR}.${VERSIONBUILD}"
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "VersionMajor" ${VERSIONMAJOR}
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "VersionMinor" ${VERSIONMINOR}
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "NoModify" 1
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "NoRepair" 1
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "EstimatedSize" ${INSTALLSIZE}
SectionEnd

; 卸载部分
Section "uninstall"
    ; 删除文件
    Delete "$INSTDIR\iot-master.exe"
    Delete "$INSTDIR\iot-master.yaml"
    Delete "$INSTDIR\uninstall.exe"
    Delete "$INSTDIR\*.ini"

    ; 删除 www 目录
    RMDir /r "$INSTDIR\www"

    ; 删除桌面快捷方式
    Delete "$DESKTOP\${APPNAME}.lnk"

    ; 删除开始菜单
    RMDir /r "$SMPROGRAMS\${APPNAME}"

    ; 删除安装目录
    RMDir "$INSTDIR"

    ; 删除注册表
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"
SectionEnd
