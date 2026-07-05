import "canvas"
import "math"
import "times"
import "rand"
import "fmt"

// Cyberpunk / Temporal color palette
colors := {
    bg: "#050510",
    panel: "#0f0f1f",
    border: "#1f1f3f",
    brain_alpha: "#ff0055",
    brain_beta: "#00ffff",
    qubit_0: "#3300ff",
    qubit_1: "#ff00aa",
    timeline_main: "#ffffff",
    timeline_branch: "#00ffcc",
    text: "#e0e0ff",
    text_dim: "#606080",
    btn_idle: "#111122",
    btn_active: "#00ffaa"
}

// Global App State
w := 800
h := 600
t := 0.0

// "idle", "capturing", "converting", "transferring"
app_state := "idle" 
capture_progress := 0.0
q_matrix := []
timelines := [{birth_t: 0.0, y_offset: 0.0, energy: 1.0}]

// Initialize fake qubit matrix
for i := 0; i < 64; i++ {
    q_matrix = append(q_matrix, rand.float())
}

fn get_layout(w, h) {
    pad := 20.0
    half_w := (w - pad * 3) / 2.0
    
    return {
        pad: pad,
        brain_x: pad,
        brain_y: pad,
        brain_w: half_w,
        brain_h: h * 0.4,
        
        q_x: pad * 2 + half_w,
        q_y: pad,
        q_w: half_w,
        q_h: h * 0.4,
        
        time_x: pad,
        time_y: pad * 2 + h * 0.4,
        time_w: w - pad * 2,
        time_h: h * 0.35,
        
        ctrl_y: h - 70.0,
        ctrl_h: 50.0
    }
}

fn draw_panel(ctx, title, x, y, width, height) {
    ctx.hex(colors.panel)
    ctx.rect(x, y, width, height)
    ctx.fill()
    
    ctx.hex(colors.border)
    ctx.linewidth(2)
    ctx.rect(x, y, width, height)
    ctx.stroke()
    
    ctx.hex(colors.text)
    ctx.text(title, x + 15, y + 25)
}

fn draw_brainwaves(ctx, x, y, width, height, t, state) {
    draw_panel(ctx, "Neural Cortex Capture", x, y, width, height)
    
    center_y := y + height / 2.0
    start_x := x + 10.0
    end_x := x + width - 10.0
    
    amp_alpha := 10.0
    amp_beta := 5.0
    
    if state == "capturing" || state == "converting" {
        amp_alpha = 40.0 + math.sin(t * 5.0) * 10.0
        amp_beta = 25.0 + math.cos(t * 7.0) * 15.0
    }
    
    // Alpha waves
    ctx.hex(colors.brain_alpha)
    ctx.linewidth(2)
    ctx.move_to(start_x, center_y)
    for px := start_x; px < end_x; px += 2.0 {
        freq := (px - start_x) * 0.05 + t * 3.0
        py := center_y + math.sin(freq) * amp_alpha + math.cos(freq * 0.5) * amp_alpha * 0.5
        ctx.line_to(px, py)
    }
    ctx.stroke()
    
    // Beta waves
    ctx.hex(colors.brain_beta)
    ctx.linewidth(1.5)
    ctx.move_to(start_x, center_y)
    for px := start_x; px < end_x; px += 2.0 {
        freq := (px - start_x) * 0.1 + t * 5.0
        py := center_y + math.cos(freq) * amp_beta + math.sin(freq * 0.3) * amp_beta * 0.3
        ctx.line_to(px, py)
    }
    ctx.stroke()
    
    if state == "capturing" {
        ctx.hex(colors.text)
        ctx.text(fmt.sprintf("Synaptic Lock: %d%%", int(capture_progress * 100)), x + 15, y + height - 15)
    }
}

fn draw_qubits(ctx, x, y, width, height, t, state) {
    draw_panel(ctx, "Qubit Encoding Matrix", x, y, width, height)
    
    cols := 8
    rows := 8
    cell_w := (width - 40.0) / cols
    cell_h := (height - 60.0) / rows
    start_x := x + 20.0
    start_y := y + 45.0
    
    for i := 0; i < 64; i++ {
        cx := start_x + (i % cols) * cell_w + cell_w / 2.0
        cy := start_y + math.floor(i / cols) * cell_h + cell_h / 2.0
        
        radius := math.min(cell_w, cell_h) * 0.3
        
        // Jitter qubit states if converting
        if state == "converting" {
            q_matrix[i] = q_matrix[i] + (rand.float() - 0.5) * 0.2
            if q_matrix[i] < 0.0 { q_matrix[i] = 0.0 }
            if q_matrix[i] > 1.0 { q_matrix[i] = 1.0 }
        } else if state == "transferring" {
            q_matrix[i] = math.sin(t * 10.0 + i) * 0.5 + 0.5 // Unified resonance
        }
        
        val := q_matrix[i]
        
        // Draw orbital rings
        ctx.hex(colors.border)
        ctx.linewidth(1)
        ctx.circle(cx, cy, radius)
        ctx.stroke()
        
        // Draw state probability
        ctx.hex(val > 0.5 ? colors.qubit_1 : colors.qubit_0)
        ctx.circle(cx, cy, radius * val)
        ctx.fill()
    }
}

