import "wui"
import "io"

// Create window with file dialogs
file_window := wui.new_window()
file_window.set_title("File Operations")
file_window.set_size(400, 300)

// Text display
text_display := wui.new_textedit()
// text_display.set_bounds(10, 10, 380, 200)

// Buttons
open_btn := wui.new_button()
open_btn.set_text("Open File")
open_btn.set_bounds(10, 220, 100, 30)

save_btn := wui.new_button()
save_btn.set_text("Save File")
save_btn.set_bounds(120, 220, 100, 30)

select_folder_btn := wui.new_button()
select_folder_btn.set_text("Select Folder")
select_folder_btn.set_bounds(230, 220, 120, 30)

// File dialogs
open_dialog := wui.new_file_open_dialog()
// open_dialog.set_filter("Text files (*.txt)|*.txt|All files (*.*)|*.*")

save_dialog := wui.new_file_save_dialog()
// save_dialog.set_filter("Text files (*.txt)|*.txt|All files (*.*)|*.*")

folder_dialog := wui.new_folder_select_dialog()

// Add controls
file_window.add(text_display)
file_window.add(open_btn)
file_window.add(save_btn)
file_window.add(select_folder_btn)

// Show window
file_window.show()