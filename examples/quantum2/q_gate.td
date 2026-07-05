import "quantum" as q
import "canvas"
import "math"
import "times"
import "cmplx"
import "rand"
import "fmt"

// Modern color palette
colors := {
    background: "#0f0f23",
    primary: "#00ff9f",
    secondary: "#ff2a6d",
    accent: "#0059ff",
    text: "#ffffff",
    grid: "#1a1a2e",
    scrollbar: "#2a2a5a",
    bar1: "#00ff9f",
    bar2: "#ff2a6d",
    bar3: "#0059ff",
    bar4: "#ffcc00"
}

// Initialize quantum system
n_qubits := 2
state := q.zero_state(n_qubits)
circuit_history := []
measurement_results := []

// Window dimensions
w := 600
h := 400

fn get_layout(w, h) {
    pad := 20.0
    // Dynamic constraints ensuring components never squash
    top_h := math.max(220.0, h * 0.35)
    mid_h := math.max(220.0, h * 0.35)
    pal_h := math.max(160.0, h * 0.25)
    ctrl_h := math.max(60.0, h * 0.08)

    y1 := pad
    y2 := y1 + top_h + pad
    y3 := y2 + mid_h + pad
    y4 := y3 + pal_h + pad

    total_h := y4 + ctrl_h + pad

    return {
        pad: pad,
        top_h: top_h,
        mid_h: mid_h,
        pal_h: pal_h,
        ctrl_h: ctrl_h,
        y1: y1,
        y2: y2,
        y3: y3,
        y4: y4,
        total_h: total_h
    }
}

fn draw_modern_background(ctx, w, h) {
    // Gradient background
    ctx.hex(colors.background)
    ctx.rect(0, 0, w, h)
    ctx.fill()
    
    // Grid pattern
    ctx.hex(colors.grid)
    ctx.linewidth(0.5)
    grid_size := math.max(20.0, math.min(w, h) / 30.0)
    for x := 0.0; x < w; x += grid_size {
        ctx.move_to(x, 0)
        ctx.line_to(x, h)
    }
    for y := 0.0; y < h; y += grid_size {
        ctx.move_to(0, y)
        ctx.line_to(w, y)
    }
    ctx.stroke()
}

fn draw_state_vector(ctx, state, x, y, width, height) {
    n := len(state)
    
    // Background
    ctx.hex("#1e1e3f")
    ctx.rect(x, y, width, height)
    ctx.fill()
    
    // Title
    ctx.hex(colors.text)
    ctx.text("Quantum State Vector", x + width * 0.05, y + height * 0.1)
    
    // Draw amplitude bars
    bar_width := (width - width * 0.1) / n
    max_height := height * 0.7
    
    for i := 0; i < n; i++ {
        bar_x := x + width * 0.05 + i * bar_width
        prob := cmplx.abs(state[i]) * cmplx.abs(state[i])
        
        // Probability bar
        ctx.hex(colors.bar1)
        bar_height := prob * max_height
        ctx.rect(bar_x, y + height * 0.8 - bar_height, bar_width * 0.8, bar_height)
        ctx.fill()
        
        // Phase indicator
        ctx.rect(bar_x, y + height * 0.83, bar_width * 0.8, height * 0.02)
        ctx.fill()
        
        // State label
        ctx.hex(colors.text)
        label := fmt.sprintf("|%0%db>", n_qubits, i)
        ctx.text(label, bar_x, y + height * 0.95)
        
        // Probability text
        ctx.text(fmt.sprintf("%.1f%%", prob * 100), bar_x, y + height * 0.75 - bar_height)
    }
}

