# Hello World Scripts in Tender

## Overview

This repository contains two simple scripts, `hello.td` and `hello1.td`, that demonstrate basic output functionality in the [**Tender**](https://github.com/2dprototype/tender-free). These scripts showcase how to print a message to the console with and without color formatting.

## Scripts

### 1. `hello.td`

This script prints "hello world" to the console with a green background using the color formatting capabilities of Tender.

**Code Example:**
```tender
sysout "hello world\n".on_green
```

**Functionality:**
- Outputs "hello world" with a green background.

### 2. `hello1.td`

This script demonstrates how to check if the color formatting is available before printing. It prints "Hello, World!" with a green background if available; otherwise, it prints the message without color.

**Code Example:**
```tender
import "colors"

if colors.on_green != null {
    sysout colors.on_green + "Hello, World!" + colors.reset + "\n"
} else {
    sysout "Hello, World!\n"
}
```

**Functionality:**
- Validates the availability of the green background color.
- Outputs "Hello, World!" with a green background or in the default color if not available.

## Usage

- To run the scripts, use the following commands in your terminal:
    ```bash
    tender hello.td
    tender hello1.td
    ```
- Observe the different outputs, particularly how `hello1.td` handles color availability.

## Explore More

These scripts are part of the larger collection of examples in the 1000+ Codes in Tender repository. Feel free to explore and modify the code to enhance your understanding of output formatting and color manipulation in Tender!

## License

This project is open-source. Feel free to contribute or use it in your own projects.
