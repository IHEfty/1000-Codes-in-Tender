import "bufio"
import "strings" as strs
import "math" as mt

print("Enter the Farhenheit Temperature > ")
input := bufio.readline()
input = strs.trim_space(input)

// farhenheit
f := float(input)
// celcius
c := (f-32)*5/9
print(c)

// or use this

// sysout (f-32)*5/9