fn draw_bloch_sphere(ctx, state, x, y, width, height) {
    size := math.min(width, height)
    center_x := x + width/2
    center_y := y + height/2
    radius := size * 0.35
    
    // Sphere background
    ctx.hex(colors.background)
    ctx.circle(center_x, center_y, radius)
    ctx.fill()
    
    // Grid lines
    ctx.hex("#3a3a6a")
    ctx.linewidth(1)
    ctx.circle(center_x, center_y, radius)
    ctx.stroke()
    
    // Axes
    ctx.linewidth(2)
    ctx.hex(colors.primary)
    ctx.move_to(center_x - radius, center_y)
    ctx.line_to(center_x + radius, center_y)
    ctx.stroke()
    
    ctx.hex(colors.secondary)
    ctx.move_to(center_x, center_y - radius)
    ctx.line_to(center_x, center_y + radius)
    ctx.stroke()
    
    if len(state) == 2 {
        alpha := state[0]
        beta := state[1]
        
        x_val := 2 * (alpha.real * beta.real + alpha.imag * beta.imag)
        y_val := 2 * (alpha.imag * beta.real - alpha.real * beta.imag)
        
        sphere_x := center_x + x_val * radius * 0.8
        sphere_y := center_y + y_val * radius * 0.8
        
        ctx.hex(colors.accent)
        ctx.linewidth(3)
        ctx.move_to(center_x, center_y)
        ctx.line_to(sphere_x, sphere_y)
        ctx.stroke()
        
        ctx.hex("#ff2a6d")
        ctx.circle(sphere_x, sphere_y, 6)
        ctx.fill()
        ctx.hex("#ffffff")
        ctx.circle(sphere_x, sphere_y, 2)
        ctx.fill()
    }
    
    ctx.hex(colors.text)
    ctx.text("Bloch Sphere (Qubit 0)", x + width * 0.05, y + height * 0.1)
}

fn draw_gate_symbol(ctx, gate_name, qubit, x, y, size) {
    ctx.hex("#2a2a5a")
    ctx.rect(x - size/2, y - size/2, size, size)
    ctx.fill()
    
    ctx.hex(colors.primary)
    ctx.rect(x - size/2, y - size/2, size, size)
    ctx.stroke()
    
    ctx.hex(colors.text)
    ctx.text(gate_name, x - size*0.3, y + size * 0.15)
}

fn draw_controlled_gate(ctx, gate_name, control, target, x, y_base, size, qubit_spacing) {
    control_y := y_base + control * qubit_spacing
    target_y := y_base + target * qubit_spacing
    
    ctx.hex(colors.primary)
    ctx.circle(x, control_y, 4)
    ctx.fill()
    
    ctx.move_to(x, math.min(control_y, target_y))
    ctx.line_to(x, math.max(control_y, target_y))
    ctx.stroke()
    
    draw_gate_symbol(ctx, gate_name, target, x, target_y, size)
}

fn draw_quantum_circuit(ctx, history, x, y, width, height) {
    ctx.hex("#1e1e3f")
    ctx.rect(x, y, width, height)
    ctx.fill()
    
    ctx.hex(colors.text)
    ctx.text("Quantum Circuit", x + width * 0.05, y + height * 0.1)
    
    ctx.hex(colors.primary)
    ctx.linewidth(2)
    qubit_spacing := height * 0.5 / n_qubits
    start_y := y + height * 0.35
    
    for i := 0; i < n_qubits; i++ {
        line_y := start_y + i * qubit_spacing
        ctx.move_to(x + width * 0.1, line_y)
        ctx.line_to(x + width * 0.9, line_y)
        ctx.stroke()
        
        ctx.text(fmt.sprintf("q[%d]", i), x + width * 0.02, line_y + 5)
    }
    
    time_slots := math.max(8.0, math.floor((width * 0.8) / 50.0))
    slot_width := width * 0.8 / time_slots
    gate_size := math.min(slot_width * 0.7, qubit_spacing * 0.7)
    
    for i, gate_op in history {
        if i >= time_slots { break } // Only show recent fitting gates
        
        slot_x := x + width * 0.15 + i * slot_width
        
        if gate_op["type"] == "single" {
            draw_gate_symbol(ctx, gate_op.gate, gate_op.target, slot_x, start_y + gate_op.target * qubit_spacing, gate_size)
        }
        else if gate_op["type"] == "controlled" {
            draw_controlled_gate(ctx, gate_op.gate, gate_op.control, gate_op.target, slot_x, start_y, gate_size, qubit_spacing)
        }
    }
}

