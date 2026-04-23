#!/bin/bash
# Only one tx in block 243,821 signals opt-in RBF. What is its txid?

# Get the block hash of block 243,821
target_block_hash=$(bitcoin-cli -signet getblockhash 243821)

# Fetch the full block data with all transaction details (verbosity=2)
target_block_data=$(bitcoin-cli -signet getblock $target_block_hash 2)

# Find the transaction that signals opt-in RBF
rbf_txid=$(echo $target_block_data | jq -r '.tx[] | select(.vin[].sequence <= 4294967293) | .txid')

# Print the txid of the RBF signaling transaction
echo $rbf_txid