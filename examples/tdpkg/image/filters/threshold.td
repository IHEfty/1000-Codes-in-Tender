export fn(img, threshold_val) {
	pixels := img.get_pixels()
	for index := 0; index < len(pixels); index += 4 {	
		v := (0.2126 * pixels[index] + 0.7152 * pixels[index + 1] + 0.0722 * pixels[index + 2] >= threshold_val) ? 255 : 0;
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