fn draw_gate_palette(ctx, gates, selected_gate, x, y, width, height) {
    ctx.hex("#1e1e3f")
    ctx.rect(x, y, width, height)
    ctx.fill()
    
    ctx.hex(colors.text)
    ctx.text("Quantum Gates", x + width * 0.05, y + height * 0.15)
    
    button_size := math.min(width * 0.12, height * 0.25)
    margin := math.min(15.0, width * 0.02)
    cols := 5
    
    for i, gate in gates {
        row := i / cols
        col := i % cols
        btn_x := x + margin + col * (button_size + margin)
        btn_y := y + height * 0.3 + row * (button_size + margin)
        
        if gate.name == selected_gate {
            ctx.hex(colors.accent)
        } else {
            ctx.hex("#2a2a5a")
        }
        ctx.rect(btn_x, btn_y, button_size, button_size)
        ctx.fill()
        
        ctx.hex(colors.primary)
        ctx.rect(btn_x, btn_y, button_size, button_size)
        ctx.stroke()
        
        ctx.hex(colors.text)
        ctx.text(gate.label, btn_x + button_size * 0.3, btn_y + button_size * 0.6)
    }
}

fn draw_measurement_stats(ctx, measurement_results, x, y, width, height) {
    ctx.hex("#1e1e3f")
    ctx.rect(x, y, width, height)
    ctx.fill()
    
    ctx.hex(colors.text)
    ctx.text("Measurement Results", x + width * 0.05, y + height * 0.1)
    
    if len(measurement_results) > 0 {
        total := len(measurement_results)
        counts := {}
        for result in measurement_results {
            counts[result] = (counts[result] || 0) + 1
        }
        
        max_count := 0
        for _, count in counts { max_count = math.max(max_count, count) }
        
        bar_width := (width * 0.8) / len(counts)
        i := 0
        for state_val, count in counts {
            bar_x := x + width * 0.1 + i * bar_width
            bar_height := (count / max_count) * (height * 0.6)
            
            ctx.hex(colors.bar2)
            ctx.rect(bar_x, y + height * 0.8 - bar_height, bar_width * 0.7, bar_height)
            ctx.fill()
            
            ctx.hex(colors.text)
            ctx.text(fmt.sprintf("%d", state_val), bar_x + (bar_width * 0.2), y + height * 0.9)
            ctx.text(fmt.sprintf("%.1f%%", (count/total)*100), bar_x + (bar_width * 0.1), y + height * 0.75 - bar_height)
            
            i += 1
        }
    } else {
        ctx.hex(colors.text)
        ctx.text("No measurements yet", x + width * 0.3, y + height * 0.5)
    }
}

fn draw_control_buttons(ctx, buttons, x, y, width, height) {
    for btn in buttons {
        ctx.hex(btn.color)
        ctx.rect(btn.x, y, btn.width, height)
        ctx.fill()
        
        ctx.hex(colors.text)
        ctx.text(btn.label, btn.x + btn.width * 0.2, y + height * 0.6)
    }
    
    ctx.hex(colors.text)
    ctx.text(fmt.sprintf("Qubits: %d | Gates Applied: %d", n_qubits, len(circuit_history)), x + width * 0.55, y + height * 0.6)
}

fn apply_quantum_gate(gate_name, target_qubit) {
    control_qubit := 0
    gate_op := { "type": "single", gate: gate_name, target: target_qubit, timestamp: times.now() }
    
    if gate_name == "H" {
        state = q.apply_single_qubit(q.hadamard(), state, n_qubits, target_qubit)
    }
    else if gate_name == "X" {
        state = q.apply_single_qubit(q.pauliX(), state, n_qubits, target_qubit)
    }
    else if gate_name == "Y" {
        state = q.apply_single_qubit(q.pauliY(), state, n_qubits, target_qubit)
    }
    else if gate_name == "Z" {
        state = q.apply_single_qubit(q.pauliZ(), state, n_qubits, target_qubit)
    }
    else if gate_name == "CNOT" {
        gate_op["type"] = "controlled"
        gate_op.control = control_qubit
        gate_op.target = target_qubit
        state = q.apply_cnot(state, n_qubits, control_qubit, target_qubit)
    }
    else if gate_name == "SWAP" {
        if n_qubits == 2 {
            state = q.apply_unitary(q.swap_2(), state)
        }
    }
    else if gate_name == "RX" {
        state = q.apply_single_qubit(q.rx(math.pi / 4), state, n_qubits, target_qubit)
    }
    else if gate_name == "RY" {
        state = q.apply_single_qubit(q.ry(math.pi / 4), state, n_qubits, target_qubit)
    }
    else if gate_name == "RZ" {
        state = q.apply_single_qubit(q.rz(math.pi / 4), state, n_qubits, target_qubit)
    }
    else if gate_name == "MEASURE" {
        result := q.sample_measure_with_r(state, rand.float())
        measurement_results = append(measurement_results, result.outcome)
        state = result.collapsed
        gate_op.measurement_result = result.outcome
    }
    
    circuit_history = append(circuit_history, gate_op)
}

