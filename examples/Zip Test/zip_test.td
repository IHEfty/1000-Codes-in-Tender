import "zip"
import "io"

//Creating ZIP
myzip := zip.writer()
myzip.create("hello.txt", "hello world")
myzip.set_comment("this is a comment!")
myzip.close()

io.writefile("hello.zip", myzip.bytes())

//Reading ZIP
zz := zip.reader(io.readfile("hello.zip"))

for file in zz.files {
	println(file.read())
}