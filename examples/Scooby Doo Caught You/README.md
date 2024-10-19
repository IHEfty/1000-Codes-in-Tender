# Scooby-Doo Text Animation in Tender

## Overview

This repository contains the `main.td` script, which demonstrates a text animation effect using the [**Tender**](https://github.com/2dprototype/tender-free). The script reads words from a subtitle file and displays them on the console with a delay, simulating a typing effect. It also features color-coded text using embedded color commands.

## Script

### `main.td`

This script imports several modules, including `times`, `strings`, `rand`, and `colors`, to implement a dynamic text display based on the content of an embedded subtitle file. It also includes an embedded image represented by `scooby0.txt`.

**Code Example:**
```tender
times := import("times")
strings := import("strings")
rand := import("rand")
color := import("colors")

scooby := embed("scooby0.txt")

raw := embed("subtitle.txt")
words := strings.split(raw, " ")

store := ""
should_store := false

_print := fn(txt) {
	for t in txt {
		if t == '~' {
			if should_store {
				should_store = false
				color.print(color[store])
				store = ""
			}
			else {
				should_store = true
			}
		}
		else {
			if should_store {
				store += t
			}
			else {
				print(t)
				times.sleep(50000000 - (rand.float()*10000))
			}
		}
	}                                   
}

for word in words {
	l := len(word)
	_print(word + " ")
	times.sleep(((times.second / 10)*l) - 50000000*l)
}

println("\n")
color.println(color.ired + scooby + color.reset)

for {}
```

### Functionality:
- **Text Animation**: Displays words from the `subtitle.txt` file with a typing effect.
- **Color Effects**: Allows for color-coded text using the color specified in the `scooby0.txt` file.
- **Dynamic Delay**: Introduces random delays between characters to enhance the animation effect.

## Usage

- **Prerequisites**: Ensure that the files `scooby0.txt`, `scooby1.txt`, `scooby2.txt`, and `subtitle.txt` are present in the same directory as the script.
- To run the script, use the following command in your terminal:
    ```bash
    tender main.td
    ```
- Observe the text animation as it displays words from the subtitle file in the console.

## Explore More

This script is part of the larger collection of examples in the 1000+ Codes in Tender repository. Feel free to explore and modify the code to enhance your understanding of text manipulation and animation effects with Tender!

## License

This project is open-source. Feel free to contribute or use it in your own projects.
