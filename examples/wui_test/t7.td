import "wui"

settings_window := wui.new_window()
settings_window.set_title("Settings")
settings_window.set_size(450, 350)

// Settings sections using panels
general_panel := wui.new_panel()
// general_panel.set_bounds(10, 10, 430, 150)

appearance_panel := wui.new_panel()
// appearance_panel.set_bounds(10, 170, 430, 170)

// General settings
auto_save := wui.new_checkbox()
auto_save.set_text("Auto-save changes")
auto_save.set_bounds(20, 20, 200, 25)

save_interval_label := wui.new_label()
save_interval_label.set_text("Save interval (minutes):")
save_interval_label.set_bounds(20, 55, 150, 25)

save_interval := wui.new_intupdown()
save_interval.set_min(1)
save_interval.set_max(60)
save_interval.set_value(5)
save_interval.set_bounds(180, 55, 80, 25)

// Appearance settings
theme_label := wui.new_label()
theme_label.set_text("Theme:")
theme_label.set_bounds(20, 20, 80, 25)

theme_combo := wui.new_combobox()
theme_combo.set_items(["Light", "Dark", "System"])
theme_combo.set_selected_index(0)
theme_combo.set_bounds(110, 20, 150, 25)

font_size_label := wui.new_label()
font_size_label.set_text("Font size:")
font_size_label.set_bounds(20, 60, 80, 25)

font_size_slider := wui.new_slider()
font_size_slider.set_min(8)
// font_size_slider.set_value(12)
font_size_slider.set_max(24)
font_size_slider.set_bounds(110, 60, 200, 25)

font_size_value := wui.new_label()
font_size_value.set_text("12")
font_size_value.set_bounds(320, 60, 30, 25)

// Buttons
ok_btn := wui.new_button()
ok_btn.set_text("OK")
ok_btn.set_bounds(280, 310, 75, 30)

cancel_btn := wui.new_button()
cancel_btn.set_text("Cancel")
cancel_btn.set_bounds(365, 310, 75, 30)

// Add controls to panels
general_panel.add(auto_save)
general_panel.add(save_interval_label)
general_panel.add(save_interval)

appearance_panel.add(theme_label)
appearance_panel.add(theme_combo)
appearance_panel.add(font_size_label)
appearance_panel.add(font_size_slider)
appearance_panel.add(font_size_value)

// Add panels and buttons to window
settings_window.add(general_panel)
settings_window.add(appearance_panel)
settings_window.add(ok_btn)
settings_window.add(cancel_btn)

settings_window.show()