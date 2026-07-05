import { to_ascii } from "tcol"
import { writefile } from "io"

dta := embed("icon.png")

p := to_ascii(dta, 47, 25)


writefile("out.txt", p)

sysout p