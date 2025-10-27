import "canvas"
import "math"
import "times"

//---------------------------------------
// Simulation Domain & Canvas Setup
//---------------------------------------
w := 600
h := 400
margin := 50

// Define simulation coordinate range.
sim_x_min := -10.0
sim_x_max := 10.0
sim_y_min := -10.0
sim_y_max := 10.0

// Mapping simulation coordinates (x,y) to canvas coordinates.
fn map_sim_to_canvas(x, y) {
    canvas_x := margin + ((x - sim_x_min) / (sim_x_max - sim_x_min)) * (w - 2 * margin)
    // In canvas, y increases downward so we flip the simulation y.
    canvas_y := h - margin - ((y - sim_y_min) / (sim_y_max - sim_y_min)) * (h - 2 * margin)
    return [canvas_x, canvas_y]
}

//---------------------------------------
// Lagrangian Particle Setup
//---------------------------------------
// We'll simulate a particle with Lagrangian L = T - V,
// where T = ½ (vx²+vy²) and V = ½ (x²+y²) + 0.1 (x⁴+y⁴)
// so the equations of motion become:
//   ax = - (x + 0.4*x³)
//   ay = - (y + 0.4*y³)
dt := 0.01
x := 0.0      // initial x position
y := 0.0      // initial y position
vx := 2.0     // initial x velocity
vy := 0.0     // initial y velocity

// To show a short trail, store recent positions.
trail := []  // list of [x,y] in simulation coordinates
max_trail_length := 200

//---------------------------------------
// Create Canvas Window
//---------------------------------------
canvas.new_window(w, h, "Modern Equation Lagrangian Particle", fn(window) {
    ctx := window.new_context(w, h)
    
    // A function to draw the simulation domain (a grid and border).
    fn draw_sim_grid() {
        // Fill background with a modern light tone.
        ctx.hex("#ecf0f1")
        ctx.rect(0, 0, w, h)
		ctx.fill()
        
        // Draw border for simulation area.
        ctx.hex("#bdc3c7")
        ctx.rect(margin, margin, w - 2 * margin, h - 2 * margin)
        ctx.stroke()
    }
    
    // Main simulation loop.
    for {
        // Update simulation: Compute accelerations.
        ax := -(x + 0.4 * math.pow(x, 3))
        ay := -(y + 0.4 * math.pow(y, 3))
        
        // Euler integration:
        vx = vx + ax * dt
        vy = vy + ay * dt
        x = x + vx * dt
        y = y + vy * dt
        
        // Append current simulation position to trail.
        trail.push([x, y])
        if trail.length > max_trail_length {
            // Remove the oldest point.
            // trail.shift()
        }
        
        // Clear canvas and re-draw grid.
        draw_sim_grid()
        
        // Draw the particle trail.
        ctx.hex("#3498db")
        ctx.linewidth(2)
        // Begin a new path.
        for i in range(0, trail.length) {
            sim_pt := trail[i]
            pt := map_sim_to_canvas(sim_pt[0], sim_pt[1])
            if i == 0 {
                ctx.move_to(pt[0], pt[1])
            } else {
                ctx.line_to(pt[0], pt[1])
            }
        }
        ctx.stroke()
        
        // Draw the current particle as a circle.
        current_pt := map_sim_to_canvas(x, y)
        ctx.hex("#e74c3c")
        ctx.arc(current_pt[0], current_pt[1], 8, 0, 2 * math.pi)
        ctx.fill()
        
        // Optionally, display current time or coordinates.
        ctx.hex("#2c3e50")
        ctx.text("x=" + x + ", y=" + y, margin, h - margin/2)
        
        window.update(w, h)
        // Delay for about 10ms between frames.
        times.sleep(10000000)
        
        // Optional: Break out on a window close event.
        e := window.next_event()
        if e.type == "lifecycle" && e.from == 3 && e.to == 0 {
            break
        }
    }
})
