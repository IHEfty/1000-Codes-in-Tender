export fn(img, adjustment) { 	
	pixels := img.get_pixels()
	for i := 0; i < len(pixels); i += 4 {	
		pixels[i] += adjustment
		pixels[i + 1] += adjustment
		pixels[i + 2] += adjustment
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