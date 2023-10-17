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

Function ID (Goerli): [0x89125699d8b9207cf13cbca9ce1819192c4aef5cd2b652ed6916c74ba74339fc](https://goerli.etherscan.io/address/0xE304f6B116bE5e43424cEC36a5eFd0B642E0dC95)

**Onchain Requests**

Import the following interface in your dApp or smart contract and make an onchain request.

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

contract Example {
    /// @notice The address of the function gateway.
    address public constant FUNCTION_GATEWAY = 0xE304f6B116bE5e43424cEC36a5eFd0B642E0dC95;

    /// @notice The function id of the ethcall oracle.
    bytes32 public constant FUNCTION_ID =
        0x89125699d8b9207cf13cbca9ce1819192c4aef5cd2b652ed6916c74ba74339fc;

    /// @notice The nonce of the oracle.
    uint256 public nonce = 0;

    /// @dev The event emitted when a callback is received.
    event EthCallOracleV1Update(uint256 requestId, bytes result);

    /// @notice An example of using the oracle to request a callback.
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

    /// @notice An example of a callback handler.
    function handleCallback(bytes memory output, bytes memory context) external {
        require(msg.sender == FUNCTION_GATEWAY && IFunctionGateway(FUNCTION_GATEWAY).isCallback());
        uint256 requestId = abi.decode(context, (uint256));
        emit EthCallOracleV1Update(requestId, output);
    }
}
```

**Offchain Requests**

Coming Soon!
