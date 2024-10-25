canvas := import("canvas")
math := import("math")

W := 600
H := 400
N := 7 

dc := canvas.new_context(W, H)

R := math.min(W, H) / 2
centerX := W / 2
centerY := H / 2

colors := ["#FF0000", "#FF7F00", "#FFFF00", "#00FF00", "#0000FF", "#4B0082", "#8B00FF"]

for i := 0; i < N; i++ {
	startAngle := i * 2 * math.pi / N
	endAngle := i+1 * 2 * math.pi / N
	
	dc.hex(colors[i])
	dc.move_to(centerX, centerY)
	dc.line_to(centerX+R*math.cos(startAngle), centerY+R*math.sin(startAngle))
	dc.arc(centerX, centerY, R, startAngle, endAngle)
	dc.closepath()
	dc.fill()
}


dc.save_png("pi_arc.png")

