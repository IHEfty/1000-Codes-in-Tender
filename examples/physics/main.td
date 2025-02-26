import "canvas"
import "math"
import "vec2"
import "physics"

w := 600
h := 400

// Draw all bodies in the physics world.
fn draw_world(ctx, world) {
    // Clear the background.
    ctx.hex("#121212")
    ctx.clear()

    // Draw each body.
    for i := 0; i < world.bodies.length; i++ {
        body := world.bodies[i]
		if (body.shape.type == "circle") {
			ctx.hex("#0f0")
			// ctx.linewidth(2)
			// Draw the circle outline
			ctx.arc(body.position.x, body.position.y, body.shape.radius, 0, math.pi * 2)
			ctx.stroke()

			// Draw the angle indicator line.
			// Compute the endpoint on the circle's perimeter using cosine and sine.
			marker_x := body.position.x + math.cos(body.angle) * body.shape.radius
			marker_y := body.position.y + math.sin(body.angle) * body.shape.radius

			// ctx.begin_path()
			ctx.move_to(body.position.x, body.position.y)
			ctx.line_to(marker_x, marker_y)
			ctx.stroke()
		}
		else if (body.shape.type == "box") {
			ctx.push()
			ctx.translate(body.position.x, body.position.y)
			ctx.rotate(body.angle)
			// Draw the box centered at (0,0)
			x := -body.shape.half_width
			y := -body.shape.half_height
			ctx.rect(x, y, body.shape.half_width * 2, body.shape.half_height * 2)
			ctx.stroke()
			ctx.pop()
		}

    }
}

canvas.new_window(w, h, "Physics Simulation", fn(window) {
    ctx := window.new_context(w, h)

    // Create a physics world with gravity.
    gravity := vec2(0, 200)
    world := physics.world(gravity)

    // Create a static ground body.
    ground := physics.body(vec2(w / 2, h - 100), 0, true, physics.circle(30))
    world.add_body(ground)

    // Create a falling ball.
    ball := physics.body(vec2(w / 2 + 30, 50), 0, false, physics.circle(20))
    world.add_body(ball)

    // Create another ball.
    ball2 := physics.body(vec2(w / 2 + 50, 0), 0, false, physics.circle(15))
    world.add_body(ball2)

    // **Create a Box (Rectangle)**
    // box := physics.body(vec2(w / 2, 200), 1, true, physics.box(50, 30))
    // world.add_body(box)
	
	box1 := physics.body(vec2(w / 2, 100), 1, false, physics.box(30, 30))
    // world.add_body(box1)
	
	box2 := physics.body(vec2(w / 2, 200), 0, true, physics.box(30, 30))
    // world.add_body(box2)
	// debug(box)

    // Simulation time step.
    dt := 1.0 / 60.0

    // Main loop.
	// go(fn(){
	for {
		// Step the physics simulation.
		world.step(dt)

		// Render the updated physics world.
		draw_world(ctx, world)
		window.update(w, h)
	}
	// })()
	
	// println("hello")
	
	// for {
		// // Process any window events.
		// e := window.next_event()
		// if (e != null) {
			// if (e.type == "size") {
				// w = e.width_px
				// h = e.height_px
				// ctx = window.new_context(w, h)
			// }
			// else if (e.type == "lifecycle" && e.from == 3 && e.to == 0) {
				// break
			// }
		// }
	// }
})
