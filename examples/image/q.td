import "image"
import "times"
import "math"
import "rand"

start := times.now()
w, h := 1024, 1024
img := image.new(w, h)

for i := 0; i < w; i++ {
	for j := 0; j < h; j++ {
		r := 0
		g := 0
		b := 10
		
		dist := math.sqrt(float((i - w/2)*(i - w/2) + (j - h/2)*(j - h/2)))
		if dist < 500.0 {
			gradient := 1.0 - dist / 500.0
			r = int(10.0 * gradient)
			g = int(5.0 * gradient)
			b = int(20.0 * gradient)
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
scale := 180.0

for i := 0; i < w; i++ {
	for j := 0; j < h; j++ {
		x := (float(i) - float(center_x)) / scale
		y := (float(j) - float(center_y)) / scale
		
		r := math.sqrt(x*x + y*y)
		theta := math.atan2(y, x)
		
		hydrogen_1s := math.exp(-r) / math.sqrt(math.pi)
		hydrogen_2s := (2.0 - r) * math.exp(-r/2.0) / (4.0 * math.sqrt(2.0 * math.pi))
		hydrogen_2p := r * math.exp(-r/2.0) * math.cos(theta) / (4.0 * math.sqrt(2.0 * math.pi))
		
		probability_1s := hydrogen_1s * hydrogen_1s
		probability_2s := hydrogen_2s * hydrogen_2s
		probability_2p := hydrogen_2p * hydrogen_2p
		
		superposition := (probability_1s + probability_2s + probability_2p) / 3.0
		
		if superposition > 0.001 {
			val := int(superposition * 255.0 * 5.0)
			if val > 255 { val = 255 }
			if val < 0 { val = 0 }
			
			red := val
			green := int(float(val) * 0.5)
			blue := int(float(val) * 0.9)
			
			if red > 255 { red = 255 }
			if green > 255 { green = 255 }
			if blue > 255 { blue = 255 }
			
			alpha := 150 + int(float(val) * 0.4)
			if alpha > 255 { alpha = 255 }
			
			color := [red, green, blue, alpha]
			img.set(i, j, color)
		}
		
		if r > 0.1 && r < 5.0 {
			radial_wave := math.sin(r * 10.0) * math.exp(-r * 0.5)
			if math.abs(radial_wave) > 0.05 {
				val := int(math.abs(radial_wave) * 200.0)
				if val > 255 { val = 255 }
				if val < 0 { val = 0 }
				
				color := [val/2, val, val, 100]
				img.set(i, j, color)
			}
		}
		
		angular_wave := math.cos(theta * 3.0) * math.exp(-r * r * 0.5)
		if math.abs(angular_wave) > 0.05 {
			val := int(math.abs(angular_wave) * 200.0)
			if val > 255 { val = 255 }
			if val < 0 { val = 0 }
			
			color := [val, val/3, val*2, 80]
			img.set(i, j, color)
		}
		
		if r < 2.0 && r > 0.5 {
			interference := math.sin(r * 15.0 - theta * 4.0)
			if math.abs(interference) > 0.1 {
				val := int(math.abs(interference) * 150.0)
				if val > 255 { val = 255 }
				if val < 0 { val = 0 }
				
				color := [val, val, val/2, 60]
				img.set(i, j, color)
			}
		}
	}
}

for k := 0; k < 8000; k++ {
	angle := rand.float() * 2 * math.pi
	radius := 0.1 + rand.float() * 3.0
	
	quantum_prob := math.exp(-radius * radius * 0.5)
	if rand.float() < quantum_prob {
		x := center_x + int(radius * scale * math.cos(angle))
		y := center_y + int(radius * scale * math.sin(angle))
		
		if x >= 0 && x < w && y >= 0 && y < h {
			brightness := 100 + int(rand.float() * 155)
			alpha := 50 + int(rand.float() * 150)
			
			if brightness > 255 { brightness = 255 }
			if alpha > 255 { alpha = 255 }
			
			red := brightness
			green := int(float(brightness) * 0.3)
			blue := int(float(brightness) * 0.8)
			
			color := [red, green, blue, alpha]
			img.set(x, y, color)
		}
	}
}

for t := 0.0; t < 2 * math.pi; t += 0.001 {
	r := 1.0 + 0.8 * math.cos(t * 4.0)
	
	x := center_x + int(r * scale * 0.6 * math.cos(t))
	y := center_y + int(r * scale * 0.6 * math.sin(t))
	
	if x >= 0 && x < w && y >= 0 && y < h {
		color := [200, 100, 255, 80]
		img.set(x, y, color)
	}
}

for t := 0.0; t < 2 * math.pi; t += 0.001 {
	r := 0.5 + 0.3 * math.sin(t * 6.0 + 1.0)
	
	x := center_x + int(r * scale * math.cos(t))
	y := center_y + int(r * scale * math.sin(t))
	
	if x >= 0 && x < w && y >= 0 && y < h {
		color := [255, 150, 100, 80]
		img.set(x, y, color)
	}
}

formulas := [
	"QUANTUM WAVE FUNCTION",
	"ψ(r,θ) = R(r)·Y(θ,φ)",
	"|ψ|² = Probability Density",
	"Hydrogen Atom Orbitals",
	"1s, 2s, 2p Superposition",
	"Quantum Interference",
	"Quantum Entanglement"
]

text_size := 14
start_x := 50
start_y := 50

for row, line in formulas {
	for col, char in line {
		if char == ` ` { continue }
		
		val := 255 - row * 20
		if val < 50 { val = 50 }
		
		red := int(float(val) * 0.8)
		green := int(float(val) * 0.4)
		blue := val
		
		if red > 255 { red = 255 }
		if green > 255 { green = 255 }
		if blue > 255 { blue = 255 }
		
		color := [red, green, blue, 200]
		
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

mathematical := [
	"ħ = h/2π",
	"i² = -1",
	"∫|ψ|² dV = 1",
	"[x,p] = iħ",
	"E = ħω",
	"p = ħk"
]

start_x2 := 600
start_y2 := 50

for row, line in mathematical {
	for col, char in line {
		if char == ` ` { continue }
		
		val := 255 - row * 20
		if val < 50 { val = 50 }
		
		red := int(float(val) * 0.5)
		green := int(float(val) * 0.8)
		blue := int(float(val) * 0.3)
		
		if red > 255 { red = 255 }
		if green > 255 { green = 255 }
		if blue > 255 { blue = 255 }
		
		color := [red, green, blue, 200]
		
		for dx := 0; dx < text_size; dx++ {
			for dy := 0; dy < text_size; dy++ {
				px := start_x2 + col * text_size + dx
				py := start_y2 + row * text_size + dy
				if px >= 0 && px < w && py >= 0 && py < h {
					img.set(px, py, color)
				}
			}
		}
	}
}

img.save("quantum_wavefunction.png", "png")

end := times.since(start)
println(end, "ms")
println(float(end)/times.second, "sec")