# Gumball Drawing Project in Tender

This project demonstrates how to convert a text-based gumball machine representation into pixel art using **Tender**. The script reads a file (`gumball.txt`), interprets the characters, and renders them as pixels on a canvas. The output is saved as a PNG file.

## Features

- Reads a text file (`gumball.txt`) for pixel art data.
- Converts characters like `#`, `@`, and `=` into colored pixels.
- Saves the rendered image as `out.png`.

## How It Works

- The script creates a canvas with a width of 51px and height of 25px.
- It reads the `gumball.txt` file, processing each line to draw pixels based on the character values.
- Characters are color-coded as follows:
  - `#` and `@` = Red
  - `=` = Semi-transparent red
  - Space = Transparent
  - Other characters = Semi-transparent red
- The final image is saved as `out.png`.

## Usage

1. Place the script and `gumball.txt` in the same directory.
2. Run the script with:

   ```bash
   tender draw.td
   ```

## Output

The result is a PNG image of the gumball machine created from text characters.

![Output](./out.png)

