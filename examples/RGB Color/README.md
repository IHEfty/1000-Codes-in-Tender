# RGB Color Test in Tender

## Overview

The `rgb_color_test.td` script demonstrates how to generate RGB color combinations using the [**Tender**](https://github.com/2dprototype/tender-free). This example is part of the larger **1000+ Codes in Tender** repository, showcasing various coding techniques and functionalities.

## Features

- **RGB Color Generation**: The script iterates through a predefined range of RGB values and outputs colored text to the terminal.
- **File Output**: Each generated colored string is appended to a text file (`out.txt`), allowing for easy review of all color combinations.
- **Endless Loop**: The script runs indefinitely after generating the colors, ensuring continuous output if desired.

## Code Explanation

```tender
import "colors"
import "fs"

// Predefined array of RGB values
var bb = [7,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107]

// Iterate through RGB values
for r in bb {
	for g in bb {
		for b in bb {	
			// Generate colored text
			s := format("\033[%d;%d;%dmHello", r, g, b) + colors.reset
			sysout s           // Output to terminal
			fs.appendfile("out.txt", s) // Append to file
		}
	}
}

// Endless loop to keep the script running
for {}
```

## Usage

1. **Run the Script**: Use the command `tender rgb_color_test.td` to execute the script.
2. **View Output**: The script will display colored "Hello" messages in the terminal. Check `out.txt` for the same messages saved to a file.

## Explore More

This project is one of many examples in the **1000+ Codes in Tender** repository. Feel free to explore and modify the code to enhance your understanding of image manipulation with Tender!

## License

This project is open-source. Feel free to contribute or use it in your own projects.
