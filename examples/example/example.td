import "fmt"

// Variable definition and primitive types
a := "foo"   // String
b := -19.84  // Floating point
c := 5       // Integer
d := true    // Boolean
e := '?'     // Char

fmt.println("a: ", a) // Print using fmt
println("b: ", b)
println("c: ", c)
println("d: ", d)
println("e: ", e)

// Assignment
b = "bar"    // Can assign a value of different type
println("b: ", b)

// Map and array
m := {a: {b: {c: [1, 2, 3]}}}
println("m: ", m)

// Slicing
str := "hello world"
println(str[1:5])    // "ello"

arr := [1, 2, 3, 4, 5]
println(arr[2:4])    // [3, 4]

// Functions
each := fn(seq, fun) {
    // Array iteration
    for x in seq {
        fun(x)
    }
}

sum := fn(seq) {
    s := 0
    each(seq, fn(x) {
        s += x    // Closure: capturing variable 's'
    })
    return s
}
println("sum: ", sum([1, 2, 3])) // 6

fn map_to_array (m) {
    arr := []
    // Map iteration
    for key, value in m {
        arr = append(arr, key, value)  // Built-in function 'append'
    }
    return arr
}

m_arr := map_to_array(m)
println(m_arr, " (len: ", len(m_arr), ")")

// Tail-call optimization: faster and enables loop via recursion
count_odds := fn(n, c) {
    if n == 0 {
        return c
    } else if n % 2 == 1 {
        c++
    }
    return count_odds(n-1, c)
}
num_odds := count_odds(100000, 0)
println(num_odds) // 50000

// Type coercion
s1 := string(1984)  // "1984"
i2 := int("-999")   // -999
f3 := float(-51)    // -51.0
b4 := bool(1)       // true
c5 := char(88)      // 'X'

// If statement
if three := 3; three > 2 {  // Optional init statement
    println("three > 2")
} 
else if three == 2 {
    println("three = 2")
} 
else {
    println("three < 2")
}

// For statement
seven := 0
arr2 := [1, 2, 3, 1]
for i := 0; i < len(arr2); i++ {
    seven += arr2[i]
}
println("seven: ", seven)
