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

fn draw_modern_background(ctx, w, h) {
    // Gradient background
    ctx.hex(colors.background)
    ctx.rect(0, 0, w, h)
    ctx.fill()
    
    // Grid pattern
    ctx.hex(colors.grid)
    ctx.linewidth(0.5)
    grid_size := math.max(20, math.min(w, h) / 30)
    for x := 0; x < w; x += grid_size {
        ctx.move_to(x, 0)
        ctx.line_to(x, h)
    }
    for y := 0; y < h; y += grid_size {
        ctx.move_to(0, y)
        ctx.line_to(w, y)
    }
    ctx.stroke()
}

fn draw_state_vector(ctx, state, x, y, width, height) {
    // Draw the state vector visualization with modern design
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
        phase := math.atan2(state[i].imag, state[i].real)
        
        // Probability bar
        ctx.hex(colors.bar1)
        bar_height := prob * max_height
        ctx.rect(bar_x, y + height * 0.8 - bar_height, bar_width * 0.9, bar_height)
        ctx.fill()
        
        // Phase indicator
        ctx.rect(bar_x, y + height * 0.85, bar_width * 0.9, height * 0.02)
        ctx.fill()
        
        // State label
        ctx.hex(colors.text)
        label := fmt.sprintf("|%0%db>", n, i)
        ctx.text(label, bar_x, y + height * 0.95)
        
        // Probability text
        ctx.text(fmt.sprintf("%.1f%%", prob * 100), bar_x, y + height * 0.75 - bar_height)
    }
}

fn draw_bloch_sphere(ctx, state, x, y, width, height) {
    // Modern Bloch sphere visualization
    size := math.min(width, height)
    center_x := x + width/2
    center_y := y + height/2
    radius := size * 0.4
    
    // Sphere background
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
    
    // Calculate Bloch vector from state
    if len(state) == 2 {
        alpha := state[0]
        beta := state[1]
        
        // Bloch coordinates
        x_val := 2 * (alpha.real * beta.real + alpha.imag * beta.imag)
        y_val := 2 * (alpha.imag * beta.real - alpha.real * beta.imag)
        z_val := alpha.real * alpha.real + alpha.imag * alpha.imag - beta.real * beta.real - beta.imag * beta.imag
        
        // Convert to sphere coordinates
        sphere_x := center_x + x_val * radius * 0.8
        sphere_y := center_y + y_val * radius * 0.8
        
        // Draw state vector
        ctx.hex(colors.accent)
        ctx.linewidth(3)
        ctx.move_to(center_x, center_y)
        ctx.line_to(sphere_x, sphere_y)
        ctx.stroke()
        
        // Draw state point
        ctx.hex("#ff2a6d")
        ctx.circle(sphere_x, sphere_y, 6)
        ctx.fill()
        ctx.hex("#ffffff")
        ctx.circle(sphere_x, sphere_y, 2)
        ctx.fill()
    }
    
    // Title
    ctx.hex(colors.text)
    ctx.text("Bloch Sphere", x + width * 0.05, y + height * 0.1)
}

fn draw_gate_symbol(ctx, gate_name, qubit, x, y, size) {
    ctx.hex("#2a2a5a")
    ctx.rect(x - size/2, y - size/2, size, size)
    ctx.fill()
    
    ctx.hex(colors.primary)
    ctx.rect(x - size/2, y - size/2, size, size)
    ctx.stroke()
    
    ctx.hex(colors.text)
    //ctx.text_align("center")
    ctx.text(gate_name, x, y + size * 0.1)
    //ctx.text_align("left")
}

fn draw_controlled_gate(ctx, gate_name, control, target, x, y_base, size, qubit_spacing) {
    control_y := y_base + control * qubit_spacing
    target_y := y_base + target * qubit_spacing
    
    // Control dot
    ctx.hex(colors.primary)
    ctx.circle(x, control_y, 4)
    ctx.fill()
    
    // Vertical line
    ctx.move_to(x, math.min(control_y, target_y))
    ctx.line_to(x, math.max(control_y, target_y))
    ctx.stroke()
    
    // Target gate
    draw_gate_symbol(ctx, gate_name, target, x, target_y, size)
}

