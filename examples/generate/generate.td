os := import("os")
strings := import("strings")
color := import("color")

file := os.read_file("hi.txt")

arr := strings.split(string(file), "")

out := ""

n := 0

for a in arr {
	if a == "\n" {
		n++
	}
	
	if n < 10 {
		if a == "#" || a == "+" {
			out += color.red + a
		}
		else if a == "%" || a == "@"  {
			out += color.ired + a
		}
		else {
			out += color.white + a
		}
	}
	else {
		out += color.white + a
	}
}

out += color.reset

sysout out