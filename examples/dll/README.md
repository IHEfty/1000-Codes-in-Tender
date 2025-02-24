# Dynamic Link Library (DLL) Example in Tender

This project shows how to use a **Dynamic Link Library (DLL)** in [**Tender**](https://github.com/2dprototype/tender) to load and call functions from an external DLL.

### Key Steps:
1. **Load the DLL**: The `dll.load` function is used to load the DLL file into the script.
2. **Retrieve a Function**: The function (`add`) is retrieved from the DLL using `proc`.
3. **Call the Function**: The function is called with parameters (e.g., `3` and `4` for addition).
4. **Display the Result**: The result is printed to the console.

### Running the Project:
To execute the example, run:

```bash
tender dll.td
```

Expected Output:

```
Result of addition: 7
```

### Files:
- **dll.td**: Tender script for loading and calling the DLL function.
- **example_dll.c**: C source code with an `add` function.
- **example_dll.dll**: The compiled DLL.

### Compiling the DLL:
Use the following command to compile the C file into a DLL on Windows (MinGW):

```bash
gcc -shared -o example_dll.dll example_dll.c
```

Visit the [Tender GitHub Repository](https://github.com/2dprototype/tender) for more examples.

