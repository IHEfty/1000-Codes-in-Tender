import "os"
import "websocket"

// Dial a WebSocket connection
var conn = websocket.dial("ws://example.com/socket")

//Read message from server
go(fn(){
	for {
		read := conn.read_message()
		println(read)
	}
})

if !conn {
	println(conn)
	os.exit(0)
}

//Write message
conn.write_message(1, "hello")