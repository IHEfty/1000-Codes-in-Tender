math := import("math")
strings := import("strings")

draw := fn(A, B) {
	b := []
	z := []

	// Pre-fill the buffer with spaces and depth values
	for k := 0; k < 1760; k++ {
		if k % 80 == 79 {
			b = append(b, "\n")
		} else {
			b = append(b, " ")
		}
		z = append(z, 0)
	}

	j := 0.0
	
	// Loop through theta
	for j < 6.28 {
		ct := math.cos(j) // cos(theta)
		st := math.sin(j) // sin(theta)
		i := 0.0 
		
		// Loop through phi
		for i < 6.28 {
			sp := math.sin(i) // sin(phi)
			cp := math.cos(i) // cos(phi)
			h := ct + 2 // R1 + R2*cos(theta)
			D := 1 / (sp * h * A + st * B + 5) // this is 1/z
			t := sp * h * A - st * st // clever factoring for x' and y'

			// Calculate screen coordinates
			x := int(40 + 30 * D * (cp * h * B - t * A))
			y := int(12 + 15 * D * (cp * h * A + t * B))
			o := int(x + 80 * y)
			N := int( 8 * ((st * A - sp * ct * B) * A - sp * ct * A - st * B - cp * ct * B))

			// Update the buffer and depth values
			if (y < 22 && y >= 0 && x >= 0 && x < 79 && D > z[o]) {
				z[o] = D
				if N > 0 {
					b[o] = ".,_-~:=!*#$@"[N]
				} else {
					b[o] = "."
				}
			}
			i += 0.07 // Increment i
		}
		j += 0.02 // Increment j
	}

	// Print the donut shape
	println(strings.join(b, ""))
}

A := 1.0
B := 1.0

// Main loop to continuously draw the donut
for {
	A += 0.07 // Increment A for rotation
	B += 0.03 // Increment B for rotation
	draw(A, B) // Draw the donut
}
