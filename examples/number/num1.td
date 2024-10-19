fn add(x, y) {
	xy := x+y
	debug("add", typeof(x), typeof(y), typeof(xy), xy)
}

fn sub(x, y) {
	xy := x-y
	debug("sub", typeof(x), typeof(y), typeof(xy), xy)
}

fn mul(x, y) {
	xy := x*y
	debug("mul", typeof(x), typeof(y), typeof(xy), xy)
}

fn div(x, y) {
	xy := x/y
	debug("div", typeof(x), typeof(y), typeof(xy), xy)
}

var types = [int, float, bigint, bigfloat]

for a in types {
	for b in types {
		add(a(100), b(55))
		sub(a(100), b(55))
		mul(a(100), b(55))
		div(a(100), b(55))
		println()
	}
}