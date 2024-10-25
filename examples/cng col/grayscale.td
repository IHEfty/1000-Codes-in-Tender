import "image"


img := image.load("img.png")

w := img.bounds().size.width
h := img.bounds().size.height


for i := 0; i < w; i++ {
	for j := 0; j < h; j++ {
		col := img.at(i, j)
		r := col[0]
		g := col[1]
		b := col[2]
		a := col[3]
		v := 0.3 * r + 0.59 * b + 0.11 * b;
		img.set(i, j, [v, v, v, a])
	}
}

img.save("out.png", "png")