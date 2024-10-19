# Chain Info Script in [**Tender**](https://github.com/2dprototype/tender-free)

## Overview

This script, `chain_info.td`, fetches blockchain data from an external API and processes it to display information about transactions, specifically the balance of addresses in the blockchain. It utilizes the [**Tender**](https://github.com/2dprototype/tender), along with HTTP and JSON modules to handle data retrieval and processing.

## Script

### `chain_info.td`

The script performs the following tasks:
- Fetches the blockchain data from `https://whalecoin.glitch.me/blockchain`.
- Decodes the JSON response and processes the transaction data for each block in the chain.
- It maintains an address balance sheet, updating balances based on transaction amounts (sent and received).
- Displays the balance of each valid address and prints the total balance.

**Code Example:**
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

### Key Functionalities:
- **Blockchain Data Fetching**: Retrieves blockchain data using HTTP requests.
- **Transaction Processing**: Updates the balance of both the sender and recipient of each transaction.
- **Address Balance Display**: Shows the balances of all valid addresses.
- **Total Calculation**: Calculates and prints the total balance of all addresses.

## Usage

1. Ensure the script is run in an environment where Tender is installed and the internet connection is available.
2. To run the script, use the following command in your terminal:
    ```bash
    tender chain_info.td
    ```
3. The output will display the balance of each address in the blockchain and a summary of the total amount.

### Sample Output:
```
0xabc123def456...  100.00
0x987zyx654wvu...  -50.00

Total Amount: 50.00
```

## Dependencies
- **HTTP**: For making API requests.
- **JSON**: For decoding and processing the JSON response.

## Explore More

This project is part of the 1000+ Codes in Tender repository. Feel free to explore and modify the code to enhance your understanding of blockchain data processing with Tender!

## License

This project is open-source. Feel free to contribute or use it in your own projects.
