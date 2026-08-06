import "image"
import "times"
import "math"
import "rand"

start := times.now()
w, h := 400, 400
// Create a new image with dark background
img := image.new(w, h)

// Fill background with dark red/black
for i := 0; i < w; i++ {
	for j := 0; j < h; j++ {
		r, g, b, a := 15, 5, 10, 255
		color := [r, g, b, a]
		img.set(i, j, color)
	}
}

// D equation: (x^2 + y^2 - 1)^3 + x^2 * y^3 = 0 (variation of heart)
// Modified to look like D horns
scale := 150.0
center_x := w / 2
center_y := h / 2

// Draw the D symbol
for i := 0; i < w; i++ {
	for j := 0; j < h; j++ {
		// Map pixel coordinates to mathematical coordinates
		x := (float(i) - float(center_x)) / scale
		y := -(float(j) - float(center_y)) / scale
		
		// D equation: multiple components
		x2 := x * x
		y2 := y * y
		
		// Main body (inverted heart)
		body := (x2 + y2 - 0.8) * (x2 + y2 - 0.8) * (x2 + y2 - 0.8) - x2 * y * y * y * 1.2
		
		// Horns (parabolic shapes)
		horn1 := y - 2.0 * (x + 0.5) * (x + 0.5) + 0.3
		horn2 := y - 2.0 * (x - 0.5) * (x - 0.5) + 0.3
		
		// Tail (spiral)
		tail_radius := math.sqrt(x2 + y2)
		tail_angle := math.atan2(y, x)
		tail := tail_radius - 0.5 - 0.3 * math.sin(tail_angle * 3.0)
		
		// Combine D features
		D := body
		
		// Add horns (points above the body)
		if y > 0.3 && (horn1 < 0.05 || horn2 < 0.05) {
			D = -0.5
		}
		
		// Add tail
		if x < -0.3 && tail < 0.05 && tail > -0.05 {
			D = -0.5
		}
		
		// Check if inside D shape
		if D <= 0.0 {
			// Inside the D - red/orange with gradient
			distance := math.sqrt(x2 + y2)
			r := 180 + int(75 * distance)
			g := 30 + int(40 * distance)
			b := 10 + int(20 * distance)
			
			if r > 255 { r = 255 }
			if g > 255 { g = 255 }
			if b > 255 { b = 255 }
			
			color := [r, g, b, 255]
			img.set(i, j, color)
		}
		
		// Highlight D border
		if D <= 0.02 && D >= -0.02 {
			color := [255, 100, 50, 255]
			img.set(i, j, color)
		}
	}
}

// Draw pentagram (D star)
star_radius := 85.0
for i := 0; i < 5; i++ {
	angle1 := float(i) * 2.0 * math.pi / 5.0 - math.pi / 2.0
	angle2 := float(i+1) * 2.0 * math.pi / 5.0 - math.pi / 2.0
	
	// Outer points
	x1 := center_x + int(star_radius * math.cos(angle1))
	y1 := center_y + int(star_radius * math.sin(angle1))
	
	// Inner points (connect to next outer)
	angle_mid := (angle1 + angle2) / 2.0
	x_mid := center_x + int(star_radius * 0.4 * math.cos(angle_mid))
	y_mid := center_y + int(star_radius * 0.4 * math.sin(angle_mid))
	
	// Draw pentagram lines
	for t := 0.0; t <= 1.0; t += 0.01 {
		// Line from outer to inner
		px := int(float(x1) * (1.0 - t) + float(x_mid) * t)
		py := int(float(y1) * (1.0 - t) + float(y_mid) * t)
		
		if px >= 0 && px < w && py >= 0 && py < h {
			color := [200, 50, 50, 200]
			img.set(px, py, color)
			
			// Make line thicker
			for dx := -1; dx <= 1; dx++ {
				for dy := -1; dy <= 1; dy++ {
					nx := px + dx
					ny := py + dy
					if nx >= 0 && nx < w && ny >= 0 && ny < h {
						img.set(nx, ny, [180, 40, 40, 150])
					}
				}
			}
		}
	}
}

