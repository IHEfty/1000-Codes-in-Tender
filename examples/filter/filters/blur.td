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

	// Define blur kernel size (e.g., 3x3, 5x5)
	kernel_size := 3
	kernel_half := kernel_size / 2

	// Create a new pixel array to store the blurred image
	blurred_pixels := copy(pixels)

	for y := kernel_half; y < height - kernel_half; y++ {
		for x := kernel_half; x < width - kernel_half; x++ {
			// Sum variables for RGB channels
			var r_sum = 0
			var g_sum = 0
			var b_sum = 0
			var count = 0

			// Loop over neighboring pixels within the kernel window
			for ky := -kernel_half; ky <= kernel_half; ky++ {
				for kx := -kernel_half; kx <= kernel_half; kx++ {
					// Get the neighboring pixel index
					index := ((y + ky) * width + (x + kx)) * 4

					// Make sure the index is within bounds
					if index >= 0 && index + 3 < len(pixels) {
						r_sum += pixels[index]       // Red channel
						g_sum += pixels[index + 1]   // Green channel
						b_sum += pixels[index + 2]   // Blue channel
						count++
					}
				}
			}

			// Calculate the average RGB values
			r_avg := clamp(r_sum / count)
			g_avg := clamp(g_sum / count)
			b_avg := clamp(b_sum / count)

			// Set the blurred pixel value in the new pixel array
			blurred_index := (y * width + x) * 4
			blurred_pixels[blurred_index] = r_avg
			blurred_pixels[blurred_index + 1] = g_avg
			blurred_pixels[blurred_index + 2] = b_avg
			blurred_pixels[blurred_index + 3] = pixels[blurred_index + 3]  // Preserve alpha channel
		}
	}

	// Set the modified pixels back to the image
	img.set_pixels(blurred_pixels)
}
