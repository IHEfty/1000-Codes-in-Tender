# Crypto Hashing in Tender

This script demonstrates how to use the built-in `crypto` module in the **Tender** programming language to generate hash values for data.

## Features

- Generate an MD5 hash from a given string.
- Easy to modify for other hashing algorithms.

### Example Output

The current output for hashing the string `"example_data"` with MD5 is:

```
8c18060e4f78b84e8cdb2bb001e42f74
```

### Code

```tender
import "crypto"

// Hashing examples
md5hash := crypto.md5("example_data")
println(md5hash)
```

## Usage

1. Install the **Tender** programming language if you haven't already.
2. Save the script as `crypto.td`.
3. Run the script using the following command:

```bash
tender crypto.td
```

## Part of 1000 Codes Project

This code is part of the **1000 Codes Project**, a collection of interesting and functional code snippets showcasing the power of the Tender language. Each snippet focuses on solving a particular problem or demonstrating a unique feature of the language.

## Explore More

This project is part of the **1000+ Codes in Tender** repository. Feel free to explore and modify the code to enhance your understanding of blockchain data processing with Tender! Visit the [Tender GitHub Repository](https://github.com/2dprototype/tender) for more examples and projects.

## License

This project is open-source. Feel free to contribute or use it in your own projects.
