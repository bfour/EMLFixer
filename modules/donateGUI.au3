#include <AVIConstants.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

Global $btcAddress = "19gGiv85yPAxayVEVk4BSsUo8KPc37Ht3K"

Func _donateGUIShow()

   If Not IsDeclared("donateGUI") Then
	  Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=S:\sabox\grid\templates\donateGUI\donateGUI.kxf
Global $donateGUI = GUICreate("Donate", 297, 214, -1, -1, -1, BitOR($WS_EX_TOOLWINDOW,$WS_EX_WINDOWEDGE))
GUISetOnEvent($GUI_EVENT_CLOSE, "donateGUIClose")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "donateGUIMinimize")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "donateGUIMaximize")
GUISetOnEvent($GUI_EVENT_RESTORE, "donateGUIRestore")
Global $bitcoinIcon = GUICtrlCreateIcon(@ScriptDir&"\GUI\bitcoin-button.ico", -1, 10, 10, 100, 150)
GUICtrlSetCursor (-1, 0)
GUICtrlSetOnEvent(-1, "bitcoinIconClick")
Global $thankYouLabel = GUICtrlCreateLabel("Thank you!", 160, 130, 96, 29)
GUICtrlSetFont(-1, 14, 400, 0, "Segoe UI")
GUICtrlSetColor(-1, 0x000000)
GUICtrlSetOnEvent(-1, "thankYouLabelClick")
Global $catAVI = GUICtrlCreateAvi(@ScriptDir&"\GUI\pusheen_s.avi", 0, 170, 84, 75, 47, BitOR($GUI_SS_DEFAULT_AVI,$ACS_AUTOPLAY))
Global $donateCloseButton = GUICtrlCreateButton("Close", 210, 170, 75, 35)
GUICtrlSetOnEvent(-1, "donateCloseButtonClick")
Global $paypalIcon = GUICtrlCreateIcon(@ScriptDir&"\GUI\donate-paypal_small.ico", -1, 120, 10, 170, 71)
GUICtrlSetCursor (-1, 0)
GUICtrlSetOnEvent(-1, "paypalIconClick")
Global $websiteLabel = GUICtrlCreateLabel("https://bfourdev.wordpress.com/", 30, 180, 161, 17)
GUICtrlSetFont(-1, 8, 400, 4, "MS Sans Serif")
GUICtrlSetColor(-1, 0x0000FF)
GUICtrlSetCursor (-1, 0)
GUICtrlSetOnEvent(-1, "websiteLabelClick")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
   EndIf

   GUISetState(@SW_SHOW, $donateGUI)
   WinActivate($donateGUI)

EndFunc

Func websiteLabelClick()
   ShellExecute("https://bfourdev.wordpress.com/", "", "", "open")
EndFunc

Func bitcoinIconClick()
   ShellExecute("bitcoin:"&$btcAddress&"?label=EMLFixer", "", "", "open")
   ClipPut($btcAddress)
   MsgBox($MB_OK + $MB_ICONINFORMATION, "EMLFixer", "If you have a bitcoin wallet installed it should open automatically. Otherwise, please use the address "&$btcAddress&" which has now been put into your clipboard. Thank you!")
EndFunc

Func paypalIconClick()
   ShellExecute("https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=G2ZWPMUAULGXL&lc=AT&item_name=open%20source%20software&item_number=EMLFixer&currency_code=EUR&bn=PP%2dDonationsBF%3abtn_donate_SM%2egif%3aNonHosted", "", "", "open")
EndFunc

Func donateCloseButtonClick()
   GUISetState(@SW_HIDE, $donateGUI)
EndFunc

Func donateGUIClose()
   GUISetState(@SW_HIDE, $donateGUI)
EndFunc
