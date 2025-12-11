import "csv"

var data = [
	["name", "age", "rating"],
	["Alex",  16,  0.7],
	["Bob", 19,  1],
	["Blade", 31,  0.9]
]

encoded := csv.encode(data)
decoded := csv.decode(encoded)

println(encoded)
println(decoded)