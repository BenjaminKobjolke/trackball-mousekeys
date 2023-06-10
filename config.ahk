;@Ahk2Exe-SetMainIcon icon.ico
;@Ahk2Exe-ExeName %A_ScriptDir%\bin\trackball-mousekeys.exe

#NoEnv 
SendMode Input
#SingleInstance force
SetTitleMatchMode, 2
SetWorkingDir %A_ScriptDir%
ListLines Off
SetBatchLines -1
#InstallMouseHook


if (!a_iscompiled) {
	Menu, tray, icon, icon.ico,0,1
}