import "wui"

calc_window := wui.new_window()
calc_window.set_title("Calculator")
calc_window.set_size(400, 500)

// Display
display := wui.new_editline()
display.set_bounds(10, 10, 280, 40)
display.set_text("0")

// Calculator buttons
buttons := [
    ["7", 10, 60, 60, 40],
    ["8", 80, 60, 60, 40],
    ["9", 150, 60, 60, 40],
    ["/", 220, 60, 60, 40],
    
    ["4", 10, 110, 60, 40],
    ["5", 80, 110, 60, 40],
    ["6", 150, 110, 60, 40],
    ["*", 220, 110, 60, 40],
    
    ["1", 10, 160, 60, 40],
    ["2", 80, 160, 60, 40],
    ["3", 150, 160, 60, 40],
    ["-", 220, 160, 60, 40],
    
    ["0", 10, 210, 60, 40],
    [".", 80, 210, 60, 40],
    ["=", 150, 210, 60, 40],
    ["+", 220, 210, 60, 40],
    
    ["C", 10, 260, 130, 40],
    ["CE", 150, 260, 130, 40]
]

// Add buttons to window
for btn_data in buttons {
    btn := wui.new_button()
    btn.set_text(btn_data[0])
    btn.set_bounds(btn_data[1], btn_data[2], btn_data[3], btn_data[4])
    calc_window.add(btn)
}

calc_window.add(display)
calc_window.show()