import "canvas"
import "json"
import "math"

// ... [Keep previous data loading code] ...
// Load and flatten dataset
data := json.decode(embed("bacteria_go_dataset_augmented.json"))
// data := json.decode(embed("bacteria_go_dataset_huge.json"))
all := []
for _, cat in ["bacteria", "viruses", "algae"] {
    items := data[cat]
    for _, item in items {
        item.category = cat
        all = append(all, item)
    }
}

// Initial window size and index
w := 700
h := 400
current := 0

// Enhanced flagella with 3D effect using available functions
draw_flagella := fn(ctx, x, y, pos) {
    ctx.push()
    ctx.linewidth(2)
    
    if pos == "polar" || pos == "both" {
        // Left flagellum with tapered effect
        ctx.hex("#5a5a5a")
        ctx.move_to(x-40, y)
        ctx.cubic_to(x-45, y-5, x-60, y-15, x-70, y-20)
        ctx.stroke()
        
        // Right flagellum with multiple lines for depth
        ctx.hex("#7a7a7a")
        ctx.move_to(x+40, y)
        ctx.cubic_to(x+45, y+5, x+60, y+15, x+70, y+20)
        ctx.stroke()
    } 
    else if pos == "peritrichous" {
        ctx.hex("#666666")
        for i in [-30, 0, 30] {
            // Front flagella
            ctx.linewidth(1.5)
            ctx.move_to(x+i, y-20)
            ctx.line_to(x+i-10, y-40)
            
            // Back flagella with thinner lines
            ctx.linewidth(0.8)
            ctx.move_to(x+i, y+20)
            ctx.line_to(x+i+10, y+40)
        }
        ctx.stroke()
    }
    ctx.pop()
}

// Realistic pili using available transformations
draw_pili := fn(ctx, x, y, d) {
    ctx.push()
    count := 8
    base_color := "#999999"
    
    ctx.translate(x, y)
    for i := 0; i < count; i++ {
        ctx.rotate(canvas.radians(360/count))
        
        // Vary pili color intensity
        ctx.hex(i % 2 == 0 ? "#aaaaaa" : "#777777")
        ctx.move_to(0, 0)
        ctx.line_to(d.width/2 + 10, d.height/2 + 10)
        ctx.stroke()
    }
    ctx.pop()
}

// Cell shading simulation using concentric circles
draw_cell_shading := fn(ctx, x, y, radius, color) {
    // Base color
    ctx.hex(color)
    ctx.circle(x, y, radius)
    ctx.fill()
    
    // Cytoplasmic texture using dots
    ctx.push()
    ctx.hex("#ffffff")
    for i := 0; i < 30; i++ {
        angle := canvas.radians(i * 12)
        // dist := radius * 0.8 * math.random(0.7, 1.0)
        dist := radius * 0.8 * 0.8
        tx := x + dist * math.cos(angle)
        ty := y + dist * math.sin(angle)
        ctx.point(tx, ty, 1)
    }
    ctx.pop()
    
    // Highlight effect using rotated ellipse
    ctx.push()
    ctx.hex("#ffffff")
    ctx.translate(x, y)
    ctx.rotate(canvas.radians(45))
    ctx.ellipse(radius/3, -radius/3, radius/4, radius/6)
    ctx.fill()
    ctx.pop()
}

// Enhanced spiral using multiple curves
draw_realistic_spiral := fn(ctx, x, y, details) {
    ctx.push()
    ctx.translate(x, y)
    ctx.linewidth(3)
    
    // Primary spiral
    ctx.hex("#7FFFD4")
    for angle := 0.0; angle < 720.0; angle += 20.0 {
        rad := angle * math.pi / 180
        px := rad * math.cos(rad)
        py := rad * math.sin(rad)
        ctx.line_to(px, py)
    }
    ctx.stroke()
    
    // Secondary spiral for depth
    ctx.hex("#5accc4")
    ctx.linewidth(1.5)
    for angle := 10.0; angle < 720.0; angle += 20.0 {
        rad := angle * math.pi / 180
        px := rad * math.cos(rad + 0.5)
        py := rad * math.sin(rad + 0.5)
        ctx.line_to(px, py)
    }
    ctx.stroke()
    ctx.pop()
}


// Modified draw_shape with depth effects
draw_shape := fn(ctx, item, x, y) {
    d := item.shape_details
    ctx.push()
    
    // Main cell body with simulated lighting
    ctx.hex(item.color)
    if item.shape == "spiral" {
        draw_realistic_spiral(ctx, x, y, d)
    }
	else {
        if item.shape == "circle" {
            draw_cell_shading(ctx, x, y, d.radius, item.color)
        }
		else if item.shape == "ellipse" {
			ctx.ellipse(x, y, d.width, d.height)
		}
		else if item.shape == "rod" {
			ctx.rounderect(x-int(d.width/2), y-int(d.height/2), d.width, d.height, 10)
		}
		else if item.shape == "spiral" {
			for angle := 0.0; angle < 720.0; angle += 20.0 {
				rad := angle * math.pi / 180
				px := x + int(rad*math.cos(rad))
				py := y + int(rad*math.sin(rad))
				ctx.circle(px, py, 1)
			}
		}
		else if item.shape ==  "comma" {
			ctx.arc(x, y, d.radius, 45, 270)
		}
		else if item.shape == "star" {
			ctx.polygon(5, x, y, d.radius, 0)
		}
		else {
			ctx.circle(x, y, d.radius)
		}
		ctx.fill()
    }
    
    // Surface details
    if item.density == "high" {
        ctx.hex(item.color)
        for i := 0; i < 20; i++ {
            angle := canvas.radians(i * 18)
            dist := d.radius * 0.9
            ctx.point(
                x + dist * math.cos(angle),
                y + dist * math.sin(angle),
				1
            )
        }
    }
    
    ctx.pop()
    
    // Appendages
    if item.flagella {
        draw_flagella(ctx, x, y, item.flagella_position)
    }
    if item.pili {
        draw_pili(ctx, x, y, d)
    }
}


// Main draw function with improved layout
draw := fn(ctx) {
    // Gradient background simulation
    ctx.hex("#1a1a2e")
    ctx.clear()
    
    // Draw organism
    item := all[current]
    // ctx.save()
    ctx.translate(w/2, h/2-50)
    draw_shape(ctx, item, 0, 0)
    // ctx.restore()
    
    // Information panel with border
    ctx.hex("#000000")
    ctx.rounderect(10, h/2 + 5, 300, 140, 12)
    ctx.fill()
    
    ctx.hex("#ffffff")
    baseY := h/2 + 20
    ctx.text(item.name+" ("+item.category+")", 20, baseY)
    // ... rest of text elements ...
}

// ... Keep window management code ...

// Open interactive window
canvas.new_window(w, h, "Organism Viewer", fn(window) {
    ctx := window.new_context(w, h)
    draw(ctx)
    window.update(w, h)

    for {
        e := window.next_event()
        if e.type == "lifecycle" && e.from == 3 && e.to == 0 {
            break
        } 
		else if e.type == "key" && e.direction == 1 {
            if e.code == 79 {
                current = (current + 1) % len(all)
            } 
			else if e.code == 80 {
                current = (current - 1 + len(all)) % len(all)
            }
            ctx = window.new_context(w, h)
            draw(ctx)
            window.update(w, h)
        } 
		else if e.type == "size" {
            w = e.width_px
            h = e.height_px
            ctx = window.new_context(w, h)
            draw(ctx)
            window.update(w, h)
        }
    }
})
