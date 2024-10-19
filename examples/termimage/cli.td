import "os"
import "termimage" as t
// var args = os.args()


// debug(args)

data := embed("download.jpg")
sysout t.to_ascii(data, 40,30,true)