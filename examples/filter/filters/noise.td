import "helper/randint"

export fn(img) {
	pixels := img.get_pixels()
	for i := 0; i < len(pixels); i += 4 {	
		pixels[i] = (pixels[i] + randint(0, 255)) / 2
		pixels[i + 1] = (pixels[i + 1] + randint(0, 255)) / 2
		pixels[i + 2] = (pixels[i + 2] + randint(0, 255)) / 2
		if pixels[i] > 255 {
			pixels[i] = 255
		}
		if pixels[i+1] > 255 {
			pixels[i+1] = 255
		}
		if pixels[i+2] > 255 {
			pixels[i+2] = 255
		}
	}	
	img.set_pixels(pixels)
}