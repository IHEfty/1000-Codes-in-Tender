import "http"
import "json"
import "strings"
import "bufio"

king := "0x" + strings.repeat("0", 40)
space := strings.repeat(" ", 42)

format_num := fn(num) {
		num = int(num)
		if (num < 1000) {
			return string(num)
		} 
		else if (num < 1000000) {
			return string(num / 1000) + "K";
		} 
		else if (num < 1000000000) {
			return string(num / 1000000) + "M";
		}
		else if (num < 1000000000000) {
			return string(num / 1000000000) + "B";
		}
		else if (num < 1000000000000000) {
			return string(num / 1000000000000) + "T";
		}
		else if (num < 1000000000000000000) {
			return string(num / 1000000000000000) + "Q";
		}
}

data := http.get(`https://whalecoin.glitch.me/blockchain`)
chain := json.decode(data)

print("Address: ")
addr := strings.trim_space(bufio.readline())
// prev_hash := null
println()

var total = 0

for block in chain {
	// println(prev_hash == chain.previousHash)
	for transaction in block.transactions {
	  if addr == transaction.sender {
	    total -= transaction.amount
	    sysout transaction.recipient || king, " ", ("-"+(transaction.amount || 0)).ired,
	    "\n"
	  }
	  if addr == transaction.recipient {
	    total += transaction.amount
	    sysout transaction.sender || king, " ", ("+"+(transaction.amount || 0)).igreen, "\n"
	  }
	  
	}
	// prev_hash = chain.hash
}

print()
sysout "-----------------------------------------------------------", "\n"

sysout "                                            ", total, "\n"
sysout "Total Amount: ".iwhite, format_num(total) // "\n"
