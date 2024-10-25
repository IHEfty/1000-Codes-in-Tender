# Greedy Box Game

Greedy Box is a minimalistic game developed in the **Tender** programming language. It symbolizes the concept of greed—endlessly consuming without gain or growth. The box continuously eats in a loop, reflecting the endless cycle of human greed.

## Features

- **Randomized Food Generation**: Random placement of food items on the canvas.
- **Dynamic Movement**: Control the Greedy Box's direction using keyboard inputs.
- **Simple Graphics**: Draws a boundary, food items, and the Greedy Box in distinct colors.
- **Game Over Conditions**: The game ends when the box hits the border or collides with itself.

## Example Output

The game canvas is 600x400 pixels, with a grid size of 20 pixels, where the Greedy Box moves, eats food, and continues until the player hits a boundary or collides with itself.


## Game Preview

![Game Preview](./preview.mp4) 

---

## Code Overview

Here's a breakdown of the main components and functions in the `greedy_box.td` script:

### Imports

- **Canvas**: Creates and manages the game window.
- **Rand**: Generates random positions for food.
- **Math**: Supports mathematical functions.
- **Times**: Controls game speed and timing.

### Game Initialization

- **Dimensions**: Canvas width (`w`) is set to 600, height (`h`) to 400.
- **Grid Size**: Each cell in the grid is 20x20 pixels.
- **Game Elements**: `greedy_box`, `food`, and direction (`dir`) are initialized.

### Functions

1. **random(min, max)**: Generates a random integer within the specified range, used for random food placement.

2. **draw(ctx)**: Draws the game elements on the canvas, including:
   - The Greedy Box.
   - The food item, which changes location each time it’s eaten.
   - Game boundaries.

3. **update_greedy_box()**: Manages the movement and collision detection for the Greedy Box:
   - Moves the box based on the `dir`.
   - Checks for wall collisions to determine game over.
   - Detects self-collision.
   - Adds new `head` at the front of the box if no collision occurs.
   - Repositions the food when eaten.

### Game Execution

1. **canvas.new_window**: Sets up the canvas window and initializes the game display.
2. **Event Loop**: Updates the game window and registers keyboard inputs to control the box’s direction.

---

## Usage

1. Ensure the **Tender** programming language is installed.
2. Save this file as `greedy_box.td`.
3. Run the game using the following command:

```bash
tender greedy_box.td
```

4. Use arrow keys to control the Greedy Box’s direction.

---

## How It Works

1. **Movement and Control**: The Greedy Box moves continuously in the specified direction until a boundary is reached or it collides with itself.
2. **Food Mechanic**: Upon contact, the Greedy Box “eats” the food, causing it to respawn at a new random location on the grid.
3. **End Condition**: If the Greedy Box collides with the boundary or with itself, the game is over, symbolizing that unchecked greed ultimately leads to self-destruction.

---

## License

This project is open-source and part of the **1000 Codes Project**, showcasing diverse code snippets in the Tender language. Feel free to explore, modify, and contribute to the project in the **[Tender GitHub Repository](https://github.com/2dprototype/tender)**.
