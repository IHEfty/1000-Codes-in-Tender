import "io"

data := "hello"

io.writefile("out.txt", data)
r := io.readfile("out.txt")

println(r)