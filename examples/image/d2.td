import "image"
import "times"
import "math"
import "rand"

start := times.now()
w, h := 600, 600
img := image.new(w, h)

// Background gradient (hellfire)
for i := 0; i < w; i++ {
	for j := 0; j < h; j++ {
		r := 30 + int(float(j) * 0.3)
		g := 10 + int(float(j) * 0.1)
		b := 5 + int(float(j) * 0.05)
		
		if r > 255 { r = 255 }
		if g > 255 { g = 255 }
		if b > 255 { b = 255 }
		
		color := [r, g, b, 255]
		img.set(i, j, color)
	}
}

// D equation: y = -|x|^0.7 + 0.5 * sqrt(1 - x^2) (modified)
// This creates a shape with horns
scale := 100.0
center_x := w / 2
center_y := h / 2

for i := 0; i < w; i++ {
	x := (float(i) - float(center_x)) / scale
	
	// D horn equation
	if math.abs(x) <= 1.2 {
		// Main body with horns
		y1 := -math.pow(math.abs(x), 0.6) + 0.3 * math.sqrt(1.0 - x*x)
		y2 := -math.pow(math.abs(x), 0.4) + 0.4 * math.sqrt(1.0 - x*x)
		
		// Multiple y values for thickness
		for dy := -0.02; dy <= 0.02; dy += 0.005 {
			for y_val in [y1, y2] {
				py := center_y - int((y_val + dy) * scale)
				
				if py >= 0 && py < h {
					// Inner glow
					if math.abs(x) < 0.3 {
						color := [255, 50, 50, 255]
						img.set(i, py, color)
					} else {
						// Horn gradient
						gradient := 1.0 - math.abs(x)
						r := 200 + int(55 * gradient)
						g := 20 + int(30 * gradient)
						b := 10 + int(20 * gradient)
						
						if r > 255 { r = 255 }
						color := [r, g, b, 255]
						img.set(i, py, color)
					}
				}
			}
		}
		
		// Highlight border
		for dy := -0.01; dy <= 0.01; dy += 0.005 {
			py := center_y - int((y1 + dy) * scale)
			if py >= 0 && py < h {
				color := [255, 100, 50, 200]
				img.set(i, py, color)
			}
		}
	}
}

// Add fire particles
for k := 0; k < 500; k++ {
	angle := rand.float() * 2 * math.pi
	radius := 0.3 + rand.float() * 0.8
	
	px := center_x + int(radius * float(scale) * math.cos(angle))
	py := center_y + int(radius * float(scale) * math.sin(angle)) - 50
	
	if px >= 0 && px < w && py >= 0 && py < h {
		alpha := 50 + int(rand.float() * 150)
		r := 255
		g := 50 + int(rand.float() * 100)
		b := 0
		color := [r, g, b, alpha]
		img.set(px, py, color)
	}
}

img.save("D_horns.png", "png")

end := times.since(start)
println(end, "ms")
println(float(end)/times.second, "sec")