; TODO
; - check whether Pd is installed
;  this is where Pd stores it's settings:
;   HKEY_LOCAL_MACHINE\SOFTWARE\Pd
;  this is the uninstaller-information of Pd-extended
;   HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\pd_is1   InstallLocation

; - ask to set env-variables
;      GEM_SINGLE_CONTEXT    /* ??? */
;      GEM_RECTANGLE_TEXTURE /* unneeded since glew? */
;      GEM_NO_TABLET         /* unneeded as [gemtablet] was dropped */
;      GEM_DEFAULT_FONT      /* "$INSTDIR/examples/data/vera.ttf" */
;  system-envvars:
;   HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment
;  user-envvars:
;   HKEY_CURRENT_USER\Environment

; Script generated by the HM NIS Edit Script Wizard.
; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "Gem"
!ifndef PRODUCT_VERSION
 !define PRODUCT_VERSION "0.93"
!endif
!define PRODUCT_ARCH "-W32-i686"
!define PRODUCT_PUBLISHER "iem et al."
!define PRODUCT_WEB_SITE "http://gem.iem.at"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

OutFile "gem-${PRODUCT_VERSION}${PRODUCT_ARCH}.exe"


; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!insertmacro MUI_PAGE_LICENSE "..\..\GnuGPL.LICENSE.txt"
; Components page
!insertmacro MUI_PAGE_COMPONENTS
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"

; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"

InstallDir "$PROGRAMFILES\pd\extra\Gem"
ShowInstDetails show
ShowUnInstDetails show

; the sections for the library itself (binary+abstractions)

SectionGroup "Gem" SEC_Gem
 Section "Gem-binary" SEC_GemBinary
  SetOverwrite ifnewer
  SectionIn RO
  SetOutPath "$INSTDIR"
  File "..\win-vs2003\Gem.dll"
  File "..\..\GnuGPL.LICENSE.txt"
 SectionEnd
 Section "Gem-abstractions" SEC_GemAbs
  SectionIn RO
  SetOverwrite ifnewer
  SetOutPath "$INSTDIR"
  File "..\..\abstractions\*.pd"
 SectionEnd

SectionGroup "plugins"

Section "DirectShow movies" SEC_plugin_filmDS
   SetOverwrite ifnewer
   SetOutPath "$INSTDIR"
   File "..\win-vs2003\gem_filmDS.dll"
SectionEnd
Section "QuickTime movies" SEC_plugin_filmQT
   SetOverwrite ifnewer
   SetOutPath "$INSTDIR"
   File "..\win-vs2003\gem_filmQT.dll"
SectionEnd
Section /o "AVI movies" SEC_plugin_filmAVI
   SetOverwrite ifnewer
   SetOutPath "$INSTDIR"
   File "..\win-vs2003\gem_filmAVI.dll"
SectionEnd

Section "ImageMagick images" SEC_plugin_imageMAGICK
   SetOverwrite ifnewer
   SetOutPath "$INSTDIR"
   File "..\win-vs2003\gem_imageMAGICK.dll"
SectionEnd
Section "QuickTime images" SEC_plugin_imageQT
   SetOverwrite ifnewer
   SetOutPath "$INSTDIR"
   File "..\win-vs2003\gem_imageQT.dll"
SectionEnd
Section /o "SGI images" SEC_plugin_imageSGI
   SetOverwrite ifnewer
   SetOutPath "$INSTDIR"
   File "..\win-vs2003\gem_imageSGI.dll"
SectionEnd
Section /o "JPEG images" SEC_plugin_imageJPEG
   SetOverwrite ifnewer
   SetOutPath "$INSTDIR"
   File "..\win-vs2003\gem_imageJPEG.dll"
SectionEnd
Section /o "TIFF images" SEC_plugin_imageTIFF
   SetOverwrite ifnewer
   SetOutPath "$INSTDIR"
   File "..\win-vs2003\gem_imageTIFF.dll"
SectionEnd

Section "QuickTime recording" SEC_plugin_recordQT
   SetOverwrite ifnewer
   SetOutPath "$INSTDIR"
   File "..\win-vs2003\gem_recordQT.dll"
SectionEnd

Section "DirectShow capturing" SEC_plugin_videoDS
   SetOverwrite ifnewer
   SetOutPath "$INSTDIR"
   File "..\win-vs2003\gem_videoDS.dll"
SectionEnd
Section /o "VFW capturing" SEC_plugin_videoVFW
   SetOverwrite ifnewer
   SetOutPath "$INSTDIR"
   File "..\win-vs2003\gem_videoVFW.dll"
SectionEnd
Section /o "Allied Vision Technologies capturing" SEC_plugin_videoAVT
   SetOverwrite ifnewer
   SetOutPath "$INSTDIR"
   File "..\win-vs2003\gem_videoAVT.dll"
SectionEnd
Section /o "MVTec/HALCON capturing" SEC_plugin_videoHALCON
   SetOverwrite ifnewer
   SetOutPath "$INSTDIR"
   File "..\win-vs2003\gem_videoHALCON.dll"
