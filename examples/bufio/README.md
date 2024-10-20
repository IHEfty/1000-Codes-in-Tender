# Buffered I/O (bufio) Example in Tender

This project demonstrates how to use the **Buffered I/O** (`bufio`) module in the **Tender** programming language. By utilizing `bufio`, you can read input efficiently by line, string, or bytes from standard input.

## Files Included

- **bufio.td**: The Tender script that demonstrates the usage of the `bufio` module for reading input in different formats.

## Overview

The **bufio.td** script showcases three primary methods for reading input:
1. Reading a line from standard input.
2. Reading a string until a specified delimiter (e.g., newline `\n`).
3. Reading a specific number of bytes from input.

## Running the Project

To run the project, execute the `bufio.td` script in your terminal:

```bash
tender bufio.td
```

The script will wait for user input and process it based on the method being used (readline, readstring, or readbytes).

### Example Interaction

1. **Reading a Line**: When prompted, enter a line of text, and the script will read and display the entire line.
   ```bash
   Line read: Hello, Tender!
   ```

2. **Reading a String Until a Delimiter**: The script will read input until the specified delimiter (e.g., newline `\n`). This allows you to process input up to a certain character.
   ```bash
   String read until delimiter: Welcome to Buffered I/O
   ```

3. **Reading a Specified Number of Bytes**: The script will read and display a specified number of bytes from the input stream.
   ```bash
   Bytes read: 10
   ```

## Project Structure

- **bufio.td**:
  - Uses the `bufio.readline()` function to read a full line from standard input.
  - Uses the `bufio.readstring()` function to read input until a specific delimiter (e.g., newline `\n`).
  - Uses the `bufio.readbytes()` function to read a defined number of bytes from the input.

### Code Breakdown

```tender
import "bufio"

// Read a full line from standard input
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
```

### Function Descriptions

- **bufio.readline()**:
  Reads a single line of text from the input until the newline character is encountered.

- **bufio.readstring(delimiter)**:
  Reads a string of input from the user until the specified delimiter (in this case, a newline `\n`).

- **bufio.readbytes(num_bytes)**:
  Reads a specified number of bytes from the input stream and returns the result as a string.

## Customizing Input

You can easily modify the number of bytes to read or change the delimiter by adjusting the `num_bytes` or `delimiter` variables within the script.

For example, to read 20 bytes instead of 10, you can update:
```tender
num_bytes := 20
```

## License

This project is open-source. Feel free to contribute or use it in your own projects.

## Explore More

The **bufio** example is part of the **1000+ Codes in Tender** collection. Visit the [Tender GitHub Repository](https://github.com/2dprototype/tender) for more examples and projects.
