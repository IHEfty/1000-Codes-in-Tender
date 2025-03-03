# Termimage

The **Termimage** project is part of the **1000+ Codes in Tender** collection. This project, written in the [**Tender**](https://github.com/2dprototype/tender), allows users to convert images into ASCII art and display them in the terminal, with optional color support.

## Preview

![preview](./preview.png)

## Running the Project

To run the Termimage project, execute the `cli.td` script:

```bash
tender cli.td
```

This will render the embedded image `download.jpg` as ASCII art in your terminal.

### Customizing the Image

To use a different image, simply replace `download.jpg` in the script with your desired image file name. Ensure that your image is located in the same directory as the script.

Example usage:

```tender
data := embed("your_image.jpg")
sysout t.to_ascii(data, 40, 30, true)
```

You can adjust the width, height, and color settings by modifying the parameters in the script.

## Project Structure

- **termcolor.td**: Contains utilities for converting RGB values to ANSI color codes.
- **termimage.td**: Implements the logic for decoding images and converting them to ASCII art.
- **cli.td**: The main script that processes and displays the selected image.
