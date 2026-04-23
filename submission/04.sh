# Which public key signed input 0 in this tx: d948454ceab1ad56982b11cf6f7157b91d3c6c5640e05c041cd17db6fff698f7
#!/bin/bash

# Store the target transaction id
target_txid=d948454ceab1ad56982b11cf6f7157b91d3c6c5640e05c041cd17db6fff698f7

# Fetch the raw transaction data in decoded format (verbose=1)
decoded_raw_tx=$(bitcoin-cli -signet getrawtransaction $target_txid 1)

# Extract the public key from the witness data of input 0
signing_pubkey=$(echo "$decoded_raw_tx" | jq -r '.vin[0].txinwitness[1]')

# Print the signing public key
echo $signing_pubkey