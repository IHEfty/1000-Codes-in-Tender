# Getting Started  

**Tender** is a flexible programming language designed for simplicity and power. Let’s dive in!

---

## **1. Variables in Tender**  

In Tender, variables are defined using the `:=` operator along with `var`. You don’t need to declare the type explicitly—Tender infers the type based on the assigned value.

### **Example: Variable Declaration**  
```go
name := "Alice"    // String variable  
age := 30          // Integer variable  
pi := 3.14         // Floating-point variable  
is_admin := false  // Boolean variable
var year = bigint(2024) //bigint datatype
```



### **Reassigning Variables**  
Variables in Tender are **dynamically typed**, meaning you can assign a value of a different type to an existing variable.

```go
age = "Thirty"  // Now 'age' holds a String instead of an Integer
println(age)    // Output: Thirty
```

---

## **2. Data Types**  

Tender supports several primitive data types:

| **Type**     | **Example**              | **Description**                    |
|--------------|--------------------------|------------------------------------|
| string       | `"Hello"`                | Sequence of characters.            |
| int          | `42`                     | Whole numbers.                     |
| float        | `-19.84`                 | Numbers with decimal points.       |
| bool         | `true` / `false`         | Logical values.                    |
| char         | `'A'`                    | Single character.                  |
| time         | `time()`                 | time (`time.Time` in Go)           |
| bigint       | `bigint(42)`             | Arbitrary-precision integer.       |
| bigfloat     | `bigfloat(1000.11)`      | Arbitrary-precision float.         |

---

## **3. Arrays and Maps**  

### **Arrays**  
Arrays hold an ordered list of values. They can contain elements of any type.  
```go
fruits := ["Apple", "Banana", "Cherry"]  
println(fruits[0])  // Output: Apple
```

### **Maps**  
Maps are key-value pairs, similar to dictionaries in other languages.  
```go
person := {name: "Alice", age: 30, is_admin: true}  
println(person["name"])  // Output: Alice
```

---

## **4. Control Flow Statements**  

### **If/Else Statements**  
Tender supports `if/else` for decision-making. You can include an **init statement** before the condition.  
```go
if age := 30; age > 18 {
    println("Adult")
}
else {
    println("Minor")
}
```

---

## **5. Loops**  

### **For Loop**  
The `for` loop is used to iterate over arrays or perform repeated actions.  
```go
numbers := [1, 2, 3, 4]
for i := 0; i < len(numbers); i++ {
    println(numbers[i])
}
```

### **For-Each Loop**  
```go
var fruits = ["mango", "apple", "banana"]

for i, fruit in fruits {
	if fruit == apple {
		continue
	}
	else if fruit i == fruits.length {
		break
	}
    println(fruit)
}
```

### **For-condition**  

```go
for true {
    println(fruit)
}
```

### **For-infinity**  

```go
for {}
```

---

## **6. Functions in Tender**  

Functions are defined using the `fn` keyword. Functions can take arguments and return values.

### **Defining a Function**  
```go
greet := fn(name) {
    return "Hello, " + name
}
println(greet("Alice"))  // Output: Hello, Alice
```

*or*

```go
fn greet(name) {
    return "Hello, " + name
}
println(greet("Alice"))  // Output: Hello, Alice
```

### **Passing Functions as Arguments**  
Tender supports higher-order functions—functions that take other functions as parameters.  
```go
each := fn(arr, action) {
    for x in arr {
        action(x)
    }
}
each([1, 2, 3], fn(n) {
    println(n)
})
```

---

## **7. Closures**  

Closures are functions that capture variables from their outer scope.  
```go
counter := fn() {
    count := 0
    return fn() {
        count += 1
        return count
    }
}
next := counter()
println(next())  // Output: 1
println(next())  // Output: 2
```

---

## **8. Recursion and Tail-Call Optimization**  

Tender supports recursion and optimizes tail-recursive calls for better performance.  
```go
factorial := fn(n, acc) {
    if n == 0 {
        return acc
    }
    return factorial(n - 1, acc * n)
}
println(factorial(5, 1))  // Output: 120
```

