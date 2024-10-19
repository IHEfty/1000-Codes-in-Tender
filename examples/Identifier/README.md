# Identifier Example in Tender

## Overview

The `iden.td` script showcases the use of identifiers in the Tender, including the ability to use non-English characters. This example highlights how variables and objects can be defined and utilized with identifiers that include Unicode characters.

## Features

- **Variable Declaration**: Demonstrates declaring a variable using a non-English identifier.
- **Object Creation**: Shows how to create an object with properties defined using non-English identifiers.
- **Output**: Prints the values of the variable and the object to the console.

## Code Explanation

```tender
var コンピュータ = 100  // Declare a variable with a non-English identifier

println(コンピュータ)  // Output the value of the variable

obj := {              // Create an object with a property using a non-English identifier
	コンピュータ: 1000
}

println(obj)         // Output the object to the console
```

### Breakdown:

- `var コンピュータ = 100`: A variable named `コンピュータ` (Japanese for "computer") is declared and assigned a value of 100.
- `println(コンピュータ)`: Prints the value of the variable to the console.
- `obj := { コンピュータ: 1000 }`: An object is created with a property also named `コンピュータ`, set to 1000.
- `println(obj)`: Prints the entire object to the console.

## Usage

1. **Run the Script**: Use the command `tender iden.td` to execute the script.
2. **View Output**: The script will display the value of the variable and the object in the terminal.

## Explore More

This project is part of the **1000+ Codes in Tender** repository, which contains numerous examples showcasing various functionalities of the Tender programming language. Feel free to explore and modify the code to enhance your understanding of identifiers and objects in Tender!

## License

This project is open-source. Contributions and adaptations are welcome.
