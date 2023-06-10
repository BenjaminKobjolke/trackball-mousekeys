
#Include %A_ScriptDir%\config.ahk
#Include, %A_ScriptDir%/libraries/MouseDelta.ahk

_guiVisible := false
_guiTriggered := false
_gui_tick := 0
_lockGui := false
_lbuttonDown := false
_rbuttonDown := false

CoordMode, Mouse, Screen

Gui, +ToolWindow +AlwaysOnTop -Caption -Border  +E0x20 

md := new MouseDelta("MouseEvent")
md.SetState(1)

SetTimer, CheckMouseTimer, 10

return

CheckMouseTimer:
    ;GoSub, CheckMousePosition
    if(_guiTriggered) {
        _guiTriggered := false
        Settimer, GuiUpdateTimer, 100
        GoSub, GuiUpdateTimer
    }
return

GuiUpdateTimer:
    if(_lockGui = false) {    
        _gui_tick ++
        if(_gui_tick > 30) {
            GoSub, HideGui
        }
    }
    GoSub, UpdateGui
return
; Gets called when mouse moves
; x and y are DELTA moves (Amount moved since last message), NOT coordinates.
MouseEvent(MouseID, x := 0, y := 0) {
    if(MouseID = 0) {
        ;ToolTip, nope
        return
    }
    ;MsgBox, %MouseID% %x% %y%
    global _guiVisible
    global _gui_tick
    global _guiTriggered
    _guiVisible := true
    _gui_tick := 0
    _guiTriggered := true
 
    ;ToolTip, %MouseID%
}

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
        _lbuttonDown := false
        Send, {LButton}
        if(_lockGui = false) {
            GoSub, HideGui 
        }
    } else {
        Send, {a}
    }
return

$y:: 
    if(_guiVisible) {
        if(_lbuttonDown = false) {
            Send, {LButton Down}
            Send, {RButton Up}
            _lbuttonDown := true
            _rbuttonDown := false
        } else {
            Send, {LButton Up}
            _lbuttonDown := false
        }
    } else {
        Send, {y}
    }
return

$c:: 
    if(_guiVisible) {
        if(_rbuttonDown = false) {
            Send, {LButton Up}
            Send, {RButton Down}
            _rbuttonDown := true
            _lbuttonDown := false
        } else {
            Send, {RButton Up}
            _rbuttonDown := false
        }
    } else {
        Send, {c}
    }
return
$s:: 
    if(_guiVisible) {
        Send, {MButton}
        _lbuttonDown := false
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
        _lbuttonDown := false
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


$q:: 
    if(_guiVisible) {
        Send, {WheelUp}
        _gui_tick := 0
    } else {
        Send, {q}
    }
return

$w:: 
    if(_guiVisible) {
        Send, {WheelUp}
        _gui_tick := 0
    } else {
        Send, {w}
    }
return

$e:: 
    if(_guiVisible) {
        Send, {WheelDown}
        _gui_tick := 0
    } else {
        Send, {e}
    }
return

$r:: 
    if(_guiVisible) {
        Send, {WheelDown}
        _gui_tick := 0
    } else {
        Send, {r}
    }
return

HideGui:
    Settimer, GuiUpdateTimer, Off
    _guiVisible := false
    Gui, hide
    _lbuttonDown := false
    Send, {LButton Up}
return

UpdateGui:
    if(_guiVisible = false) {
        return
    }
    width := 50
    if(_lockGui = false) {
        width := width - _gui_tick
        Gui, Color, Yellow
    } else {
        Gui, Color, Blue
    }
    if(_lbuttonDown) {
        Gui, Color, Red
    }
    Gui, Show, NoActivate w%width% h%width%, MouseSpot
        
    WinSet, Trans, 100, MouseSpot 
    WinSet, Region, 0-0 W%width% H%width% E, MouseSpot

    offset := width / 2  
    MouseGetPos, MX, MY
    WinMove, MouseSpot,,  MX - offset, MY - offset
return

if(!A_IsCompiled) {            
    #y::
        Send, ^s                
        reload
    return             
}