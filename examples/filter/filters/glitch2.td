import "helper/randint"

// Ensure pixel values stay within the valid range [0, 255]
fn clamp(value) {
	if value < 0 {
		return 0
	}
	if value > 255 {
		return 255
	}
	return value
}

export fn(img) {
	pixels := img.get_pixels()
	width := img.bounds().size.width  // Get the width of the image
	height := img.bounds().size.height // Get the height of the image

	// Introduce random "glitches"
	for index := 0; index < len(pixels); index += 4 {
		r := pixels[index]
		g := pixels[index + 1]
		b := pixels[index + 2]

		// Add some random offset to each color channel, but allow some randomness in intensity for more variation
		r_offset := randint(0, 20)
		g_offset := randint(-5, 25)   // Green can vary more to add contrast
		b_offset := randint(-10, 15)  // Blue channel might shift more significantly

		// Apply offsets with realistic variation
		pixels[index] = clamp(r + r_offset)
		pixels[index + 1] = clamp(g + g_offset)
		pixels[index + 2] = clamp(b + b_offset)

		// Optional: Introduce horizontal/vertical displacement for "glitch" screen effect
		if randint(0, 10) > 3 {
			// Randomly shift pixels left, right, up, or down
			offset_dir := randint(0, 4) // 0 = left, 1 = right, 2 = up, 3 = down
			shift_amount := randint(0, 3) * 4 // amount to shift in terms of pixels (based on RGB = 4 bytes)

			var shift_index = index
			if offset_dir == 0 {
				shift_index = index - shift_amount // Left
			} else if offset_dir == 1 {
				shift_index = index + shift_amount // Right
			} else if offset_dir == 2 {
				shift_index = index - (shift_amount * width) // Up (by row size)
			} else if offset_dir == 3 {
				shift_index = index + (shift_amount * width) // Down (by row size)
			}


			// Ensure we don't go out of bounds and apply glitch (swap pixels to simulate corruption)
			if shift_index >= 0 && shift_index < len(pixels) {
				pixels[index] = pixels[shift_index]
				pixels[shift_index] = pixels[index]
			}
		}
	}

	img.set_pixels(pixels)
}
