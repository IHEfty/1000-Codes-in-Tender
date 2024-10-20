import "image"

// Create a new image
img := image.new(255, 255)

for i := 0; i < 255; i++ {
	for j := 0; j < 255; j++ {
		color := [i, 0, j, 255]
		img.set(i, j, color)
	}
}

img.save("out.png", "png")