import "wui"

// Function to create a labeled input field
create_labeled_input := fn(window, label_text, x, y) {
    label := wui.new_label()
    label.set_text(label_text)
    label.set_bounds(x, y, 100, 25)
    
    input := wui.new_edit_line()
    input.set_bounds(x + 110, y, 150, 25)
    
    window.add(label)
    window.add(input)
    
    return input
}

// Main window
main_window := wui.new_window()
main_window.set_title("Dynamic Form")
main_window.set_size(400, 400)

// Create multiple input fields dynamically
fields := [
    ["First Name:", 20, 20],
    ["Last Name:", 20, 60],
    ["Email:", 20, 100],
    ["Phone:", 20, 140],
    ["Address:", 20, 180]
]

inputs := []

for field in fields {
    input := create_labeled_input(main_window, field[0], field[1], field[2])
    // inputs.append(input)
}

// Submit button
submit_btn := wui.new_button()
submit_btn.set_text("Submit")
submit_btn.set_bounds(150, 250, 100, 30)

main_window.add(submit_btn)
main_window.show()