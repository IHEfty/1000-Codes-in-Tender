import "canvas"
import "math"     
import "times"

w := 600           // Window width
h := 400           // Window height
amplitude := 100   // Amplitude of the sine wave
frequency := 0.02  // Frequency controls the wavelength

fn draw_axes(ctx) {
	// Set axis color and line thickness
	ctx.hex("#ffffff")  // White for axes
	ctx.linewidth(1)

	// Draw X-axis (horizontal)
	ctx.move_to(0, h / 2)
	ctx.line_to(w, h / 2)
	ctx.stroke()

	// Draw Y-axis (vertical)
	ctx.move_to(w / 2, 0)
	ctx.line_to(w / 2, h)
	ctx.stroke()

	// Draw tick marks on X-axis
	for i := 0; i < w; i += 50 {
		ctx.move_to(i, h / 2 - 5)
		ctx.line_to(i, h / 2 + 5)
		ctx.stroke()
	}

	// Draw tick marks on Y-axis
	for j := 0; j < h; j += 50 {
		ctx.move_to(w / 2 - 5, j)
		ctx.line_to(w / 2 + 5, j)
		ctx.stroke()
	}
}

fn draw_func(ctx, hex, func) {
	ctx.hex(hex)     // Green color for the sine wave
	ctx.linewidth(1)    // Set line thickness

	// Start drawing the sine wave
	for x := 0; x < w; x++ {
		// Calculate the sine value, adjusted with amplitude
		y := h / 2 - (amplitude * func((x - w / 2) * frequency))

		if x == 0 {
			ctx.move_to(x, y)  // Start from the first point
		} else {
			ctx.line_to(x, y)  // Draw a line to the next point
		}
	}
	

	ctx.stroke()  // Apply the stroke to draw the sine wave
}

fn draw(ctx) {
	draw_axes(ctx)
	draw_func(ctx, "#0ff", fn(x){
		return math.sin(x) * math.cos(x) - math.sin(x)
	})
	// draw_func(ctx, "#ff0", fn(x){
		// return math.sqrt(2-x*x)
	// })
	draw_func(ctx, "#f00", math.cos)	
	draw_func(ctx, "#0f0", math.sin)	
}

canvas.new_window(w, h, "waves", fn(window) {
	ctx := window.new_context(w, h)
	draw(ctx)
	window.update(w, h)

	// Handle resizing or window events if needed
	for {
		e := window.next_event()
		if e.type == "size" {
			w = e.width_px
			h = e.height_px
			ctx = window.new_context(w, h)

			// Redraw everything after resize
			draw(ctx)
			window.update(w, h)
		} else if e.type == "lifecycle" && e.from == 3 && e.to == 0 {
			break  // Exit loop on window close
		}
	}
})
