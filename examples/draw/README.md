# Gumball Drawing Project in Tender

This project demonstrates how to create pixel art from text-based representations using the **Tender** programming language. The script reads a text file containing a graphical representation of a gumball machine and renders it onto a canvas.

## Features

- Reads a text file (`gumball.txt`) that contains a pixel art representation.
- Renders the pixel art on a canvas with color coding based on character values.
- Saves the rendered image as a PNG file (`out.png`).

## Prerequisites

- Ensure you have the **Tender** programming language installed. For installation instructions, visit the [Tender GitHub Repository](https://github.com/2dprototype/tender).

## Installation

1. Clone this repository or download the project files.
2. Ensure you have the `gumball.txt` file in the same directory as the script.

## Usage

Run the script using the following command:

```bash
tender draw.td
```

## Code Overview

### File Structure

```
draw
├── draw.td        # Script for drawing the gumball machine
├── gumball.txt    # Text representation of the gumball machine
└── out.png        # Output image of the rendered gumball machine
```

### Drawing Logic

1. **Imports**:
   The script imports necessary modules for canvas manipulation, file operations, and string handling.

   ```tender
   canvas := import("canvas")
   os := import("os")
   strings := import("strings")
   ```

2. **Canvas Initialization**:
   A canvas context is created with a width of 51 pixels and a height of 25 pixels.

   ```tender
   ctx := canvas.new_context(51, 25)
   ```

3. **Reading the Text File**:
   The script reads the `gumball.txt` file and splits its contents into an array of strings, where each string represents a line of pixel data.

   ```tender
   file := os.read_file("gumball.txt")
   arr := strings.split(string(file), "\n")
   ```

4. **Pixel Rendering**:
   The script iterates over each character in the text representation. Depending on the character, it sets the corresponding pixel color:

   - `#` or `@`: Red
   - `=`: Semi-transparent red
   - Space (` `): Transparent
   - Any other character: Semi-transparent red

   ```tender
   for i, a in arr {
       for j, b in a {
           ctx.set_pixel(j, i)
           if b == '#' || b == '@' {
               ctx.hex("#ff0000")
           } else if b == '=' {
               ctx.hex("#ff000080")
           } else if b == ' ' {
               ctx.hex("#ffffff00")
           } else {
               ctx.hex("#ff000050")
           }
           ctx.fill()
       }
   }
   ```

5. **Saving the Rendered Image**:
   Finally, the rendered canvas is saved as `out.png`.

   ```tender
   ctx.save_png("out.png")
   ```

## Output
![Output](./out.png)

After running the script, you will get an output image (`out.png`) that visually represents the gumball machine based on the text file.

## Explore More

This project is part of the **1000 Codes Project** in **Tender**, which features a collection of interesting and functional code snippets. Visit the [Tender GitHub Repository](https://github.com/2dprototype/tender) for more examples and projects.

## License

This project is open-source. Feel free to contribute or use it in your own projects.
