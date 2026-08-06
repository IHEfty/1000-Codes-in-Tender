import "image"
import "times"
import "math"
import "rand"

start := times.now()
w, h := 600, 600
img := image.new(w, h)

// Background gradient
for i := 0; i < w; i++ {
	for j := 0; j < h; j++ {
		// Radial gradient background
		cx := float(w) / 2
		cy := float(h) / 2
		dist := math.sqrt(float(i*i) + float(j*j)) / 400.0
		
		r := 10 + int(20 * dist)
		g := 5 + int(10 * dist)
		b := 15 + int(25 * dist)
		
		if r > 255 { r = 255 }
		if g > 255 { g = 255 }
		if b > 255 { b = 255 }
		
		color := [r, g, b, 255]
		img.set(i, j, color)
	}
}

// Parametric heart: x = 16 sin^3(t), y = 13cos(t) - 5cos(2t) - 2cos(3t) - cos(4t)
scale := 14.0
center_x := w / 2
center_y := h / 2

// Draw heart outline (parametric)
for t := 0.0; t < 2 * math.pi; t += 0.001 {
	// Heart parametric equations
	x := 16.0 * math.pow(math.sin(t), 3.0)
	y := 13.0 * math.cos(t) - 5.0 * math.cos(2.0*t) - 2.0 * math.cos(3.0*t) - math.cos(4.0*t)
	
	px := center_x + int(x * scale / 16.0)
	py := center_y - int(y * scale / 16.0)
	
	if px >= 0 && px < w && py >= 0 && py < h {
		// Main heart line
		color := [255, 50, 50, 255]
		img.set(px, py, color)
		
		// Thicker line
		for dx := -1; dx <= 1; dx++ {
			for dy := -1; dy <= 1; dy++ {
				nx := px + dx
				ny := py + dy
				if nx >= 0 && nx < w && ny >= 0 && ny < h {
					if dx == 0 && dy == 0 {
						continue
					}
					img.set(nx, ny, [255, 30, 30, 180])
				}
			}
		}
	}
}

// Fill the heart with color
for i := 0; i < w; i++ {
	for j := 0; j < h; j++ {
		// Check if point is inside parametric heart
		// Using ray casting or point-in-polygon
		inside := false
		
		// Simple approximation: check multiple angles
		for angle := 0.0; angle < 2 * math.pi; angle += 0.1 {
			// Parametric point at this angle
			t := angle
			hx := 16.0 * math.pow(math.sin(t), 3.0)
			hy := 13.0 * math.cos(t) - 5.0 * math.cos(2.0*t) - 2.0 * math.cos(3.0*t) - math.cos(4.0*t)
			
			px := center_x + int(hx * scale / 16.0)
			py := center_y - int(hy * scale / 16.0)
			
			// Check distance from point to parametric point
			dist := math.sqrt(float((i-px)*(i-px) + (j-py)*(j-py)))
			if dist < 2.0 {
				inside = true
				break
			}
		}
		
		if inside {
			// Gradient inside heart
			dist_from_center := math.sqrt(float((i-center_x)*(i-center_x) + (j-center_y)*(j-center_y)))
			gradient := 1.0 - dist_from_center / 150.0
			if gradient < 0.3 { gradient = 0.3 }
			
			r := int(200 * gradient) + 55
			g := int(20 * gradient) + 10
			b := int(30 * gradient) + 15
			
			if r > 255 { r = 255 }
			
			color := [r, g, b, 255]
			img.set(i, j, color)
		}
	}
}

// Add sparkles
for k := 0; k < 100; k++ {
	angle := rand.float() * 2 * math.pi
	t := angle
	hx := 16.0 * math.pow(math.sin(t), 3.0)
	hy := 13.0 * math.cos(t) - 5.0 * math.cos(2.0*t) - 2.0 * math.cos(3.0*t) - math.cos(4.0*t)
	
	// Random offset from heart surface
	offset := 5 + int(rand.float() * 20)
	px := center_x + int(hx * scale / 16.0) + offset * int(math.cos(angle))
	py := center_y - int(hy * scale / 16.0) + offset * int(math.sin(angle))
	
	if px >= 0 && px < w && py >= 0 && py < h {
		alpha := 100 + int(rand.float() * 155)
		color := [255, 200, 200, alpha]
		img.set(px, py, color)
	}
}

img.save("parametric_heart.png", "png")

end := times.since(start)
println(end, "ms")
println(float(end)/times.second, "sec")