#Requires AutoHotkey v2.0

vmode := ""
jumpn := ""
susp := 0
global msgtext := ""
global MsgGui := ""
global targethwnd



; GUI ELEMENTS-------------------
ShowMsg(txt, color := "FFFFFF") {
    global MsgGui

    try MsgGui.Destroy()

    MsgGui := Gui("-Caption +AlwaysOnTop +ToolWindow")
    MsgGui.BackColor := "202020"

    MsgGui.SetFont("s12 Bold", "Segoe UI")
    MsgGui.AddText("c" color " w200 Center", txt)

    MsgGui.Show("x10 y10 NoActivate AutoSize")

    SetTimer(HideMsg, -1000)
}

HideMsg() {
	global MsgGui
	try MsgGui.Destroy()
}

commandbox() {
	global msgui, msgtext, editbox, targethwnd
	targethwnd := winexist("a")
	msgui := gui("-caption +alwaysontop +toolwindow")

	editbox := msgui.add("edit", "w300")
	msgui.add("button", "hidden w0 h0 default", "save").onevent("click", savecommand)
	
	msgui.show("x10 y1000 autosize")
}

savecommand(*) {
	global msgui, msgtext, editbox, targethwnd
	msgtext := editbox.value
	msgui.destroy()
	winactivate(targethwnd)
	sleep(50)
	commander(msgtext)
}

; COMMAND BEHAVIOR--------------------

commander(com) {
	global vmode
	if(com = "w") {
		send("^s")
	}
	else if(com = "q") {
		send("!{F4}")
	}
	else if(com = "wq") {
		send("^s")
		sleep(20)
		send("!{F4}")
	}
	vmode := "no"
}










; INSERT MODE TOGGLE-------------------
i:: { 
	global vmode
	global jumpn
	if(vmode = "in") {
		sendtext("i")
	}
	else {
		jumpn := ""
		vmode := "in"
		showmsg("insert mode", "00ff66")
	}
}

+a:: { 
	global vmode
	if(vmode = "in") {
		sendtext("A")
	}
	else {
		send("{end}")
		vmode := "in"
		showmsg("insert mode", "00ff66")
	}
}

 ::: {
	global vmode, msgtext
	if(vmode = "no") {
		vmode := "i"
		commandbox()
	}
	else if(vmode = "vi") {
		vmode := "i"
		commandbox()
	}
	else {
		sendtext(":")
	}
}

; VISUAL MODE TOGGLE-------------------
v:: {
	global vmode
	if(vmode = "in") {
		sendtext("v")
	}
	else {
		vmode := "vi"
		showmsg("visual mode", "e600ff")
	}

}

; NORMAL MODE TOGGLE (send Esc)-------------------
~Esc:: {
	global vmode
	if(vmode = "no"){
		showmsg("normal mode")
	}
	else {
		vmode := "no"
		showmsg("normal mode")
	}
}

; NORMAL MODE TOGGLE (send Esc)-------------------
$^f:: {
	global vmode
	if(vmode = "no"){
		sendinput("^f")
	}
	else {
		vmode := "no"
		showmsg("normal mode")
	}
}


; JUMP FUNCTION FOR DIRECTION KEYS-------------------
jumper(ikey){
	global vmode
	global jumpn
	if(vmode = "no"){
		jumpn .= ikey
		showmsg("jump by " . jumpn)
			if(jumpn > 100){
				jumpn := 100
			}
	}
	else if(vmode = "vi"){
		jumpn .= ikey
		showmsg("jump by" . jumpn)
			if(jumpn > 100){
				jumpn := 100
			}
	}
	else{
		sendtext(ikey)
	}
}


; SEND FUNCTION FOR DIRECTION KEYS-------------------
sender(nkey, ikey, vkey) {
	global vmode
	global jumpn
	
	if(vmode = "no"){
		if(jumpn != ""){
			loop (jumpn){
				send(nkey)
			}
			jumpn := ""
		}
		else{
			send(nkey)
		}
	}
	else if(vmode = "vi"){
		send(vkey)
	}
	else{
		sendtext(ikey)
	}
}

; DIRECTION/NAV KEYS DECLARATION-------------------
h:: sender("{left}", "h", "+{left}")
j:: sender("{down}", "j", "+{down}")
k:: sender("{up}", "k", "+{up}")
l:: sender("{right}", "l", "+{right}")

w:: sender("^{right}", "w", "+^{right}")
b:: sender("^{left}", "b", "+^{left}")
	
^4:: {
	if(vmode = "no"){
		send("!h")
		sleep(10)
		sendtext("j")
	}
}


; JUMPER KEYS DECLARATION
1:: jumper(1)
2:: jumper(2)
3:: jumper(3)
4:: jumper(4)
5:: jumper(5)
6:: jumper(6)
7:: jumper(7)
8:: jumper(8)
9:: jumper(9)
0:: jumper(0)

; SUSPEND KEY DECLARATION
#suspendexempt
^numpad5:: {
	global susp
	suspend
	if !susp {
		susp := 1	
		showmsg("vimnav SUSPENDED", "ff2800")
		
	}
	else {
		susp := 0
		showmsg("vimnav ACTIVE", "00ff66")
	}
}
#suspendexempt false



