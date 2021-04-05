;  ________________________________________________________________________________________
; |  Created by Houdini101 (Edgecraft). You may copy, distribute, or modify this file and  |
; |  change it's code to suit your need, provided that you, as the user, will NOT ommit    |
; |  this comment box or any commentary whatsoever.                                        |
; |________________________________________________________________________________________|

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; En sures a consistent starting directory.
#WinActivateForce
#Persistent
#IfWinActive ahk_class GLFW30
SetWinDelay, 100
SetTitleMatchMode, RegEx
SetTitleMatchMode, Fast
CoordMode, Pixel, Relative
gosub, Image2Include

;=============================================================================
Hotkeys:
Hotkey, !c, AFK_Fishing, t2 	; Alt + C : Toggle Auto-Fishing
Hotkey, !v, Auto_Attack, t2 	; Alt + V : Toggle Auto-Sweep Attack
Hotkey, !z, Portal_Calculator	; Alt + Z : Nether Portal Calculator

;=============================================================================
Info:
Gui, New,, Minecraft Mini-Tool
Gui, Add, Text, y+30, % "Alt + C : Toggle Auto-Fishing"
Gui, Add, Text, y+30, % "Alt + V : Toggle Auto Sweep-Attack"
Gui, Add, Text, y+30, % "Alt + Z : Nether Portal Calculator"
Gui, Add, Button,y+30 w+100, % "Hide"
Gui, Add, Button, yp wp x+10, % "Exit"
Gui, Show,, Minecraft Mini-Tool
return

GuiClose:
goto, ButtonExit

ButtonHide:
Gui +OwnDialogs
MsgBox, 4, Minecraft Mini-Tool, % "Hide the tool window?`n`nReminder:`n`nYou can close this tool later by right-clicking`non its tray icon then selecting exit."
IfMsgBox Yes
Gui, Hide
return

ButtonExit:
Gui +OwnDialogs
MsgBox, 4, Minecraft Mini-Tool, % "Are you sure you want to exit?"
IfMsgBox Yes
ExitApp

;=============================================================================
AFK_Fishing: ;################################################################
;=============================================================================

if Fishing = Auto
	{
	Fishing := "Stopped"
	return
	}

WinMove, ahk_class GLFW30, , 0, 1, 1280, 720
WinSet, AlwaysOnTop, On, ahk_class GLFW30
	
Fishing := "Auto"
FishCount := 0
Fish_Idle := 0

StartTime := A_TickCount ;Logs the Start Time

Send {RButton} ;Initial cast of the Fishing Rod

Loop
	{
	if !WinActive(ahk_class GLFW30)
			Fishing := "AltTabbed"			
	if Fishing != Auto
		break
	ImageSearch, , , 1005, 555, 1085, 655, *40 *TransBlack HBITMAP:*%FishHook%
		if ErrorLevel = 1
			{
			Fish_Idle += 1
			sleep, 100
			if Fish_Idle < 600
				continue
			break
			}
		else if ErrorLevel = 0
			{
			Send {RButton} ; Reel-in the Fishing Rod
			sleep, 300
			Send {RButton} ; Casts the Fishing Rod again
			Fish_Idle := 0 ; Resets the Fish_Idle Counter
			FishCount += 1
			sleep, 2000
			}
	}
	
ElapsedTime := Round((A_TickCount - StartTime)/1000)

FishDuration := Convert(ElapsedTime)

