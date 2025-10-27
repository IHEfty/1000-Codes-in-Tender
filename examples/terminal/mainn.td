import "gui"
import "times"
import "hex"
import "helper/randstr"

 
w := 600
h := 400

win := gui.window("win Demo", w, h) 
win.set_font(embed("DMMono-Medium.ttf"), 13)



input_username := gui.input(w/2 - 100, h/2 - 50, 200, 30)
label_1 := gui.label(w/2 - 100, h/2 - 60, "Username")
label_1.color = "#00ff00"

input_password := gui.input(w/2 - 100, h/2 + 10, 200, 30)
input_password.password = true
label_2 := gui.label(w/2 - 100, h/2, "Password")
label_2.color = "#00ff00"

button := gui.button(w/2 - 100, h/2 + 50, 80, 30, "Login")

term :=  gui.terminal(10, 10, w-20, h-20)
term.line_height = 15

input_username.on_enter = fn(e){
	if input_username.text.length > 3 {
		win.focused_input = input_password
	}
	else {
		label_1.color = "#ff0000"
		label_1.text = "Invalid username! Try again."
	}
}

input_password.on_enter = fn(e){
	if input_username.text.length > 3 {
		win.elements = []
		term.prompt = "QuantamX.Cloud@" + input_username.text + "> "
		win.add(term)
		win.focused_input = term
		for i in range(0,10) {
			term.lines.push("00000000 SEED " + randstr(12))
			win.update()
		}
		term.lines.push("")
	} 
	else {
		label_1.color = "#ff0000"
		label_1.text = "Invalid username! Try again."
	}
}

button.on_click = fn(e){
	if input_username.text.length > 3 {
		win.elements = []
		term.prompt = "QuantamX.Cloud@" + input_username.text + "> "
		win.add(term)
		win.focused_input = term
		for i in range(0,10) {
			term.lines.push("00000000 SEED " + randstr(12))
			win.update()
		}
		term.lines.push("")
	} 
	else {
		label_1.color = "#ff0000"
		label_1.text = "Invalid username! Try again."
	}
}


win.add(button)
win.add(label_1)
win.add(label_2)
win.add(input_username)
win.add(input_password)
win.start()
