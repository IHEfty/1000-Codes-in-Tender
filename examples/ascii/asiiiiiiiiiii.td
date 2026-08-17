import "console"
import "bufio"

fn draw() {
	str := ""

	for i := 0; i < 255; i+=10 {
		for j := 0; j < 255; j+=5 {
			r := (i * 255) / (255-1)
			g := (j * 255) / (255-1)
			b := 128
			hex := format("#%.2x%.2x%.2x", r, g, b)
			str += console.style("@", {
				background: hex,
				color: hex
			})
		}
		str += "\n"
	}

	sysout str
}

draw()

for {
	bufio.readline()
	draw()
}