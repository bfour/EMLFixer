#include <AVIConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

#include <GuiListView.au3>
#include <GuiImageList.au3>

#include <_dropFiles.au3>
#include "helpGUI.au3"
#include "aboutGUI.au3"
#include "donateGUI.au3"

Global $GUIIsBusy = False
Global $GUIIsInterruptRequested = False

Func _createGUI()

   Opt("GUIOnEventMode", 1)

   Global $mainGUI, $fileList, $rootDirInput, $syncDirInput, $statusLabel, $statusIcon, $busyAVI, $startButton, $stopButton

   #Region ### START Koda GUI section ### Form=S:\sabox\grid\EMLFixer\GUI\mainGUI.kxf
   Global $mainGUI = GUICreate("EMLFixer", 971, 587, -1, -1, BitOR($GUI_SS_DEFAULT_GUI,$WS_MAXIMIZEBOX,$WS_SIZEBOX,$WS_THICKFRAME,$WS_TABSTOP), BitOR($WS_EX_ACCEPTFILES,$WS_EX_WINDOWEDGE))
   GUISetOnEvent($GUI_EVENT_CLOSE, "mainGUIClose")
   GUISetOnEvent($GUI_EVENT_MINIMIZE, "mainGUIMinimize")
   GUISetOnEvent($GUI_EVENT_MAXIMIZE, "mainGUIMaximize")
   GUISetOnEvent($GUI_EVENT_RESTORE, "mainGUIRestore")
   Global $syncDirInput = GUICtrlCreateInput("", 610, 491, 221, 24)
   GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
   GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
   GUICtrlSetOnEvent(-1, "syncDirInputChange")
   Global $selectSyncDirButton = GUICtrlCreateButton("Select Sync Directory", 836, 490, 125, 26)
   GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
   GUICtrlSetOnEvent(-1, "selectSyncDirButtonClick")
   Global $startButton = GUICtrlCreateButton("Start", 866, 542, 95, 35)
   GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
   GUICtrlSetOnEvent(-1, "startButtonClick")
   Global $rootDirInput = GUICtrlCreateInput("", 250, 491, 221, 24)
   GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
   GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
   GUICtrlSetOnEvent(-1, "rootDirInputChange")
   Global $fileList = GUICtrlCreateListView("", 10, 10, 950, 470)
   GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKBOTTOM)
   GUICtrlSetOnEvent(-1, "fileListClick")
   Global $selectRootDirButton = GUICtrlCreateButton("Select Root Directory", 476, 490, 125, 26)
   GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
   GUICtrlSetOnEvent(-1, "selectRootDirButtonClick")
   Global $busyAVI = GUICtrlCreateAvi(@ScriptDir&"\GUI\busy_16.avi", 0, 813, 551, 18, 15, BitOR($GUI_SS_DEFAULT_AVI,$ACS_AUTOPLAY))
   GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
   GUICtrlSetState(-1, $GUI_HIDE)
   Global $statusLabel = GUICtrlCreateLabel("", 455, 542, 354, 34, BitOR($SS_RIGHT,$SS_CENTERIMAGE))
   GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
   GUICtrlSetOnEvent(-1, "statusLabelClick")
   Global $statusIcon = GUICtrlCreateIcon("", -1, 813, 547, 22, 22)
   GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
   GUICtrlSetState(-1, $GUI_HIDE)
   GUICtrlSetOnEvent(-1, "statusIconClick")
   Global $stopButton = GUICtrlCreateIcon("", -1, 840, 549, 22, 22)
   GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
   GUICtrlSetState(-1, $GUI_HIDE)
   GUICtrlSetOnEvent(-1, "stopButtonClick")
   Global $aboutButton = GUICtrlCreateButton("About", 10, 542, 95, 35)
   GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
   GUICtrlSetOnEvent(-1, "aboutButtonClick")
   Global $helpButton = GUICtrlCreateButton("Help", 110, 542, 95, 35)
   GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
   GUICtrlSetOnEvent(-1, "helpButtonClick")
   Global $donateButton = GUICtrlCreateButton("Donate", 210, 542, 95, 35)
   GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
   GUICtrlSetOnEvent(-1, "donateButtonClick")
   Global $dragdropIcon = GUICtrlCreateIcon("S:\sabox\grid\EMLFixer\GUI\dragndrop_text.ico", -1, 363, 190, 245, 123)
   GUICtrlSetResizing(-1, $GUI_DOCKHCENTER+$GUI_DOCKVCENTER+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
   GUISetState(@SW_SHOW)
   #EndRegion ### END Koda GUI section ###

   GUICtrlSetState($fileList, $GUI_HIDE)
   GUICtrlSetState($selectRootDirButton, $GUI_SHOW) ; TODO remove

   Local $iImageSquareSize = 14
   Local $hImage = _GUIImageList_Create($iImageSquareSize, $iImageSquareSize, 5, 3)
   _GUIImageList_AddIcon($hImage, @ScriptDir&"\GUI\file.ico")
   _GUIImageList_AddIcon($hImage, @ScriptDir&"\GUI\info.ico")
   _GUIImageList_AddIcon($hImage, @ScriptDir&"\GUI\warning.ico")
   _GUIImageList_AddIcon($hImage, @ScriptDir&"\GUI\OK.ico")
   _GUIImageList_AddIcon($hImage, @ScriptDir&"\GUI\error.ico")
   _GUICtrlListView_SetImageList($fileList, $hImage, 1)

   _GUICtrlListView_AddColumn($fileList, "Status", 150)
   _GUICtrlListView_AddColumn($fileList, "File to be fixed", 300)
   _GUICtrlListView_AddColumn($fileList, "Modification time", 100)
   _GUICtrlListView_AddColumn($fileList, "File in sync directory", 300)
   _GUICtrlListView_AddColumn($fileList, "Modification time", 100)
   _fixColumnsBug()

   GUICtrlSetImage($stopButton, @ScriptDir&"\GUI\stop_22.ico")

   $fileDropDummy = GUICtrlCreateDummy()
   GUICtrlSetOnEvent(-1, "filesDropped")
   _dropfilesRegisterCallbackDummy($fileDropDummy)

EndFunc

Func mainGUIClose()
   Exit
EndFunc

Func selectRootDirButtonClick()
   Local $rootDir = FileSelectFolder("Select the root folder.", "", 0, @MyDocumentsDir, $mainGUI)
   If @error Then
	  TrayTip(@ScriptName, "Root directory selection failed.", 10) ; TODO improve
	  Return
   EndIf
   GUICtrlSetData($rootDirInput, $rootDir)
   _matchRootWithSyncDir()
EndFunc

Func selectSyncDirButtonClick()
   Local $dir = FileSelectFolder("Select the sync folder.", "", 0, @MyDocumentsDir, $mainGUI)
   If @error Then
	  TrayTip(@ScriptName, "Sync directory selection failed.", 10) ; TODO improve
	  Return
   EndIf
   GUICtrlSetData($syncDirInput, $dir)
   _matchRootWithSyncDir()
EndFunc

Func rootDirInputChange()
   _matchRootWithSyncDir()
EndFunc

Func syncDirInputChange()
   _matchRootWithSyncDir()
EndFunc

Func filesDropped()

   GUICtrlSetState($fileList, $GUI_SHOW)
   _setBusy("processing dropped files")

   _GUICtrlListView_DeleteAllItems($fileList)
   For $i=0 To UBound($_dropFilesDroppedFilesArray)-1
	  Local $path = $_dropFilesDroppedFilesArray[$i]
	  _GUICtrlListView_AddItem($fileList, "ready", 0)
	  _GUICtrlListView_AddSubItem($fileList, $i, $path, 1)
	  _GUICtrlListView_AddSubItem($fileList, $i, FileGetTime($path, $FT_MODIFIED, $FT_STRING), 2)
	  _GUICtrlListView_EnsureVisible($fileList, $i)
	  If Mod($i,14)==0 And _isInterruptRequested() Then
		 _setAborted("processing dropped files cancelled")
		 Return
	  EndIf
   Next

   _matchRootWithSyncDir()

   _setDone(UBound($_dropFilesDroppedFilesArray)&" files added")

EndFunc

Func stopButtonClick()
   $GUIIsInterruptRequested = True
   ConsoleWrite("interrupt")
EndFunc

Func _isInterruptRequested()
   If GUIGetMsg() == $stopButton Then
;~    If $GUIIsInterruptRequested Then
	  $GUIIsInterruptRequested = False
	  Return True
   ElseIf GUIGetMsg() == $GUI_EVENT_CLOSE Then
	  Exit
   Else
	  Return False
   EndIf
EndFunc

Func _setBusy($message)
   Opt("GUIOnEventMode", 0)
   GUICtrlSetState($startButton, $GUI_DISABLE)
   $GUIIsBusy = True
   $GUIIsInterruptRequested = False
   GUICtrlSetData($statusLabel, $message)
   GUICtrlSetState($statusIcon, $GUI_HIDE)
   GUICtrlSetState($busyAVI, $GUI_SHOW)
   GUICtrlSetState($stopButton, $GUI_SHOW)
   GUICtrlSetState($busyAVI, $GUI_AVISTART)
EndFunc

Func _updateBusyStatus($message)
   GUICtrlSetData($statusLabel, $message)
EndFunc

Func _setDone($message)
   Opt("GUIOnEventMode", 1)
   GUICtrlSetData($statusLabel, $message)
   GUICtrlSetState($busyAVI, $GUI_HIDE)
   GUICtrlSetState($stopButton, $GUI_HIDE)
   GUICtrlSetImage($statusIcon, @ScriptDir&"\GUI\OK.ico")
   GUICtrlSetState($statusIcon, $GUI_SHOW)
   $GUIIsBusy = False
   $GUIIsInterruptRequested = False
   GUICtrlSetState($startButton, $GUI_ENABLE)
EndFunc

Func _setAborted($message)
   _setDone($message)
   GUICtrlSetImage($statusIcon, @ScriptDir&"\GUI\warning.ico")
EndFunc

Func _matchRootWithSyncDir()

   If GUICtrlRead($syncDirInput)=="" Or GUICtrlRead($rootDirInput)=="" Or _GUICtrlListView_GetItemCount($fileList)==0 Then Return

   _setBusy("matching files with sync dir")

   Local $rootDir = GUICtrlRead($rootDirInput)
   Local $syncDir = GUICtrlRead($syncDirInput)
   Local $paths = $_dropFilesDroppedFilesArray
   Local $matchCount = 0
   Local $mismatchCount = 0

   For $i=0 To UBound($paths)-1
	  Local $path = $paths[$i]
	  Local $subPath = StringTrimLeft($path, StringLen($rootdir))
	  Local $syncPath = $syncDir & $subPath
	  If FileExists($syncPath) Then
		 _GUICtrlListView_AddSubItem($fileList, $i, "ready", 0, 1)
		 $matchCount += 1
	  Else
		 _GUICtrlListView_AddSubItem($fileList, $i, "file missing in sync dir", 0, 2)
		 $mismatchCount += 1
	  EndIf
	  _GUICtrlListView_AddSubItem($fileList, $i, $syncPath, 3)
	  _GUICtrlListView_AddSubItem($fileList, $i, FileGetTime($syncPath, $FT_MODIFIED, $FT_STRING), 4)
	  _GUICtrlListView_EnsureVisible($fileList, $i)
;~ 	  ConsoleWrite($syncPath&@LF)
	  If Mod($i,10)==0 And _isInterruptRequested() Then
		 _setAborted("matching files cancelled")
		 Return
	  EndIf
   Next

   _fixColumnsBug()
   If $mismatchCount==0 Then
	  _setDone("matching complete: all files match")
   Else
	  _setAborted("matching failed for "&$mismatchCount&" files")
   EndIf

EndFunc

Func _fixColumnsBug()
   _GUICtrlListView_SetColumnOrder($fileList, "1|2|3|4|0")
   Local $curPos = WinGetPos($mainGUI)
   WinMove($mainGUI, "", $curPos[0], $curPos[1], $curPos[2]+1, $curPos[3]+1)
   WinMove($mainGUI, "", $curPos[0], $curPos[1], $curPos[2], $curPos[3])
EndFunc

Func startButtonClick()

;~    If GUICtrlRead($syncDirInput) == "" Then
;~ 	  Local $answer = MsgBox($MB_OKCANCEL + $MB_ICONINFORMATION, "EMLFixer", "You didn't set a sync directory. "& _
;~ 	  "This means that this tool shall merely remove the Zone Identifier ADS, "& _
;~ 	  "but will not restore any timestamps. Removing the ADS will cause the timestamp "& _
;~ 	  "to be set to the current time under Windows 10. "&@LF& _
;~ 	  @LF& _
;~ 	  "Select OK to continue.")
;~ 	  If $answer <> $IDOK Then
;~ 		 _setAborted("processing aborted")
;~ 		 Return
;~ 	  EndIf
;~    EndIf

   _setBusy("processing, please wait ...")

   Local $processedCounter = 0
   Local $skippedCounter = 0
   Local $errorCounter = 0

   For $i=0 To _GUICtrlListView_GetItemCount($fileList)-1

	  _GUICtrlListView_EnsureVisible($fileList, $i)
	  _updateBusyStatus("processing "&$i+1&" of "&_GUICtrlListView_GetItemCount($fileList))

	  Local $item = _GUICtrlListView_GetItemTextArray($fileList, $i)
	  Local $localPath = $item[2]
	  Local $status = $item[1]
	  Local $lastChangeTimeLocal = $item[3]
	  Local $syncPath = $item[4]
	  Local $lastChangeTimeSync = $item[5]

	  If $status<>"ready" Then
		 $skippedCounter += 1
		 ConsoleWrite("skipping "&$localPath&" because status not ready"&@LF)
		 If StringInStr($status, "file missing")<>0 Then
			_GUICtrlListView_AddSubItem($fileList, $i, "skipped: missing sync file", 0, 2)
		 ElseIf StringInStr($status, "ADS removed")<>0 Then
			_GUICtrlListView_AddSubItem($fileList, $i, "skipped: already processed", 0, 2)
		 Else
			_GUICtrlListView_AddSubItem($fileList, $i, "skipped", 0, 2)
		 EndIf
		 ContinueLoop
	  EndIf

	  _ZoneId_ADSStreamDelete($localPath)
	  If @error Then
		 _GUICtrlListView_AddSubItem($fileList, $i, "failed to remove ADS", 0, 4)
		 $errorCounter += 1
		 ContinueLoop
	  EndIf
	  ConsoleWrite("removed ADS from "&$localPath&@LF)
	  _GUICtrlListView_AddSubItem($fileList, $i, "ADS removed", 0, 3)

	  Local $setTimeError
	  If $lastChangeTimeSync <> "" Then
		 FileSetTime($localPath, $lastChangeTimeSync, $FT_MODIFIED)
		 $setTimeError = @error
	  Else
		 FileSetTime($localPath, $lastChangeTimeLocal, $FT_MODIFIED)
		 $setTimeError = @error
	  EndIf
	  If $setTimeError Then
		 _GUICtrlListView_AddSubItem($fileList, $i, "failed to restore modification time", 0, 4)
		 $errorCounter += 1
		 ContinueLoop
	  EndIf
	  ConsoleWrite("set last modification date to "&$lastChangeTimeSync&" for "&$localPath&@LF)
	  _GUICtrlListView_AddSubItem($fileList, $i, "ADS removed and time reset", 0, 3)

	  $processedCounter += 1

	  If Mod($i,15)==0 And _isInterruptRequested() Then
		 _setAborted("processing files cancelled")
		 Return
	  EndIf

   Next

   Local $doneText = ""
   If $processedCounter == 0 Then
	  $doneText = "skipped all "&$skippedCounter&" files"
   Else
	  $doneText = "processed "&$processedCounter&", skipped "&$skippedCounter&" files"
   EndIf
   If $errorCounter > 0 Then $doneText &= "; "&$errorCounter&" files failed to be processed"
   _setDone($doneText)

EndFunc

Func aboutButtonClick()
   _aboutGUIShow()
EndFunc

Func helpButtonClick()
   _helpGUIShow()
EndFunc

Func donateButtonClick()
   _donateGUIShow()
EndFunc