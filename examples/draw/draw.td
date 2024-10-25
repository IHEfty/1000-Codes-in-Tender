canvas := import("canvas")
os := import("os")
strings := import("strings")

ctx := canvas.new_context(51, 25)

file := os.read_file("gumball.txt")
arr := strings.split(string(file), "\n")

for i, a in arr {
	for j, b in a {
		ctx.set_pixel(j, i)
		if b == '#' || b == '@'  {
			ctx.hex("#ff0000")
		}
		else if b == '='  {
			ctx.hex("#ff000080")
		}
		else if b == ' '  {
			ctx.hex("#ffffff00")
		}
		else {
			ctx.hex("#ff000050")
		}
		ctx.fill()
	}
}

ctx.save_png("out.png")

