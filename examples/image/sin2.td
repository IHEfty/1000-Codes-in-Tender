import "image"
import "times"
import "math"

start := times.now()
w, h := 1024, 512
img := image.new(w, h)

// Fill background with dark
for i := 0; i < w; i++ {
	for j := 0; j < h; j++ {
		color := [20, 20, 30, 255]
		img.set(i, j, color)
	}
}

// Draw multiple sin waves with different colors
frequencies := [1.0, 2.0, 3.0, 4.0]
colors := [
	[255, 0, 0, 255],    // Red
	[0, 255, 0, 255],    // Green
	[0, 0, 255, 255],    // Blue
	[255, 255, 0, 255]  // Yellow
]

for idx, freq in frequencies {
	amplitude := h / 5
	center_y := h / 2 + int(float(idx-2) * float(h)/8)
	
	for x := 0; x < w; x++ {
		sin_val := math.sin(freq * 2 * math.pi * float(x) / float(w))
		y := center_y + int(float(amplitude) * sin_val)
		
		if y >= 0 && y < h {
			img.set(x, y, colors[idx])
		}
		
		// Add glow effect
		if y-1 >= 0 {
			img.set(x, y-1, [colors[idx][0]/2, colors[idx][1]/2, colors[idx][2]/2, 150])
		}
		if y+1 < h {
			img.set(x, y+1, [colors[idx][0]/2, colors[idx][1]/2, colors[idx][2]/2, 150])
		}
	}
}

// Draw axes
for x := 0; x < w; x++ {
	if x % 100 == 0 {
		for y := 0; y < h; y++ {
			if y % 50 == 0 {
				color := [100, 100, 100, 200]
				img.set(x, y, color)
			}
		}
	}
}

// Horizontal center line
for x := 0; x < w; x++ {
	color := [150, 150, 150, 200]
	img.set(x, h/2, color)
}

img.save("sin_waves.png", "png")

end := times.since(start)
println(end, "ms")
println(float(end)/times.second, "sec")