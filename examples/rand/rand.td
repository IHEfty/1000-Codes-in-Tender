canvas := import("canvas")
rand := import("rand")
math := import("math")

width := 255
height := 255

ctx := canvas.new_context(width, height)

for i := 0; i < width; i++ {
	for j := 0; j < height; j++ {
		ctx.set_pixel(i, j)
		r := rand.float()
		g := rand.float()
		b := rand.float()
		ctx.rgb(r, g, b)
		ctx.fill()
	}
}

ctx.save_png("rand.png")