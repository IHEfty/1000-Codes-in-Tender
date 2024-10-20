# Tender Utilities and Examples

This project contains various utility scripts written in the **Tender** programming language, showcasing functionalities such as big integer and float operations, formatted output, input/output handling, colorized console output, GOB encoding/decoding, and data wrapping.

## Files Included

1. **big_intfloat.td**: Demonstrates the usage of big integers and big floats in Tender.
2. **fmt_fprint.td**: Shows how to use formatted printing with colors.
3. **io_reader.td**: Provides examples of reading input from the standard input.
4. **io_writer.td**: Demonstrates writing output to a file by executing a command.
5. **output.txt**: Stores the output from the command executed in `io_writer.td`.
6. **stdlib_colors.td**: Shows how to use colors in the console output.
7. **stdlib_gob.td**: Demonstrates GOB encoding and decoding in Tender.
8. **wrapper.td**: Provides an example of wrapping and unwrapping data structures.

## Overview of Each File

### 1. **big_intfloat.td**
**To Run `big_intfloat.td`**:
```bash
tender big_intfloat.td
```
This script demonstrates the creation and manipulation of big integers and big floats in Tender.

```tender
var bi1 = bigint(1000000000000000000000000000000000000000000000000000)
var bi2 = bigint("1000000000000000000000000000000000000000000000000000")
var bi3 = 10000000000000000000000000000000000000000000000000000000000000000000000000

var bf1 = bigfloat(1000000000000000000000000000000000000000000000000000.001)
var bf2 = bigfloat("1000000000000000000000000000000000000000000000000000.001")
var bf3 = 1000e1000

println(bi1)
println(bi2)
println(bi3)

println(bf1)
println(bf2)
println(bf3)
```

### 2. **fmt_fprint.td**
**To Run `fmt_fprint.td`**:
```bash
tender fmt_fprint.td
```
This script demonstrates formatted printing with color support using the `fmt` and `colors` modules.

```tender
import "fmt"
import "colors"
import "os"

fmt.fprint(colors.stdout, "Hello".red, "World".green, "\n")
fmt.fprintln(colors.stderr, "Hello".red, "World".green)
fmt.fprintln(os.stdout, "Hello".red, "World".green, "\n")
```

### 3. **io_reader.td**
**To Run `io_reader.td`**:
```bash
tender io_reader.td
```
This script showcases reading from the standard input and using the `io` module.

```tender
import "io"
import "os"

reader := os.stdin
io.read_full(reader, "\n")
println("done")
io.read_all(reader)
```

### 4. **io_writer.td**
**To Run `io_writer.td`**:
```bash
tender io_writer.td
```
This script demonstrates how to write the output of a command to a file.

```tender
import "os"

file := os.create("output.txt")
cmd := os.exec("go", "version")
cmd.stdout(file.writer)
cmd.stderr(file.writer)
cmd.start()
```

### 5. **output.txt**

This file contains the output from the command executed in `io_writer.td`:

```
go version go1.22.3 windows/amd64
```

### 6. **stdlib_colors.td**
**To Run `stdlib_colors.td`**:
```bash
tender stdlib_colors.td
```
This script demonstrates the usage of colors in the console output.

```tender
import "colors"

cout := colors.stdout
cout.write("\x1b[0;32mhello world\x1b[0m\n")
cerr := colors.stderr
cerr.write("\x1b[0;31mtender script\x1b[0m\n")
```

### 7. **stdlib_gob.td**
**To Run `stdlib_gob.td`**:
```bash
tender stdlib_gob.td
```
This script demonstrates GOB encoding and decoding of data structures in Tender.

```tender
import "gob"

var map = {x:100,y:immutable([1,2,3,5])}
encoded := gob.encode(map)
decoded := gob.decode(encoded)

println(encoded)
println(decoded)
```

### 8. **wrapper.td**
**To Run `wrapper.td`**:
```bash
tender wrapper.td
```
This script demonstrates wrapping and unwrapping data structures in Tender.

```tender
var map = {x:100}
var wrapped_map = wrap(map)

println(wrapped_map)
println(wrapped_map.x)
println(unwrap(wrapped_map))
```

## Dependencies

Make sure you have the **Tender** programming language installed. You can find installation instructions on the [Tender GitHub Repository](https://github.com/2dprototype/tender).

## License

This project is open-source and can be freely modified and distributed.

## Explore More

For additional examples and utilities, check out the rest of the **1000+ Codes in Tender** collection in the [Tender GitHub Repository](https://github.com/2dprototype/tender).