fn draw_quantum_circuit(ctx, history, x, y, width, height) {
    // Draw quantum circuit diagram
    ctx.hex("#1e1e3f")
    ctx.rect(x, y, width, height)
    ctx.fill()
    
    ctx.hex(colors.text)
    ctx.text("Quantum Circuit", x + width * 0.05, y + height * 0.1)
    
    // Draw qubit lines
    ctx.hex(colors.primary)
    ctx.linewidth(2)
    qubit_spacing := height * 0.6 / n_qubits
    start_y := y + height * 0.3
    
    for i := 0; i < n_qubits; i++ {
        line_y := start_y + i * qubit_spacing
        ctx.move_to(x + width * 0.1, line_y)
        ctx.line_to(x + width * 0.9, line_y)
        ctx.stroke()
        
        // Qubit labels
        ctx.text(fmt.sprintf("q[%d]", i), x + width * 0.02, line_y + height * 0.02)
    }
    
    // Draw gates
    time_slots := 8
    slot_width := width * 0.8 / time_slots
    gate_size := math.min(slot_width * 0.8, qubit_spacing * 0.8)
    
    for i, gate_op in history {
        if i >= time_slots { break }
        
        slot_x := x + width * 0.1 + i * slot_width
        
        if gate_op.type == "single" {
            draw_gate_symbol(ctx, gate_op.gate, gate_op.target, slot_x, start_y + gate_op.target * qubit_spacing, gate_size)
        }
        else if gate_op.type == "controlled" {
            draw_controlled_gate(ctx, gate_op.gate, gate_op.control, gate_op.target, slot_x, start_y, gate_size, qubit_spacing)
        }
    }
}

fn draw_gate_palette(ctx, gates, selected_gate, x, y, width, height) {
    // Gate selection palette
    ctx.hex("#1e1e3f")
    ctx.rect(x, y, width, height)
    ctx.fill()
    
    ctx.hex(colors.text)
    ctx.text("Quantum Gates", x + width * 0.05, y + height * 0.1)
    
    // Draw gate buttons
    button_size := math.min(width * 0.15, height * 0.3)
    margin := math.min(10, width * 0.02)
    cols := 5
    rows := 2
    
    for i, gate in gates {
        row := i / cols
        col := i % cols
        btn_x := x + margin + col * (button_size + margin)
        btn_y := y + height * 0.2 + row * (button_size + margin)
        
        // Button background
        if gate.name == selected_gate {
            ctx.hex(colors.accent)
        } else {
            ctx.hex("#2a2a5a")
        }
        ctx.rect(btn_x, btn_y, button_size, button_size)
        ctx.fill()
        
        // Button border
        ctx.hex(colors.primary)
        ctx.rect(btn_x, btn_y, button_size, button_size)
        ctx.stroke()
        
        // Gate label
        ctx.hex(colors.text)
        //ctx.text_align("center")
        ctx.text(gate.label, btn_x + button_size/2, btn_y + button_size/2)
        //ctx.text_align("left")
    }
}

fn draw_measurement_stats(ctx, measurement_results, x, y, width, height) {
    ctx.hex("#1e1e3f")
    ctx.rect(x, y, width, height)
    ctx.fill()
    
    ctx.hex(colors.text)
    ctx.text("Measurement Results", x + width * 0.05, y + height * 0.1)
    
    if len(measurement_results) > 0 {
        // Calculate statistics
        total := len(measurement_results)
        counts := {}
        for result in measurement_results {
            counts[result] = (counts[result] || 0) + 1
        }
        
        // Draw histogram
        max_count := 0
        for _, count in counts { max_count = math.max(max_count, count) }
        
        bar_width := (width * 0.8) / len(counts)
        i := 0
        for state_val, count in counts {
            bar_x := x + width * 0.1 + i * bar_width
            bar_height := (count / max_count) * (height * 0.6)
            
            ctx.hex(colors.bar1)
            ctx.rect(bar_x, y + height * 0.7 - bar_height, bar_width * 0.8, bar_height)
            ctx.fill()
            
            ctx.hex(colors.text)
            //ctx.text_align("center")
            ctx.text(state_val, bar_x + (bar_width * 0.8)/2, y + height * 0.85)
            ctx.text(fmt.sprintf("%.1f%%", (count/total)*100), bar_x + (bar_width * 0.8)/2, y + height * 0.65 - bar_height)
            //ctx.text_align("left")
            
            i += 1
        }
    } else {
        ctx.hex(colors.text)
        ctx.text("No measurements yet", x + width * 0.3, y + height * 0.5)
    }
}

