import "wui"

// Create a window with interactive controls
window := wui.new_window()
window.set_title("Calculator")
window.set_size(300, 200)

// Number input
numInput := wui.new_intupdown()
numInput.set_bounds(10, 10, 100, 25)
numInput.set_min_max(0, 100)

// Slider linked to the number
slider := wui.new_slider()
// slider.set_bounds(10, 40, 200, 20)

// Link the controls
numInput.set_on_value_change(fn(value){
    slider.set_value(value)
})

// slider.set_on_change(fn(value){
    // numInput.set_value(value)
// })

// Add controls
window.add(numInput)
window.add(slider)

// Show window
window.show()