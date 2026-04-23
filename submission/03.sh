# Which tx in block 216,351 spends the coinbase output of block 216,128?
#!/bin/bash
# Which tx in block 216,351 spends the coinbase output of block 216,128?

# Getting the blockhash of the source block (216,128) and the spending block (216,351)
source_block_hash=$(bitcoin-cli -signet -named getblockhash 216128)
spending_block_hash=$(bitcoin-cli -signet -named getblockhash 216351)

# Getting the txid of the coinbase transaction in the source block (216,128)
source_coinbase_txid=$(bitcoin-cli -signet -named getblock $source_block_hash | jq -r '.tx[0]')

# Searching the spending block (216,351) for the transaction that spends the source coinbase output
bitcoin-cli -signet -named getblock $spending_block_hash 2 | jq -r '.tx[] | select(.vin[].txid == "'$source_coinbase_txid'") | .txid'