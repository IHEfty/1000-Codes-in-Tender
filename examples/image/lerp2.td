import "image"
import "times"
import "mathf"
import "math"

start := times.now()
w, h := 800, 600
img := image.new(w, h)

// Dark background
for i := 0; i < w; i++ {
	for j := 0; j < h; j++ {
		color := [20, 20, 30, 255]
		img.set(i, j, color)
	}
}

// Draw different interpolation curves
// Custom lerp variants without using mathf.lerp directly
center_y := h / 2
amplitude := h / 3

// Helper: custom lerp function
lerp := fn (a, b, t) {
	return a + t * (b - a)
}

// Helper: ease-in function (quadratic)
ease_in := fn (t) {
	return t * t
}

// Helper: ease-out function (quadratic)
ease_out := fn (t) {
	return 1.0 - (1.0 - t) * (1.0 - t)
}

// Helper: ease-in-out function (cubic)
ease_in_out := fn (t) {
	if t < 0.5 {
		return 4.0 * t * t * t
	}
	return 1.0 - math.pow(-2.0 * t + 2.0, 3.0) / 2.0
}

// Draw linear lerp (blue)
for x := 0; x < w; x++ {
	t := float(x) / float(w-1)
	val := lerp(0.0, 255.0, t)
	y := center_y - int((val/255.0) * float(amplitude))
	
	if y >= 0 && y < h {
		img.set(x, y, [0, 100, 255, 255])
		if y-1 >= 0 { img.set(x, y-1, [0, 100, 255, 150]) }
		if y+1 < h { img.set(x, y+1, [0, 100, 255, 150]) }
	}
}

// Draw ease-in (red)
for x := 0; x < w; x++ {
	t := float(x) / float(w-1)
	eased_t := ease_in(t)
	val := lerp(0.0, 255.0, eased_t)
	y := center_y - int((val/255.0) * float(amplitude)) + amplitude/2
	
	if y >= 0 && y < h {
		img.set(x, y, [255, 50, 50, 255])
	}
}

// Draw ease-out (green)
for x := 0; x < w; x++ {
	t := float(x) / float(w-1)
	eased_t := ease_out(t)
	val := lerp(0.0, 255.0, eased_t)
	y := center_y - int((val/255.0) * float(amplitude)) - amplitude/2
	
	if y >= 0 && y < h {
		img.set(x, y, [50, 255, 50, 255])
	}
}

// Draw ease-in-out (yellow)
for x := 0; x < w; x++ {
	t := float(x) / float(w-1)
	eased_t := ease_in_out(t)
	val := lerp(0.0, 255.0, eased_t)
	y := center_y - int((val/255.0) * float(amplitude)) + amplitude/4
	
	if y >= 0 && y < h {
		img.set(x, y, [255, 255, 50, 255])
	}
}

// Draw grid
for x := 0; x < w; x += 40 {
	for y := 0; y < h; y++ {
		if y % 40 == 0 {
			color := [60, 60, 70, 150]
			img.set(x, y, color)
		}
	}
}

// Horizontal center line
for x := 0; x < w; x++ {
	img.set(x, center_y, [100, 100, 100, 200])
}

img.save("lerp_curves.png", "png")

end := times.since(start)
println(end, "ms")
println(float(end)/times.second, "sec")