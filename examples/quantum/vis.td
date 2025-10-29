import "quantum" as q
import "canvas"
import "math"
import "times"
import "cmplx"

// Window size
w := 600
h := 400

// Initialize base state |0⟩
state := q.ket0()

// Create window and context
canvas.new_window(w, h, "Quantum State Visualizer", fn(window) {
	ctx := window.new_context(w, h)
	
	fn draw_background() {
		ctx.hex("#1e272e")
		ctx.rect(0, 0, w, h)
		ctx.fill()
	}

	//-------------------------------------------
	// Draw Bloch circle with current state vector
	//-------------------------------------------
	fn draw_bloch(psi) {
		draw_background()
		
		center_x := w / 2
		center_y := h / 2
		radius := 120

		// Draw circle (the Bloch sphere equator)
		ctx.hex("#95a5a6")
		ctx.circle(center_x, center_y, radius)
		ctx.stroke()

		// Compute Bloch coordinates from qubit amplitudes
		alpha := psi[0]
		beta := psi[1]
		θ := 2 * math.acos(cmplx.abs(alpha))
		φ := math.atan2(beta.imag, beta.real) - math.atan2(alpha.imag, alpha.real)

		// 2D projection of Bloch vector (x = sinθ cosφ, y = sinθ sinφ)
		x := radius * math.sin(θ) * math.cos(φ)
		y := -radius * math.sin(θ) * math.sin(φ)

		// Draw Bloch vector
		ctx.hex("#00cec9")
		ctx.linewidth(3)
		ctx.move_to(center_x, center_y)
		ctx.line_to(center_x + x, center_y + y)
		ctx.stroke()

		// Draw probability bars for |0⟩ and |1⟩
		probs := q.probs_from_state(psi)
		bar_w := 200
		bar_h := 20
		x0 := (w - bar_w) / 2

		ctx.hex("#74b9ff")
		ctx.rect(x0, h - 80, bar_w * probs[0], bar_h)
		ctx.fill()
		ctx.hex("#0984e3")
		ctx.text("|0⟩: " + (probs[0]*100) + "%", x0, h - 90)

		ctx.hex("#fab1a0")
		ctx.rect(x0, h - 50, bar_w * probs[1], bar_h)
		ctx.fill()
		ctx.hex("#d63031")
		ctx.text("|1⟩: " + (probs[1]*100) + "%", x0, h - 60)

		window.update(w, h)
	}

	//-------------------------------------------
	// Animate applying a unitary transformation
	//-------------------------------------------
	fn animate_gate(U, steps) {
		for s in range(1, steps+1) {
			// Partial interpolation: simulate smooth rotation
			t := s / steps
			// Linear blend approximation of state change
			tmp := q.apply_unitary(U, state)
			state = [
				q.normalize([
					complex((1-t)*state[0].real + t*tmp[0].real, (1-t)*state[0].imag + t*tmp[0].imag),
					complex((1-t)*state[1].real + t*tmp[1].real, (1-t)*state[1].imag + t*tmp[1].imag)
				])[0],
				q.normalize([
					complex((1-t)*state[0].real + t*tmp[0].real, (1-t)*state[0].imag + t*tmp[0].imag),
					complex((1-t)*state[1].real + t*tmp[1].real, (1-t)*state[1].imag + t*tmp[1].imag)
				])[1]
			]
			draw_bloch(state)
			times.sleep(40000000) // ~40ms per frame
		}
	}

	//-------------------------------------------
	// Simulation sequence
	//-------------------------------------------
	draw_bloch(state)
	times.sleep(500000000)

	// Apply Hadamard gate
	println("Applying Hadamard gate...")
	Uh := q.hadamard()
	animate_gate(Uh, 10)

	times.sleep(500000000)

	// Apply Pauli-X gate
	println("Applying Pauli-X gate...")
	Ux := q.pauliX()
	animate_gate(Ux, 10)

	times.sleep(500000000)

	// Apply rotation around Y-axis (π/3)
	println("Applying RY(π/3) rotation...")
	Uy := q.ry(math.pi / 3)
	animate_gate(Uy, 10)

	times.sleep(1000000000)

	//-------------------------------------------
	// Measure final state
	//-------------------------------------------
	r := 0.42
	m := q.sample_measure_with_r(state, r)
	println("Measured outcome:", m.outcome)
	state = m.collapsed
	draw_bloch(state)

	//-------------------------------------------
	// Keep window open
	//-------------------------------------------
	for {
		e := window.next_event()
		if e.type == "lifecycle" && e.from == 3 && e.to == 0 {
			break
		}
	}
})
