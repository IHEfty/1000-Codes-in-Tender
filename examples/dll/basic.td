// tender@v0.0.2

import "dll"

// Example 1: Basic error handling
kernel32 := dll.load("kernel32.dll")
get_error_proc := kernel32.proc("GetLastError")
error_code := get_error_proc.call()
println("Last error code:", error_code)

// Example 2: Memory allocation and basic operations
mem := dll.memory().alloc(1024)
dll.pointer().write_int(mem, 42)
value := dll.pointer().read_int(mem)
println("Written value:", value)

// Example 3: Working with strings in memory
text_ptr := dll.memory().alloc(100)
dll.pointer().write_bytes(text_ptr, bytes("Hello, World!"))
read_text := dll.pointer().read_bytes(text_ptr, 13)
println("Read text:", string(read_text))

// Clean up
dll.memory().free(mem)
dll.memory().free(text_ptr)