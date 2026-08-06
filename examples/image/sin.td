import "image"
import "times"
import "math"

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

// Draw sin graph
amplitude := h / 3
center_y := h / 2
frequency := 2.0

for x := 0; x < w; x++ {
	// Calculate sin value
	sin_val := math.sin(frequency * math.pi * float(x) / float(w) * 2)
	y := center_y + int(float(amplitude) * sin_val)
	
	// Draw a thicker line (3 pixels wide)
	for dy := -1; dy <= 1; dy++ {
		py := y + dy
		if py >= 0 && py < h {
			// Red color for the sin graph
			color := [255, 0, 0, 255]
			img.set(x, py, color)
		}
	}
	
	// Draw horizontal axis
	axis_y := center_y
	if x % 10 == 0 {
		for dy := -2; dy <= 2; dy++ {
			py := axis_y + dy
			if py >= 0 && py < h {
				color := [0, 0, 0, 100]
				img.set(x, py, color)
			}
		}
	}
}

// Draw grid lines (optional)
for x := 0; x < w; x += 50 {
	for y := 0; y < h; y++ {
		if y % 50 == 0 {
			color := [200, 200, 200, 100]
			img.set(x, y, color)
		}
	}
}

img.save("sin_graph.png", "png")

end := times.since(start)
println(end, "ms")
println(float(end)/times.second, "sec")