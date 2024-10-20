# Infinite Loop Demo

The **Infinite Loop Demo** is part of the **1000+ Codes in Tender** collection. This project, written in [**Tender**](https://github.com/2dprototype/tender), demonstrates how to implement and control an infinite loop in the Tender programming language.

## Running the Project

To run the **Infinite Loop Demo** project, execute the `infinite_loop.td` script:

```bash
tender infinite_loop.td
```

This will run an infinite loop where a counter is incremented and printed in each iteration. The loop does not break until the counter reaches 10.

## Code Preview

Here's a preview of the **infinite_loop.td** script:

```tender
counter := 0
for {
    println("Counter:", counter)
    counter += 1

    if counter == 10 {
        println("Breaking the loop!")
        // break
    }
}
```

### Customizing the Loop

To modify the behavior of the loop, you can adjust the condition inside the `if` statement. For example, to stop the loop at a different counter value, change the number `10` to any desired value.

Example modification:

```tender
if counter == 20 {
    println("Breaking the loop at 20!")
    break
}
```

### Breaking the Loop

By default, the loop does not break as the `break` statement is commented out. To stop the loop at a specific point, simply uncomment the `break` statement:

```tender
// Uncomment to break the loop
break
```

## Project Structure

- **infinite_loop.td**: The main script that demonstrates the infinite loop and counter logic.

## Explore More

The **Infinite Loop Demo** project is part of the **1000+ Codes in Tender** repository. Feel free to explore and modify the code to deepen your understanding of control flow and looping mechanisms in **Tender**!