fn draw_control_buttons(ctx, buttons, w, h) {
    button_height := h * 0.06
    button_y := h * 0.9
    
    for btn in buttons {
        ctx.hex(btn.color)
        ctx.rect(btn.x, button_y, btn.width, button_height)
        ctx.fill()
        
        ctx.hex(colors.text)
        //ctx.text_align("center")
        ctx.text(btn.label, btn.x + btn.width/2, button_y + button_height/2)
        //ctx.text_align("left")
    }
    
    // Current state info
    ctx.hex(colors.text)
    ctx.text(fmt.sprintf("Qubits: %d | Gates Applied: %d", n_qubits, len(circuit_history)), w * 0.6, button_y + button_height/2)
}

fn apply_quantum_gate(gate_name, target_qubit) {
    control_qubit := 0
    
    gate_op := {
        type: "single",
        gate: gate_name,
        target: target_qubit,
        timestamp: times.now()
    }
    
    if gate_name == "H" {
        G := q.hadamard()
        state = q.apply_single_qubit(G, state, n_qubits, target_qubit)
    }
    else if gate_name == "X" {
        G := q.pauliX()
        state = q.apply_single_qubit(G, state, n_qubits, target_qubit)
    }
    else if gate_name == "Y" {
        G := q.pauliY()
        state = q.apply_single_qubit(G, state, n_qubits, target_qubit)
    }
    else if gate_name == "Z" {
        G := q.pauliZ()
        state = q.apply_single_qubit(G, state, n_qubits, target_qubit)
    }
    else if gate_name == "CNOT" {
        gate_op.type = "controlled"
        gate_op.control = control_qubit
        gate_op.target = target_qubit
        state = q.apply_cnot(state, n_qubits, control_qubit, target_qubit)
    }
    else if gate_name == "SWAP" {
        if n_qubits == 2 {
            G := q.swap_2()
            state = q.apply_unitary(G, state)
        }
    }
    else if gate_name == "RX" {
        G := q.rx(math.pi / 4)
        state = q.apply_single_qubit(G, state, n_qubits, target_qubit)
    }
    else if gate_name == "RY" {
        G := q.ry(math.pi / 4)
        state = q.apply_single_qubit(G, state, n_qubits, target_qubit)
    }
    else if gate_name == "RZ" {
        G := q.rz(math.pi / 4)
        state = q.apply_single_qubit(G, state, n_qubits, target_qubit)
    }
    else if gate_name == "MEASURE" {
        r := rand.float()
        result := q.sample_measure_with_r(state, r)
        measurement_results = append(measurement_results, result.outcome)
        state = result.collapsed
        gate_op.measurement_result = result.outcome
    }
    
    circuit_history = append(circuit_history, gate_op)
}

