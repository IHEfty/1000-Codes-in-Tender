import "image"
import "times"

start := times.now()
w, h := 255*2, 255*2
// Create a new image
img := image.new(w, h)

for i := 0; i < w; i++ {
	for j := 0; j < h; j++ {
		r := (i * 255) / (w-1)
		g := (j * 255) / (h-1)
		b := 128
		a := 255
		color := [r, g, b, a]
		img.set(i, j, color)
	}
}

img.save("out.png", "png")

end := times.since(start)

println(end, "ms")
println(float(end)/times.second, "sec")
