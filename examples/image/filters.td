import "image"

img := image.load("gopher.png")
img = img.filters.grayscale()
img = img.filters.vignette(1)
img = img.filters.hue(70)
img = img.filters.temperature(170)
img = img.filters.pixelate(10)
img = img.filters.emboss(10)
img = img.filters.sobel(10)
img = img.filters.saturation(10)
// img = img.filters.edge(1)

img.save("gopher_out.png", "png")