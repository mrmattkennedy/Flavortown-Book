#include <Misc.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Opt("GUIOnEventMode", 1)

Global $width = 567
Global $height = 733
Global $titleBarOffset = 20
Global $addBtnSize = 40
Global $pageArr[1]
Global $currentPageIndex = 0
CreateMainCover()

While 1
   If _IsPressed("1B") Then
	  GUISetState(@SW_HIDE, $main_cover)
	  Sleep(1000)
	  Exit
   EndIf
WEnd

Func CreateMainCover()
   Local $main_cover = GUICreate("COVER PAGE", $width, $height, Default, Default, $WS_THICKFRAME, BitOR($WS_EX_CLIENTEDGE, $WS_EX_TOOLWINDOW))
   Local $addBtn = GUICtrlCreateButton ("+", $width - ($addBtnSize + 10), $height - ($addBtnSize + 10 + $titleBarOffset), $addBtnSize, $addBtnSize)
	  GUICtrlSetOnEvent(-1, "AddPage")

   $currentPageIndex = 0
   $pageArr[$currentPageIndex] = $main_cover
   GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
   GUISetState(@SW_SHOW, $main_cover)
EndFunc


Func LeftPressed()
   GUISetState(@SW_HIDE, $pageArr[$currentPageIndex])
   $currentPageIndex -= 1
   GUISetState(@SW_SHOW, $pageArr[$currentPageIndex])
EndFunc

Func RightPressed()
   ConsoleWrite($currentPageIndex & @CRLF)
   GUISetState(@SW_HIDE, $pageArr[$currentPageIndex])
   $currentPageIndex -= 1
   GUISetState(@SW_SHOW, $pageArr[$currentPageIndex])
EndFunc

Func AddPage()
   Local $size = UBound($pageArr)
   Local $temp_page = GUICreate("Page " & $size, $width, $height, Default, Default, $WS_THICKFRAME, BitOR($WS_EX_CLIENTEDGE, $WS_EX_TOOLWINDOW))
   Local $addBtn = GUICtrlCreateButton("+", $width - ($addBtnSize + 10), $height - ($addBtnSize + 10 + $titleBarOffset), $addBtnSize, $addBtnSize)
	  GUICtrlSetOnEvent(-1, "AddPage")
   Local $leftBtn = GUICtrlCreateButton("<", ($addBtnSize / 2) - 10, ($height / 2) - ($addBtnSize / 2), $addBtnSize, $addBtnSize)
	  GUICtrlSetOnEvent(-1, "LeftPressed")
   Local $rightBtn = GUICtrlCreateButton(">", $width - ($addBtnSize + 10), ($height / 2) - ($addBtnSize / 2), $addBtnSize, $addBtnSize)

   GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
   ReDim $pageArr[UBound($pageArr) + 1]

   ConsoleWrite($currentPageIndex & @CRLF)
   $pageArr[UBound($pageArr) - 1] = $temp_page

   GUISetState(@SW_HIDE, $pageArr[$currentPageIndex])
   $currentPageIndex = UBound($pageArr) - 1
   GUISetState(@SW_SHOW, $pageArr[UBound($pageArr) - 1])
EndFunc

Func _Exit()
   Exit
EndFunc