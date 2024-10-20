# Dynamic Link Library (DLL) Example in Tender

This project demonstrates how to use a **Dynamic Link Library (DLL)** in the [**Tender**](https://github.com/2dprototype/tender). By leveraging the `dll` module, you can load external functions from a compiled DLL file and call them directly in your Tender scripts. This example shows how to use a DLL function to perform a simple addition.

## Files Included

- **dll.td**: The Tender script that loads the DLL and calls a function from it.
- **example_dll.c**: The C source code that contains the `add` function, which is compiled into the DLL.
- **example_dll.dll**: The compiled DLL file that is loaded by the `dll.td` script.

## Overview

The **dll.td** script demonstrates the following key steps:
1. Loading a DLL file.
2. Retrieving a function (`add`) from the DLL.
3. Calling the function with arguments.
4. Displaying the result.

### Example DLL Function

The DLL contains a simple function that adds two integers:

```c
int add(int a, int b) {
    return a + b;
}
```

## Running the Project

To run the project, ensure you have the necessary DLL file (`example_dll.dll`) and the corresponding Tender script (`dll.td`). Use the following command to execute the script:

```bash
tender dll.td
```

### Expected Output

When you run the `dll.td` script, the following output should be displayed:

```
Result of addition: 7
```

This confirms that the DLL's `add` function has been successfully called with the arguments `3` and `4`, and the result (`7`) is correctly printed.

## Project Structure

- **dll.td**: 
  - Loads the DLL using the `dll.load` function.
  - Retrieves the `add` function from the DLL.
  - Calls the `add` function with two integer arguments (3 and 4).
  - Prints the result to the console.

- **example_dll.c**: 
  - A simple C program containing the `add` function that adds two integers.
  - Compile this file to create the DLL (`example_dll.dll`).

- **example_dll.dll**: 
  - The compiled DLL that contains the `add` function.

### Example Usage in `dll.td`

```tender
import "dll"

// Load the DLL
my_dll := dll.load("example_dll.dll")

// Get the 'add' function from the DLL
add_func := my_dll.proc("add")

// Call the 'add' function with arguments
result := add_func.call(3, 4)

// Print the result
println("Result of addition:", result)  // Output: Result of addition: 7
```

## Compiling the DLL

If you want to modify or compile the `example_dll.c` file, you can use the following command on a machine with a C compiler:

### Windows (using MinGW or similar):
```bash
gcc -shared -o example_dll.dll example_dll.c
```

This will generate a new DLL file that you can load using the Tender script.

## License

This project is open-source. Feel free to contribute or use it in your own projects.

## Explore More

The **DLL Example in Tender** is part of the **1000+ Codes in Tender** collection. Visit the [Tender GitHub Repository](https://github.com/2dprototype/tender) for more examples and projects.
