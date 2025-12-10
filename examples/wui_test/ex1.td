import "wui"

w := wui.new_window()
w.set_title("Basic Controls Demo")
w.set_size(600, 500)

// Label
label := wui.new_label()
label.set_text("Welcome to WUI Demo")
label.set_bounds(20, 20, 300, 30)
label.set_alignment(1) // Center alignment

// Button
button := wui.new_button()
button.set_text("Click Me")
button.set_bounds(20, 70, 100, 30)
button.set_onclick(fn() {
	println("Button clicked!")
	label.set_text("Button was clicked!")
})

// CheckBox
checkbox := wui.new_checkbox()
checkbox.set_text("Enable Feature")
checkbox.set_bounds(20, 120, 150, 30)
checkbox.set_on_change(fn(checked) {
	println("Checkbox:", checked)
	button.set_enabled(checked)
})

// edit_line (Single-line text input)
edit := wui.new_editline()
edit.set_text("Type here...")
edit.set_bounds(20, 170, 200, 30)
edit.set_on_text_change(fn() {
	println("Edit text:", edit.text())
})

// TextEdit (Multi-line text input)
textedit := wui.new_textedit()
// textedit.set_text("Multi-line\ntext editor")
// textedit.set_bounds(20, 220, 250, 100)

w.add(label)
w.add(button)
w.add(checkbox)
w.add(edit)
w.add(textedit)

w.show()