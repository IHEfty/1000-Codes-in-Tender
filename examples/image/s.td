import "image"
import "times"
import "math"

start := times.now()
w, h := 800, 800
img := image.new(w, h)

for i := 0; i < w; i++ {
	for j := 0; j < h; j++ {
		r := 20 + int(float(i) * 0.1)
		g := 5 + int(float(j) * 0.05)
		b := 30 + int(float(i+j) * 0.08)
		
		if r > 255 { r = 255 }
		if g > 255 { g = 255 }
		if b > 255 { b = 255 }
		
		color := [r, g, b, 255]
		img.set(i, j, color)
	}
}

scale := 80.0
center_x := w / 2
center_y := h / 2

for angle := 0.0; angle < 2 * math.pi; angle += 0.001 {
	k := 3.0
	r := 1.0 * math.cos(k * angle)
	
	x := center_x + int(r * scale * math.cos(angle))
	y := center_y + int(r * scale * math.sin(angle))
	
	if x >= 0 && x < w && y >= 0 && y < h {
		color := [255, 50, 150, 255]
		img.set(x, y, color)
	}
}

for t := 0.0; t < 2 * math.pi; t += 0.001 {
	a := 200.0
	b := 150.0
	delta := math.pi / 2.0
	
	x := center_x - 200 + int(a * math.sin(2.0 * t + delta))
	y := center_y + 100 + int(b * math.sin(3.0 * t))
	
	if x >= 0 && x < w && y >= 0 && y < h {
		color := [100, 200, 255, 200]
		img.set(x, y, color)
	}
}

for t := 0.0; t < 12 * math.pi; t += 0.001 {
	r := 0.8 * (math.exp(math.sin(t)) - 2.0 * math.cos(4.0 * t) - math.pow(math.sin((2.0*t - math.pi)/24.0), 5.0))
	
	x := center_x + 200 + int(r * 50.0 * math.cos(t))
	y := center_y + 100 + int(r * 50.0 * math.sin(t))
	
	if x >= 0 && x < w && y >= 0 && y < h {
		color := [255, 200, 100, 200]
		img.set(x, y, color)
	}
}

sixty_nine := [
	"  666  999  ",
	" 6   6 9   9",
	" 6     9   9",
	"  666   999 ",
	"     6    9 ",
	" 6   6 9   9",
	"  666  999  "
]

text_size := 10
start_x := 280
start_y := 600

for row, line in sixty_nine {
	for col, char in line {
		if char == ` ` { continue }
		
		color := [255, 100, 100, 200]
		for dx := 0; dx < text_size; dx++ {
			for dy := 0; dy < text_size; dy++ {
				px := start_x + col * text_size + dx
				py := start_y + row * text_size + dy
				if px >= 0 && px < w && py >= 0 && py < h {
					img.set(px, py, color)
				}
			}
		}
	}
}

img.save("sscurves.png", "png")

end := times.since(start)
println(end, "ms")
println(float(end)/times.second, "sec")