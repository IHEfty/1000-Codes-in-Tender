# Image Creation Example in Tender

This project demonstrates how to create and manipulate images using the **image** module in **Tender**. The script generates a 255x255 pixel gradient image and saves it as a PNG file.

## How It Works

The **image.td** script creates an image using `image.new()`, sets pixel colors with `img.set()`, and saves the image with `img.save()`. The color of each pixel is based on its position, creating a gradient effect. In this example, the red and blue components change across the width and height of the image.

### Example Output

![preview](./out.png)

## Project Structure

- **image.td**: Main script that generates a gradient image and saves it as `out.png`.

### Customization

- Change image size by modifying `image.new(width, height)`.
- Adjust the color gradient by modifying the pixel color array.

## License

This project is open-source. Feel free to contribute or use it in your own projects.

For more examples, visit the [Tender GitHub Repository](https://github.com/2dprototype/tender).
