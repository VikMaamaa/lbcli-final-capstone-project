#!/bin/bash
# How many satoshis did this transaction pay for fee?: b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb

# Store the target transaction id
target_txid=b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb

# Fetch the raw transaction data in decoded format (verbose=true)
decoded_raw_tx=$(bitcoin-cli -signet getrawtransaction $target_txid true)

# Start total input value at 0
total_input_value=0

# Get the number of inputs in the transaction
total_inputs=$(echo "$decoded_raw_tx" | jq -r '.vin | length')

# Loop through each input and sum up their values
# We need to look up each input's previous transaction to get its value
for (( i=0; i < $total_inputs; i++)); do
    # Get the txid and vout index of the previous output being spent
    prev_txid=$(echo $decoded_raw_tx | jq -r ".vin[$i].txid")
    prev_vout_index=$(echo $decoded_raw_tx | jq -r ".vin[$i].vout")

    # Fetch the previous transaction and extract the value of the spent output
    prev_output_value=$(bitcoin-cli -signet getrawtransaction $prev_txid true | jq -r ".vout[$prev_vout_index].value")

    # Add the previous output value to the total input value
    total_input_value=$(echo "$total_input_value+$prev_output_value" | bc)
done

# Sum up all output values in the target transaction
total_output_value=$(echo $decoded_raw_tx | jq -r '[.vout[].value] | add')

# Fee = total inputs - total outputs (in BTC)
fee_in_btc=$(echo "$total_input_value-$total_output_value" | bc)

# Convert BTC to satoshis (1 BTC = 100,000,000 satoshis) and remove decimal
fee_in_satoshis=$(echo "$fee_in_btc*100000000" | bc | cut -d'.' -f 1)

echo $fee_in_satoshis