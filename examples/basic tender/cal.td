import "bufio"
import "strings" as strs
import "math" as mt

print("Enter 1st Number > ")
input := bufio.readline()
input = strs.trim_space(input)
a := float(input)

print("Enter 2nd Number > ")
inputt := bufio.readline()
inputt = strs.trim_space(inputt)
b := float(inputt)

sum := a+b // or // sysout a + b
sub := a-b // or // sysout a - b
mul := a*b // or // sysout a * b
div := a/b // or // sysout a / b

println("Sum > ", sum)
println("Sub > ", sub)
println("Mul > ", mul)
print("Div > ", div)