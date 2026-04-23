#!/bin/bash
# What is the coinbase tx in block 243,834?

# Get the block hash of block 243,834
target_block_hash=$(bitcoin-cli -signet getblockhash 243834)

# Fetch the block data and extract the coinbase transaction
coinbase_txid=$(bitcoin-cli -signet getblock $target_block_hash | jq -r '.tx[0]')

# Print the coinbase transaction id
echo $coinbase_txid