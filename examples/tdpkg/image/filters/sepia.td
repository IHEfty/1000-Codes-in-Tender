export fn(img) {
	pixels := img.get_pixels()
	for index := 0; index < len(pixels); index += 4 {	
		r := pixels[index];
		g := pixels[index + 1]
		b := pixels[index + 2]
		
		pixels[index] = (r * 0.393) + (g * 0.769) + (b * 0.189)
		pixels[index + 1] = (r * 0.349) + (g * 0.686) + (b * 0.168)
		pixels[index + 2] = (r * 0.272) + (g * 0.534) + (b * 0.131)
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