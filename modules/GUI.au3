#include <AVIConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

#include <GuiListView.au3>
#include <GuiImageList.au3>
#include <GuiAVI.au3>

#include <_dropFiles.au3>

Global $GUIIsBusy = False
Global $GUIIsInterruptRequested = False

Func _createGUI()

   Opt("GUIOnEventMode", 1)

   Global $mainGUI, $fileList, $rootDirInput, $syncDirInput, $statusLabel, $statusIcon, $busyAVI, $startButton

#Region ### START Koda GUI section ### Form=S:\sabox\grid\EMLFixer\GUI\mainGUI.kxf
$mainGUI = GUICreate("EMLFixer", 971, 597, -1, -1, BitOR($GUI_SS_DEFAULT_GUI,$WS_MAXIMIZEBOX,$WS_SIZEBOX,$WS_THICKFRAME,$WS_TABSTOP), BitOR($WS_EX_ACCEPTFILES,$WS_EX_WINDOWEDGE))
GUISetOnEvent($GUI_EVENT_CLOSE, "mainGUIClose")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "mainGUIMinimize")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "mainGUIMaximize")
GUISetOnEvent($GUI_EVENT_RESTORE, "mainGUIRestore")
$syncDirInput = GUICtrlCreateInput("", 660, 520, 171, 21)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT)
GUICtrlSetOnEvent(-1, "syncDirInputChange")
$selectSyncDirButton = GUICtrlCreateButton("Select Sync Directory", 836, 520, 125, 25)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetOnEvent(-1, "selectSyncDirButtonClick")
$startButton = GUICtrlCreateButton("Start", 856, 552, 105, 35)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetOnEvent(-1, "startButtonClick")
$rootDirInput = GUICtrlCreateInput("", 660, 490, 171, 21)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT)
GUICtrlSetOnEvent(-1, "rootDirInputChange")
$fileList = GUICtrlCreateListView("", 10, 10, 950, 470)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKBOTTOM)
GUICtrlSetOnEvent(-1, "fileListClick")
$selectRootDirButton = GUICtrlCreateButton("Select Root Directory", 836, 490, 125, 25)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetOnEvent(-1, "selectRootDirButtonClick")
$busyAVI = GUICtrlCreateAvi(@ScriptDir&"\GUI\busy_indicator_32x32.avi", -1, 820, 552, 32, 32)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetState(-1, $GUI_HIDE)
$statusLabel = GUICtrlCreateLabel(" ", 570, 550, 217, 37, BitOR($SS_RIGHT,$SS_CENTERIMAGE))
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetOnEvent(-1, "statusLabelClick")
$stopButton = GUICtrlCreateButton("stopButton", 790, 550, 25, 25)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlSetOnEvent(-1, "stopButtonClick")
$statusIcon = GUICtrlCreateIcon("", -1, 820, 550, 35, 35)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlSetOnEvent(-1, "statusIconClick")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

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

   _setBusy("processing dropped files")

   _GUICtrlListView_DeleteAllItems($fileList)
   For $i=0 To UBound($_dropFilesDroppedFilesArray)-1
	  Local $path = $_dropFilesDroppedFilesArray[$i]
	  _GUICtrlListView_AddItem($fileList, "File added", 0)
	  _GUICtrlListView_AddSubItem($fileList, $i, $path, 1)
	  _GUICtrlListView_AddSubItem($fileList, $i, FileGetTime($path, $FT_MODIFIED, $FT_STRING), 2)
	  If _isInterruptRequested() Then
		 _setAborted("processing dropped files cancelled")
		 Return
	  EndIf
   Next

   _matchRootWithSyncDir()

   _setDone(UBound($_dropFilesDroppedFilesArray)&" files added")

EndFunc

Func stopButtonClick()
   $GUIIsInterruptRequested = True
EndFunc

Func _isInterruptRequested()
   If $GUIIsInterruptRequested Then
	  $GUIIsInterruptRequested = False
	  Return True
   Else
	  Return False
   EndIf
EndFunc

Func _setBusy($message)
   GUICtrlSetState($startButton, $GUI_DISABLE)
   $GUIIsBusy = True
   GUICtrlSetData($statusLabel, $message)
   GUICtrlSetState($busyAVI, $GUI_SHOW)
   GUICtrlSetState($busyAVI, $GUI_AVISTART)
EndFunc

Func _updateBusyStatus($message)
   GUICtrlSetData($statusLabel, $message)
EndFunc

