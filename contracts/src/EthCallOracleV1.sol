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

    function isCallback() external view returns (bool);
}

contract EthCallOracleV1 {
    /// @notice The address of the function gateway.
    address public constant FUNCTION_GATEWAY = 0xE304f6B116bE5e43424cEC36a5eFd0B642E0dC95;

    /// @notice The function id of the ethcall oracle.
    bytes32 public constant FUNCTION_ID =
        0xd963c3c7a53ffeb8851d88bda4a30c4557dd0bf4025f291569ccad25c0d1dc2f;

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

    /// @notice An example of using the oracle to request a call.
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
                this.callEntrypoint.selector, chainId, blockNumber, fromAddress, toAddress, data
            ),
            1000000
        );
    }

    /// @notice An example of a call entrypoint.
    function callEntrypoint(
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
