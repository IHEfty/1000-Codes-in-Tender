// Variable declarations
var name = "Tender"
const PI = 3.14159

// Functions
fn add(a, b) {
    return a + b
}

// Closures
fn make_counter() {
    var count = 0
    return fn() {
        count++
        return count
    }
}

// Arrays and maps
var arr = [1, 2, 3, 4, 5]
var map = { "key": "value" }

// Type conversion and checking
var num = int("123")
if is_string(num) {
    println("This is a string")
} else {
    println("This is not a string")
}

// Error handling
var result = error("something went wrong")
if is_error(result) {
    println(result.value)
}