---

## **9. Slicing Strings and Arrays**  

You can extract parts of strings or arrays using **slices**.  
```go
str := "hello world"
println(str[0:5])  // Output: hello

arr := [10, 20, 30, 40, 50]
println(arr[1:4])  // Output: [20, 30, 40]
```

---

## **10. Type Conversion**  

Tender provides built-in functions to convert between data types.  
```go
str_num := string(42)  // "42"
int_num := int("99")   // 99
float_num := float(3)  // 3.0
bool_val := bool(1)    // true
```

## **12. Built-in Functions**  

| **Function**   | **Description**                           |
|----------------|-------------------------------------------|
| `println()`    | Prints output to the console.             |
| `len()`        | Returns the length of an array or string. |
| `append()`     | Adds elements to an array.                |
|more...||

See all [builtin functions](builtins.md)!

---
# 1000+ Codes in Tender

Welcome to **1000+ Codes in Tender**! This project is a comprehensive collection of code snippets and examples designed to help developers learn and utilize the Tender effectively. Whether you are a beginner or an experienced developer, you will find a variety of practical examples and tutorials that cover a wide range of functionalities in [**Tender**](https://github.com/2dprototype/tender).

## Table of Contents
- [Introduction](#introduction)
- [Installation](#installation)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Included Scripts](#included-scripts)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)

## Introduction

Tender is a general-purpose programming language optimized for image processing, 2D graphics, and scripting. This repository contains over 1000 code snippets demonstrating various features and libraries within Tender, making it an excellent resource for learning and experimentation.

## Installation

To get started with Tender, follow these steps:

1. **Install Go**: Ensure you have the latest version of Go installed on your machine. You can download it from [golang.org](https://golang.org/dl/).

2. **Install Tender**: Use the following command to install Tender:
   ```bash
   go install github.com/2dprototype/tender/cmd/tender@latest
   ```

   Alternatively, you can download precompiled binaries from the [Tender Releases](https://github.com/2dprototype/tender/releases) page. Choose the appropriate binary for your operating system and follow the installation instructions provided there.

3. **Clone the Repository**:
   ```bash
   git clone https://github.com/IHEfty/1000-codes-in-tender.git
   cd 1000-codes-in-tender
   ```

## Usage

After cloning the repository, you can run any of the example codes provided:

1. Navigate to the example directory:
   ```bash
   cd examples folder
   ```

2. Run a specific Tender script:
   ```bash
   tender example_script.td
   ```

Feel free to explore the various code snippets and modify them as needed to fit your projects.

## Project Structure

The project is organized as follows:

```
examples
├── benzene
│   ├── benzene.td
│   └── ...
├── ...
└── count.td
```

- **examples/**: Contains various Tender scripts demonstrating different functionalities.
- **README.md**: This documentation file.
- **LICENSE**: The license for this project.

## Included Scripts

### `count.td`

The `count.td` script counts the total number of `.td` files in the current directory and its subdirectories. It provides a simple way to track how many Tender scripts you have, which can be useful for project organization or inventory purposes.

## Preview

![preview](./count/preview.png)

**How It Works**:
1. **Walks the Directory**: The script uses the `path.walklist` function to retrieve a list of files in the current directory.
2. **Counts `.td` Files**: It iterates through the list and checks each file's extension. If the extension is `.td`, it increments a counter and adds the file to a list.
3. **Outputs Results**: Finally, it prints the total count of `.td` files and lists them.

**To Run `count.td`**:
```bash
tender count.td
```

## Contributing

Contributions are welcome! If you have code snippets or examples that you would like to share, please follow these steps:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/YourFeature`).
3. Make your changes and commit them (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature/YourFeature`).
5. Open a Pull Request.

## License

This project is open-source. Feel free to contribute or use it in your own projects.

## Acknowledgments

A special thanks to the creators of Tender and all contributors to the Tender community. Your hard work and dedication make this project possible!
