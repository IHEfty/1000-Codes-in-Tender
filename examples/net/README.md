# Network Communication Example in Tender

This project demonstrates how to perform DNS lookups, resolve TCP/UDP addresses, and establish a TCP connection using the **net** module in the **Tender** programming language. The script shows various network operations such as making HTTP requests over a TCP connection.

## Files Included

- **net.td**: The main script that performs DNS lookups, resolves TCP/UDP addresses, establishes a TCP connection, sends an HTTP request, and reads the response.

## Overview

The **net.td** script provides a hands-on example of how to interact with network services using Tender. It performs several key network-related tasks, such as:

- Resolving DNS names.
- Resolving TCP and UDP addresses.
- Creating a TCP connection.
- Sending data to a server and receiving the response.

## Running the Project

To run the project, execute the `net.td` script:

```bash
tender net.td
```

After running the script, the following network operations are performed:

1. A DNS lookup is made for `example.com`.
2. The TCP and UDP addresses for `example.com:80` are resolved.
3. A TCP connection is established, an HTTP GET request is sent to `example.com`, and the server's response is printed.

### Example Output

```bash
["93.184.215.14"]
93.184.215.14:80
93.184.215.14:80
Connected to:  {string: <user-function>, network: <user-function>}
Bytes written:  37
Response:  HTTP/1.1 200 OK
Accept-Ranges: bytes
Age: 219766
Cache-Control: max-age=604800
Content-Type: text/html; charset=UTF-8
Date: Sun, 20 Oct 2024 07:45:47 GMT
Etag: "3147526947"
Expires: Sun, 27 Oct 2024 07:45:47 GMT
Last-Modified: Thu, 17 Oct 2019 07:18:26 GMT
Server: ECAcc (nyd/D14E)
Vary: Accept-Encoding
X-Cache: HIT
Content-Length: 1256
...
```

## Project Structure

- **net.td**:
  - Resolves DNS, TCP, and UDP addresses for a given domain.
  - Establishes a TCP connection to `example.com` on port 80.
  - Sends an HTTP GET request and reads the response.
  - Closes the TCP connection after receiving the response.

### Code Breakdown

```tender
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
```

### How It Works

1. **net.dnslookup(hostname)**: Performs a DNS lookup to retrieve the IP addresses associated with the given hostname.
   
```tender
addresses := net.dnslookup("example.com")
println(addresses)  // Prints: ["93.184.215.14"]
```

2. **net.resolve_tcp_addr(network, address)**: Resolves the TCP address for the given network (e.g., "tcp") and address (e.g., "example.com:80").
   
```tender
tcp_addr := net.resolve_tcp_addr("tcp", "example.com:80")
println(tcp_addr)  // Prints: 93.184.215.14:80
```

3. **net.resolve_udp_addr(network, address)**: Resolves the UDP address in a similar manner to the TCP address.
   
```tender
udp_addr := net.resolve_udp_addr("udp", "example.com:80")
println(udp_addr)  // Prints: 93.184.215.14:80
```

4. **net.dialtcp(network, address)**: Establishes a TCP connection to the server at the given address.

```tender
conn := net.dialtcp("tcp", "example.com:80")
```

5. **conn.write(data)**: Sends data over the TCP connection. In this case, an HTTP GET request is sent.

```tender
msg := bytes("GET / HTTP/1.1\r\nHost: example.com\r\n\r\n")
n := conn.write(msg)
println("Bytes written: ", n)
```

6. **conn.read(buffer)**: Reads data from the connection into a buffer and prints the server's response.

```tender
buf := bytes(1024)
n = conn.read(buf)
println("Response: ", string(buf[:n]))
```

7. **conn.close()**: Closes the connection once the communication is complete.

```tender
conn.close()
```

## Customization

You can modify the host, message, or request data as needed. For example, to send a different HTTP request or interact with a different server, update the `msg` and domain name:

```tender
msg := bytes("GET /index.html HTTP/1.1\r\nHost: anotherdomain.com\r\n\r\n")
```

## License

This project is open-source. Feel free to contribute or use it in your own projects.

## Explore More

The **Network Communication Example** is part of the **1000+ Codes in Tender** collection. Visit the [Tender GitHub Repository](https://github.com/2dprototype/tender) for more examples and projects.
