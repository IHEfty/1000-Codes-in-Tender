# HTTP Request Example in Tender

This project demonstrates making a basic HTTP GET request using the **http** module in **Tender**. It fetches content from a URL and displays the result.

![preview](./preview.png)

## Overview

The `http.td` script performs a GET request to a specified URL (e.g., `https://example.com`) and displays the HTML content or an error message if the request fails.

### How It Works

1. **http.get(url)** sends a GET request to the URL.
2. **is_error(response)** checks if the request was successful.
3. If successful, the HTML content is printed; if there's an error, the error message is displayed.

## Running the Project

To run, execute the `http.td` script:

```bash
tender http.td
```
