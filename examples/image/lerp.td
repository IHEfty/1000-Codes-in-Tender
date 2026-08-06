import "image"
import "times"
import "mathf"

start := times.now()
w, h := 800, 400
// Create a new image with white background
img := image.new(w, h)

// Fill background with white
for i := 0; i < w; i++ {
	for j := 0; j < h; j++ {
		r, g, b, a := 255, 255, 255, 255
		color := [r, g, b, a]
		img.set(i, j, color)
	}
}

// Draw lerp graph (linear interpolation)
// lerp(a, b, t) = a + t * (b - a)
// where t goes from 0 to 1

start_val := 0.0   // a
end_val := 255.0   // b
center_y := h / 2
amplitude := h / 3

for x := 0; x < w; x++ {
	// Calculate t from 0 to 1 based on x position
	t := float(x) / float(w-1)
	
	// Calculate lerp value
	lerp_val := mathf.lerp(start_val, end_val, t)
	
	// Map to y position (0 at bottom, h at top)
	// lerp_val is 0-255, we want to map it to visible area
	y := center_y - int((lerp_val/255.0) * float(amplitude))
	
	if y >= 0 && y < h {
		// Draw main lerp line (blue)
		color := [0, 0, 255, 255]
		img.set(x, y, color)
		
		// Add thickness
		if y-1 >= 0 {
			img.set(x, y-1, [0, 0, 255, 150])
		}
		if y+1 < h {
			img.set(x, y+1, [0, 0, 255, 150])
		}
	}
}

// Draw diagonal reference line (y = x)
for x := 0; x < w; x++ {
	t := float(x) / float(w-1)
	y := int(float(center_y) - float(amplitude) * t)
	
	if y >= 0 && y < h {
		color := [200, 200, 200, 150]
		img.set(x, y, color)
	}
}

// Draw grid and labels
for x := 0; x < w; x += 50 {
	for y := 0; y < h; y++ {
		if y % 50 == 0 {
			color := [220, 220, 220, 100]
			img.set(x, y, color)
		}
	}
}

// Horizontal axis
for x := 0; x < w; x++ {
	color := [150, 150, 150, 200]
	img.set(x, center_y, color)
}

// Vertical axis
for y := 0; y < h; y++ {
	color := [150, 150, 150, 200]
	img.set(w/2, y, color)
}

// Draw start and end points
start_x := 0
end_x := w-1

// Start point (t=0, lerp=0)
start_y := center_y
for dy := -3; dy <= 3; dy++ {
	for dx := -3; dx <= 3; dx++ {
		px := start_x + dx
		py := start_y + dy
		if px >= 0 && px < w && py >= 0 && py < h {
			img.set(px, py, [255, 0, 0, 255])  // Red point
		}
	}
}

// End point (t=1, lerp=255)
end_y := center_y - amplitude
for dy := -3; dy <= 3; dy++ {
	for dx := -3; dx <= 3; dx++ {
		px := end_x + dx
		py := end_y + dy
		if px >= 0 && px < w && py >= 0 && py < h {
			img.set(px, py, [0, 255, 0, 255])  // Green point
		}
	}
}

img.save("lerp_graph.png", "png")

end := times.since(start)
println(end, "ms")
println(float(end)/times.second, "sec")