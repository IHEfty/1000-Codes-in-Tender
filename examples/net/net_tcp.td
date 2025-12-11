import "net"

// DNS Lookup
addresses := net.dnslookup("example.com")
println(addresses)

// Resolve TCP Address
tcp_addr := net.resolve_tcp_addr("tcp", "example.com:80")
println(tcp_addr)

// Resolve UDP Address
udp_addr := net.resolve_udp_addr("udp", "example.com:80")
println(udp_addr)

// Dial a TCP Connection
conn := net.dialtcp("tcp", "example.com:80")
if !is_error(conn) {
    println("Connected to: ", conn.remote_addr())

    // Write to the connection
    msg := bytes("GET / HTTP/1.1\r\nHost: example.com\r\n\r\n")
    n := conn.write(msg)
    println("Bytes written: ", n)

    // Read from the connection
    buf := bytes(1024)
    n = conn.read(buf)
    println("Response: ", string(buf[:n]))

    // Close the connection
    conn.close()
}