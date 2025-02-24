# Tender Example: Variables, Data Structures, and Control Flow

This repository contains a brief example script demonstrating key features of the **Tender** programming language.

## Key Concepts

- **Variable Definitions & Types**: Variables can hold different types like strings, integers, floats, booleans, and characters.
- **Data Structures**: Tender supports maps (key-value pairs) and arrays. You can manipulate and access data easily.
- **Control Flow**: Use `if` statements and `for` loops for conditional checks and iterations.
- **Functions & Closures**: Define functions that can capture variables from the outer scope (closures). Tail-call optimization is also supported.
- **Type Coercion**: Tender automatically converts between types such as strings, integers, floats, booleans, and characters.

## How It Works

- Variables are defined with `:=` and can later be reassigned with `=`.
- **Maps** and **Arrays** are supported for storing data. You can slice strings and arrays to extract parts.
- Functions are created using `fn`, and they can take parameters and return values. Higher-order functions are supported for more flexibility.
- The script shows an example of summing elements in an array and recursively counting odd numbers with tail-call optimization.
- Control flow allows for complex logic using `if` conditions and `for` loops.
- Tender supports automatic type conversion for smoother interactions between different data types.

## Running the Example

To run the script, simply use the following command:

```bash
tender example.td
```

## Output

The script will output values for variables, maps, arrays, and results of the functions as specified in the code.
