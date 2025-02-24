# Chain Info Script (Tender)

`chain_info.td` fetches blockchain data, processes transactions, and displays address balances.

## Features
- **Fetches Blockchain Data** via HTTP.  
- **Processes Transactions** updating balances.  
- **Displays Balances** for valid addresses.  
- **Calculates Total** amount in the blockchain.  

## Usage
```bash
tender chain_info.td
```

## Sample Output
```
0xabc123def456...  100.00
0x987zyx654wvu...  -50.00

Total Amount: 50.00
```

## Dependencies
- HTTP, JSON (built-in Tender modules).  

**License:** Open-source.
