import "path"

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

for l in li {
  println(l)
}
