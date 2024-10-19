# Donut

The **Donut** project is part of the **1000+ Codes in Tender** collection. This project, written in the [**Tender**](https://github.com/2dprototype/tender) programming language, demonstrates how to create a rotating ASCII donut shape in the terminal.

## Overview

The **Donut** program uses mathematical functions to generate a 3D donut shape, represented using ASCII characters. The program continuously updates the display to create a rotating effect, providing a visually engaging output.

## Running the Project

To run the Donut project, execute the `donut.td` script:

```bash
tender donut.td
```

This will generate an ASCII donut that rotates in the terminal.

### Customizing the Animation

You can modify the speed of the rotation by adjusting the increments of `A` and `B` in the main loop. For example, changing the values like so:

```tender
A += 0.05
B += 0.02
```

will result in a slower rotation.

## Project Structure

- **donut.td**: The main script that generates the rotating ASCII donut. It contains the logic for rendering the donut shape based on mathematical calculations.

### Code Details

- **Imports**: The script imports the `math` and `strings` modules for mathematical functions and string manipulation.
- **Functions**: The `draw` function calculates the donut's shape and updates the ASCII representation.
- **Main Loop**: The loop continuously updates the parameters for the drawing function, creating the rotation effect.

## Explore More

The **Donut** project is one of many examples in the **1000+ Codes in Tender** repository. Feel free to explore and modify the code to enhance your understanding of ASCII art and mathematical visualizations in Tender!
