// tender@v0.0.2
import "dll"

kernel32 := dll.load("kernel32.dll")

// Example 1: Get current process ID
get_current_process_id := kernel32.proc("GetCurrentProcessId")
pid := get_current_process_id.call()
println("Current Process ID:", pid)

// Example 2: Get current thread ID
get_current_thread_id := kernel32.proc("GetCurrentThreadId")
tid := get_current_thread_id.call()
println("Current Thread ID:", tid)

// Example 3: Sleep function
sleep := kernel32.proc("Sleep")
println("Sleeping for 2 seconds...")
sleep.call(2000) // 2000 milliseconds
println("Awake!")

// Example 4: Get tick count
get_tick_count := kernel32.proc("GetTickCount")
start_time := get_tick_count.call()
sleep.call(1000)
end_time := get_tick_count.call()
println("Elapsed time:", end_time - start_time, "ms")