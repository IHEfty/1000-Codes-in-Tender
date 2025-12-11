import "cmplx"

z1 := 10 + 3i
z2 := complex(1, 2)
z3 := cmplx.new(5, 6)

z := z1 + z2 + z3

println(z1)
println(z2)
println(z3)

println("real part:", z.real)
println("imagine part:", z.imag)
