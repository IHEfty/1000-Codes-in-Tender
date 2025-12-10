import "wui"

// Create a window
w := wui.new_window()
w.set_title("My Application")
w.set_size(400, 300)

// Create and add controls
label := wui.new_label()
label.set_text("Hello, World!")
label.set_bounds(50, 50, 200, 30)

button := wui.new_button()
button.set_text("Click Me!")
button.set_bounds(50, 100, 100, 30)
button.set_onclick(fn(){
	println("hello")
})

// Add controls to window
w.add(label)
w.add(button)

// Show the window
w.show()