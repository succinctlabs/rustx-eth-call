source ../.env
forge create src/EthCallOracleV1.sol:EthCallOracleV1 \
    --rpc-url $RPC_5 \
    --private-key $PRIVATE_KEY \
    --verify \
    --etherscan-api-key $ETHERSCAN_API_5