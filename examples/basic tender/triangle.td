import "bufio"
import "strings" as strs
import "math" as mt

print("Enter Hight > ")
input := bufio.readline()
input = strs.trim_space(input)
h := float(input)

print("Enter Width > ")
inputt := bufio.readline()
inputt = strs.trim_space(inputt)
w := float(inputt)

area := 0.5*h*w

print("Triangle Area >", area)

// or 
// sysout 0.5*h*w