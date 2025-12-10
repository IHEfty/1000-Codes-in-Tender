import "wui"

w := wui.new_window()
w.set_title("Numerical Controls Demo")
w.set_size(500, 400)

// IntUpDown (Integer spinner)
int_spinner := wui.new_intupdown()
int_spinner.set_min(0)
int_spinner.set_max(100)
int_spinner.set_value(50)
int_spinner.set_bounds(20, 20, 100, 30)
int_spinner.set_on_value_change(fn(value) {
	println("Integer value:", value)
})

// FloatUpDown (Float spinner)
float_spinner := wui.new_floatupdown()
float_spinner.set_min(0.0)
float_spinner.set_max(1.0)
float_spinner.set_value(0.5)
float_spinner.set_precision(2) // 2 decimal places
float_spinner.set_bounds(20, 70, 100, 30)
float_spinner.set_on_value_change(fn(value) {
	println("Float value:", value)
})

// Slider
slider := wui.new_slider()
// slider.set_min(0)
// slider.set_max(100)
// slider.set_cursor_position(25)
// slider.set_bounds(20, 130, 200, 30)
// slider.set_on_change(fn(position) {
	// println("Slider position:", position)
// })

// ProgressBar
progress := wui.new_progressbar()
// progress.set_value(0.3) // 30%
// progress.set_bounds(20, 180, 200, 30)

// Button to update progress
update_btn := wui.new_button()
update_btn.set_text("Add 10%")
update_btn.set_bounds(20, 230, 100, 30)
update_btn.set_onclick(fn() {
	current := progress.value()
	if current < 1.0 {
		progress.set_value(current + 0.1)
	}
})

w.add(int_spinner)
w.add(float_spinner)
w.add(slider)
w.add(progress)
w.add(update_btn)

w.show()