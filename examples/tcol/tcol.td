import "colors"
import "math"
import "canvas"
import "image"

block := "█"

to_ascii := fn (img, width, height) {
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
			hex :=  format("#%02x%02x%02x", rgb[0], rgb[1], rgb[2])
			str += colors.style(block, {color:hex,background:hex})
		} 
		result += str + "\n" 
	}
	
	return result
}

export {
	to_ascii : to_ascii,
	set_block : fn(b) {
		block = b
	}
}		