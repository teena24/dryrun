OrderWindows(MonCount){
	#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
	SendMode Input ; Recommended for new scripts due to its superior speed and reliability.

	CSVfileName = OrderWindows.csv
	CSVfile = %A_ScriptDir%\%CSVfileName%

	If !MonCount
		SysGet, MonCount, MonitorCount

	; Determine which CSV columns to use
	IfGreater, MonCount, 1
		colX := 5, colY := 6, colW := 7, colH := 8, colS := 9
	Else IfEqual, MonCount, 1
		colX := 10, colY := 11, colW := 12, colH := 13, colS := 14
	Else
		colX := 15, colY := 16, colW := 17, colH := 18, colS := 19

	List =
	Loop, Read, %CSVfile%
	{
		If (A_index >= 2)
		{
			If A_loopreadline is Not Space
			{
				List .= A_loopreadline "`n"
				curLineArr := []
				Loop Parse, A_loopreadline, `,, %OmitChars%
					curLineArr.Insert(A_LoopField)
				
				WinClass := curLineArr[2]
				WinTitle := curLineArr[3]
				WinX := curLineArr[colX]
				WinY := curLineArr[colY]
				WinW := curLineArr[colW]
				WinH := curLineArr[colH]
				WinS := curLineArr[colS]
				
				If WinTitle
					curWin := WinTitle
				Else
					curWin := % "ahk_class " . WinClass
				
				IfWinExist, %curWin%
				{
					;WinGet curWinState, MinMax, %curWin%
					;MsgText := "WinClass`t" WinClass "`n" "WinTitle`t" WinTitle "`n" "CurState`t" curWinState "`n" "X`t" WinX "`n" "Y`t" WinY "`n" "W`t" WinW "`n" "H`t" WinH "`n" "State`t" WinS
					;MsgBox, %MsgText%
				
					WinActivate, %curWin%
					sleep 50
					WinMove, %curWin%, , %WinX%, %WinY%, %WinW%, %WinH%
					
					IfEqual, WinS, 1, WinMaximize, %curWin%
					Else IfEqual, WinS, -1, WinMinimize, %curWin%
					Else IfEqual, WinS, 0, WinRestore, %curWin%
				}
			}
		}
	}
}