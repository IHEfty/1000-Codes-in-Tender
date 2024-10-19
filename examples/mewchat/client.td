import "bufio" 
import "net" 
import "fmt"
import "json"
import "strings"
import "colors" as color
import "fs"

count := 0

for f in fs.readdir(".") {
    if f.is_dir { count++ }
}

println(count)

serverAddr := net.resolve_tcp_addr("tcp", "localhost:3000")
conn := net.dial("tcp", serverAddr)

name := null

if conn != null {
	print("Enter your name: ")
	name = strings.trim_space(bufio.readline())
	
	go(fn(){
		for {
			buff := bytes(1024)
			n := conn.read(buff)
			data := json.decode(buff[:n])
			name := data.name || "?"      
			text := data.text || "?"      
			color.println(color.igreen + name + color.reset + ": " + text)
		}
	})
	for {
		print(">>>")
		text := strings.trim_space(bufio.readline())
		conn.write(json.encode({
			text: text,
			name: name,
			type: "msg"
		}))
	}
}
