// tender example.td
import "dll"

// Load the DLL
my_dll := dll.load("example_dll.dll")

// Get the 'add' function from the DLL
add_func := my_dll.proc("add")

// Call the 'add' function with arguments
result := add_func.call(3, 4)

// Print the result
println("Result of addition:", result)  // Output: Result of addition: 7
