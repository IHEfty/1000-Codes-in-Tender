import "image"
import "times"
import "math"
import "rand"

start := times.now()
w, h := 1024, 768
img := image.new(w, h)

for i := 0; i < w; i++ {
	for j := 0; j < h; j++ {
		r := 10
		g := 5
		b := 15
		
		dist := math.sqrt(float((i - w/2)*(i - w/2) + (j - h/2)*(j - h/2)))
		if dist < 300.0 {
			r = 20 + int(200.0 * dist / 300.0)
			g = 5 + int(50.0 * dist / 300.0)
			b = 15 + int(100.0 * dist / 300.0)
		}
		
		if r > 255 { r = 255 }
		if g > 255 { g = 255 }
		if b > 255 { b = 255 }
		
		color := [r, g, b, 255]
		img.set(i, j, color)
	}
}

center_x := w / 2
center_y := h / 2

for i := 0; i < w; i++ {
	for j := 0; j < h; j++ {
		x := (float(i) - float(center_x)) / 150.0
		y := (float(j) - float(center_y)) / 150.0
		
		undefined := math.pow(x, y)
		imaginary := math.pow(-1.0, x)
		infinity := 1.0 / (x*x + y*y - 0.01)
		indeterminate := (x*x + y*y - 0.5) / (x*x + y*y - 0.5)
		
		forbidden := undefined * imaginary * infinity * indeterminate
		
		if math.abs(forbidden) < 50.0 && math.abs(forbidden) > 0.01 {
			val := int(math.abs(forbidden) * 10.0)
			if val > 255 { val = 255 }
			
			r := val
			g := int(float(val) * 0.2)
			b := int(float(val) * 0.8)
			
			if r > 255 { r = 255 }
			if g > 255 { g = 255 }
			if b > 255 { b = 255 }
			
			color := [r, g, b, 200]
			img.set(i, j, color)
		}
		
		if math.abs(x*x + y*y - 0.01) < 0.001 {
			color := [255, 0, 0, 255]
			img.set(i, j, color)
		}
		
		if math.abs(x*x + y*y - 0.5) < 0.001 {
			color := [0, 255, 0, 255]
			img.set(i, j, color)
		}
		
		if math.abs(x) < 0.01 || math.abs(y) < 0.01 {
			color := [100, 100, 255, 150]
			img.set(i, j, color)
		}
	}
}

symbols := [
	"∑",
	"∫",
	"∂",
	"∇",
	"∞",
	"∅"
]

symbol_size := 30
for idx, symbol in symbols {
	sx := 80 + idx * 120
	sy := 700
	color := [200 - idx * 20, 50 + idx * 10, 255 - idx * 30, 150]
	
	for dx := 0; dx < symbol_size; dx++ {
		for dy := 0; dy < symbol_size; dy++ {
			px := sx + dx
			py := sy + dy
			if px >= 0 && px < w && py >= 0 && py < h {
				img.set(px, py, color)
			}
		}
	}
}

warnings := [
	"WARNING: MATHEMATICAL LAWS VIOLATED",
	"DIVISION BY ZERO DETECTED",
	"IMAGINARY NUMBERS ESCAPING",
	"INFINITY LOOP DETECTED"
]

text_size := 14
start_x := 100
start_y := 50

for row, line in warnings {
	for col, char in line {
		if char == ` ` { continue }
		
		val := 255 - row * 40
		if val < 50 { val = 50 }
		color := [val, 50, 50, 200]
		
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

for k := 0; k < 2000; k++ {
	angle := rand.float() * 2 * math.pi
	radius := 100.0 + rand.float() * 300.0
	
	x := center_x + int(radius * math.cos(angle))
	y := center_y + int(radius * math.sin(angle))
	
	if x >= 0 && x < w && y >= 0 && y < h {
		alpha := 30 + int(rand.float() * 150)
		val := 150 + int(rand.float() * 105)
		color := [val, 50, val, alpha]
		img.set(x, y, color)
	}
}

img.save("forbidden_math.png", "png")

end := times.since(start)
println(end, "ms")
println(float(end)/times.second, "sec")