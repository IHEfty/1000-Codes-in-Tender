import "io"
import "os"


reader := os.stdin
io.read_full(reader, "\n")

println("done")

io.read_all(reader)