fn draw_timelines(ctx, x, y, width, height, t, state, timelines) {
    draw_panel(ctx, "Temporal Divergence Map", x, y, width, height)
    
    center_y := y + height / 2.0
    start_x := x + 20.0
    
    // Draw grid
    ctx.hex(colors.border)
    ctx.linewidth(0.5)
    for gx := start_x; gx < x + width - 20; gx += 50.0 {
        ctx.move_to(gx, y + 40)
        ctx.line_to(gx, y + height - 20)
    }
    ctx.stroke()
    
    ctx.linewidth(2)
    
    // Draw all timelines
    for i, tl in timelines {
        if i == 0 { ctx.hex(colors.timeline_main) } 
        else { ctx.hex(colors.timeline_branch) }
        
        ctx.move_to(start_x, center_y)
        
        current_x := start_x
        current_y := center_y
        
        // Simulate plotting the timeline forward
        for step := 0.0; step < t - tl.birth_t; step += 0.5 {
            px := start_x + step * 20.0
            
            if px > x + width - 20 { break } // Clip to panel
            
            // Branching math
            if i > 0 {
                // Ease into the offset
                progress := math.min(1.0, step / 5.0) 
                py := center_y + (tl.y_offset * progress) + math.sin(step + i) * 2.0
                ctx.line_to(px, py)
                current_x = px
                current_y = py
            } else {
                ctx.line_to(px, center_y)
                current_x = px
                current_y = center_y
            }
        }
        ctx.stroke()
        
        // Draw active present node
        if current_x <= x + width - 20 {
            ctx.circle(current_x, current_y, 4.0)
            ctx.fill()
        }
    }
    
    if state == "transferring" {
        // Glitch effect on map
        ctx.hex("#ffffff")
        ctx.rect(x + rand.float()*width, y + rand.float()*height, 50, 2)
        ctx.fill()
    }
}

fn draw_controls(ctx, w, lay, state) {
    btn_w := 200.0
    btn_x := (w - btn_w) / 2.0
    
    ctx.hex(state == "idle" ? colors.border : colors.btn_active)
    ctx.rect(btn_x, lay.ctrl_y, btn_w, lay.ctrl_h)
    ctx.fill()
    
    ctx.hex(colors.bg)
    ctx.rect(btn_x + 2, lay.ctrl_y + 2, btn_w - 4, lay.ctrl_h - 4)
    ctx.fill()
    
    ctx.hex(state == "idle" ? colors.text : colors.btn_active)
    
    label := "INITIATE CAPTURE"
    if state == "capturing" { label = "EXTRACTING NEURAL DATA..." }
    else if state == "converting" { label = "QUANTUM TRANSLATION..." }
    else if state == "transferring" { label = "TIMELINE DIVERGING!!!" }
    
    ctx.text(label, btn_x + 20, lay.ctrl_y + 30)
}

// Main Window Loop
canvas.new_window(w, h, "Brainwave Transfer Simulator", fn(window) {
    ctx := window.new_context(w, h)
    
    for {
        t += 0.05
        
        // Logic updates based on state
        if app_state == "capturing" {
            capture_progress += 0.01
            if capture_progress >= 1.0 {
                app_state = "converting"
                capture_progress = 0.0
            }
        }
        else if app_state == "converting" {
            capture_progress += 0.01
            if capture_progress >= 1.0 {
                app_state = "transferring"
                capture_progress = 0.0
            }
        }
        else if app_state == "transferring" {
            capture_progress += 0.02
            if capture_progress >= 1.0 {
                // CREATE PARALLEL TIMELINE
                new_tl := {
                    birth_t: t, 
                    y_offset: (rand.float() > 0.5 ? 1.0 : -1.0) * (40.0 + rand.float() * 60.0),
                    energy: 1.0
                }
                timelines = append(timelines, new_tl)
                
                app_state = "idle"
                capture_progress = 0.0
            }
        }
        
        // Handle Events
        e := window.next_event()
        if e["type"] == "size" {
            w = e.width_px
            h = e.height_px
            ctx = window.new_context(w, h)
        }
        else if e["type"] == "mouse" && e.direction == 1 { // Mouse down
            lay := get_layout(w, h)
            btn_w := 200.0
            btn_x := (w - btn_w) / 2.0
            
            // Check button click
            if e.x >= btn_x && e.x <= btn_x + btn_w && e.y >= lay.ctrl_y && e.y <= lay.ctrl_y + lay.ctrl_h {
                if app_state == "idle" {
                    app_state = "capturing"
                    capture_progress = 0.0
                    // Reset t so the timeline starts drawing from left if it goes offscreen
                    if t > 60.0 { 
                        t = 0.0 
                        timelines = [{birth_t: 0.0, y_offset: 0.0, energy: 1.0}]
                    }
                }
            }
        }
        else if e["type"] == "lifecycle" && e["from"] == 3 && e.to == 0 {
            break
        }
        
        // Rendering
        ctx.hex(colors.bg)
        ctx.rect(0, 0, w, h)
        ctx.fill()
        
        lay := get_layout(w, h)
        
        draw_brainwaves(ctx, lay.brain_x, lay.brain_y, lay.brain_w, lay.brain_h, t, app_state)
        draw_qubits(ctx, lay.q_x, lay.q_y, lay.q_w, lay.q_h, t, app_state)
        draw_timelines(ctx, lay.time_x, lay.time_y, lay.time_w, lay.time_h, t, app_state, timelines)
        draw_controls(ctx, w, lay, app_state)
        
        window.update(w, h)
        times.sleep(16666666) // ~60 FPS
    }
})