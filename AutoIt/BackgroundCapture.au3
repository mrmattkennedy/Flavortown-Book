#include <ScreenCapture.au3>
#include <Misc.au3>

Local $count = 0
While 1
   Sleep(10)
   if _IsPressed("14") Then
	  ;Local $aPos = MouseGetPos()
	  ;ConsoleWrite($aPos[0] & ", " & $aPos[1])
	  _ScreenCapture_Capture($count & ".png", -811, 200, -330, 828)
	  $count += 1
	  ConsoleWrite("Captured" & @CRLF)
	  Sleep(500)
   ElseIf _IsPressed("1B") Then
	  Exit
   EndIf
WEnd
