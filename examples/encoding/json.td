import "json"

var map = {
	x: 100,
	y: immutable([1,2,3,5]),
	z: "Hello"
}

encoded := json.encode(map)
decoded := json.decode(encoded)

println(encoded)
println(decoded)