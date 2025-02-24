# Hello World Scripts in Tender

## Overview  
This repo contains two simple **Tender** scripts, `hello.td` and `hello1.td`, demonstrating basic console output with and without color formatting.

## Scripts  

- **`hello.td`** – Prints "hello world" with a green background:  
  ```tender
  sysout "hello world\n".on_green
  ```

- **`hello1.td`** – Checks for color support before printing:  
  ```tender
  import "colors"
  if colors.on_green != null {
      sysout colors.on_green + "Hello, World!" + colors.reset + "\n"
  } else {
      sysout "Hello, World!\n"
  }
  ```

## Usage  
Run with:  
```bash
tender hello.td  
tender hello1.td  
```

Explore more in **1000+ Codes in Tender**! 🚀
