import "wui"
import "randint"
import "os"

w := wui.new_window()
w.set_title("Container Controls Demo")
w.set_size(600, 500)

// Panel as a container
panel := wui.new_panel()
// panel.set_bounds(20, 20, 250, 200)
// panel.set_border_style(1) // Sunken border

// Controls inside panel
panel_label := wui.new_label()
panel_label.set_text("Inside Panel")
panel_label.set_bounds(10, 10, 100, 30)

panel_button := wui.new_button()
panel_button.set_text("Panel Button")
panel_button.set_bounds(10, 50, 120, 30)

// Add controls to panel
// panel.add(panel_label)
// panel.add(panel_button)

// PaintBox for custom drawing
paintbox := wui.new_paintbox()
paintbox.set_bounds(300, 20, 200, 200)
paintbox.set_on_paint(fn(canvas) {
	// println(canvas)
	// println(canvas.set_color)
	// Draw a rectangle
	// canvas.set_color(255, 0, 0) // Red
	canvas.draw_rect(10, 10, 180, 180, wui.rgb_color(randint(0,255),0,randint(0,255)))
	// println("ook")
})

// Button to refresh paintbox
refresh_btn := wui.new_button()
refresh_btn.set_text("Refresh")
refresh_btn.set_bounds(300, 230, 100, 30)
refresh_btn.set_onclick(fn() {
	// paintbox.paint() // Force repaint
	os.exit(0)
})

w.add(panel)
w.add(paintbox)
w.add(refresh_btn)

go(fn(){
	for {
		paintbox.paint()
	}
})
	
// debug(g)

w.show()