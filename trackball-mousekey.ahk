#Requires AutoHotkey v1.1
#Include %A_ScriptDir%\config.ahk
#InstallMouseHook

_guiVisible := false
_gui_tick := 0
_lockGui := false

CoordMode, Mouse, Screen

Gui, +ToolWindow +AlwaysOnTop -Caption -Border  +E0x20 

 
loop
{
    GoSub, CheckMousePosition
    if(_guiVisible) {
        GoSub, UpdateGui
    }
}
return

$Space:: 
    if(_guiVisible) {
        _lockGui := false
        GoSub, HideGui 
    } else {
        Send, {Space}
    }
return


$a:: 
    if(_guiVisible) {
        Send, {LButton}
        if(_lockGui = false) {
            GoSub, HideGui 
        }
    } else {
        Send, {a}
    }
return

$s:: 
    if(_guiVisible) {
        Send, {MButton}
        if(_lockGui = false) {
            GoSub, HideGui 
        }
    } else {
        Send, {s}
    }
return

$d:: 
    if(_guiVisible) {
        Send, {RButton}
        if(_lockGui = false) {
            GoSub, HideGui 
        }
    } else {
        Send, {d}
    }
return

$f:: 
    if(_guiVisible) {
        if(_lockGui) {
            _lockGui := false
          } else {
            _lockGui := true 
        }
    } else {
        Send, {f}
    }
return

HideGui:
    _guiVisible := false
    Gui, hide
return

UpdateGui:
    width := 50
    if(_lockGui = false) {
        width := width - _gui_tick
        Gui, Color, Yellow
    } else {
        Gui, Color, Blue
    }
    Gui, Show, NoActivate w%width% h%width%, MouseSpot
        
    WinSet, Trans, 100, MouseSpot 
    WinSet, Region, 0-0 W%width% H%width% E, MouseSpot

    offset := width / 2  
    MouseGetPos, MX, MY
    WinMove, MouseSpot,,  MX - offset, MY - offset
return

CheckMousePosition:
    MouseGetPos, x1, y1  
    Sleep, 10
    MouseGetPos, x2, y2

    If (x2 != x1 || y2 != y1) {
        _gui_tick := 0
        _guiVisible := true
    } else {
        if(_guiVisible) {
            if(_lockGui = false) {
              
                _gui_tick ++
                if(_gui_tick > 30) {
                    GoSub, HideGui
                }
            }
        }
    }
return


if(!A_IsCompiled) {            
    #y::                
        reload
    return             
}