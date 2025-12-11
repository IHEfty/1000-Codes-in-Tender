// tender@v0.0.2
import "dll"

// Load necessary DLLs
user32 := dll.load("user32.dll")
kernel32 := dll.load("kernel32.dll")

// Define constants
MB_OK := 0x00000000
MB_YESNO := 0x00000004
MB_ICONINFO := 0x00000040
IDYES := 6
IDNO := 7
SW_SHOW := 5

// Example 1: Simple Message Box
show_message_box := user32.proc("MessageBoxW")
result := show_message_box.call(0, "Hello from Tender!", "Tender GUI Example", MB_OK)
println("Message box result:", result)

// Example 2: Yes/No Dialog
result = show_message_box.call(0, "Do you like Tender?", "Question", MB_YESNO | MB_ICONINFO)
if result == IDYES {
    println("User clicked Yes!")
} else {
    println("User clicked No!")
}

// Example 3: Get System Directory
get_system_directory := kernel32.proc("GetSystemDirectoryW")
buffer := dll.memory().alloc(260) // MAX_PATH
length := get_system_directory.call(buffer, 260)
if length > 0 {
    system_dir := dll.pointer().read_bytes(buffer, 260)
    println("System directory:", string(system_dir))
}
dll.memory().free(buffer)

// Example 4: Beep with different frequencies
beep_proc := kernel32.proc("Beep")
beep_proc.call(500, 300)  // 500Hz for 300ms
beep_proc.call(1000, 200) // 1000Hz for 200ms