Func _setDone($message)
   GUICtrlSetState($startButton, $GUI_ENABLE)
   $GUIIsBusy = False
   GUICtrlSetData($statusLabel, $message)
   GUICtrlSetState($busyAVI, $GUI_HIDE)
   GUICtrlSetState($statusIcon, $GUI_SHOW)
   GUICtrlSetData($statusIcon, @ScriptDir&"\GUI\OK.ico")
EndFunc

Func _setAborted($message)
   GUICtrlSetState($startButton, $GUI_ENABLE)
   $GUIIsBusy = False
   GUICtrlSetData($statusLabel, $message)
   GUICtrlSetState($busyAVI, $GUI_HIDE)
   GUICtrlSetState($statusIcon, $GUI_SHOW)
   GUICtrlSetData($statusIcon, @ScriptDir&"\GUI\warning.ico")
EndFunc

Func _matchRootWithSyncDir()

   If GUICtrlRead($syncDirInput)=="" Or GUICtrlRead($rootDirInput)=="" Then Return

   _setBusy("matching files with sync dir")

   Local $rootDir = GUICtrlRead($rootDirInput)
   Local $syncDir = GUICtrlRead($syncDirInput)
   Local $paths = $_dropFilesDroppedFilesArray

   For $i=0 To UBound($paths)-1
	  Local $path = $paths[$i]
	  Local $subPath = StringTrimLeft($path, StringLen($rootdir))
	  Local $syncPath = $syncDir & $subPath
	  If FileExists($syncPath) Then
		 _GUICtrlListView_AddSubItem($fileList, $i, "ready", 0, 1)
	  Else
		 _GUICtrlListView_AddSubItem($fileList, $i, "file missing in sync dir", 0, 2)
	  EndIf
	  _GUICtrlListView_AddSubItem($fileList, $i, $syncPath, 3)
	  _GUICtrlListView_AddSubItem($fileList, $i, FileGetTime($syncPath, $FT_MODIFIED, $FT_STRING), 4)
	  ConsoleWrite($syncPath&@LF)
	  If _isInterruptRequested() Then
		 _setAborted("matching files cancelled")
		 Return
	  EndIf
   Next

   _fixColumnsBug()
   _setDone("file matching completed")

EndFunc

Func _fixColumnsBug()
   _GUICtrlListView_SetColumnOrder($fileList, "1|2|3|4|0")
   Local $curPos = WinGetPos($mainGUI)
   WinMove($mainGUI, "", $curPos[0], $curPos[1], $curPos[2]+1, $curPos[3]+1)
   WinMove($mainGUI, "", $curPos[0], $curPos[1], $curPos[2], $curPos[3])
EndFunc

Func startButtonClick()

   _setBusy("processing, please wait ...")

   Local $processedCounter = 0
   Local $skippedCounter = 0

   For $i=0 To _GUICtrlListView_GetItemCount($fileList)-1

	  _updateBusyStatus("processing "&$i+1&" of "&_GUICtrlListView_GetItemCount($fileList))

	  Local $item = _GUICtrlListView_GetItemTextArray($fileList, $i)
	  Local $localPath = $item[2]
	  Local $status = $item[1]
	  If $status<>"ready" Then
		 $skippedCounter += 1
		 ConsoleWrite("skipping "&$localPath&" because status not OK"&@LF)
		 ContinueLoop
	  EndIf
	  Local $syncPath = $item[4]
	  Local $lastChangeTimeSync = $item[5]

	  _ZoneId_ADSStreamDelete($localPath)
	  If @error Then
		 _GUICtrlListView_AddSubItem($fileList, $i, "failed to remove ADS", 0, 4)
		 ContinueLoop
	  EndIf
	  ConsoleWrite("removed ADS from "&$localPath&@LF)

	  FileSetTime($localPath, $lastChangeTimeSync, $FT_MODIFIED)
	  If @error Then
		 _GUICtrlListView_AddSubItem($fileList, $i, "failed to restore modification time", 0, 4)
		 ContinueLoop
	  EndIf
	  ConsoleWrite("set last modification date to "&$lastChangeTimeSync&" for "&$localPath&@LF)

	  $processedCounter += 1
	  _GUICtrlListView_AddSubItem($fileList, $i, "ADS removed and time reset", 0, 3)

	  If _isInterruptRequested() Then
		 _setAborted("processing files cancelled")
		 Return
	  EndIf

   Next

   _setDone("processed "&$processedCounter&", skipped "&$skippedCounter&" files")

EndFunc