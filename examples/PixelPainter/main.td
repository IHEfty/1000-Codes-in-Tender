image := import("image")
math := import("math")
matrix := import("matrix")
col := import("col")

mat := matrix.from_array(col, int(math.sqrt(len(col))))
order := mat.order()

img := image.new(order[0], order[1])

for i := 0; i < order[0]; i++ {
	for j := 0; j < order[1]; j++ {
		c := mat.data[i][j]
		img.set(i, j, c)
	}
}

img.save("out.png", "png")