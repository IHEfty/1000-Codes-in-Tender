# Grayscale Image Converter in Tender

This project demonstrates how to convert a colored image to grayscale using the **Tender** programming language. The script utilizes the `image` module to load an image, process its pixel data, and save the modified image as a grayscale version.

## `input`

![preview](./img.png) 

## `output`

![preview](./out.png) 

## Features

- Converts any input image to grayscale.
- Maintains the alpha channel of the original image.
- Outputs the processed image in PNG format.

## Prerequisites

- Ensure you have the **Tender** programming language installed. For installation instructions, visit the [Tender GitHub Repository](https://github.com/2dprototype/tender).

## Installation

1. Clone this repository or download the script.
2. Save the code in a file named `grayscale.td`.
3. Place your input image (named `img.png`) in the same directory as the script.

## Usage

Run the script using the following command:

```bash
tender grayscale.td
```

## Code Overview

### Image Processing Logic

1. **Loading the Image**:
   The script loads the input image (`img.png`) using the `image.load` function.

   ```tender
   img := image.load("img.png")
   ```

2. **Getting Image Dimensions**:
   It retrieves the width and height of the image to iterate over each pixel.

   ```tender
   w := img.bounds().size.width
   h := img.bounds().size.height
   ```

3. **Converting to Grayscale**:
   The script processes each pixel to convert it to grayscale using the formula:
   \[
   \text{Grayscale Value} = 0.3 \times R + 0.59 \times G + 0.11 \times B
   \]
   Each pixel's red, green, and blue components are averaged based on their contribution to brightness.

   ```tender
   for i := 0; i < w; i++ {
       for j := 0; j < h; j++ {
           col := img.at(i, j)
           r := col[0]
           g := col[1]
           b := col[2]
           a := col[3]
           v := 0.3 * r + 0.59 * g + 0.11 * b  // Corrected formula
           img.set(i, j, [v, v, v, a])  // Set new grayscale color
       }
   }
   ```

4. **Saving the Processed Image**:
   Finally, the script saves the processed image as `out.png`.

   ```tender
   img.save("out.png", "png")
   ```

## Example Images

- **Input Image (`img.png`)**: The original colored image used for conversion.
- **Output Image (`out.png`)**: The resulting grayscale image after processing.

## File Structure

```
cng col
├── grayscale.td   # Grayscale conversion script
├── img.png        # Original colored image
└── out.png        # Grayscale image output
```

## Explore More

This project is part of the **1000 Codes Project** in **Tender**, which features a collection of interesting and functional code snippets. Visit the [Tender GitHub Repository](https://github.com/2dprototype/tender) for more examples and projects.

## License

This project is open-source. Feel free to contribute or use it in your own projects.
