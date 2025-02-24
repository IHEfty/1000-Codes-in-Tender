export fn(img) {
	pixels := img.get_pixels()
	for index := 0; index < len(pixels); index += 4 {	
		v := (pixels[index] + pixels[index + 1] + pixels[index + 2]) / 3;
		pixels[index] = v;
		pixels[index + 1] = v;
		pixels[index + 2] = v;
		if pixels[index] > 255 {
			pixels[index] = 255
		}
		if pixels[index+1] > 255 {
			pixels[index+1] = 255
		}
		if pixels[index+2] > 255 {
			pixels[index+2] = 255
		}
	}	
	img.set_pixels(pixels)
}