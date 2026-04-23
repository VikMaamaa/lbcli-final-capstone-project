#!/bin/bash
# What block height was this tx mined?
# 49990a9c8e60c8cba979ece134124695ffb270a98ba39c9824e42c4dc227c7eb

# Store the target transaction id
target_txid=49990a9c8e60c8cba979ece134124695ffb270a98ba39c9824e42c4dc227c7eb

# Fetch the raw transaction data and extract the block hash it was mined in
# verbose=1 gives us decoded transaction data including the blockhash field
mined_block_hash=$(bitcoin-cli -signet getrawtransaction $target_txid 1 | jq -r '.blockhash')

# Fetch the block data using the block hash and extract the block height
mined_block_height=$(bitcoin-cli -signet getblock $mined_block_hash | jq -r '.height')

# Print the block height the transaction was mined in
echo $mined_block_height