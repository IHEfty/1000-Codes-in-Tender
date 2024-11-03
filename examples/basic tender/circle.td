import "bufio"
import "strings" as strs
import "math" as mt

print("Enter Radius > ")
input := bufio.readline()
input = strs.trim_space(input)

R := float(input)
area := mt.pi * R * R
print("Circle Area >", area)

// or only use 
// sysout mt.pi * R * R