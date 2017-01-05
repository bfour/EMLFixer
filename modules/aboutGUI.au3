#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

Func _aboutGUIShow()

   If Not IsDeclared("aboutForm") Then
	  Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=S:\sabox\grid\EMLFixer\GUI\aboutForm.kxf
Global $aboutForm = GUICreate("EMLFixer About", 369, 295, -1, -1, -1, BitOR($WS_EX_TOOLWINDOW,$WS_EX_WINDOWEDGE))
GUISetOnEvent($GUI_EVENT_CLOSE, "aboutFormClose")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "aboutFormMinimize")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "aboutFormMaximize")
GUISetOnEvent($GUI_EVENT_RESTORE, "aboutFormRestore")
Global $aboutCloseButton = GUICtrlCreateButton("Close", 260, 250, 95, 35)
GUICtrlSetOnEvent(-1, "aboutCloseButtonClick")
Global $instructionsEdit = GUICtrlCreateEdit("", 10, 10, 345, 239, $ES_READONLY, 0)
GUICtrlSetData(-1, StringFormat("EMLFixer Copyright 2017 Florian Pollak (fpdevelop@gmail.com)\r\n\r\nLicensed under the Apache License, Version 2.0 (the "&Chr(34)&"License"&Chr(34)&");\r\nyou may not use this file except in compliance with the License.\r\nYou may obtain a copy of the License at\r\n\r\n    http://www.apache.org/licenses/LICENSE-2.0\r\n\r\nUnless required by applicable law or agreed to in writing, software\r\ndistributed under the License is distributed on an "&Chr(34)&"AS IS"&Chr(34)&" BASIS,\r\nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either \r\nexpress or implied.\r\nSee the License for the specific language governing permissions and\r\nlimitations under the License.\r\n\r\nUsed components: _ZoneId_ADSStreamDelete by Ascend4nt; \r\nGUIHyperLink UDF Copyright 2011-2013 CreatoR"&Chr(39)&"s Lab (G.Sandler), \r\nwww.creator-lab.ucoz.ru, www.autoit-script.ru"))
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT)
GUICtrlSetOnEvent(-1, "instructionsEditChange")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
   EndIf

   GUISetState(@SW_SHOW, $aboutForm)
   WinActivate($aboutForm)

EndFunc


Func aboutCloseButtonClick()
   GUISetState(@SW_HIDE, $aboutForm)
EndFunc

Func aboutFormClose()
   GUISetState(@SW_HIDE, $aboutForm)
EndFunc
