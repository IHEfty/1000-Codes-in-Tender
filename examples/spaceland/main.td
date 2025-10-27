// Solar System Rocket Game

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
            // Use a different color for the sun.
            if (body.mass > 100) {
                ctx.hex("#ffcc00") // Sun: yellowish
            } else {
                ctx.hex("#0f0")    // Planets: green
            }
            ctx.arc(body.position.x, body.position.y, body.shape.radius, 0, math.pi * 2)
            ctx.stroke()

            // Draw an angle indicator line.
            marker_x := body.position.x + math.cos(body.angle) * body.shape.radius
            marker_y := body.position.y + math.sin(body.angle) * body.shape.radius
            ctx.move_to(body.position.x, body.position.y)
            ctx.line_to(marker_x, marker_y)
            ctx.stroke()
        }
        else if (body.shape.type == "box") {
            ctx.push()
            ctx.translate(body.position.x, body.position.y)
            ctx.rotate(body.angle)
            x := -body.shape.half_width
            y := -body.shape.half_height
            // Use red color for the player's rocket.
            if (body.player == true) {
                ctx.hex("#ff0000")
            } else {
                ctx.hex("#ffffff")
            }
            ctx.rect(x, y, body.shape.half_width * 2, body.shape.half_height * 2)
            ctx.stroke()
            ctx.pop()
        }
    }
}

canvas.new_window(w, h, "Solar System Rocket Game", fn(window) {
    ctx := window.new_context(w, h)

    // Create a physics world with zero constant gravity.
    world := physics.world(vec2(0, 0))

    // --- Create the Sun ---
    sun := physics.body(vec2(w / 2, h / 2), 0, false, physics.circle(30))
    // Make the sun heavy.
    sun.mass = 1000
    sun.inv_mass = 1 / sun.mass
    sun.inertia = 0.5 * sun.mass * 30 * 30  // For a circle: (1/2) m r^2
    sun.inv_inertia = 1 / sun.inertia
    world.add_body(sun)

    // --- Create Planet 1 ---
    planet1 := physics.body(vec2(w / 2 + 100, h / 2), 0, false, physics.circle(10))
    planet1.mass = 1
    planet1.inv_mass = 1 / planet1.mass
    planet1.inertia = 0.5 * planet1.mass * 10 * 10
    planet1.inv_inertia = 1 / planet1.inertia
    // For a circular orbit, orbital speed v = sqrt(G * M / r). With G=1, M=1000, r=100 => v ~3.16.
    // Here we give it an upward velocity.
    planet1.velocity = vec2(0, 3.16)
    world.add_body(planet1)

    // --- Create Planet 2 ---
    planet2 := physics.body(vec2(w / 2, h / 2 - 150), 0, false, physics.circle(8))
    planet2.mass = 0.5
    planet2.inv_mass = 1 / planet2.mass
    planet2.inertia = 0.5 * planet2.mass * 8 * 8
    planet2.inv_inertia = 1 / planet2.inertia
    // For a planet above the sun, give it a rightward velocity.
    planet2.velocity = vec2(2.58, 0)
    world.add_body(planet2)

    // --- Create Planet 3 ---
    planet3 := physics.body(vec2(w / 2 - 130, h / 2), 0, false, physics.circle(12))
    planet3.mass = 0.8
    planet3.inv_mass = 1 / planet3.mass
    planet3.inertia = 0.5 * planet3.mass * 12 * 12
    planet3.inv_inertia = 1 / planet3.inertia
    // For a planet to the left, give it a downward velocity.
    planet3.velocity = vec2(0, -2.77)
    world.add_body(planet3)

    // --- Create the Player's Rocket ---
    // We'll represent the rocket as a box.
    rocket := physics.body(vec2(w / 2 + 150, h / 2), 0, false, physics.box(10, 20))
    rocket.mass = 0.5
    rocket.inv_mass = 1 / rocket.mass
    // For a rectangle, moment of inertia = (1/12) * mass * (width^2 + height^2)
    // Our box dimensions: half_width = 10, half_height = 20, so full width = 20, full height = 40.
    width := 20
    height := 40
    rocket.inertia = (rocket.mass * (width * width + height * height)) / 12
    rocket.inv_inertia = 1 / rocket.inertia
    // Mark this body as the player's rocket.
    rocket.player = true
    world.add_body(rocket)

    // Simulation time step.
    dt := 1.0 / 60.0
    // Gravitational constant (tweak for desired behavior).
    G := 90

    // Control parameters for the rocket.
    thrust_force := 15.0
    rotation_torque := 0.02

	fun := fn(){
		// Main loop.
		for {
			// // --- Process Player Input ---
			// // (Assuming window.is_key_down(key) returns true if the key is held.)
			// if window.is_key_down("ArrowLeft") {
				// rocket.apply_torque(-rotation_torque)
			// }
			// if window.is_key_down("ArrowRight") {
				// rocket.apply_torque(rotation_torque)
			// }
			// if window.is_key_down("ArrowUp") {
				// // Apply thrust in the direction the rocket is pointing.
				// direction := vec2(math.cos(rocket.angle), math.sin(rocket.angle))
				// rocket.apply_force(direction.scale(thrust_force))
			// }

			// --- Compute pairwise gravitational forces ---
			// Newton's law: F = G * m1 * m2 / r^2 (directed along the line between bodies)
			for i := 0; i < world.bodies.length; i++ {
				for j := i + 1; j < world.bodies.length; j++ {
					b1 := world.bodies[i]
					b2 := world.bodies[j]
					r_vec := b2.position.sub(b1.position)
					dist := r_vec.len()
					if (dist < 1) { dist = 1 }  // avoid singularities
					force_mag := G * b1.mass * b2.mass / (dist * dist)
					force := r_vec.norm().scale(force_mag)
					if (!b1.is_static) {
						b1.apply_force(force)
					}
					if (!b2.is_static) {
						b2.apply_force(force.scale(-1))
					}
				}
			}

			// --- Step the physics simulation ---
			world.step(dt)
			// Render the updated world.
			draw_world(ctx, world)
			window.update(w, h)
		}
	}
	
	go(fun)()
	
	for {
		println(9)
	}
})