fn handle_mouse_click(mx, my, w, h, selected_gate, show_probabilities, show_phases, scroll_y) {
    lay := get_layout(w, h)
    
    // Check Custom Scrollbar Click
    if lay.total_h > h && mx >= w - 16 {
        thumb_h := math.max(40.0, (h / lay.total_h) * h)
        new_sy := ((my - thumb_h/2.0) / (h - thumb_h)) * (lay.total_h - h)
        new_sy = math.max(0.0, math.min(lay.total_h - h, new_sy))
        return [selected_gate, show_probabilities, show_phases, new_sy]
    }

    // Offset mouse by scroll for content interaction
    my_sc := my + scroll_y

    // Palette Click
    palette_x := w * 0.02
    palette_y := lay.y3
    palette_width := w * 0.94
    palette_height := lay.pal_h
    
    if mx >= palette_x && mx <= palette_x + palette_width && my_sc >= palette_y && my_sc <= palette_y + palette_height {
        button_size := math.min(palette_width * 0.12, palette_height * 0.25)
        margin := math.min(15.0, palette_width * 0.02)
        cols := 5
        
        local_x := mx - palette_x - margin
        local_y := my_sc - palette_y - palette_height * 0.3
        
        if local_x >= 0 && local_y >= 0 {
            col := math.floor(local_x / (button_size + margin))
            row := math.floor(local_y / (button_size + margin))
            
            index := int(row * cols + col)
            gates := [
                {name: "H", label: "H"}, {name: "X", label: "X"}, {name: "Y", label: "Y"}, 
                {name: "Z", label: "Z"}, {name: "CNOT", label: "CX"}, {name: "SWAP", label: "SWAP"},
                {name: "RX", label: "RX"}, {name: "RY", label: "RY"}, {name: "RZ", label: "RZ"},
                {name: "MEASURE", label: "M"}
            ]
            
            if index >= 0 && index < len(gates) {
                selected_gate = gates[index].name
                
                if selected_gate == "CNOT" || selected_gate == "SWAP" {
                    apply_quantum_gate(selected_gate, 1)
                } else {
                    apply_quantum_gate(selected_gate, 0)
                }
            }
        }
    }
    
    // Control Buttons Click
    if my_sc >= lay.y4 && my_sc <= lay.y4 + lay.ctrl_h {
        button_width := w * 0.15
        
        if mx >= w * 0.02 && mx <= w * 0.02 + button_width {
            state = q.zero_state(n_qubits)
            circuit_history = []
            measurement_results = []
        }
        else if mx >= w * 0.20 && mx <= w * 0.20 + button_width {
            show_probabilities = !show_probabilities
        }
        else if mx >= w * 0.38 && mx <= w * 0.38 + button_width {
            show_phases = !show_phases
        }
    }
    
    return [selected_gate, show_probabilities, show_phases, scroll_y]
}

