import "canvas"
import "json"
import "math"

// Load and flatten dataset
data := json.decode(embed("bacteria_go_dataset_augmented.json"))
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

// Draw flagella helper
draw_flagella := fn(ctx, x, y, pos) {
    ctx.hex("#555555")
    if pos == "polar" || pos == "both" {
        ctx.line(x-40, y, x-70, y-20)
        ctx.line(x+40, y, x+70, y+20)
    } else if pos == "peritrichous" {
        for _, i in [-30, 0, 30] {
            ctx.line(x+i, y-20, x+i-10, y-40)
            ctx.line(x+i, y+20, x+i+10, y+40)
        }
    }
    ctx.stroke()
}

// Draw pili helper
draw_pili := fn(ctx, x, y, d) {
    ctx.hex("#999999")
    count := 6
    for i := 0; i < count; i++ {
        angle := float(i) * 360.0 / float(count)
        rad := angle * math.pi / 180
        px := x + int(math.cos(rad)*(d.width/2+5))
        py := y + int(math.sin(rad)*(d.height/2+5))
        ctx.line(x, y, px, py)
    }
    ctx.stroke()
}

// Draw shape with details
draw_shape := fn(ctx, item, x, y) {
    d := item.shape_details
	if item.shape == "circle" {
        ctx.circle(x, y, d.radius)
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

    if item.flagella == true && item.flagella_position != "" {
        draw_flagella(ctx, x, y, item.flagella_position)
    }
    if item.pili == true {
        draw_pili(ctx, x, y, d)
    }
}

// Main draw function
draw := fn(ctx) {
    ctx.hex("#121212")
    ctx.clear()

    item := all[current]
    // Draw organism
    ctx.hex(item.color)
    draw_shape(ctx, item, w/2, h/2-50)

    // Draw text details
    ctx.hex("#FFFFFF")
    baseY := h/2 + 20
    ctx.text(item.name+" ("+item.category+")", 20, baseY)
    ctx.text("Type: "+item.type, 20, baseY+20)
    ctx.text("Shape: "+item.shape, 20, baseY+40)
    ctx.text("Size: "+item.size, 20, baseY+60)
    ctx.text("Density: "+item.density, 20, baseY+80)
    if item.flagella {
        ctx.text("Flagella: "+item.flagella_position, 20, baseY+100)
    }
    if item.pili {
        ctx.text("Pili: "+item.pili_type, 20, baseY+120)
    }
}

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
