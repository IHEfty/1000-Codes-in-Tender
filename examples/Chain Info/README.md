# Chain Info Script in Tender

This script, `chain_info.td`, fetches blockchain data from an external API and processes it to display address balances. It uses Tender, along with HTTP and JSON modules for data retrieval and processing.

## Script

### `chain_info.td`

```tender
import "http"
import "json"

data := http.get(`https://whalecoin.glitch.me/blockchain`)
chain := json.decode(data)

address := {}

for block in chain {
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
```

### Key Features:
- **Blockchain Data Fetching**: Retrieves data via HTTP.
- **Transaction Processing**: Updates sender and recipient balances.
- **Balance Display**: Shows balances of valid addresses.
- **Total Calculation**: Prints the total balance.

## Usage

1. Ensure Tender is installed and internet is available.
2. Run the script:
    ```bash
    tender chain_info.td
    ```
3. Output displays address balances and total amount.

### Sample Output:
```
0xabc123def456...  100.00
0x987zyx654wvu...  -50.00

Total Amount: 50.00
```

## Dependencies
- **HTTP**: For API requests.
- **JSON**: For processing JSON data.

## License

Open-source. Feel free to use or contribute.
