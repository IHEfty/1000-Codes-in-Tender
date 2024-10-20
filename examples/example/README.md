# Tender Example: Variables, Data Structures, and Control Flow

This repository contains an example script written in the **Tender** programming language. The script demonstrates variable definitions, data types, control flow statements, functions, and more.

## Overview

The `example.td` script showcases various features of the Tender language, including:

- Variable definitions and primitive types
- Dynamic type assignments
- Data structures: maps and arrays
- Slicing operations
- Function definitions and higher-order functions
- Tail-call optimization
- Type coercion
- Control flow using if and for statements

## Code Breakdown

### 1. Variable Definitions and Primitive Types

The script starts by defining variables of different types:

```tender
a := "foo"   // String
b := -19.84  // Floating point
c := 5       // Integer
d := true    // Boolean
e := '?'     // Char

fmt.println("a: ", a) // Print using fmt
println("b: ", b)
println("c: ", c)
println("d: ", d)
println("e: ", e)
```

### 2. Assignment

Demonstrates the ability to reassign variables to different types:

```tender
b = "bar"    // Can assign a value of different type
println("b: ", b)
```

### 3. Maps and Arrays

Shows how to create and print a nested map and an array:

```tender
m := {a: {b: {c: [1, 2, 3]}}}
println("m: ", m)
```

### 4. Slicing

Demonstrates slicing on strings and arrays:

```tender
str := "hello world"
println(str[1:5])    // "ello"

arr := [1, 2, 3, 4, 5]
println(arr[2:4])    // [3, 4]
```

### 5. Functions

Defines a function for iterating through an array and another for summing its elements:

```tender
each := fn(seq, fun) {
    for x in seq {
        fun(x)
    }
}

sum := fn(seq) {
    s := 0
    each(seq, fn(x) {
        s += x    // Closure: capturing variable 's'
    })
    return s
}
println("sum: ", sum([1, 2, 3])) // 6
```

### 6. Map to Array Conversion

Converts a map to an array:

```tender
fn map_to_array (m) {
    arr := []
    for key, value in m {
        arr = append(arr, key, value)  // Built-in function 'append'
    }
    return arr
}

m_arr := map_to_array(m)
println(m_arr, " (len: ", len(m_arr), ")")
```

### 7. Tail-Call Optimization

Demonstrates recursive function calls with tail-call optimization:

```tender
count_odds := fn(n, c) {
    if n == 0 {
        return c
    } else if n % 2 == 1 {
        c++
    }
    return count_odds(n-1, c)
}
num_odds := count_odds(100000, 0)
println(num_odds) // 50000
```

### 8. Type Coercion

Shows type coercion between different types:

```tender
s1 := string(1984)  // "1984"
i2 := int("-999")   // -999
f3 := float(-51)    // -51.0
b4 := bool(1)       // true
c5 := char(88)      // 'X'
```

### 9. Control Flow

Demonstrates if statements and for loops:

```tender
if three := 3; three > 2 {  // Optional init statement
    println("three > 2")
} 
else if three == 2 {
    println("three = 2")
} 
else {
    println("three < 2")
}

seven := 0
arr2 := [1, 2, 3, 1]
for i := 0; i < len(arr2); i++ {
    seven += arr2[i]
}
println("seven: ", seven)
```

## Running the Example

To execute the script, use the following command:

```bash
tender example.td
```

### Expected Output

When you run the script, you should see the following output:

```
a:  foo
b:  -19.84
c:  5
d:  true
e:  ?
b:  bar
m:  {a: {b: {c: [1, 2, 3]}}}
ello
[3, 4]
sum:  6
["a", {b: {c: [1, 2, 3]}}]  (len:  2 )
50000
three > 2
seven:  7
```

## Dependencies

Ensure you have the **Tender** programming language installed. For installation instructions, visit the [Tender GitHub Repository](https://github.com/2dprototype/tender).

## License

This project is open-source and can be freely modified and distributed.

## Further Exploration

For additional examples and utilities, check out the rest of the **1000+ Codes in Tender** collection in the [Tender GitHub Repository](https://github.com/2dprototype/tender).
