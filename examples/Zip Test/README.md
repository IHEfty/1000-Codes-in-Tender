# Zip Test

The **Zip Test** project is part of the **1000+ Codes in Tender** collection. This project, written in [**Tender**](https://github.com/2dprototype/tender), demonstrates how to create and read ZIP files using the Tender.

## Running the Project

To run the Zip Test project, execute the `zip_test.td` script:

```bash
tender zip_test.td
```

This will create a ZIP file named `hello.zip` containing a text file `hello.txt` with the content "hello world." It also reads the contents of the ZIP file and prints them to the console.

### Customizing the ZIP File

To use a different file or content, modify the parameters in the script. For example, you can change the filename and content as follows:

```tender
myzip.create("your_file.txt", "your content here")
```

Make sure to adjust the reading logic accordingly if you change the name of the file within the ZIP.

## Project Structure

- **zip_test.td**: The main script that creates a ZIP file and reads its contents.

## Explore More

The **Zip Test** project is one of many examples in the **1000+ Codes in Tender** repository. Feel free to explore and modify the code to enhance your understanding of file compression and manipulation with Tender!

## License

This project is open-source. Feel free to contribute or use it in your own projects.
