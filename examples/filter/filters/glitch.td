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

// Function to add glitch filter with random shifting
export fn(img) {
	pixels := img.get_pixels()
	width := img.bounds().size.width  // Get the width of the image
	height := img.bounds().size.height // Get the height of the image
	shift_amount := 10                  // Amount of pixels to shift (can be adjusted)
	glitch_intensity := 30             // Intensity of color shift (can be adjusted)

	// Loop through each pixel and apply glitch effect
	for y := 0; y < height; y++ {
		for x := 0; x < width; x++ {
			index := (y * width + x) * 4

			// Apply random horizontal or vertical shift
			offset_x := randint(-shift_amount, shift_amount)
			offset_y := randint(-shift_amount, shift_amount)

			// Randomly choose to shift each pixel's red, green, or blue channels
			shift_channel := randint(0, 3)  // 0 = red, 1 = green, 2 = blue, 3 = no shift

			if shift_channel != 3 {
				// Shift color channels
				shifted_index := (y * width + x + offset_x + offset_y * width) * 4
				if shifted_index >= 0 && shifted_index < len(pixels) {
					// Swap pixels between the original and shifted pixels
					tmp := pixels[index + shift_channel] // Temporarily hold original pixel
					pixels[index + shift_channel] = pixels[shifted_index + shift_channel]
					pixels[shifted_index + shift_channel] = tmp
				}
			}

			// Introduce a random noise effect by shifting the RGB channels
			if randint(0, glitch_intensity) > 8 {
				// Apply small random color glitches
				pixels[index] = clamp(pixels[index] + randint(-glitch_intensity, glitch_intensity))   // Red
				pixels[index + 1] = clamp(pixels[index + 1] + randint(-glitch_intensity, glitch_intensity)) // Green
				pixels[index + 2] = clamp(pixels[index + 2] + randint(-glitch_intensity, glitch_intensity)) // Blue
			}

			// Optional: Add random vertical or horizontal displacement with noise
			if randint(0, 5) > 3 {
				// Simulate random jumps in the pixel positions
				shift_index := index + (randint(0,5) - 2) * 4
				if shift_index >= 0 && shift_index < len(pixels) {
					// Swap the pixel values, simulating a jump effect
					pixels[index] = pixels[shift_index]
					pixels[shift_index] = pixels[index]
				}
			}
		}
	}

	// Set the modified pixels back to the image
	img.set_pixels(pixels)
}
