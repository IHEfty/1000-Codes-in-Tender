import "path"
import "bufio"
import "os"

arr := path.walklist("./")
li := []

td_count := 0
for a in arr {
    if path.ext(a) == ".td" {
        td_count++
        li.push(a)
     }
}

sysout format("total .td files, %d", td_count).igreen, "\n"

"Enter to exit..." |> print

for bufio.readline() {
  os.exit(0)
}
