# Image Processing Filters in [**Tender**](https://github.com/2dprototype/tender)

## Overview

![Preview GIF](res/preview.gif)

This project demonstrates a collection of image processing filters implemented in [**Tender**](https://github.com/2dprototype/tender). The filters include **Black and White**, **Grayscale**, **Noise**, **Threshold**, **Brightness**, **Invert**, **Sepia**, **Glitch**, and **Blur**. The project provides an interactive interface where users can apply these filters to an image and see the results in real-time.

The scripts work by manipulating the pixel data of an image. Each filter processes the image's pixels in a specific way to achieve the desired effect. Below, we’ll break down how each filter works and how the main script ties everything together.

---

## How the Code Works

### **Main Script (`main.td`)**

The `main.td` script is the core of the application. It sets up the interactive interface, loads an image, and applies the selected filter when a button is clicked. Here's how it works:

1. **Image Loading**:
   - The script loads an image (`image.jpg`) using the `image.load()` function.
   - The image is stored in the `img` variable, which holds the pixel data and metadata (e.g., width, height).

2. **Canvas Setup**:
   - A canvas window is created with a default size of 600x400 pixels.
   - The `draw()` function is responsible for rendering the image and the filter buttons on the canvas.

3. **Interactive Buttons**:
   - Buttons for each filter are displayed on the left side of the window.
   - Each button corresponds to a specific filter (e.g., Black and White, Grayscale, etc.).
   - When a button is clicked, the corresponding filter function is applied to the image.

4. **Event Handling**:
   - The script listens for events such as mouse clicks, key presses, and window resizing.
   - When a button is clicked, the script identifies which filter was selected and applies it to the image by calling the appropriate filter function.

5. **Real-Time Updates**:
   - After applying a filter, the `draw()` function is called again to update the canvas with the modified image.

---

### **Filter Scripts**

Each filter script contains a function that manipulates the pixel data of the image. The pixel data is represented as an array of RGBA values (Red, Green, Blue, Alpha), where each pixel is represented by 4 consecutive values in the array.

#### **1. Black and White (`blackandwhite.td`)**
- **How it works**:
  - Converts the image to black and white by averaging the RGB values of each pixel.
  - The average value is then applied to all three color channels (R, G, B).
- **Code**:
  ```tender
  v := (pixels[index] + pixels[index + 1] + pixels[index + 2]) / 3;
  pixels[index] = v;
  pixels[index + 1] = v;
  pixels[index + 2] = v;
  ```

#### **2. Grayscale (`grayscale.td`)**
- **How it works**:
  - Converts the image to grayscale using weighted averages of the RGB values.
  - The weights are based on human perception: `0.3 * R + 0.59 * G + 0.11 * B`.
- **Code**:
  ```tender
  v := 0.3 * pixels[i] + 0.59 * pixels[i+1] + 0.11 * pixels[i+2];
  pixels[i] = v;
  pixels[i+1] = v;
  pixels[i+2] = v;
  ```

#### **3. Noise (`noise.td`)**
- **How it works**:
  - Adds random noise to each pixel by averaging the original pixel value with a random value between 0 and 255.
- **Code**:
  ```tender
  pixels[i] = (pixels[i] + randint(0, 255)) / 2;
  pixels[i + 1] = (pixels[i + 1] + randint(0, 255)) / 2;
  pixels[i + 2] = (pixels[i + 2] + randint(0, 255)) / 2;
  ```

#### **4. Threshold (`threshold.td`)**
- **How it works**:
  - Converts the image to a binary (black and white) representation based on a threshold value.
  - If the grayscale value of a pixel is greater than or equal to the threshold, it is set to white (255); otherwise, it is set to black (0).
- **Code**:
  ```tender
  v := (0.2126 * pixels[index] + 0.7152 * pixels[index + 1] + 0.0722 * pixels[index + 2] >= threshold_val) ? 255 : 0;
  pixels[index] = v;
  pixels[index + 1] = v;
  pixels[index + 2] = v;
  ```

#### **5. Brightness (`brightness.td`)**
- **How it works**:
  - Adjusts the brightness of the image by adding or subtracting a fixed value from each pixel's RGB channels.
- **Code**:
  ```tender
  pixels[i] += adjustment;
  pixels[i + 1] += adjustment;
  pixels[i + 2] += adjustment;
  ```

#### **6. Invert (`invert.td`)**
- **How it works**:
  - Inverts the colors of the image by subtracting each pixel's RGB values from 255.
- **Code**:
  ```tender
  pixels[i] = 255 - pixels[i];
  pixels[i + 1] = 255 - pixels[i + 1];
  pixels[i + 2] = 255 - pixels[i + 2];
  ```

#### **7. Sepia (`sepia.td`)**
- **How it works**:
  - Applies a sepia tone to the image by combining the RGB values with specific weights.
  - The weights are based on the formula: `R = 0.393 * R + 0.769 * G + 0.189 * B`, `G = 0.349 * R + 0.686 * G + 0.168 * B`, `B = 0.272 * R + 0.534 * G + 0.131 * B`.
- **Code**:
  ```tender
  pixels[index] = (r * 0.393) + (g * 0.769) + (b * 0.189);
  pixels[index + 1] = (r * 0.349) + (g * 0.686) + (b * 0.168);
  pixels[index + 2] = (r * 0.272) + (g * 0.534) + (b * 0.131);
  ```

#### **8. Glitch (`glitch.td`)**
- **How it works**:
  - Applies a glitch effect by randomly shifting pixel values and introducing noise.
  - The script randomly displaces pixels horizontally or vertically and adds random color shifts.
- **Code**:
  ```tender
  offset_x := randint(-shift_amount, shift_amount);
  offset_y := randint(-shift_amount, shift_amount);
  pixels[index + shift_channel] = pixels[shifted_index + shift_channel];
  ```

#### **9. Blur (`blur.td`)**
- **How it works**:
  - Applies a blur effect by averaging the RGB values of neighboring pixels.
  - The script uses a 3x3 kernel to calculate the average color of each pixel and its neighbors.
- **Code**:
  ```tender
  r_avg := clamp(r_sum / count);
  g_avg := clamp(g_sum / count);
  b_avg := clamp(b_sum / count);
  ```

---

## Usage

1. **Run the Script**:
   - Ensure Tender is installed and the image file (`image.jpg`) is in the same directory as the script.
   - Run the script using the following command:
     ```bash
     tender main.td
     ```

2. **Apply Filters**:
   - Click on the buttons on the left side of the window to apply the corresponding filter.
   - The image will update in real-time to reflect the applied filter.

3. **Resize the Window**:
   - The interface dynamically adjusts to the window size, ensuring the image and buttons are always visible.

---


## Dependencies

- **Canvas**: For rendering the image and interface.
- **Image**: For loading and manipulating image data.
- **Helper Functions**: For utility functions like `randint` and `clamp`.

---

## Explore More

This project is part of the **1000+ Codes in Tender** repository. Feel free to explore and modify the code to enhance your understanding of image processing and interactive applications in Tender!

---

## License

This project is open-source. Feel free to contribute or use it in your own projects.
