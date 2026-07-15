import "strings"
import "http"
import "json"
import "os"
import "helper/format_num"

const url = "https://whalecoin.onrender.com/blockchain"

req := http.get(url).body()

if is_error(req) {
	println(req)
	os.exit(0)
}

var chain = json.decode(req)

var wallets = {}

for i, block in chain {
	if block.transactions && block.transactions[0] {
		transaction := block.transactions[0]
		if wallets[transaction.sender] == null {
			wallets[transaction.sender] = -transaction.amount
		}
		else {
			wallets[transaction.sender] -= transaction.amount
		}		
		
		if wallets[transaction.recipient] == null {
			wallets[transaction.recipient] = +transaction.amount
		}
		else {
			wallets[transaction.recipient] += transaction.amount
		}
	}
}

for wallet, amount in wallets {
	if (wallet == "null") wallet = "0x000000000000000000"
	sysout `${wallet} ${format_num(amount).green}`, "\n"
}

for {}