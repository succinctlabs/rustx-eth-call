// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "forge-std/Script.sol";
import "../src/EthCallOracleV1.sol";

contract RequestUpdateScript is Script {
    function run() public {
        vm.broadcast();
        EthCallOracleV1 s = EthCallOracleV1(0x1898bf58B6cA6bb5DceF418DE8872D30c4979945);
        // s.requestCallback{value: 30 gwei * 1_000_000}(
        //     5,
        //     9591261,
        //     address(0x355348b048b5b491793110bB76d7A2723262D175),
        //     address(0xD555cD8277B0E16860F0aE44FcbC2Ed94DFce9da),
        //     hex"050DDCCE00000000000000000000000003ACD25623E5999FDDC27BE7FDB904358700F3AE000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000064EB9D300000000000000000000000000000000000000000000000000000000000000000"
        // );
        s.requestCall{value: 30 gwei * 1_000_000}(
            5,
            9591261,
            address(0x355348b048b5b491793110bB76d7A2723262D175),
            address(0xD555cD8277B0E16860F0aE44FcbC2Ed94DFce9da),
            hex"050DDCCE00000000000000000000000003ACD25623E5999FDDC27BE7FDB904358700F3AE000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000064EB9D300000000000000000000000000000000000000000000000000000000000000000"
        );
    }
}
