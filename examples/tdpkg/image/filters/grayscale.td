export fn(img) {
	pixels := img.get_pixels()
	for i := 0; i < len(pixels); i += 4 {	
		v := 0.3 * pixels[i] + 0.59 * pixels[i+1] + 0.11 * pixels[i+2]
		pixels[i] = v
		pixels[i+1] = v
		pixels[i+2] = v
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