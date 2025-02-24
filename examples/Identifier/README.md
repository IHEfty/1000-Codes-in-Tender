# Identifier Example in Tender

## Overview

The `iden.td` script showcases the use of identifiers in the [**Tender**](https://github.com/2dprototype/tender), including the ability to use non-English characters. This example highlights how variables and objects can be defined and utilized with identifiers that include Unicode characters.

## Features

- **Variable Declaration**: Demonstrates declaring a variable using a non-English identifier.
- **Object Creation**: Shows how to create an object with properties defined using non-English identifiers.
- **Output**: Prints the values of the variable and the object to the console.

### Breakdown:

- `var コンピュータ = 100`: A variable named `コンピュータ` (Japanese for "computer") is declared and assigned a value of 100.
- `println(コンピュータ)`: Prints the value of the variable to the console.
- `obj := { コンピュータ: 1000 }`: An object is created with a property also named `コンピュータ`, set to 1000.
- `println(obj)`: Prints the entire object to the console.

## Usage

1. **Run the Script**: Use the command `tender iden.td` to execute the script.
2. **View Output**: The script will display the value of the variable and the object in the terminal.