fn render(ctx, w, h, state, circuit_history, measurement_results, selected_gate, show_probabilities, show_phases, scroll_y) {
    draw_modern_background(ctx, w, h)
    lay := get_layout(w, h)
    sy := scroll_y
    
    draw_state_vector(ctx, state, w * 0.02, lay.y1 - sy, w * 0.46, lay.top_h)
    draw_bloch_sphere(ctx, state, w * 0.50, lay.y1 - sy, w * 0.46, lay.top_h)
    
    draw_quantum_circuit(ctx, circuit_history, w * 0.02, lay.y2 - sy, w * 0.46, lay.mid_h)
    draw_measurement_stats(ctx, measurement_results, w * 0.50, lay.y2 - sy, w * 0.46, lay.mid_h)
    
    gates := [
        {name: "H", label: "H"}, {name: "X", label: "X"}, {name: "Y", label: "Y"}, 
        {name: "Z", label: "Z"}, {name: "CNOT", label: "CX"}, {name: "SWAP", label: "SWAP"},
        {name: "RX", label: "RX"}, {name: "RY", label: "RY"}, {name: "RZ", label: "RZ"},
        {name: "MEASURE", label: "M"}
    ]
    draw_gate_palette(ctx, gates, selected_gate, w * 0.02, lay.y3 - sy, w * 0.94, lay.pal_h)
    
    buttons := [
        {x: w * 0.02, width: w * 0.15, label: "Reset", color: colors.secondary},
        {x: w * 0.20, width: w * 0.15, label: show_probabilities ? "Hide Probs" : "Show Probs", color: colors.primary},
        {x: w * 0.38, width: w * 0.15, label: show_phases ? "Hide Phases" : "Show Phases", color: colors.accent}
    ]
    draw_control_buttons(ctx, buttons, w * 0.02, lay.y4 - sy, w * 0.94, lay.ctrl_h)

    // Render Custom Scrollbar Track & Thumb
    if lay.total_h > h {
        track_w := 12.0
        track_x := w - track_w
        
        ctx.hex(colors.scrollbar)
        ctx.rect(track_x, 0, track_w, h)
        ctx.fill()
        
        thumb_h := math.max(40.0, (h / lay.total_h) * h)
        thumb_y := (sy / (lay.total_h - h)) * (h - thumb_h)
        
        ctx.hex(colors.primary)
        ctx.rect(track_x + 2, thumb_y, track_w - 4, thumb_h)
        ctx.fill()
    }
}

// Main window creation
canvas.new_window(w, h, "Quantum Playground", fn(window) {
    ctx := window.new_context(w, h)
    
    // UI state
    selected_gate := "H"
    show_probabilities := true
    show_phases := true
    scroll_y := 0.0
    
    render(ctx, w, h, state, circuit_history, measurement_results, selected_gate, show_probabilities, show_phases, scroll_y)
    window.update(w, h)
    
    for {
        e := window.next_event()
        
        if e["type"] == "size" {
            w = e.width_px 
            h = e.height_px
            ctx = window.new_context(w, h)
            
            // Re-clamp scroll if height grows
            lay := get_layout(w, h)
            max_scroll := math.max(0.0, lay.total_h - h)
            if scroll_y > max_scroll { scroll_y = max_scroll }
            
            render(ctx, w, h, state, circuit_history, measurement_results, selected_gate, show_probabilities, show_phases, scroll_y)
            window.update(w, h)
        }
        else if e["type"] == "mouse" && e.direction == 1 {
            Handle := handle_mouse_click(e.x, e.y, w, h, selected_gate, show_probabilities, show_phases, scroll_y)
            selected_gate = Handle[0] 
            show_probabilities = Handle[1] 
            show_phases = Handle[2]
            scroll_y = Handle[3]
            
            render(ctx, w, h, state, circuit_history, measurement_results, selected_gate, show_probabilities, show_phases, scroll_y)
            window.update(w, h)
        }
        else if e["type"] == "key" && e.direction == 1 {
            lay := get_layout(w, h)
            max_scroll := math.max(0.0, lay.total_h - h)
            
            // Arrow Keys for UI scrolling
            if e.code == 81 { scroll_y += 60.0 } // Down Arrow
            else if e.code == 82 { scroll_y -= 60.0 } // Up Arrow
            // Gate Shortcuts
            else if e.code == 11 { apply_quantum_gate("H", 0) }
            else if e.code == 27 { apply_quantum_gate("X", 0) }
            else if e.code == 28 { apply_quantum_gate("Y", 0) }
            else if e.code == 29 { apply_quantum_gate("Z", 0) }
            else if e.code == 6  { apply_quantum_gate("CNOT", 1) }
            else if e.code == 22 { apply_quantum_gate("SWAP", 1) }
            else if e.code == 16 { apply_quantum_gate("MEASURE", 0) }
            else if e.code == 21 {
                state = q.zero_state(n_qubits)
                circuit_history = []
                measurement_results = []
            }
            
            if scroll_y < 0.0 { scroll_y = 0.0 }
            if scroll_y > max_scroll { scroll_y = max_scroll }
            
            render(ctx, w, h, state, circuit_history, measurement_results, selected_gate, show_probabilities, show_phases, scroll_y)
            window.update(w, h)
        }
        else if e["type"] == "lifecycle" && e["from"] == 3 && e.to == 0 {
            break
        }
        
        times.sleep(16666666)  // ~60 FPS
    }
})