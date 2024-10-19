# Number Operations

The **Number Operations** project is part of the **1000+ Codes in Tender** collection. This project, written in the [**Tender**](https://github.com/2dprototype/tender), demonstrates various numeric operations and type conversions using different numeric types. It provides insights into how different types interact with arithmetic operations and comparisons.

## Overview

This project consists of two scripts:

1. **num.td**: Tests comparisons between different numeric types.
2. **num1.td**: Implements basic arithmetic operations (addition, subtraction, multiplication, and division) using various numeric types.

## Running the Projects

To run the **Number Operations** projects, execute the following commands in your terminal:

### For `num.td`

```bash
tender num.td
```

### For `num1.td`

```bash
tender num1.td
```

## Script Details

### num.td

The **num.td** script performs the following tasks:

1. **Define Numeric Types**: 
   - A list of numeric types is created: `int`, `float`, `bigint`, and `bigfloat`.

2. **Initialize Variables**: 
   - Two variables, `x` and `y`, are both initialized to `10`.

3. **Iterate Through Types**: 
   - Nested loops iterate through each combination of the defined numeric types. For each combination:
     - Convert `x` and `y` to the respective types.
     - Perform various comparisons between the converted values and the original `x` and `y`.

4. **Print Comparisons**: 
   - The script prints the results of comparisons including greater than, less than, greater than or equal to, less than or equal to, equality, and inequality.
   - This allows you to observe how different numeric types behave in comparison operations.

**Example Output for `num.td`:**
```
int  int  true false false false false true
int  float  true false false false false true
int  bigint  true false false false false true
int  bigfloat  true false false false false true
...
bigfloat  bigfloat  true false false false false true
```

### num1.td

The **num1.td** script performs basic arithmetic operations as follows:

1. **Define Arithmetic Functions**: 
   - Four functions are defined: 
     - `add(x, y)`: Returns the sum of `x` and `y`.
     - `sub(x, y)`: Returns the difference of `x` and `y`.
     - `mul(x, y)`: Returns the product of `x` and `y`.
     - `div(x, y)`: Returns the quotient of `x` and `y`.

2. **Logging with Debugging**: 
   - Each function logs its inputs and outputs using the `debug` function for easy tracking of results.

3. **Iterate Through Types**: 
   - Similar to `num.td`, nested loops iterate through each combination of the defined numeric types.
   - Each function is called with `100` and `55` as inputs, showcasing how operations vary with different numeric types.

4. **Print Results**: 
   - The results of each operation are printed to the console.

**Example Output for `num1.td`:**
```
add int int int 155
add int float float 155.0
add int bigint bigint 155
add int bigfloat bigfloat 155.0
...

div bigfloat bigfloat bigfloat 1.8181818181818181
```

## Project Structure

- **num.td**: 
  - The main script for testing comparisons between different numeric types.
  - Contains logic for type conversion and comparison operations.

- **num1.td**: 
  - The main script for implementing basic arithmetic operations.
  - Contains functions for addition, subtraction, multiplication, and division with debugging outputs.

## License

This project is open-source. Feel free to contribute or use it in your own projects.

## Explore More

The **Number Operations** project is one of many examples in the **1000+ Codes in Tender** repository. Feel free to explore and modify the code to enhance your understanding of numeric types and operations in Tender!