SectionEnd
Section /o "Basler/PYLON capturing" SEC_plugin_videoPYLON
   SetOverwrite ifnewer
   SetOutPath "$INSTDIR"
   File "..\win-vs2003\gem_videoPYLON.dll"
SectionEnd

SectionGroupEnd

SectionGroup "Documentation" SEC_documentation
 Section "reference" SEC_ref
  SetOverwrite ifnewer
  SetOutPath "$INSTDIR"
  File /r /x .svn "..\..\help\*.pd"
 SectionEnd

 Section "examples" SEC_examples
  SetOverwrite ifnewer
  SetOutPath "$INSTDIR\examples\"
  File /r /x .svn "..\..\examples\*.*"
  ; this should only be set if there is no entry yet
  WriteRegStr HKCU "Environment" "GEM_DEFAULT_FONT" "$INSTDIR\examples\data\vera.ttf"
 SectionEnd

 Section "manual" SEC_manual
  SetOverwrite ifnewer
  SetOutPath "$INSTDIR\doc\manual"
  File /r /x .svn "..\..\doc\manual\*.*"
 SectionEnd

 Section "doc" SEC_doc
  SetOverwrite ifnewer
  SetOutPath "$INSTDIR\doc"
  File /r /x .svn "..\..\doc\*.*"
 SectionEnd
SectionGroupEnd


Function .onInit
 ; prevent multiple instances running at the same time
 System::Call 'kernel32::CreateMutexA(i 0, i 0, t "gemInstallerMutex") i .r1 ?e'
 Pop $R0
 StrCmp $R0 0 +3
  MessageBox MB_OK|MB_ICONEXCLAMATION "The installer is already running."
  Abort
FunctionEnd


Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) has been successfully uninstalled."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Do you really want to uninstall $(^Name) and all it's components?" IDYES +2
  Abort
FunctionEnd

; u�h: isn't there a way to only delete the files we actually installed?
; that is: without having to enumerate them here
Section Uninstall
  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\*.pd"
  Delete "$INSTDIR\Gem.dll"

  Delete "$INSTDIR\filmAVI.dll"
  Delete "$INSTDIR\filmDS.dll"
  Delete "$INSTDIR\filmQT.dll"
  Delete "$INSTDIR\imageJPEG.dll"
  Delete "$INSTDIR\imageMAGICK.dll"
  Delete "$INSTDIR\imageQT.dll"
  Delete "$INSTDIR\imageSGI.dll"
  Delete "$INSTDIR\imageTIFF.dll"
  Delete "$INSTDIR\recordQT.dll"
  Delete "$INSTDIR\videoAVT.dll"
  Delete "$INSTDIR\videoDS.dll"
  Delete "$INSTDIR\videoHALCON.dll"
  Delete "$INSTDIR\videoPYLON.dll"
  Delete "$INSTDIR\videoVFW.dll"

  Delete "$INSTDIR\doc\manual\*.*"
  RMDir "$INSTDIR\doc\manual"

  Delete "$INSTDIR\doc\*.*"
  RMDir "$INSTDIR\doc"

  Delete "$INSTDIR\examples\data\*.*"
  Delete "$INSTDIR\examples\99.games\*.pd"
  Delete "$INSTDIR\examples\10.glsl\*.frag"
  Delete "$INSTDIR\examples\10.glsl\*.vert"
  Delete "$INSTDIR\examples\10.glsl\*.jpg"
  Delete "$INSTDIR\examples\10.glsl\*.pd"
  Delete "$INSTDIR\examples\09.openGL\*.pd"
  Delete "$INSTDIR\examples\08.io\*.pd"
  Delete "$INSTDIR\examples\07.texture\*.pd"
  Delete "$INSTDIR\examples\06.particle\*.pd"
  Delete "$INSTDIR\examples\05.text\*.ttf"
  Delete "$INSTDIR\examples\05.text\*.pd"
  Delete "$INSTDIR\examples\04.video\*.pd"
  Delete "$INSTDIR\examples\04.pix\*.pd"
  Delete "$INSTDIR\examples\03.lighting\*.pd"
  Delete "$INSTDIR\examples\02.advanced\*.pd"
  Delete "$INSTDIR\examples\01.basic\*.pd"
  RMDir "$INSTDIR\examples\data"
  RMDir "$INSTDIR\examples\99.games"
  RMDir "$INSTDIR\examples\10.glsl"
  RMDir "$INSTDIR\examples\09.openGL"
  RMDir "$INSTDIR\examples\08.io"
  RMDir "$INSTDIR\examples\07.texture"
  RMDir "$INSTDIR\examples\06.particle"
  RMDir "$INSTDIR\examples\05.text"
  RMDir "$INSTDIR\examples\04.video"
  RMDir "$INSTDIR\examples\04.pix"
  RMDir "$INSTDIR\examples\03.lighting"
  RMDir "$INSTDIR\examples\02.advanced"
  RMDir "$INSTDIR\examples\01.basic"
  RMDir "$INSTDIR\examples"

  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  ; try to delete   HKCU\"Environment"\"GEM_DEFAULT_FONT" if it is "$INSTDIR\examples\data\vera.ttf"

  SetAutoClose true
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd


