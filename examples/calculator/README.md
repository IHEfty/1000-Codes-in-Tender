# Calculator Template

The **Calculator Template** is part of the **1000+ Codes in Tender** collection. This project, written in [**Tender**](https://github.com/2dprototype/tender), provides a graphical interface for a basic calculator. While it offers a fully functioning user interface, the calculation logic is not yet implemented—making this a template for further development.

## Preview

![preview](./preview.png)

## Running the Project

To run the **Calculator Template**, execute the `calc.td` script:

```bash
tender calc.td
```

This will open a window displaying the calculator's interface, complete with buttons and a display for input.

## Code Preview

Here's a preview of the **calc.td** script:

```tender
import "canvas"

w := 300
h := 400
input := ""
result := 0
buttons := [
	"7", "8", "9", "/",
	"4", "5", "6", "*",
	"1", "2", "3", "-",
	"0", ".", "=", "+"
]

fn draw(ctx) {
	// Drawing logic for display and buttons
}

fn calculate() {
	// Placeholder function for future calculation logic
}

canvas.new_window(w, h, "Calculator", fn(window) {
	ctx := window.new_context(w, h)
	draw(ctx)
	window.update(w, h)
})
```

### Customizing the Calculator

To add calculation functionality, you can implement the logic inside the `calculate` function. For example, you might parse the `input` string to handle arithmetic operations.

Example modification:

```tender
fn eval(s) {
	// Add your evaluation logic here
}
```

### Adding New Features

Feel free to extend the template with additional features like:
- Clear button (`C`)
- Handling more complex operations
- Adding error handling for invalid inputs

## Project Structure

- **calc.td**: The main script that defines the graphical interface and interaction logic for the calculator.

## Explore More

The **Calculator Template** project is a starting point for building a fully functional calculator. Explore the code, make changes, and implement the missing logic to create your own customized calculator in **Tender**!
