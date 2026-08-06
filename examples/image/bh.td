import "image"
import "times"
import "math"
import "rand"

start := times.now()
w, h := 1024, 1024
img := image.new(w, h)

for i := 0; i < w; i++ {
	for j := 0; j < h; j++ {
		dist := math.sqrt(float((i - w/2)*(i - w/2) + (j - h/2)*(j - h/2)))
		max_dist := float(w) / 2.0
		
		r := 0
		g := 0
		b := 0
		
		if dist < max_dist {
			gradient := 1.0 - dist / max_dist
			r = int(5.0 * gradient)
			g = int(2.0 * gradient)
			b = int(10.0 * gradient)
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
scale := 250.0

for i := 0; i < w; i++ {
	for j := 0; j < h; j++ {
		x := (float(i) - float(center_x)) / scale
		y := (float(j) - float(center_y)) / scale
		
		r_schwarzschild := math.sqrt(x*x + y*y)
		angle := math.atan2(y, x)
		
		if r_schwarzschild < 0.05 {
			color := [0, 0, 0, 255]
			img.set(i, j, color)
			continue
		}
		
		if r_schwarzschild < 0.5 {
			val := int(255.0 * (1.0 - r_schwarzschild / 0.5))
			if val > 255 { val = 255 }
			if val < 0 { val = 0 }
			color := [val, val/4, val/2, 255]
			img.set(i, j, color)
		} else if r_schwarzschild < 0.8 {
			val := int(200.0 * (1.0 - (r_schwarzschild - 0.5) / 0.3))
			if val > 255 { val = 255 }
			if val < 0 { val = 0 }
			color := [255, val, val/3, 255]
			img.set(i, j, color)
		}
		
		if r_schwarzschild > 0.7 && r_schwarzschild < 1.3 {
			disk_brightness := 100 + int(150.0 * (0.5 + 0.5 * math.sin(angle * 10.0 + r_schwarzschild * 15.0)))
			if disk_brightness > 255 { disk_brightness = 255 }
			if disk_brightness < 0 { disk_brightness = 0 }
			
			red := disk_brightness
			green := disk_brightness / 2
			blue := disk_brightness
			
			alpha := 150 + int(100.0 * (0.5 + 0.5 * math.sin(angle * 8.0)))
			if alpha > 255 { alpha = 255 }
			if alpha < 0 { alpha = 0 }
			
			color := [red, green, blue, alpha]
			img.set(i, j, color)
		}
		
		if r_schwarzschild > 1.2 && r_schwarzschild < 2.0 {
			wave := int(80.0 * (0.5 + 0.5 * math.sin(angle * 15.0 + r_schwarzschild * 25.0)))
			if wave > 255 { wave = 255 }
			if wave < 0 { wave = 0 }
			
			alpha := 50 + int(100.0 * (1.0 - (r_schwarzschild - 1.2) / 0.8))
			if alpha > 255 { alpha = 255 }
			if alpha < 0 { alpha = 0 }
			
			color := [wave, wave/3, wave*2, alpha]
			img.set(i, j, color)
		}
		
		if r_schwarzschild > 1.9 && r_schwarzschild < 2.3 {
			alpha := int(80.0 * (1.0 - (r_schwarzschild - 1.9) / 0.4))
			if alpha > 255 { alpha = 255 }
			if alpha < 0 { alpha = 0 }
			
			color := [100, 50, 150, alpha]
			img.set(i, j, color)
		}
	}
}

for k := 0; k < 5000; k++ {
	angle := rand.float() * 2 * math.pi
	radius := 0.1 + rand.float() * 2.5
	
	x := center_x + int(radius * scale * math.cos(angle))
	y := center_y + int(radius * scale * math.sin(angle))
	
	if x >= 0 && x < w && y >= 0 && y < h {
		brightness := 30 + int(rand.float() * 200)
		alpha := 20 + int(rand.float() * 200)
		
		if radius < 0.3 {
			brightness = 200 + int(rand.float() * 55)
			alpha = 150 + int(rand.float() * 105)
		}
		
		if brightness > 255 { brightness = 255 }
		if alpha > 255 { alpha = 255 }
		
		red := brightness
		green := brightness / 3
		blue := brightness * 2 / 3
		
		color := [red, green, blue, alpha]
		img.set(x, y, color)
	}
}

for angle := 0.0; angle < 2 * math.pi; angle += 0.001 {
	for r := 0.3; r < 2.5; r += 0.02 {
		x := center_x + int(r * scale * math.cos(angle))
		y := center_y + int(r * scale * math.sin(angle))
		
		if x >= 0 && x < w && y >= 0 && y < h {
			lens_strength := 1.0 / (r * r)
			val := int(30.0 * lens_strength)
			if val > 150 { val = 150 }
			if val < 0 { val = 0 }
			
			alpha := val
			color := [val, val/3, val*2, alpha/2]
			img.set(x, y, color)
		}
	}
}

info := [
	"★ BLACK HOLE SIMULATION ★",
	"Event Horizon: r = 1.0",
	"Singularity: r → 0",
	"Accretion Disk",
	"Gravitational Lensing"
]

text_size := 14
start_x := 50
start_y := 700

for row, line in info {
	for col, char in line {
		if char == ` ` { continue }
		
		val := 200 - row * 15
		if val < 50 { val = 50 }
		color := [val, val/2, val, 200]
		
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

img.save("blackhole_simulation.png", "png")

end := times.since(start)
println(end, "ms")
println(float(end)/times.second, "sec")