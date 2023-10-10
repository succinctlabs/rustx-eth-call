// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

interface IFunctionGateway {
    function request(
        bytes32 functionId,
        bytes memory inputs,
        bytes4 callbackSelector,
        bytes memory context
    ) external payable;
}

contract EthCallOracleV1 {
    /// @notice The address of the function gateway.
    address public constant FUNCTION_GATEWAY =
        0x852a94F8309D445D27222eDb1E92A4E83DdDd2a8;

    /// @notice The function id of the eth call oracle.
    bytes32 public constant FUNCTION_ID =
        0xd657c5ca16b1e0bf0e82542028470c2372d4a0143d60c2eb33d05bcff316d89b;

    /// @notice The nonce of the oracle.
    uint256 public nonce = 0;

    /// @dev The event emitted when a callback is received.
    event EthCallOracleV1Update(uint256 requestId, bytes result);

    /// @notice The entrypoint for requesting an oracle update.
    function request(
        uint32 chainId,
        uint64 blockNumber,
        address fromAddress,
        address toAddress,
        bytes memory data
    ) external payable {
        IFunctionGateway(FUNCTION_GATEWAY).request{value: msg.value}(
            FUNCTION_ID,
            abi.encode(chainId, blockNumber, fromAddress, toAddress, data),
            this.handleUpdate.selector,
            abi.encode(nonce)
        );
        nonce++;
    }

    /// @notice The callback function for the oracle.
    function handleUpdate(bytes memory output, bytes memory context) external {
        require(msg.sender == FUNCTION_GATEWAY);
        uint256 requestId = abi.decode(context, (uint256));
        emit EthCallOracleV1Update(requestId, output);
    }
}
