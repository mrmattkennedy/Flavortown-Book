#include <Misc.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <ColorConstants.au3>
#include <WindowsConstants.au3>
#include <WinAPISysWin.au3>
#include <Array.au3>

Opt("GUIOnEventMode", 1)

Global $guiWidth = 567
Global $guiHeight = 733
Global $titleBarOffset = 20
Global $addBtnSize = 40
Global $addTxtSize = 80
Global $pageArr[1]
Global $currentPageIndex = 0
CreateMainCover()

While 1
   If _IsPressed("1B") Then
	  GUISetState(@SW_HIDE, $main_cover)
	  Exit
   ElseIf _IsPressed("01") Then

	  Local $iControl = GUIGetCursorInfo($pageArr[$currentPageIndex])[4]
	  If StringCompare(_WinAPI_GetClassName($iControl), "Button", 2) == 0 Then
		 While _IsPressed("01")
			Sleep(10)
		 WEnd
		 ContinueLoop
	  EndIf

	  Local $aPos = ControlGetPos($pageArr[$currentPageIndex], "", $iControl)
	  Local $cInfo = GUIGetCursorInfo($pageArr[$currentPageIndex])

	  Local $left = $aPos[0]
	  Local $top = $aPos[1]
	  Local $width = $aPos[2]
	  Local $height = $aPos[3]
	  Local $cursorX = $cInfo[0]
	  Local $cursorY = $cInfo[1]
	  Local $iSubtractX = $cInfo[0] - $aPos[0]
	  Local $iSubtractY = $cInfo[1] - $aPos[1]

	  If ($cursorX > $left - 3 And $cursorX < ($left + $width) + 3) And ($cursorY > $top - 3 And $cursorY < $top + 3) Then ;Top border
		 Do
			;Increase the y pos, and change the height accordingly
			$cInfo = GUIGetCursorInfo($pageArr[$currentPageIndex])
			ControlMove($pageArr[$currentPageIndex], "", $iControl, $left, $cInfo[1] - $iSubtractY, $width, $top - $cInfo[1] + $height)
		 Until Not $cInfo[2]
		 ContinueLoop
	  ElseIf ($cursorX > ($left + $width) - 3 And $cursorX < ($left + $width) + 3) And ($cursorY > $top - 3 And $cursorY < ($top + $height) + 3) Then ;Right border
		 Do
			;Increase the y pos, and change the height accordingly
			$cInfo = GUIGetCursorInfo($pageArr[$currentPageIndex])
			ControlMove($pageArr[$currentPageIndex], "", $iControl, $left, $top, $width + ($cInfo[0] - $iSubtractX), $height)
		 Until Not $cInfo[2]
		 ContinueLoop
	  ;ElseIf ($cursorX > $left - 3 And $cursorX < ($left + $width) + 3) And ($cursorY > ($top + $height) - 3 And $cursorY < ($top + $height) + 3) Then ;Bottom border
		; ConsoleWrite("bottom" & @CRLF)
	  ;ElseIf ($cursorX > $left - 3 And $cursorX < $left + 3) And ($cursorY > $top - 3 And $cursorY < ($top + $height) + 3) Then ;Left border
		; ConsoleWrite("left" & @CRLF)
	  EndIf

	  Do
		 $cInfo = GUIGetCursorInfo($pageArr[$currentPageIndex])
		 ControlMove($pageArr[$currentPageIndex], "", $iControl, $cInfo[0] - $iSubtractX, $cInfo[1] - $iSubtractY)
	  Until Not $cInfo[2]

   EndIf
   sleep(10)
WEnd

Func CreateMainCover()
   Local $main_cover = GUICreate("COVER PAGE", $guiWidth, $guiHeight, Default, Default, $WS_THICKFRAME, BitOR($WS_EX_CLIENTEDGE, $WS_EX_TOOLWINDOW))
   Local $addBtn = GUICtrlCreateButton ("+", $guiWidth - ($addBtnSize + 10), $guiHeight - ($addBtnSize + 10 + $titleBarOffset), $addBtnSize, $addBtnSize)
	  GUICtrlSetOnEvent(-1, "AddPage")
   Local $leftBtn = GUICtrlCreateButton("<", ($addBtnSize / 2) - 10, ($guiHeight / 2) - ($addBtnSize / 2), $addBtnSize, $addBtnSize)
	  GUICtrlSetOnEvent(-1, "LeftPressed")
   Local $rightBtn = GUICtrlCreateButton(">", $guiWidth - ($addBtnSize + 10), ($guiHeight / 2) - ($addBtnSize / 2), $addBtnSize, $addBtnSize)
	  GUICtrlSetOnEvent(-1, "RightPressed")

   $currentPageIndex = 0
   $pageArr[$currentPageIndex] = $main_cover
   GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
   GUISetState(@SW_SHOW, $main_cover)
EndFunc

Func AddPage()
   Local $size = UBound($pageArr)
   Local $temp_page = GUICreate("Page " & $size, $guiWidth, $guiHeight, Default, Default, $WS_THICKFRAME, BitOR($WS_EX_CLIENTEDGE, $WS_EX_TOOLWINDOW))
   Local $addBtn = GUICtrlCreateButton("+", $guiWidth - ($addBtnSize + 10), $guiHeight - ($addBtnSize + 10 + $titleBarOffset), $addBtnSize, $addBtnSize)
	  GUICtrlSetOnEvent(-1, "AddPage")
   Local $leftBtn = GUICtrlCreateButton("<", ($addBtnSize / 2) - 10, ($guiHeight / 2) - ($addBtnSize / 2), $addBtnSize, $addBtnSize)
	  GUICtrlSetOnEvent(-1, "LeftPressed")
   Local $rightBtn = GUICtrlCreateButton(">", $guiWidth - ($addBtnSize + 10), ($guiHeight / 2) - ($addBtnSize / 2), $addBtnSize, $addBtnSize)
	  GUICtrlSetOnEvent(-1, "RightPressed")
   Local $addTxt = GUICtrlCreateButton("Text", $guiWidth - ($addTxtSize + $addBtnSize + 10), $guiHeight - (($addTxtSize/2) + 10 + $titleBarOffset), $addTxtSize, $addTxtSize/2)
	  GUICtrlSetOnEvent(-1, "AddText")

   GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
   ReDim $pageArr[UBound($pageArr) + 1]

   $pageArr[UBound($pageArr) - 1] = $temp_page

   GUISetState(@SW_HIDE, $pageArr[$currentPageIndex])
   $currentPageIndex = UBound($pageArr) - 1
   GUISetState(@SW_SHOW, $pageArr[UBound($pageArr) - 1])
EndFunc

Func LeftPressed()
   If $currentPageIndex == 0 Then Return
   GUISetState(@SW_HIDE, $pageArr[$currentPageIndex])
   $currentPageIndex -= 1
   GUISetState(@SW_SHOW, $pageArr[$currentPageIndex])
EndFunc

Func RightPressed()
   If $currentPageIndex == UBound($pageArr) - 1 Then Return
   GUISetState(@SW_HIDE, $pageArr[$currentPageIndex])
   $currentPageIndex += 1
   GUISetState(@SW_SHOW, $pageArr[$currentPageIndex])
EndFunc

Func AddText()
Local $text = GUICtrlCreateEdit("", 5, 5, 100, 100, BitOr($ES_MULTILINE, $ES_WANTRETURN))
EndFunc

Func _Exit()
   Exit
EndFunc