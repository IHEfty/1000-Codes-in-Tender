# Random Color Canvas Project in Tender

This project demonstrates how to create a canvas filled with random colors using the **Tender** programming language. The script generates an image where each pixel is assigned a random RGB color value.

## Features

- Creates a 255x255 pixel canvas.
- Each pixel is filled with a randomly generated RGB color.
- Saves the rendered image as a PNG file (`rand.png`).

## Prerequisites

- Ensure you have the **Tender** programming language installed. For installation instructions, visit the [Tender GitHub Repository](https://github.com/2dprototype/tender).

## Installation

1. Clone this repository or download the project files.
2. Ensure you have the `rand.td` file in your working directory.

## Usage

Run the script using the following command:

```bash
tender rand.td
```

## Code Overview

### File Structure

```
.
├── rand.td      # Script for generating a canvas with random colors
└── rand.png     # Output image of the random color canvas
```

### Drawing Logic

1. **Imports**:
   The script imports necessary modules for canvas manipulation, random number generation, and mathematical functions.

   ```tender
   canvas := import("canvas")
   rand := import("rand")
   math := import("math")
   ```

2. **Canvas Initialization**:
   A canvas context is created with a width and height of 255 pixels.

   ```tender
   width := 255
   height := 255
   ctx := canvas.new_context(width, height)
   ```

3. **Filling the Canvas**:
   The script iterates over each pixel in the canvas. For each pixel, it generates three random float values representing the RGB color components, which range from 0 to 1.

   ```tender
   for i := 0; i < width; i++ {
       for j := 0; j < height; j++ {
           ctx.set_pixel(i, j)
           r := rand.float()
           g := rand.float()
           b := rand.float()
           ctx.rgb(r, g, b)
           ctx.fill()
       }
   }
   ```

4. **Saving the Rendered Image**:
   Finally, the canvas filled with random colors is saved as `rand.png`.

   ```tender
   ctx.save_png("rand.png")
   ```

## Output
![Output](./rand.png)

After running the script, you will get an output image (`rand.png`) that visually represents a canvas filled with randomly generated colors.

## Explore More

This project is part of the **1000 Codes Project** in **Tender**, which features a collection of interesting and functional code snippets. Visit the [Tender GitHub Repository](https://github.com/2dprototype/tender) for more examples and projects.

## License

This project is open-source. Feel free to contribute or use it in your own projects.
