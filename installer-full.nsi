; iot-master Windows Installer Script (Complete with MongoDB)
; Compile with NSIS: makensis installer-full.nsi

!include "MUI2.nsh"

!define APPNAME "iot-master"
!define COMPANYNAME "iot-master"
!define DESCRIPTION "iot-master IoT platform"
!define VERSIONMAJOR 1
!define VERSIONMINOR 0
!define VERSIONBUILD 0
!define INSTALLSIZE 150000

Name "${APPNAME}"
OutFile "iot-master-setup.exe"
InstallDir "$PROGRAMFILES\${APPNAME}"
InstallDirRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "InstallLocation"
RequestExecutionLevel admin

!define MUI_ABORTWARNING

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "English"

Section "install"
    SetOutPath $INSTDIR

    ; Main program files
    File "iot-master.exe"
    File /r "www\*.*"
    File "iot-master.yaml"
    File "start.bat"

    ; MongoDB
    SetOutPath $INSTDIR\mongodb\bin
    File "mongodb\bin\mongod.exe"
    File "mongodb\bin\vc_redist.x64.exe"

    CreateDirectory "$INSTDIR\mongodb\data"
    CreateDirectory "$INSTDIR\mongodb\log"

    ; VC++ runtime
    ExecWait '"$INSTDIR\mongodb\bin\vc_redist.x64.exe" /q /norestart'

    ; Desktop shortcut
    CreateShortcut "$DESKTOP\${APPNAME}.lnk" "$INSTDIR\start.bat" "" "" 0

    ; Start menu
    CreateDirectory "$SMPROGRAMS\${APPNAME}"
    CreateShortcut "$SMPROGRAMS\${APPNAME}\Start ${APPNAME}.lnk" "$INSTDIR\start.bat" "" "" 0
    CreateShortcut "$SMPROGRAMS\${APPNAME}\Install Directory.lnk" "$INSTDIR" "" "" 0
    CreateShortcut "$SMPROGRAMS\${APPNAME}\Uninstall ${APPNAME}.lnk" "$INSTDIR\uninstall.exe" "" "" 0

    ; Uninstaller
    WriteUninstaller "$INSTDIR\uninstall.exe"

    ; Registry
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

    ; Start service
    ExecShell "" "$INSTDIR\start.bat" "$INSTDIR" SW_SHOW

SectionEnd

Section "uninstall"
    Delete "$INSTDIR\iot-master.exe"
    Delete "$INSTDIR\iot-master.yaml"
    Delete "$INSTDIR\start.bat"
    Delete "$INSTDIR\uninstall.exe"
    Delete "$INSTDIR\mongodb\bin\mongod.exe"
    Delete "$INSTDIR\mongodb\bin\vc_redist.x64.exe"

    RMDir /r "$INSTDIR\www"
    RMDir /r "$INSTDIR\mongodb"

    Delete "$DESKTOP\${APPNAME}.lnk"
    RMDir /r "$SMPROGRAMS\${APPNAME}"
    RMDir "$INSTDIR"

    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"
SectionEnd
