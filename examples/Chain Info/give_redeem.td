import "http"
import "json"
import "bufio"
import "strings"

print("Address: ")
address := strings.trim_space(bufio.readline())
print("Pass Phrase: ")
passphrase := strings.trim_space(bufio.readline())
print("Amount: ")
amount := strings.trim_space(bufio.readline())

body := {
    "amount": float(amount),
    "message": "Wooh! you got {amount} WC!",
    "address": address,
    "passphrase": passphrase
}

x := http.post("https://whalecoin.glitch.me/give", json.encode(body), {"Content-Type": "application/json"})

println(string(x))
for{}