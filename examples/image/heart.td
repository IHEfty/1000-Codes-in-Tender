import "image"
import "times"
import "math"
import "rand"

start := times.now()
w, h := 800, 800
// Create a new image with dark background
img := image.new(w, h)

// Fill background with dark
for i := 0; i < w; i++ {
	for j := 0; j < h; j++ {
		r, g, b, a := 20, 10, 20, 255
		color := [r, g, b, a]
		img.set(i, j, color)
	}
}

// Heart equation: (x^2 + y^2 - 1)^3 - x^2 * y^3 <= 0
// Scale and center the heart
scale := 120.0
center_x := w / 2
center_y := h / 2

// Draw the filled heart
for i := 0; i < w; i++ {
	for j := 0; j < h; j++ {
		// Map pixel coordinates to mathematical coordinates
		x := (float(i) - float(center_x)) / scale
		y := -(float(j) - float(center_y)) / scale  // Flip y-axis
		
		// Heart equation
		x2 := x * x
		y2 := y * y
		heart := (x2 + y2 - 1.0) * (x2 + y2 - 1.0) * (x2 + y2 - 1.0) - x2 * y * y * y
		
		if heart <= 0.0 {
			// Inside the heart - red with gradient
			distance := math.sqrt(x2 + y2)
			r := 200 + int(55 * distance)
			g := 20 + int(30 * distance)
			b := 30 + int(40 * distance)
			
			if r > 255 { r = 255 }
			if g > 255 { g = 255 }
			if b > 255 { b = 255 }
			
			color := [r, g, b, 255]
			img.set(i, j, color)
		}
	}
}

// Draw heart border
for i := 0; i < w; i++ {
	for j := 0; j < h; j++ {
		x := (float(i) - float(center_x)) / scale
		y := -(float(j) - float(center_y)) / scale
		
		x2 := x * x
		y2 := y * y
		heart := (x2 + y2 - 1.0) * (x2 + y2 - 1.0) * (x2 + y2 - 1.0) - x2 * y * y * y
		
		// Check if near the border
		if heart <= 0.01 && heart >= -0.01 {
			color := [255, 200, 200, 255]
			img.set(i, j, color)
		}
	}
}

// Draw glow particles around the heart
for k := 0; k < 200; k++ {
	angle := rand.float() * 2 * math.pi
	radius := 0.8 + rand.float() * 0.4
	
	x := float(center_x) + radius * float(scale) * math.cos(angle) * 1.2
	y := float(center_y) + radius * float(scale) * math.sin(angle) * 1.2
	
	px := int(x)
	py := int(y)
	
	if px >= 0 && px < w && py >= 0 && py < h {
		alpha := 50 + int(rand.float() * 150)
		color := [255, 100, 100, alpha]
		img.set(px, py, color)
		
		// Add some sparkle
		for dx := -1; dx <= 1; dx++ {
			for dy := -1; dy <= 1; dy++ {
				spx := px + dx
				spy := py + dy
				if spx >= 0 && spx < w && spy >= 0 && spy < h {
					if rand.float() > 0.5 {
						img.set(spx, spy, [255, 150, 150, 100])
					}
				}
			}
		}
	}
}

img.save("heart.png", "png")

end := times.since(start)
println(end, "ms")
println(float(end)/times.second, "sec")