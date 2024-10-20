import "os"

file := os.create("output.txt")

cmd := os.exec("go", "version")
cmd.stdout(file.writer)
cmd.stderr(file.writer)
cmd.start()