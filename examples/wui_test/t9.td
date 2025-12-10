import "wui"

color_window := wui.new_window()
color_window.set_title("Colors and Fonts Demo")
color_window.set_size(500, 400)

// Create custom colors
red_color := wui.rgb_color(255, 0, 0)
green_color := wui.rgb_color(0, 255, 0)
blue_color := wui.rgb_color(0, 0, 255)
purple_color := wui.rgb_color(128, 0, 128)

// Create custom font
font_desc := {
    "name": "Arial",
    "height": 16,
    "bold": true
}

custom_font := wui.new_font(font_desc)

// Create labels with different colors and fonts
label1 := wui.new_label()
label1.set_text("Red Text")
label1.set_bounds(50, 50, 200, 30)
// Note: You would need to extend the API to support set_foreground_color

label2 := wui.new_label()
label2.set_text("Bold Font Text")
label2.set_bounds(50, 100, 200, 30)
// label2.set_font(custom_font) // When font setting is implemented

label3 := wui.new_label()
label3.set_text("Large Text")
label3.set_bounds(50, 150, 200, 40)

// Add controls
color_window.add(label1)
color_window.add(label2)
color_window.add(label3)

color_window.show()