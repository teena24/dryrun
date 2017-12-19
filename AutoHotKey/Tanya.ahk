; Modifiers
; # - Win key
; ! - Alt
; ^ - Control
; + - Shift
; <^ - left Ctrl button only
; >+ = right Shift button only
; n & m - combination, press 'm' while holding 'n'


; The Auto-execute Section
; ========================
; After the script has been loaded, it begins executing at the top line,
; continuing until a Return, Exit, hotkey/hotstring label, or the physical
; end of the script is encountered (whichever comes first).
; This top portion of the script is referred to as the auto-execute section.

#NoEnv  					; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn 						; Enable warnings to assist with detecting common errors.
SendMode Input  			; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
#SingleInstance Force 		; [Force|Ignore|Off] Determines whether a script is allowed to run again when already running.
#Persistent 				; Keeps a script permanently running (that is, until the user closes it or ExitApp is encountered).
;#installKeybdHook  ; Forces the unconditional installation of the keyboard hook 
					; (https://autohotkey.com/docs/commands/_InstallKeybdHook.htm)
;Menu, Tray, Icon , Shell32.dll, 25, 1 ; Changes the script's notification area icon

MyString := 
SetWinDelay, 50

;Includes
#Include, %A_ScriptDir%/Maths/Maths.ahk
#Include, %A_ScriptDir%/Encrypt.ahk
#Include, %A_ScriptDir%/OrderWindows.ahk

;Other Variables
Global Cur_TitleMatchMode,Prev_TitleMatchMode
Prev_TitleMatchMode := A_TitleMatchMode
Cur_TitleMatchMode := A_TitleMatchMode


;=============================================
;#############  LOAD FUNCTIONS  ##############
;=============================================

; Sets new or restores previous TitleMatchMode
TitleMatchModeSetOrRestore(Mode="")
{
; Mode sets the matchin mode, if empty it will restore the previous mode
; Usage:
; 	TitleMatchModeSetOrRestore(1)		; Set TitleMatchMode to "Starts With"
; 	TitleMatchModeSetOrRestore(2)		; Set TitleMatchMode to "Contains"
; 	TitleMatchModeSetOrRestore(3)		; Set TitleMatchMode to "Exact Match"
; 	TitleMatchModeSetOrRestore(RegEx)	; Set TitleMatchMode to RegEx
; 	TitleMatchModeSetOrRestore()		; Restores TitleMatchMode to previous mode (default is 1)
	If Mode in 1,2,3,RegEx
	{
		Cur_TitleMatchMode = %Mode%
	}
	Else
	{
		Cur_TitleMatchMode = %Prev_TitleMatchMode%
	}
	Prev_TitleMatchMode := A_TitleMatchMode
	SetTitleMatchMode %Cur_TitleMatchMode%
	;MsgBox, Prev %Prev_TitleMatchMode%`nCur  %Cur_TitleMatchMode%
}

;Moves specified window to specified position and state
MoveWindow(WindowName, X, Y, W, H, WinState, WinStateMultiMon)
{
	;MsgBox ,0, Input Params, [WindowName] %WindowName%`n[X] %X%`n[Y] %Y%`n[W] %W%`n[H] %H%`n[WinState] %WinState%`n[WinStateMultiMon] %WinStateMultiMon%
	If (MonCount = 1)
	{
		SysGet, Mon1, Monitor, 1
		X := 0
		Y := 0
		MaxW := Mon1Right
		MaxH := Mon1Bottom - 41
		If (W > MaxW)
		{
			W := MaxW
		}
		If (H > MaxH)
		{
			H := MaxH
		}
		WindowsState = %WinState%
	}
	Else
	{
		WindowsState = %WinStateMultiMon%
	}
	WinActivate, %WindowName%
	sleep 50
	WinMove, %WindowName%, , %X%, %Y%, %W%, %H%
	If (%WindowsState% > 0)
	{
		WinMaximize, %WindowName%
	}
	If (%WindowsState% < 0)
	{
		WinMinimize, %WindowName%
	}
	sleep 50
}

; 
; ;Pre-load password from file
; GetPass(DecryptedPass)
; {
; 	psName := "WhiteSource"
; 	fileName = pass_%psName%.txt
; 	
; 	IfNotExist, %fileName%
; 		Run UpdatePassword.ahk
; 	
; 	FileReadLine, encryptedPass, %fileName%, 1
; 	DecryptedPass := Decrypt(encryptedPass, psName)
; 	return DecryptedPass
; }
; curPass := GetPass(curPass)
; ;TrayTip, Tidhar.ahk, Started, 1
; ;SoundBeep, 300, 150
; Return
; 


;=============================================================================
;##############################  ORDER WINDOWS  ##############################
;=============================================================================

; ;Move Mail and Calendar window to their place and size when using two monitors
;^o::
;SysGet, monCnt, MonitorCount
;global MonCount := monCnt
;
;TrayText = 1 Monitor
;IfGreater, MonCount, 1
;	TrayText = %MonCount% Monitors
;
;TrayTip, Arranging Windows, %TrayText%, 1
;
;TitleMatchModeSetOrRestore("RegEx")
;
;; Call OrderWindows() from OrderWindows.ahk
;OrderWindows(MonCount)
;
;TitleMatchModeSetOrRestore()
;return

;=============================================================================
;#############################################################################
;=============================================================================

;In Notepad++, sends Alt+L and then X, to format current document in [Defined] language syntax highlighting
#IfWinActive ahk_class Notepad++
^!X::
Send !{L}
;sleep 100
;Send {J}	;Java
;Send {X}	;XML
Send {P}	;Properties

;When there's more than one language in P
;Send {P}	;PowerShell
;Send {Down}
;Send {Enter}

#IfWinActive
return


;Export Selected Text into a Word Document
#Q::
SendInput ^c
WinGetActiveTitle, CurrentTitle
psScript := "C:\Data\Scripts\PowerShell\CreateWordDocument\CreateWordDocument.ps1"
If FileExist(psScript) {
	Run, PowerShell.exe -NoLogo -NoProfile -ExecutionPolicy Unrestricted -WindowStyle Hidden -File "%psScript%" "%CurrentTitle%"
}
Else
{
	MsgBox,, File Not Found, File Not Found:`n%psScript%
}
return






; ; SQL Shortcuts
; +s::
; selectStatement := "SELECT * FROM "
; SendPlay %selectStatement%
; return


;MySQL Workbench
;ahk_class WindowsForms10.Window.8.app.0.1ca0192_r8_ad1
;ahk_exe MySQLWorkbench.exe

;=============================================================================
;#############################################################################
;=============================================================================

; WhiteSource Email Only
#E::
SendInput tanya.zhok{@}whitesourcesoftware.com
SendInput {Tab}
return

;In any text editor, add a [TM]: comment
#I::
SendInput [TZ]{:}
SendInput +{Left}+{Left}+{Left}+{Left}+{Left}
SendInput ^b
SendInput {End}
SendInput ^b
SendInput {Space}
return

; WhiteSource Email Only
#T::
SendInput C:\temp
SendInput {Enter}
return

;=============================================================================
;#################################   Exec Scripts       ###############################
;=============================================================================

;Execute Sleep.bat
#S::
   Run, "C:\Data\Scripts\Sleep.bat"
Return

;Execute obs
#o::
	IfWinExist,OBS 20.1.3
	{
		WinClose ; use the window found above
	}
	Run, "C:\Users\tanya\Documents\Quick Launch\OBS Studio (64bit)"
	IfWinExist,OBS 20.1.3
	{
		WinActivate 
	}
Return


;Execute WSAdminActions.bat
#W::
   Run, "C:\Data\WS_admin\WSAdminActions\WSAdminActions.bat"
Return



;Execute impersonate and opens the account name in SalesForce.
#!W::
	StringSplit, word_array, Clipboard, %A_Space%, .  ; Returns first word (email) from clipboard. Omits periods. 
	URL = https://eu8.salesforce.com/_ui/search/ui/UnifiedSearchResults?str=%word_array1%
	Run,chrome.exe %URL%

	Run, "C:\Data\Scripts\WSAdminActions\WSAdminActions.bat"	
	IfWinExist,WSAdminActions
	{
		WinActivate
		WinWaitActive
		Sleep 20 
		SendInput 2 
	}
	
Return



;Execute ListFileTypes.bat
#!L::
	Run, "C:\Data\Scripts\ListFilesAndFolders\ListFileTypes.bat"
	StringSplit, word_array, Clipboard, %A_Space%, .  ; Returns first word (email) from clipboard. Omits periods. 
	IfWinExist,ListFileTypes
	{
		WinActivate
		WinWaitActive
		Sleep 20 
		SendInput %word_array1%  
	}

Return



;Execute ListFilesAndFolders (Full) to XML
#!^L::
	StringSplit, word_array, Clipboard, %A_Space%, .  ; Returns first word (email) from clipboard. Omits periods. 
	Run, "C:\Data\Scripts\ListFilesAndFolders\ListFilesAndFolders.ps1"
	
	IfWinExist,ListFilesAndFolders
	{
		WinActivate
		WinWaitActive
		Sleep, 20
		SendInput %word_array1% 
		SendInput {Enter}	
		SendInput {R}
	}
	
Return



; FOR TESTING 
#!Z::
;	clipFirstWrd := SubStr(String, 1, InStr(string, " ") + 1)   ; 
	Run, "C:\Data\Scripts\WSAdminActions\WSAdminActions.bat"	

	IfWinExist,WSAdminActions
	{
		WinActivate
		WinWaitActive
		Sleep 30 
		MsgBox, debug!
		SendInput 2 
	}
	
	
	;MsgBox, The 1th word is %word_array1%.	
	;msgbox, the url: %URL%
	;Run,chrome.exe %URL%
;	ClipBoard = %ClipBoard%                             ; Convert to text
;	Send ^v 
;Return