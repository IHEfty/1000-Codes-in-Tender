# Pi Arc Drawing Project in Tender

This project demonstrates how to create a colorful pie chart-like drawing using the **Tender** programming language. The script generates an image with segments representing different colors, inspired by the mathematical constant π (pi).

## Features

- Draws a pie chart with N segments, each filled with a different color.
- Saves the rendered image as a PNG file (`pi_arc.png`).

## Prerequisites

- Ensure you have the **Tender** programming language installed. For installation instructions, visit the [Tender GitHub Repository](https://github.com/2dprototype/tender).

## Installation

1. Clone this repository or download the project files.
2. Ensure you have the `pi_arc.td` file in your working directory.

## Usage

Run the script using the following command:

```bash
tender pi_arc.td
```

## Code Overview

### File Structure

```
.
├── pi_arc.td      # Script for drawing the pi arc segments
└── pi_arc.png     # Output image of the drawn pi arcs
```

### Drawing Logic

1. **Imports**:
   The script imports necessary modules for canvas manipulation and mathematical functions.

   ```tender
   canvas := import("canvas")
   math := import("math")
   ```

2. **Canvas Initialization**:
   A canvas context is created with a width of 600 pixels and a height of 400 pixels.

   ```tender
   W := 600
   H := 400
   dc := canvas.new_context(W, H)
   ```

3. **Calculate Center and Radius**:
   The center point and radius for the arcs are calculated based on the dimensions of the canvas.

   ```tender
   R := math.min(W, H) / 2
   centerX := W / 2
   centerY := H / 2
   ```

4. **Color Definitions**:
   An array of colors is defined for the pie segments. These colors will be used to fill each segment.

   ```tender
   colors := ["#FF0000", "#FF7F00", "#FFFF00", "#00FF00", "#0000FF", "#4B0082", "#8B00FF"]
   ```

5. **Drawing the Arcs**:
   The script iterates through the number of segments (`N`), calculates the start and end angles for each segment, and draws the arc using the defined colors.

   ```tender
   for i := 0; i < N; i++ {
       startAngle := i * 2 * math.pi / N
       endAngle := (i + 1) * 2 * math.pi / N

       dc.hex(colors[i])
       dc.move_to(centerX, centerY)
       dc.line_to(centerX + R * math.cos(startAngle), centerY + R * math.sin(startAngle))
       dc.arc(centerX, centerY, R, startAngle, endAngle)
       dc.closepath()
       dc.fill()
   }
   ```

6. **Saving the Rendered Image**:
   Finally, the drawn canvas is saved as `pi_arc.png`.

   ```tender
   dc.save_png("pi_arc.png")
   ```

## Output
![Output](./out.png)

After running the script, you will get an output image (`pi_arc.png`) that visually represents the pie segments filled with different colors.

## Explore More

This project is part of the **1000 Codes Project** in **Tender**, which features a collection of interesting and functional code snippets. Visit the [Tender GitHub Repository](https://github.com/2dprototype/tender) for more examples and projects.

## License

This project is open-source. Feel free to contribute or use it in your own projects.
