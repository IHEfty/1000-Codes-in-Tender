import "bufio"

line := bufio.readline()
println("Line read:", line)

// Read a string until a specific delimiter character
delimiter := "\n"
string_input := bufio.readstring(delimiter)
println("String read until delimiter:", string_input)

// Read a specified number of bytes
num_bytes := 10
bytes_read := bufio.readbytes(num_bytes)
println("Bytes read:", bytes_read)