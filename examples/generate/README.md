# Text Color Generator in Tender

This project demonstrates how to create a color-coded text output in the **Tender** programming language. The script reads a text file (`hi.txt`) and applies color formatting to specific characters based on predefined conditions.

![preview](./preview.png)

## Features

- Reads a text file and applies color to characters based on type:
  - Red for `#` and `+`
  - Intense red for `%` and `@`
  - White for others
- Limits output to 10 lines with color formatting.

## Usage

1. Clone or download the project.
2. Ensure `hi.txt` is in the same directory as the script.
3. Run the script:

```bash
tender generate.td
```

## How It Works

The script reads the `hi.txt` file and applies color formatting based on the character:
- `#` and `+` are red.
- `%` and `@` are intense red.
- All other characters are white.
Color formatting is applied only for the first 10 lines.

## License

Open-source project. Contributions are welcome!
