#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

Func _aboutGUIShow()

   If Not IsDeclared("aboutForm") Then
	  Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=S:\grid\EMLFixer\GUI\aboutForm.kxf
Global $aboutForm = GUICreate("EMLFixer About", 545, 335, -1, -1, -1, BitOR($WS_EX_TOOLWINDOW,$WS_EX_WINDOWEDGE))
GUISetOnEvent($GUI_EVENT_CLOSE, "aboutFormClose")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "aboutFormMinimize")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "aboutFormMaximize")
GUISetOnEvent($GUI_EVENT_RESTORE, "aboutFormRestore")
Global $aboutCloseButton = GUICtrlCreateButton("Close", 440, 290, 95, 35)
GUICtrlSetOnEvent(-1, "aboutCloseButtonClick")
Global $instructionsEdit = GUICtrlCreateEdit("", 190, 40, 345, 219, $ES_READONLY, 0)
GUICtrlSetData(-1, StringFormat("EMLFixer Copyright 2017 Florian Pollak (bfourdev@gmail.com)\r\n\r\nLicensed under the Apache License, Version 2.0 (the "&Chr(34)&"License"&Chr(34)&");\r\nyou may not use this file except in compliance with the License.\r\nYou may obtain a copy of the License at\r\n\r\n    http://www.apache.org/licenses/LICENSE-2.0\r\n\r\nUnless required by applicable law or agreed to in writing, software\r\ndistributed under the License is distributed on an "&Chr(34)&"AS IS"&Chr(34)&" BASIS,\r\nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either \r\nexpress or implied.\r\nSee the License for the specific language governing permissions and\r\nlimitations under the License.\r\n\r\nUsed components: _ZoneId_ADSStreamDelete by Ascend4nt"))
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT)
GUICtrlSetOnEvent(-1, "instructionsEditChange")
Global $aboutGithubLinkLabel = GUICtrlCreateLabel("https://github.com/bfour/EMLFixer/issues", 190, 275, 204, 17)
GUICtrlSetColor(-1, 0x0000FF)
GUICtrlSetCursor (-1, 0)
GUICtrlSetOnEvent(-1, "aboutGithubLinkLabelClick")
Global $aboutWebsiteLinkLabel = GUICtrlCreateLabel("https://bfourdev.wordpress.com/emlfixer", 190, 10, 201, 17)
GUICtrlSetColor(-1, 0x0000FF)
GUICtrlSetCursor (-1, 0)
GUICtrlSetOnEvent(-1, "aboutWebsiteLinkLabelClick")
Global $Label1 = GUICtrlCreateLabel("Please report any bugs and leave any change requests on github:", 190, 260, 314, 17)
GUICtrlSetOnEvent(-1, "Label1Click")
Global $bfourLogo = GUICtrlCreateIcon(@ScriptDir&"\GUI\logo_small.ico", -1, 10, 10, 164, 118)
GUICtrlSetOnEvent(-1, "bfourLogoClick")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
   EndIf

   GUISetState(@SW_SHOW, $aboutForm)
   WinActivate($aboutForm)

EndFunc

Func bfourLogoClick()
   ShellExecute("https://bfourdev.wordpress.com/emlfixer/", "", "", "open")
EndFunc

Func aboutWebsiteLinkLabelClick()
   ShellExecute("https://bfourdev.wordpress.com/emlfixer/", "", "", "open")
EndFunc

Func aboutGithubLinkLabelClick()
   ShellExecute("https://github.com/bfour/EMLFixer/issues", "", "", "open")
EndFunc

Func aboutCloseButtonClick()
   GUISetState(@SW_HIDE, $aboutForm)
EndFunc

Func aboutFormClose()
   GUISetState(@SW_HIDE, $aboutForm)
EndFunc
