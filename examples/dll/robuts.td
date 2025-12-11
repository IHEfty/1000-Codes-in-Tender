// tender@v0.0.2

import "dll"

// Robust error handling example
user32 := dll.new("user32.dll") // Using lazy loading

show_message_box := user32.proc("MessageBoxW")
if show_message_box != null {
    result := show_message_box.call(0, "Test message", "Test", 0)
    if result == 0 {
        error_code := dll.last_error()
        println("MessageBox failed with error:", error_code)
    } else {
        println("MessageBox succeeded, result:", result)
    }
} else {
    println("Failed to get MessageBoxW procedure")
}

// Memory management with error checking
mem := dll.memory().alloc(100)
if mem.address != 0 {
    println("Memory allocated at:", mem.address)
    
    // Use the memory
    dll.pointer().write_int(mem, 1234)
    value := dll.pointer().read_int(mem)
    println("Stored value:", value)
    
    // Clean up
    free_result := dll.memory().free(mem)
    if free_result {
        println("Memory freed successfully")
    } else {
        println("Failed to free memory")
    }
} else {
    println("Failed to allocate memory")
}