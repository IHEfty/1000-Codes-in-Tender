# Dialogue Text Animation in Tender

## Overview

This repository contains the `main.td` script, which showcases a text animation effect using the [**Tender**](https://github.com/2dprototype/tender-free). The script reads dialogue from an embedded text file and displays it in the console with a typing effect, simulating a natural reading experience.

## Script

### `main.td`

This script imports the `times`, `strings`, and `rand` modules to implement a dynamic text display based on the content of an embedded `dialogue.txt` file.

**Code Example:**
```tender
times := import("times")
strings := import("strings")
rand := import("rand")

raw := embed("dialogue.txt")
words := strings.split(raw, " ")

_print := fn(txt) {
	for t in txt {
		print(t)
		times.sleep(100000000 - (rand.float()*10000))
	}
}

for word in words {
	l := len(word)
	_print(word + " ")
	times.sleep(((times.second / 10)*l) - 100000000*l)
}
```

### Functionality:
- **Text Animation**: Displays words from the `dialogue.txt` file with a typing effect, creating an engaging experience.
- **Dynamic Delay**: Introduces random delays between characters and words to simulate a natural reading pace.

## Usage

- **Prerequisites**: Ensure that the file `dialogue.txt` is present in the same directory as the script.
- To run the script, use the following command in your terminal:
    ```bash
    tender main.td
    ```
- Observe the animated dialogue display as it presents words from the `dialogue.txt` file in the console.

## Explore More

This script is part of the larger collection of examples in the 1000+ Codes in Tender repository. Feel free to explore and modify the code to enhance your understanding of text manipulation and animation effects with Tender!

## License

This project is open-source. Feel free to contribute or use it in your own projects.
