import "gui"
 
w := 600
h := 400

win := gui.window("win Demo", w, h) 

label := gui.label(w/2 - 100, h/2 - 60, "Enter your dusty password...")
label.color = "#00ff00"
button := gui.button(w/2 - 100, h/2 + 20, 80, 30, "Login")
input_field := gui.input(w/2 - 100, h/2 - 50, 200, 30)
checkbox := gui.checkbox(w/2 - 100,  h/2 - 8, "Remember me?", true)

button.on_click = fn(e){
	if input_field.text == "wallpaper" {
		label.color = "#00ff00"
		label.text = "https://upload-my-ass.glitch.me/"
		button.text = ">:("
	} 
	else {
		label.color = "#ff0000"
		label.text = "Wrong password! Try again!"
	}
}


win.add(button)
win.add(label)
win.add(input_field)
win.add(checkbox)
win.start()
