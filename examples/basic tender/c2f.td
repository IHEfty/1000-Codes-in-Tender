import "bufio"
import "strings" as strs
import "math" as mt

print("Enter the Celcius Temperature > ")
input := bufio.readline()
input = strs.trim_space(input)

// celcius
c := float(input)
// farhenheit
f := (c*9/5)+32
print(f)

// or use this

// sysout (c*9/5)+32