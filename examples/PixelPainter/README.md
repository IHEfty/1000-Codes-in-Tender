# PixelPainter

The **PixelPainter** project is part of the **1000+ Codes in Tender** collection. This project, written in the [**Tender**](https://github.com/2dprototype/tender), demonstrates how to create and manipulate an image using a matrix representation of colors.

## Running the Project

To run the Main project, execute the `main.td` script:

```bash
tender main.td
```

This will generate an output image named `out.png` based on the color data defined in the `col.td` file.

### Customizing the Colors

To use a different set of colors, you can modify the `col.td` file. Add or remove colors as needed, ensuring that the new color values are in the format `[R, G, B, A]`, where each component ranges from 0 to 255.

Example modification:

```tender
export [
	[255, 255, 255, 255],  // Add white color
	[0, 0, 0, 255],        // Add black color
	// Your custom colors here
]
```

## Project Structure

- **main.td**: The main script that creates an image from the color matrix and saves it as `out.png`.
- **col.td**: A module that defines a set of RGBA color values for use in the Main project.

## Explore More

The **Main** project is one of many examples in the **1000+ Codes in Tender** repository. Feel free to explore and modify the code to enhance your understanding of image manipulation with Tender!