Convert(X_Secs) ; Convert Seconds to Hour:Min:Sec format. Check the end of script for alternate.
	{
	Timer := {Hour: X_Secs//3600, Min: (Mod(X_Secs, 3600))//60, Sec: Mod(X_Secs, 60)}
	For Key in Timer
		if Timer[Key] < 10
			Timer[Key] := "0" Timer[Key]
	return Timer.Hour ":" Timer.Min ":" Timer.Sec
	}

Fish_Tally := "`n`n`nReport :`n`nFish/Loots : " FishCount "`n`nDuration : " FishDuration
	
if Fishing = Auto ; If nothing happens within 1 minute, the auto-cast stops.
	{
	MsgBox, 0, Minecraft Mini-Tool, % "Something went wrong. Error may be caused by one of the ff. reasons:`n`n1. The required in-game settings was not met, causing the ImageSearch to fail.`n`n2. The Mouse was moved, casting the fishing rod at the wrong place.`n`n3. Failed to catch any fish within the time period." Fish_Tally
	}
if Fishing = Stopped ; Alt + c was pressed again.
	{
	MsgBox, 0, Minecraft Mini-Tool, % "You stopped the Auto-Fishing by toggling Alt + C." Fish_Tally
	}
if Fishing = AltTabbed ; Minecraft window was minimized.
	{
	MsgBox, 0, Minecraft Mini-Tool, % "The Auto-Fishing was stopped becaused the Minecraft window was minimized." Fish_Tally
	}
WinActivate, ahk_class GLFW30
Fishing := ""
return

;=============================================================================
Auto_Attack: ;################################################################
;=============================================================================

if !AutoAttack
	{
	WinMove, ahk_class GLFW30, , 0, 1, 1280, 720
	WinSet, AlwaysOnTop, On, ahk_class GLFW30
	AutoAttack := true
	
	Target:
	Loop
		{
		if (!WinActive(ahk_class GLFW30) or !AutoAttack)
			break
		ImageSearch, , , 637, 385, 644, 392, *90 *TransBlack HBITMAP:*%CrossHair%
			if ErrorLevel = 1
				{
				sleep, 50
				continue
				}
			else if ErrorLevel = 0
				{
				Send {LButton} ; Auto Sweep Attack
				sleep, 500
				}
		}
	return
	}
	
else
	AutoAttack := false
return

;=============================================================================
Portal_Calculator: ;##########################################################
;=============================================================================

KeyWait Alt
BlockInput On

Clipboard := "" 

Send {F3 down}{c}{F3 up}

ClipWait, 1
	if ErrorLevel
		{
		BlockInput Off
		return
		}

if InStr(Clipboard, "the_end", false, 23)
	{
	LocValid := false
	Clipboard := ""
	goto, FinalRep
	}
else LocValid := true
	
Coordinates := StrReplace(StrReplace(Clipboard, "/execute in minecraft:"), "run tp @s ")

Clipboard := ""

Loop, Parse, Coordinates, %A_Space%
	{
	if A_Index in 1,3
		continue
	if A_Index = 2
		{
		My_XPos := (Substr(A_LoopField, 1, -3)) - 0
		continue
		}
	if A_Index = 4
		{
		My_ZPos := (Substr(A_LoopField, 1, -3)) - 0
		break	
		}
	}

if InStr(Coordinates, "overworld")
	{
	My_World := "OverWorld"
	Other_World := "Nether"
	Other_XPos := Floor(My_XPos/8)
	Other_ZPos := Floor(My_ZPos/8)
	}		
else
	{
	My_World := "Nether"
	Other_World := "OverWorld"
	Other_XPos := My_XPos*8
	Other_ZPos := My_ZPos*8	
	}

FinalRep:

IsValid := "At your current " My_World " coordinate (" My_XPos ", ~, " My_ZPos "), your " Other_World " portal will be at coordinate (" Other_XPos ", ~, " Other_ZPos ")."

IsInvalid := "You are currently in End City, so setting up a portal is NOT possible, sorry."

Send {t}

sleep, 100

if LocValid = true
	Send {Text}%IsValid%
else
	Send {Text}%IsInvalid%

Send {Enter}

BlockInput Off

return

;=============================================================================
Image2Include: ;##############################################################
;=============================================================================

;  _______________________________________________________________________________________________________ 
; | This #Include file was generated by Image2Include.ahk, you must not change it!                        |
; | Bitmap creation adopted from "How to convert Image data (JPEG/PNG/GIF) to hBITMAP?" by SKAN           |
; | http://www.autohotkey.com/board/topic/21213-how-to-convert-image-data-jpegpnggif-to-hbitmap/?p=139257 |
; |_______________________________________________________________________________________________________|
	
Fishing_File := ["iVBORw0KGgoAAAANSUhEUgAAAEQAAAASCAIAAABtpu8PAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAACtSURBVEhL3ZbBDsAgCEP9/5/eDnpgIYWnm4nDo6vYQnG0Vmxd4epiO4QLJ3iC4TcOZEEx0zkID2zJOqG44+IdMYmW0Q/WbP6YJ6fM6XtMRbYx42iWT4L0n38vJi6izyLBq3qq6sVJVNZ97BN/lxVj80r6wTv+oMoUFPPe38S6s68oGlW+6islADW3GazkC7xGNH7QCbm1yiS/jVJi0JhwAIhPCQeQzSiUEpOJbTc2o8hirsx+9QAAAABJRU5ErkJggg==", 376]
Attacking_File := ["iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAhSURBVBhXY2AgCP6DARZlWCQgQsgAqg+nBESeFDuwOhgAWrE7xUdTTdAAAAAASUVORK5CYII=", 188]

FishHook := File2Hbitmap(Fishing_File)
CrossHair := File2Hbitmap(Attacking_File)

File2Hbitmap(File) {
	Static hBitmap := 0
	VarSetCapacity(B64, File.2 << !!A_IsUnicode)
	B64 := File.1
	If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", 0, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
		Return False
	VarSetCapacity(Dec, DecLen, 0)
	If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", &Dec, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
		Return False
	hData := DllCall("Kernel32.dll\GlobalAlloc", "UInt", 2, "UPtr", DecLen, "UPtr")
	pData := DllCall("Kernel32.dll\GlobalLock", "Ptr", hData, "UPtr")
	DllCall("Kernel32.dll\RtlMoveMemory", "Ptr", pData, "Ptr", &Dec, "UPtr", DecLen)
	DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hData)
	DllCall("Ole32.dll\CreateStreamOnHGlobal", "Ptr", hData, "Int", True, "PtrP", pStream)
	hGdip := DllCall("Kernel32.dll\LoadLibrary", "Str", "Gdiplus.dll", "UPtr")
	VarSetCapacity(SI, 16, 0), NumPut(1, SI, 0, "UChar")
	DllCall("Gdiplus.dll\GdiplusStartup", "PtrP", pToken, "Ptr", &SI, "Ptr", 0)
	DllCall("Gdiplus.dll\GdipCreateBitmapFromStream",  "Ptr", pStream, "PtrP", pBitmap)
	DllCall("Gdiplus.dll\GdipCreateHBITMAPFromBitmap", "Ptr", pBitmap, "PtrP", hBitmap, "UInt", 0)
	DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", pBitmap)
	DllCall("Gdiplus.dll\GdiplusShutdown", "Ptr", pToken)
	DllCall("Kernel32.dll\FreeLibrary", "Ptr", hGdip)
	DllCall(NumGet(NumGet(pStream + 0, 0, "UPtr") + (A_PtrSize * 2), 0, "UPtr"), "Ptr", pStream)
	Return hBitmap
	}

Fishing_File := ""
Attacking_File := ""

return

;=============================================================================


;################################################################
;# ALTERNATE FUNCTION FOR CONVERTING SECONDS TO HH:MM:SS FORMAT #
;################################################################
;Convert(Secs)
;	{	
;	DummyDate := 20200101  ; This date is just a Duh! Me!
;	DummyDate += %Secs%, seconds
;	FormatTime, XXMin_XXSec, %DummyDate%, mm:ss
;	XXHr := Secs//3600
;	if XXHr < 10
;		XXHr := "0" XXHr
;	return XXHr ":" XXMin_XXSec
;	}
;################################################################
