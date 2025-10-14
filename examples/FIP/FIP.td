import "bufio"
import "strings"

var total_money = 129338.40
var students = 30
var map = {}

for i := 1; i <= students; i++ {
  var money;
  if i <= 3 {
    money = 10_000
  } 
  else if i <= 10 {
    money = 5_000
  } 
  else {
    money = total_money / (students-i)
  }
  total_money -= money
  map[i] = {
    points: money
  }
}

debug(map)
