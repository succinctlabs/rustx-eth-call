// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

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
}

contract EthCallOracleV1 {
    /// @notice The address of the function gateway.
    address public constant FUNCTION_GATEWAY = 0xE304f6B116bE5e43424cEC36a5eFd0B642E0dC95;

    /// @notice The function id of the eth call oracle.
    bytes32 public constant FUNCTION_ID =
        0x197e4275632346e0d02a22fcb54b6db1966fd734325b2ea40fef04485ded2163;

    /// @notice The nonce of the oracle.
    uint256 public nonce = 0;

    /// @dev The event emitted when a callback is received.
    event EthCallOracleV1Update(uint256 requestId, bytes result);

    /// @notice The entrypoint for requesting an oracle update.
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

    /// @notice The callback function for the oracle.
    function handleCallback(bytes memory output, bytes memory context) external {
        require(msg.sender == FUNCTION_GATEWAY);
        uint256 requestId = abi.decode(context, (uint256));
        emit EthCallOracleV1Update(requestId, output);
    }

    /// @notice The entrypoint for requesting an oracle update.
    function requestCall(
        uint32 chainId,
        uint64 blockNumber,
        address fromAddress,
        address toAddress,
        bytes memory data
    ) external payable {
        IFunctionGateway(FUNCTION_GATEWAY).requestCall{value: msg.value}(
            FUNCTION_ID,
            abi.encode(chainId, blockNumber, fromAddress, toAddress, data),
            address(this),
            abi.encodeWithSelector(
                this.entrypoint.selector, chainId, blockNumber, fromAddress, toAddress, data
            ),
            1000000
        );
    }

    function entrypoint(
        int32 chainId,
        uint64 blockNumber,
        address fromAddress,
        address toAddress,
        bytes memory data
    ) external {
        bytes memory output = IFunctionGateway(FUNCTION_GATEWAY).verifiedCall(
            FUNCTION_ID, abi.encode(chainId, blockNumber, fromAddress, toAddress, data)
        );
        emit EthCallOracleV1Update(0, output); 
    }
}
