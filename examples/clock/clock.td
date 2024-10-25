import "canvas"
import "times"  // Import to get the current time
import "math"

w := 300
h := 300

// Helper function to draw a hand at a given angle and length
fn draw_hand(ctx, angle, length) {
	x := w/2 + length * math.cos(angle)
	y := h/2 + length * math.sin(angle)

	ctx.move_to(w/2, h/2)  // Start from the center
	ctx.line_to(x, y)       // Draw to the calculated end point
	ctx.stroke()
}

// Draw hour numbers on the clock face
fn draw_numbers(ctx) {
	ctx.hex("#000")  // Black color for text
	// ctx.font("16px Arial")

	for i := 1; i <= 12; i++ {
		angle := -math.pi/2 + (2 * math.pi * i) / 12  // Calculate the angle for each hour

		// Calculate the text position slightly inside the circle
		x := w/2 + (w/2 - 30) * math.cos(angle)
		y := h/2 + (h/2 - 30) * math.sin(angle)

		// Center align the text
		// ctx.text_align("center")
		// ctx.text_baseline("middle")
		ctx.text(i, x, y)  // Convert number to string and draw it
	}
}

fn draw_clock(ctx) {
	ctx.hex(`#ffffff`)  // White background
	ctx.clear()

	// Draw the clock face
	ctx.hex("#000")  // Black border
	ctx.linewidth(5)
	ctx.circle(w/2, h/2, w/2 - 10)
	ctx.stroke()

	// Draw hour numbers
	draw_numbers(ctx)

	// Get current time
	now := times.now()
	hour := times.time_hour(now) % 12
	minute := times.time_minute(now)
	second := times.time_second(now)

	// Calculate angles for the clock hands
	second_angle := -math.pi/2 + (2 * math.pi * second) / 60
	minute_angle := -math.pi/2 + (2 * math.pi * minute) / 60
	hour_angle := -math.pi/2 + (2 * math.pi * (hour + minute / 60)) / 12

	// Draw hour hand
	ctx.hex("#000")
	ctx.linewidth(8)
	draw_hand(ctx, hour_angle, w/2 - 60)

	// Draw minute hand
	ctx.linewidth(5)
	draw_hand(ctx, minute_angle, w/2 - 40)

	// Draw second hand
	ctx.hex("#f00")  // Red second hand
	ctx.linewidth(2)
	draw_hand(ctx, second_angle, w/2 - 20)
}

// Main function to create the window and update the clock
canvas.new_window(w, h, "Clock", fn(window) {
	ctx := window.new_context(w, h)

	ro := go(fn(){
		for {
			draw_clock(ctx)
			window.update(w, h)
			times.sleep(times.second)  // Pause for 1 second
		}
	})

	for {
		// Draw the clock every second

		e := window.next_event()
		if e.type == "lifecycle" && e.from == 3 && e.to == 0 {
			ro.abort()
			break  // Exit on window close
		}
	}
})
