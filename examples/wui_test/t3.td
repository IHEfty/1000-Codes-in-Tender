import "wui"

// Simple message box
wui.message_box("Info", "Operation completed successfully!")

// Error message box
wui.message_box_error("Error", "Failed to open file!")

// Warning message box
wui.message_box_warning("Warning", "Are you sure you want to delete this item?")

// Question message box
wui.message_box_question("Question", "Do you want to save changes?")

// OK/Cancel dialog
result := wui.message_box_ok_cancel("Confirm", "Delete selected item?")
if result {
    print("User clicked OK")
} else {
    print("User clicked Cancel")
}

// Yes/No dialog
result2 := wui.message_box_yes_no("Save", "Save changes before closing?")
if result2 {
    print("User clicked Yes")
} else {
    print("User clicked No")
}