# Canvas Window

The **Canvas Window** project is part of the **1000+ Codes in Tender** collection. This project, written in the [**Tender**](https://github.com/2dprototype/tender), demonstrates how to create a window with a drawing canvas and render basic graphics.

## Overview

The **Canvas Window** program utilizes the `canvas` module to create a window where shapes can be drawn. In this example, a simple green rectangle is rendered on a dark background.

## Running the Project

To run the Canvas Window project, execute the `canvas_win.td` script:

```bash
tender canvas_win.td
```

This will open a window titled "Wooh" with a canvas measuring 600x400 pixels, displaying a green rectangle.

### Customizing the Drawing

You can modify the drawing by changing the parameters in the `draw` function. For example, you can alter the rectangle's position, size, or color by adjusting the following line:

```tender
ctx.rect(100, 100, 100, 100) // Change position (x, y) or size (width, height)
ctx.hex("#0f0") // Change color using hex codes
```

## Project Structure

- **canvas_win.td**: The main script that creates a window and renders a shape on the canvas.

### Code Details

- **Imports**: The script imports the `canvas` module for window and graphics management, and the `times` module for handling delays (if needed).
- **Draw Function**: The `draw` function handles the drawing logic, including setting the background color, clearing the canvas, and drawing shapes.
- **Window Options**: The `opt` variable specifies the properties of the window, including dimensions, title, and fullscreen settings.
- **Event Loop**: The event loop continuously checks for window events, such as resizing, and updates the canvas accordingly.

## License

This project is open-source. Feel free to contribute or use it in your own projects.

## Explore More

The **Canvas Window** project is one of many examples in the **1000+ Codes in Tender** repository. Feel free to explore and modify the code to enhance your understanding of graphics programming with Tender!
