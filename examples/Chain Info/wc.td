import "http"
import "json"

data := http.get(`https://whalecoin.glitch.me/blockchain`)
chain := json.decode(data)

address := {}

// prev_hash := null

for block in chain {
	// println(prev_hash == chain.previousHash)
	for transaction in block.transactions {
		if address[transaction.recipient] == null {
			address[transaction.recipient] = 0
		}
		if address[transaction.sender] == null {
			address[transaction.sender] = 0
		}
		
		address[transaction.recipient] += transaction.amount
		address[transaction.sender] -= transaction.amount
	}
	// prev_hash = chain.hash
}

total := 0

for k, v in address {
	if len(k) != 42 {
		continue
	}
	sysout k.green, " ", string(v).iwhite, "\n"
	total += v
}

println()
sysout "Total Amount: ".iwhite, total, "\n"
