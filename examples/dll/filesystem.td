// tender@v0.0.2
import "dll"

kernel32 := dll.load("kernel32.dll")

// Example 1: Create directory
create_directory := kernel32.proc("CreateDirectoryW")
// result := create_directory.call("C:\\TenderTest", 0)
result := create_directory.call("TenderTest", 0)
println("Create directory result:", result)

// Example 2: Get current directory
get_current_directory := kernel32.proc("GetCurrentDirectoryW")
buffer := dll.memory().alloc(260)
length := get_current_directory.call(260, buffer)
if length > 0 {
    current_dir := dll.pointer().read_bytes(buffer, length)
    println(current_dir)
    println("Current directory:", string(current_dir))
}
dll.memory().free(buffer)

// Example 3: File operations
create_file := kernel32.proc("CreateFileW")
write_file := kernel32.proc("WriteFile")
close_handle := kernel32.proc("CloseHandle")

// Create a file
file_handle := create_file.call(
    "test.txt",                    // filename
    0x40000000,                   // GENERIC_WRITE
    0,                            // no sharing
    0,                            // security attributes
    2,                            // CREATE_ALWAYS
    0x00000080,                   // FILE_ATTRIBUTE_NORMAL
    0                             // no template
)

if file_handle != -1 {
    data := "Hello from Tender file operations!"
    data_bytes := bytes(data)
    data_ptr := dll.memory().alloc(len(data_bytes))
    dll.pointer().write_bytes(data_ptr, data_bytes)
    
    bytes_written := 0
    write_result := write_file.call(
        file_handle,
        data_ptr,
        len(data_bytes),
        dll.pointer().create(bytes_written),
        0
    )
    
    if write_result != 0 {
        println("File written successfully!")
    }
    
    close_handle.call(file_handle)
    dll.memory().free(data_ptr)
}