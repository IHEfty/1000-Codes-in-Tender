import "color"
import "math"
import "canvas"
import "image"

block := "█"

COLORS := [
	[000, 000, 000], [255, 000, 000], [000, 255, 000], [255, 255, 000],
	[000, 000, 255], [255, 000, 255], [000, 255, 255], [255, 255, 255],
	[128, 128, 128], [128, 000, 000], [000, 128, 000], [128, 128, 000],
	[000, 000, 128], [128, 000, 128], [000, 128, 128], [192, 192, 192]
]

ANSI_COLORS := [
	color.black, color.ired, color.igreen, color.iyellow,
	color.iblue, color.ipurple, color.icyan, color.iwhite,
	color.iblack, color.red, color.green, color.yellow,
	color.blue, color.purple, color.cyan, color.white
]

color_distance := fn(color1, color2) {
	dr := color1[0] - color2[0]
	dg := color1[1] - color2[1]
	db := color1[2] - color2[2]
	
	return math.sqrt(dr * dr + dg * dg + db * db)
}


fn termcolor(rgb) {
	// Find the index of the nearest color
	minDistance := 100000000000000000
	minIndex := 0;
	
	for i := 0; i < len(ANSI_COLORS); i++ {
		distance := color_distance(rgb, COLORS[i])
		
		if distance < minDistance {
			minDistance = distance;
			minIndex = i
		}
	}
	return ANSI_COLORS[minIndex]
}

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