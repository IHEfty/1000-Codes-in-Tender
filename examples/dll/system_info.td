// tender@v0.0.2
import "dll"

kernel32 := dll.load("kernel32.dll")
user32 := dll.load("user32.dll")

// Example 1: Get computer name
get_computer_name := kernel32.proc("GetComputerNameW")
buffer := dll.memory().alloc(256)
size_ptr := dll.memory().alloc(4)
dll.pointer().write_int(size_ptr, 256)

if get_computer_name.call(buffer, size_ptr) != 0 {
    computer_name := dll.pointer().read_bytes(buffer, 256)
    println("Computer name:", string(computer_name))
}

// Example 2: Get username
get_user_name := kernel32.proc("GetUserNameW")
buffer2 := dll.memory().alloc(256)
size_ptr2 := dll.memory().alloc(4)
dll.pointer().write_int(size_ptr2, 256)

if get_user_name && get_user_name.call(buffer2, size_ptr2) != 0 {
    username := dll.pointer().read_bytes(buffer2, 256)
    println("Username:", username)
}

// Example 3: Get system info
get_system_info := kernel32.proc("GetSystemInfo")
sys_info_buffer := dll.memory().alloc(48) // SYSTEM_INFO size
get_system_info.call(sys_info_buffer)

// Read processor architecture (first field)
arch := dll.pointer().read_int(sys_info_buffer)
println("Processor architecture:", arch)

// Clean up
dll.memory().free(buffer)
dll.memory().free(size_ptr)
dll.memory().free(buffer2)
dll.memory().free(size_ptr2)
dll.memory().free(sys_info_buffer)