// Draw flames/aura around the D
for k := 0; k < 300; k++ {
	angle := rand.float() * 2 * math.pi
	radius := 0.7 + rand.float() * 0.5
	
	x := float(center_x) + radius * float(scale) * math.cos(angle) * 1.2
	y := float(center_y) + radius * float(scale) * math.sin(angle) * 1.2
	
	px := int(x)
	py := int(y)
	
	if px >= 0 && px < w && py >= 0 && py < h {
		alpha := 30 + int(rand.float() * 120)
		r := 255
		g := 50 + int(rand.float() * 100)
		b := 10 + int(rand.float() * 30)
		color := [r, g, b, alpha]
		img.set(px, py, color)
		
		// Add flickering effect
		for dx := -2; dx <= 2; dx++ {
			for dy := -2; dy <= 2; dy++ {
				spx := px + dx
				spy := py + dy
				if spx >= 0 && spx < w && spy >= 0 && spy < h {
					if rand.float() > 0.7 {
						img.set(spx, spy, [255, 100, 50, 80])
					}
				}
			}
		}
	}
}

// Add evil eyes
eye_radius := 15.0
eye_y_offset := -30.0

// Left eye
eye1_x := center_x - 40
eye1_y := center_y - 80

// Right eye
eye2_x := center_x + 40
eye2_y := center_y - 80

// Draw eyes
for i := -eye_radius; i <= eye_radius; i++ {
	for j := -eye_radius; j <= eye_radius; j++ {
		// Left eye
		dx := float(i)
		dy := float(j)
		if dx*dx + dy*dy <= eye_radius*eye_radius {
			px := eye1_x + int(dx)
			py := eye1_y + int(dy)
			if px >= 0 && px < w && py >= 0 && py < h {
				// Red eye glow
				color := [255, 0, 0, 255]
				img.set(px, py, color)
				
				// Pupil (black)
				if dx*dx + dy*dy <= (eye_radius/2)*(eye_radius/2) {
					img.set(px, py, [0, 0, 0, 255])
				}
				
				// Glow effect
				if dx*dx + dy*dy <= eye_radius*eye_radius && dx*dx + dy*dy > (eye_radius/1.5)*(eye_radius/1.5) {
					img.set(px, py, [255, 100, 100, 200])
				}
			}
		}
		
		// Right eye
		dx = float(i)
		dy = float(j)
		if dx*dx + dy*dy <= eye_radius*eye_radius {
			px := eye2_x + int(dx)
			py := eye2_y + int(dy)
			if px >= 0 && px < w && py >= 0 && py < h {
				color := [255, 0, 0, 255]
				img.set(px, py, color)
				
				if dx*dx + dy*dy <= (eye_radius/2)*(eye_radius/2) {
					img.set(px, py, [0, 0, 0, 255])
				}
				
				if dx*dx + dy*dy <= eye_radius*eye_radius && dx*dx + dy*dy > (eye_radius/1.5)*(eye_radius/1.5) {
					img.set(px, py, [255, 100, 100, 200])
				}
			}
		}
	}
}

// Draw evil smile (arc)
for angle := 0.0; angle <= math.pi; angle += 0.01 {
	smile_radius := 50.0
	x := center_x + int(smile_radius * math.cos(angle))
	y := center_y + 20 + int(smile_radius * 0.5 * math.sin(angle))
	
	if x >= 0 && x < w && y >= 0 && y < h {
		color := [200, 50, 50, 255]
		img.set(x, y, color)
		
		// Thicker smile
		for dy := -1; dy <= 1; dy++ {
			ny := y + dy
			if ny >= 0 && ny < h {
				img.set(x, ny, [180, 40, 40, 200])
			}
		}
	}
}

img.save("D.png", "png")

end := times.since(start)
println(end, "ms")
println(float(end)/times.second, "sec")