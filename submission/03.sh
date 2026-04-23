# Which tx in block 216,351 spends the coinbase output of block 216,128?
# Get the block hash of block 216,128
bitcoin-cli -signet getblockhash 216128

# The coinbase tx is always the first transaction (index 0)
bitcoin-cli -signet getblock $(bitcoin-cli -signet getblockhash 216128) 2 | jq -r '.tx[0].txid'

# Save the coinbase txid 
COINBASE_TXID=$(bitcoin-cli -signet getblock $(bitcoin-cli -signet getblockhash 216128) 2 | jq -r '.tx[0].txid')

# Confirm it saved correctly
echo $COINBASE_TXID

# Get the block hash of block 216,351
bitcoin-cli -signet getblockhash 216351

# Loop through every tx in block 216,351
# Return the spending tx's txid
bitcoin-cli -signet getblock $(bitcoin-cli -signet getblockhash 216351) 2 | jq -r --arg txid "$COINBASE_TXID" '
  .tx[]                          # iterate over all transactions
  | select(                      # filter to only matching transactions
      .vin[]                     # iterate over all inputs
      | .txid == $txid           # check if input spends our coinbase
    )
  | .txid                        # return the txid of the spending transaction
'