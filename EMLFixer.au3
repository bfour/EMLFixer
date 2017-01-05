#pragma compile(ProductName, EMLFixer)
#pragma compile(FileVersion, 1.1)
#pragma compile(ProductVersion, 1.1)
#pragma compile(CompanyName, 'bfour')

#include <FileConstants.au3>
#include <_ZoneID.au3>

#include "modules\GUI.au3"

#include <Array.au3>

_initialize()
_main()

Func _initialize()
   Global $fileSelection = $CmdLine
EndFunc

Func _main()

   If $CmdLineRaw == "" Or Not @Compiled Then
	  _createGUI()
	  While 1
		 Sleep(100)
	  WEnd
   EndIf

   If _validateFileSelection($fileSelection) <> 1 Then
	  TrayTip(@ScriptName, "File selection invalid, one or more files don't exist. Closing without changes.", 10)
	  Exit
   EndIf

EndFunc

Func _validateFileSelection($files)

   If Not IsArray($files) Or UBound($files)<=1 Then Return SetError(1, 0, 0)

   For $i=1 To UBound($files)-1
	  If Not FileExists($files[$i]) Then Return SetError(1, 0, 0)
   Next

   Return 1

EndFunc