fn handle_mouse_click(mx, my, w, h, selected_gate, show_probabilities, show_phases) {
    // Check gate palette clicks
    palette_x := w * 0.02
    palette_y := h * 0.7
    palette_width := w * 0.96
    palette_height := h * 0.25
    
    if mx >= palette_x && mx <= palette_x + palette_width &&
       my >= palette_y && my <= palette_y + palette_height {
        
        button_size := math.min(w * 0.12, h * 0.15)
        margin := math.min(10, w * 0.015)
        cols := 5
        
        local_x := mx - palette_x - w * 0.03
        local_y := my - palette_y - h * 0.15
        
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
    
    // Check control buttons
    button_y := h * 0.83
    button_height := h * 0.06
    
    if my >= button_y && my <= button_y + button_height {
        button_width := w * 0.15
        
        // Reset button
        if mx >= w * 0.02 && mx <= w * 0.02 + button_width {
            state = q.zero_state(n_qubits)
            circuit_history = []
            measurement_results = []
        }
        // Show/hide probabilities
        else if mx >= w * 0.20 && mx <= w * 0.20 + button_width {
            show_probabilities = !show_probabilities
        }
        // Show/hide phases
        else if mx >= w * 0.38 && mx <= w * 0.38 + button_width {
            show_phases = !show_phases
        }
    }
    
    return [selected_gate, show_probabilities, show_phases]
}

fn render(ctx, w, h, state, circuit_history, measurement_results, selected_gate, show_probabilities, show_phases) {
    draw_modern_background(ctx, w, h)
    
    // Calculate responsive layout
    top_section_height := h * 0.3
    middle_section_height := h * 0.3
    control_height := h * 0.06
    palette_height := h * 0.25
    
    // Draw all UI components
    draw_state_vector(ctx, state, w * 0.01, h * 0.02, w * 0.48, top_section_height)
    draw_bloch_sphere(ctx, state, w * 0.51, h * 0.02, w * 0.48, top_section_height)
    draw_quantum_circuit(ctx, circuit_history, w * 0.01, h * 0.34, w * 0.48, middle_section_height)
    draw_measurement_stats(ctx, measurement_results, w * 0.51, h * 0.34, w * 0.48, middle_section_height)
    
    gates := [
        {name: "H", label: "H"}, {name: "X", label: "X"}, {name: "Y", label: "Y"}, 
        {name: "Z", label: "Z"}, {name: "CNOT", label: "CX"}, {name: "SWAP", label: "SWAP"},
        {name: "RX", label: "RX"}, {name: "RY", label: "RY"}, {name: "RZ", label: "RZ"},
        {name: "MEASURE", label: "M"}
    ]
    draw_gate_palette(ctx, gates, selected_gate, w * 0.02, h * 0.70, w * 0.96, palette_height)
    
    // Draw control buttons
    buttons := [
        {x: w * 0.02, width: w * 0.15, label: "Reset", color: colors.secondary},
        {x: w * 0.20, width: w * 0.15, label: show_probabilities ? "Hide Probs" : "Show Probs", color: colors.primary},
        {x: w * 0.38, width: w * 0.15, label: show_phases ? "Hide Phases" : "Show Phases", color: colors.accent}
    ]
    draw_control_buttons(ctx, buttons, w, h)
}

// Main window creation
canvas.new_window(w, h, "Quantum Playground", fn(window) {
    ctx := window.new_context(w, h)
    
    // UI state
    selected_gate := "H"
    show_probabilities := true
    show_phases := true
    
    // Initial render
    render(ctx, w, h, state, circuit_history, measurement_results, selected_gate, show_probabilities, show_phases)
    window.update(w, h)
    
    // Event loop
    for {
        e := window.next_event()
        if e.type == "size" {
            w = e.width_px 
            h = e.height_px
            ctx = window.new_context(w, h)
            render(ctx, w, h, state, circuit_history, measurement_results, selected_gate, show_probabilities, show_phases)
            window.update(w, h)
        }
        else if e.type == "mouse" && e.direction == 1 {
            Handle := handle_mouse_click(e.x, e.y, w, h, selected_gate, show_probabilities, show_phases)
			// debug(h)
			selected_gate := Handle[0] 
			show_probabilities := Handle[1] 
			show_phases := Handle[2]
            render(ctx, w, h, state, circuit_history, measurement_results, selected_gate, show_probabilities, show_phases)
            window.update(w, h)
        }
        else if e.type == "key" && e.direction == 1 {
            // Quick gate shortcuts 
			// debug(e)
            if e.code == 11 { apply_quantum_gate("H", 0) }
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
            render(ctx, w, h, state, circuit_history, measurement_results, selected_gate, show_probabilities, show_phases)
            window.update(w, h)
        }
        else if e.type == "lifecycle" && e.from == 3 && e.to == 0 {
            break
        }
        
        times.sleep(16666666)  // ~60 FPS
    }
})