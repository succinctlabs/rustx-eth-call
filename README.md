# rustx-eth-call

This repository implements access to the `eth_call` endpoint using the `rustx` framework with the
Succinct Platform.

## About

As L1 gas has gotten more expensive, there has been an explosion in the number of rollups. More 
complex and interesting protocol development has moved to L2s. However, L2 dApp developers often 
need to access L1 information in their L2s smart contract, or vice-versa. 

Example use-cases include:
- Reading Chainlink L1 data on L2 for DeFi protocols
- Conducting voting on L2, weighted by balanceOf an ERC-20 on L1
- Perp protocols on L2 with price oracles from L1 AMM pools (i.e., Uniswap TWAP)
- Claiming rewards on L2, gated by L1 ERC-721 ownership


Succinct state queries allows dapp developers to request arbitrary view function data from any L1
or L2 and have that information available on any chain. Compared with other oracle solutions like
Chainlink, Succinct state queries optimize for flexibility, latency and low gas costs. 

## How To Use

**Contract Addresses**

Function Gateway (Goerli): [0xE304f6B116bE5e43424cEC36a5eFd0B642E0dC95](https://goerli.etherscan.io/address/0xE304f6B116bE5e43424cEC36a5eFd0B642E0dC95)

Function ID (Goerli): [0xd963c3c7a53ffeb8851d88bda4a30c4557dd0bf4025f291569ccad25c0d1dc2f](https://goerli.etherscan.io/address/0xE304f6B116bE5e43424cEC36a5eFd0B642E0dC95)

**Onchain Requests**

Import the following interface in your dApp or smart contract.

```solidity
interface IFunctionGateway {
    function requestCallback(
        bytes32 _functionId,
        bytes memory _input,
        bytes memory _context,
        bytes4 _callbackSelector,
        uint32 _callbackGasLimit
    ) external payable returns (bytes32);

    function requestCall(
        bytes32 _functionId,
        bytes memory _input,
        address _address,
        bytes memory _data,
        uint32 _gasLimit
    ) external payable;

    function verifiedCall(bytes32 _functionId, bytes memory _input)
        external
        view
        returns (bytes memory);

    function isCallback() external view returns (bool);
}
```

Make an onchain request and define a callback entrypoint.

```solidity
function requestCallback(
    uint32 chainId,
    uint64 blockNumber,
    address fromAddress,
    address toAddress,
    bytes memory data
) external payable {
    IFunctionGateway(FUNCTION_GATEWAY).requestCallback{value: msg.value}(
        FUNCTION_ID,
        abi.encode(chainId, blockNumber, fromAddress, toAddress, data),
        abi.encode(nonce),
        this.handleCallback.selector,
        2000000
    );
    nonce++;
}

function handleCallback(bytes memory output, bytes memory context) external {
    require(msg.sender == FUNCTION_GATEWAY && IFunctionGateway(FUNCTION_GATEWAY).isCallback());
    uint256 requestId = abi.decode(context, (uint256));
    emit EthCallOracleV1Update(requestId, output);
}
```

**Offchain Requests**

Coming Soon!
