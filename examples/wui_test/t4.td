import "wui"
import "io"

// Create main window
main_window := wui.new_window()
main_window.set_title("Simple Text Editor")
main_window.set_size(700, 600)

// Create menu
main_menu := wui.new_main_menu()

file_menu := wui.new_menu("File")
// file_menu.add(wui.new_menu_string("New"))
// file_menu.add(wui.new_menu_string("Open"))
// file_menu.add(wui.new_menu_string("Save"))
// file_menu.add(wui.new_menu_separator())
// file_menu.add(wui.new_menu_string("Exit"))

edit_menu := wui.new_menu("Edit")
// edit_menu.add(wui.new_menu_string("Cut"))
// edit_menu.add(wui.new_menu_string("Copy"))
// edit_menu.add(wui.new_menu_string("Paste"))

// main_menu.add(file_menu)
// main_menu.add(edit_menu)

// Create text edit control
text_edit := wui.new_textedit()
// text_edit.set_bounds(10, 10, 580, 440)

// Create buttons
open_btn := wui.new_button()
open_btn.set_text("Open File")
open_btn.set_bounds(10, 460, 100, 30)

save_btn := wui.new_button()
save_btn.set_text("Save File")
save_btn.set_bounds(120, 460, 100, 30)

clear_btn := wui.new_button()
clear_btn.set_text("Clear")
clear_btn.set_bounds(230, 460, 100, 30)

// Status bar
status_label := wui.new_label()
status_label.set_text("Ready")
status_label.set_bounds(340, 460, 250, 30)

// Add all controls
main_window.add(text_edit)
main_window.add(open_btn)
main_window.add(save_btn)
main_window.add(clear_btn)
main_window.add(status_label)

// Function to update status
update_status := fn(text) {
    status_label.set_text(text)
}

main_window.show()