!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
 !insertmacro MUI_DESCRIPTION_TEXT ${SEC_Gem} "Graphical Environment for Multimedia"
 !insertmacro MUI_DESCRIPTION_TEXT ${SEC_GemBinary} "the Gem binary"
 !insertmacro MUI_DESCRIPTION_TEXT ${SEC_GemAbs} "Gem-abstractions"
 !insertmacro MUI_DESCRIPTION_TEXT ${SEC_documentation} "Gem documentation: patches, HTML, PDFs,..."
 !insertmacro MUI_DESCRIPTION_TEXT ${SEC_ref} "reference patches for Gem-objects"
 !insertmacro MUI_DESCRIPTION_TEXT ${SEC_examples} "a large number of patches showing what to do with GEM"
 !insertmacro MUI_DESCRIPTION_TEXT ${SEC_manual} "HTML-manual"
 !insertmacro MUI_DESCRIPTION_TEXT ${SEC_doc} "Gem primer,..."

#plugins
 !insertmacro MUI_DESCRIPTION_TEXT ${SEC_plugin_filmDS} "allows to read movies using DirectShow filters"
 !insertmacro MUI_DESCRIPTION_TEXT ${SEC_plugin_filmQT} "allows to read movies using Apple's QuickTime library (if present)"
 !insertmacro MUI_DESCRIPTION_TEXT ${SEC_plugin_filmAVI} "allows to read movies using Microsoft's old (and deprecated) AVI library"

 !insertmacro MUI_DESCRIPTION_TEXT ${SEC_plugin_videoDS} "allows to capture live video sources using DirectShow filters"
 !insertmacro MUI_DESCRIPTION_TEXT ${SEC_plugin_videoVFW} "allows to capture live video using Microsoft's old (and deprecated) Video-For-Windows method"
 !insertmacro MUI_DESCRIPTION_TEXT ${SEC_plugin_recordQT} "allows to output Gem-pixes into QuickTime MOVie files"


!insertmacro MUI_DESCRIPTION_TEXT ${SEC_plugin_filmDS} "allows to read movies using DirectShow filters"
!insertmacro MUI_DESCRIPTION_TEXT ${SEC_plugin_filmQT} "allows to read movies using Apple's QuickTime library (you will have to download and install QuickTime for Windows yourself in order to use this)"
!insertmacro MUI_DESCRIPTION_TEXT ${SEC_plugin_filmAVI} "allows to read movies using Microsoft's old (and deprecated) AVI library"

!insertmacro MUI_DESCRIPTION_TEXT ${SEC_plugin_imageMAGICK} "allows to read/write still images using ImageMagick (this can virtually read/write any image format, including but not limited to JPEG, TIFF and SGI, so it's probably the only 'image' plugin you need)"
!insertmacro MUI_DESCRIPTION_TEXT ${SEC_plugin_imageQT} "allows to read/write still images using Apple's QuickTime (you will have to download and install QuickTime for Windows yourself in order to use this)"
!insertmacro MUI_DESCRIPTION_TEXT ${SEC_plugin_imageSGI} "allows to read SGI images"
!insertmacro MUI_DESCRIPTION_TEXT ${SEC_plugin_imageJPEG} "allows to read/write JPEG images"
!insertmacro MUI_DESCRIPTION_TEXT ${SEC_plugin_imageTIFF} "allows to read/write TIFF images"

!insertmacro MUI_DESCRIPTION_TEXT ${SEC_plugin_recordQT} "allows to output Gem-pixes into QuickTime MOVie files (you will have to download and install QuickTime for Windows yourself in order to use this)"

!insertmacro MUI_DESCRIPTION_TEXT ${SEC_plugin_videoDS} "allows to capture live video sources using DirectShow filters"
!insertmacro MUI_DESCRIPTION_TEXT ${SEC_plugin_videoVFW} "allows to capture live video using Microsoft's old (and deprecated) Video-For-Windows method"
!insertmacro MUI_DESCRIPTION_TEXT ${SEC_plugin_videoAVT} "allows to capture live video from GigE-cameras using AVT (Allied Vision Technologies); supported cameras include the Prosilica family (http://www.alliedvisiontec.com) "
!insertmacro MUI_DESCRIPTION_TEXT ${SEC_plugin_videoHALCON} "allows to capture live video from a number of devices (including GigE-cameras and industry grade frame grabbers) using MVTec's HALCON library; you will need to purchase a license from MVTec in order to be able to use this plugin (http://www.mvtec.com) "
!insertmacro MUI_DESCRIPTION_TEXT ${SEC_plugin_videoPYLON} "allows to capture live video from GigE-cameras using Basler's PYLON library; mainly supports Basler cameras; you might need to download additional software in order to use this plugin (http://www.baslerweb.com)"


!insertmacro MUI_FUNCTION_DESCRIPTION_END
