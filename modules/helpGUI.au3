#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Func _helpGUIShow()

   If Not IsDeclared("helpForm") Then
	  Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=S:\sabox\grid\EMLFixer\GUI\helpForm.kxf
Global $helpForm = GUICreate("EMLFixer Help", 432, 352, -1, -1, -1, BitOR($WS_EX_TOOLWINDOW,$WS_EX_WINDOWEDGE))
GUISetOnEvent($GUI_EVENT_CLOSE, "helpFormClose")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "helpFormMinimize")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "helpFormMaximize")
GUISetOnEvent($GUI_EVENT_RESTORE, "helpFormRestore")
Global $instructionsEdit = GUICtrlCreateEdit("", 10, 10, 415, 299, $ES_READONLY, 0)
GUICtrlSetData(-1, StringFormat("This tools lets you remove the Zone.Identifier stream from a selection of files. Removing \r\nthis Alternate Data Stream (ADS) should effectively fix the issue of changing file \r\nmodification timestamps in Windows 10.\r\n\r\nTo start, simply drag & drop the files from which you want to remove the stream onto this \r\nwindow. This allows you, for instance, to use Windows Explorer to search for all your \r\neml-files within a directory and its subdirectories and use advanced filters.\r\n\r\nIf you want to restore the modification timestamp for these files, please select the root \r\ndirectory of your files and the matching "&Chr(34)&"sync"&Chr(34)&" directory, ie. the directory that contains \r\nthe same files with the original timestamps. This tool will then try to match the files by \r\ntheir names. \r\nEg. if you store your e-mail (eml) files in C:\myfiles and synchronize with the directory D:\r\n\myfiles, this tool will match C:\myfiles\folder\file.eml with D:\myfiles\folder\file.eml.\r\n\r\nIf you finally want to remove the Zone.Identifier ADS, press the start button. If you \r\nselected a sync directory, any unmatched files (for which there is no matching \r\ncounterpart in your sync directory) will not be processed. \r\n\r\nPlease note that removing the ADS will change the modification time of your files to the \r\ncurrent time. By choosing a sync directory, the timestamps will be restored from the files \r\ntherein after removing the ADS."))
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT)
GUICtrlSetOnEvent(-1, "instructionsEditChange")
Global $closeButton = GUICtrlCreateButton("Close", 340, 310, 85, 35)
GUICtrlSetOnEvent(-1, "closeButtonClick")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
   EndIf

   GUISetState(@SW_SHOW, $helpForm)
   WinActivate($helpForm)

EndFunc

Func closeButtonClick()
   GUISetState(@SW_HIDE, $helpForm)
EndFunc

Func helpFormClose()
   GUISetState(@SW_HIDE, $helpForm)
EndFunc