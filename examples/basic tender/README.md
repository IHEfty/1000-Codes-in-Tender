# Basic Tender

This project is part of the **1000+ Codes in Tender** collection, demonstrating the use of various libraries and functions in Tender to perform geometry calculations and temperature conversions. The scripts cover basic concepts such as input handling, type conversion, and arithmetic operations.

## Overview

This project includes the following scripts:

1. **c2f.td**: Converts a temperature from Celsius to Fahrenheit.
2. **f2c.td**: Converts a temperature from Fahrenheit to Celsius.
3. **cal.td**: Performs basic arithmetic operations on two numbers.
4. **circle.td**: Calculates the area of a circle given its radius.
5. **triangle.td**: Calculates the area of a triangle given its height and width.

Each script makes use of key libraries in Tender to streamline input/output and mathematical calculations. Here’s an overview of these libraries:

### Libraries Used

- **bufio**: Provides functions for buffered input and output. In each script, `bufio.readline()` is used to read input from the user.
- **strings (as strs)**: This library, aliased as `strs`, is used for string manipulation. `strs.trim_space()` is used to remove any whitespace from user input to ensure clean data handling.
- **math (as mt)**: This library, aliased as `mt`, contains mathematical functions and constants. Here, it provides `mt.pi` for calculating areas involving circles.

## Running the Scripts

To run each script, use the `tender` command in your terminal.

### For Temperature Conversion

#### Celsius to Fahrenheit (`c2f.td`)

```bash
tender c2f.td
```

- **Input**: Enter a temperature in Celsius.
- **Output**: Displays the converted temperature in Fahrenheit.

#### Fahrenheit to Celsius (`f2c.td`)

```bash
tender f2c.td
```

- **Input**: Enter a temperature in Fahrenheit.
- **Output**: Displays the converted temperature in Celsius.

### For Basic Calculations (`cal.td`)

```bash
tender cal.td
```

- **Input**: Enter two numbers for calculation.
- **Output**: Displays the results of addition, subtraction, multiplication, and division on the two numbers.

### For Area Calculations

#### Circle Area (`circle.td`)

```bash
tender circle.td
```

- **Input**: Enter the radius of the circle.
- **Output**: Displays the calculated area of the circle.

#### Triangle Area (`triangle.td`)

```bash
tender triangle.td
```

- **Input**: Enter the height and width of the triangle.
- **Output**: Displays the calculated area of the triangle.

## Script Details

Each script is structured to handle user input and perform necessary operations in an efficient manner. Here’s a breakdown of the key components.

### Common Components

#### Input Handling

In all scripts, user input is handled as follows:

```tender
input := bufio.readline()
input = strs.trim_space(input)
```

- `bufio.readline()`: Reads input from the user. This method waits for the user to enter a value before proceeding.
- `strs.trim_space()`: Removes any leading or trailing whitespace from the input, ensuring clean data processing. This is especially helpful for cases where accidental spaces may interfere with the script’s execution.

#### Type Conversion

After obtaining the input, it is converted to a `float` to ensure compatibility with mathematical operations:

```tender
variable := float(input)
```

Using `float` conversion is important for arithmetic and temperature conversion scripts because it allows handling decimal values, which are common in both temperature and geometry calculations.

### c2f.td (Celsius to Fahrenheit)

- **Description**: This script converts a Celsius temperature to Fahrenheit.
- **Logic**:
  - Reads a Celsius temperature from the user.
  - Uses the formula `F = (C * 9/5) + 32` to convert to Fahrenheit.
  - Outputs the converted temperature.

**Example Code**:
```tender
c := float(input)         // Convert Celsius input to float
f := (c*9/5)+32           // Apply formula for Fahrenheit
print(f)                  // Display result
```

### f2c.td (Fahrenheit to Celsius)

- **Description**: This script converts a Fahrenheit temperature to Celsius.
- **Logic**:
  - Reads a Fahrenheit temperature from the user.
  - Uses the formula `C = (F - 32) * 5/9` to convert to Celsius.
  - Outputs the converted temperature.

**Example Code**:
```tender
f := float(input)         // Convert Fahrenheit input to float
c := (f-32)*5/9           // Apply formula for Celsius
print(c)                  // Display result
```

### cal.td (Basic Calculations)

- **Description**: This script performs addition, subtraction, multiplication, and division on two numbers.
- **Logic**:
  - Reads two numbers from the user.
  - Calculates and displays the sum, difference, product, and quotient of the two numbers.

**Example Code**:
```tender
a := float(input)         // First number
b := float(inputt)        // Second number
sum := a + b              // Addition
sub := a - b              // Subtraction
mul := a * b              // Multiplication
div := a / b              // Division
```

### circle.td (Circle Area)

- **Description**: This script calculates the area of a circle.
- **Logic**:
  - Reads the radius of a circle from the user.
  - Uses the formula `Area = π * R^2` to compute the area, using `mt.pi`.
  - Outputs the area.

**Example Code**:
```tender
R := float(input)         // Radius of the circle
area := mt.pi * R * R     // Area formula using π
print("Circle Area >", area)
```

### triangle.td (Triangle Area)

- **Description**: This script calculates the area of a triangle.
- **Logic**:
  - Reads the height and width of the triangle from the user.
  - Uses the formula `Area = 0.5 * Height * Width` to compute the area.
  - Outputs the area.

**Example Code**:
```tender
h := float(input)         // Height of the triangle
w := float(inputt)        // Width of the triangle
area := 0.5 * h * w       // Area formula for triangle
print("Triangle Area >", area)
```

## Project Structure

- **c2f.td**: Celsius to Fahrenheit conversion.
- **f2c.td**: Fahrenheit to Celsius conversion.
- **cal.td**: Basic arithmetic operations.
- **circle.td**: Circle area calculation.
- **triangle.td**: Triangle area calculation.

## License

This project is open-source. Feel free to contribute or use it in your own projects.

## Explore More

These scripts are part of the **1000+ Codes in Tender** repository. Explore other codes to deepen your understanding of basic programming concepts in Tender!
