# Tender Explorer

**Tender Explorer** is an interactive file explorer built with Tender, allowing users to navigate directories and view files.

![preview](./res/preview.png)
## Features
- **Interactive File Browser**: Displays files and folders with icons.
- **Directory Navigation**: Click on directories to explore.
- **Responsive UI**: Adapts to window size with scroll functionality.

## Installation
1. Clone or download this repository.
2. Install **Tender** from the [Tender GitHub Repository](https://github.com/2dprototype/tender).
3. Run `tender explorer.td` in your terminal.

## Usage
Launch the file explorer with:

```bash
tender main.td
```

## Controls
- **Scroll**: Use arrow keys or the scroll wheel.
- **Navigate Folders**: Click folder icons.
- **Back**: Press `*` key.

## How It Works
The explorer uses the **Tender** `canvas` and `fs` modules to display files and navigate directories. It handles scrolling by adjusting the visible items based on the current position and allows folder navigation by clicking on icons.

## License
Open-source, feel free to contribute or modify.
