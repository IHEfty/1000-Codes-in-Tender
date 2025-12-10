import "wui"

// Create window
window := wui.new_window()
window.set_title("User Registration")
window.set_size(500, 400)

// Name field
name_label := wui.new_label()
name_label.set_text("Name:")
name_label.set_bounds(20, 20, 80, 25)

name_edit := wui.new_editline()
name_edit.set_bounds(110, 20, 200, 25)

// Email field
email_label := wui.new_label()
email_label.set_text("Email:")
email_label.set_bounds(20, 60, 80, 25)

email_edit := wui.new_editline()
email_edit.set_bounds(110, 60, 200, 25)

// Gender selection
gender_label := wui.new_label()
gender_label.set_text("Gender:")
gender_label.set_bounds(20, 100, 80, 25)

male_radio := wui.new_radiobutton()
// male_radio.set_text("Male")
// male_radio.set_bounds(110, 100, 80, 25)

female_radio := wui.new_radiobutton()
// female_radio.set_text("Female")
// female_radio.set_bounds(200, 100, 80, 25)

// Subscribe checkbox
subscribe := wui.new_checkbox()
subscribe.set_text("Subscribe to newsletter")
// subscribe.set_checked(true)
subscribe.set_bounds(110, 140, 200, 25)

// Country combo box
country_label := wui.new_label()
country_label.set_text("Country:")
country_label.set_bounds(20, 180, 80, 25)

country_combo := wui.new_combobox()
country_combo.set_items(["USA", "Canada", "UK", "Australia", "Germany"])
country_combo.set_selected_index(0)
country_combo.set_bounds(110, 180, 150, 25)

// Buttons
submit_btn := wui.new_button()
submit_btn.set_text("Submit")
submit_btn.set_bounds(110, 240, 100, 30)

cancel_btn := wui.new_button()
cancel_btn.set_text("Cancel")
cancel_btn.set_bounds(220, 240, 100, 30)

// Add all controls to window
controls := [name_label, name_edit, email_label, email_edit,
             gender_label, male_radio, female_radio, subscribe,
             country_label, country_combo, submit_btn, cancel_btn]

for control in controls {
    window.add(control)
}

window.show()