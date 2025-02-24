color := import("colors")     
math := import("math")
canvas := import("canvas")
image := import("image")
termcolor := import("termcolor")

block := "█"

to_ascii := fn (img, width, height, colored) {
	im := image.decode(img)

	w := im.bounds().size.width
	h := im.bounds().size.height

	ctx := canvas.new_context(width, height)
	ctx.scale(float(width)/w, float(height)/h)
	ctx.drawimage(img, 0, 0)
	img := ctx.image()
	
	result := ""
	for j := 0; j < height; j++ {
		str := ""
		for i := 0; i < width; i++ {
			rgb := img.at(i, j)
			if colored {
				str += termcolor(rgb)
			}
			str += block
		} 
		result += str + "\n" 
	}
	
	return result + color.reset
}

export {
	to_ascii : to_ascii,
	set_block : fn(b) {
		block = b
	}
}		