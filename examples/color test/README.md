# Color Test Examples in Tender

## Overview

This repository contains two scripts, `col_test.td` and `col_test_2.td`, that demonstrate the generation of RGB color values using the [**Tender**](https://github.com/2dprototype/tender). Both scripts explore color manipulation through ANSI escape codes, with `col_test_2.td` enhancing the output by including random strings and improving console formatting.

## Scripts

### 1. `col_test.td`

- **Functionality**: Generates a spectrum of colors by iterating through all possible combinations of red, green, and blue values (0 to 255).
- **Output**: Displays each color in the console using ANSI escape codes.

**Code Example**:

```tender
import "colors"  // Import the colors module

for r in range(0,255) {  // Loop through red values
	for g in range(0,255) {  // Loop through green values
		for b in range(0,255) {  // Loop through blue values	
			sysout format("\033[%d;%d;%dm$", r, g, b) + colors.reset  // Output the color
		}
	}
}

for {}
```

### 2. `col_test_2.td`

- **Functionality**: Builds upon the first script by adding random strings to the output and organizing the console display for better readability.
- **Output**: Displays RGB colors in a structured format with appended random strings.

**Code Example**:

```tender
import "colors"  // Import the colors module
import "helper/randstr"  // Import the random string helper module

for r in range(0,255) {  // Loop through red values
	for g in range(0,255) {  // Loop through green values
		for b in range(0,255) {  // Loop through blue values	
			sysout format("\033[%d;%d;%dm"+randstr(1), r, g, b) + colors.reset  // Output the color with random string
			if b%8==0 {  // Add space after every 8 colors
				print(" ")
			}
			if b%16==0 {  // New line after every 16 colors
				println()
			}	
		}
	}
}

for {}
```

## Usage

1. **Run the Scripts**: Use the commands `tender col_test.td` and `tender col_test_2.td` to execute each script.
2. **View Output**: Observe the various colors displayed in the terminal along with the enhancements in the second script.

## Explore More

This project is one of many examples in the [**1000+ Codes in Tender**](https://github.com/IHEfty/1000-Codes-in-Tender/) repository. Feel free to explore and modify the code to enhance your understanding of color manipulation and formatting with Tender!

## License

This project is open-source. Feel free to contribute or use it in your own projects.
