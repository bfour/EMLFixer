#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

Func _aboutGUIShow()

   If Not IsDeclared("helpForm") Then
	  Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=S:\sabox\grid\EMLFixer\GUI\aboutForm.kxf
Global $aboutForm = GUICreate("aboutForm", 405, 293, 559, 409)
GUISetOnEvent($GUI_EVENT_CLOSE, "aboutFormClose")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "Form2Minimize")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "Form2Maximize")
GUISetOnEvent($GUI_EVENT_RESTORE, "Form2Restore")
Global $aboutCloseButton = GUICtrlCreateButton("Close", 300, 250, 95, 35)
GUICtrlSetOnEvent(-1, "aboutCloseButtonClick")
Global $Icon1 = GUICtrlCreateIcon("S:\sabox\grid\EMLFixer\icon.ico", -1, 10, 10, 128, 128)
GUICtrlSetOnEvent(-1, "Icon1Click")
Global $Label1 = GUICtrlCreateLabel("EMLFixer (c) 2017 Florian Pollak", 150, 10, 156, 17)
GUICtrlSetOnEvent(-1, "Label1Click")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
   EndIf

   GUISetState(@SW_SHOW, $aboutForm)
EndFunc


Func aboutCloseButtonClick()
   GUISetState(@SW_HIDE, $aboutForm)
EndFunc

Func aboutFormClose()
   GUISetState(@SW_HIDE, $aboutForm)
EndFunc
