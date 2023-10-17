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

Goerli: [0xcDffC912FE4609918c6a42274dbFA561aCBb20Ae](https://etherscan.io/address/0xcdffc912fe4609918c6a42274dbfa561acbb20ae)

**Onchain Requests**

Import the following interface in your dApp or smart contract.

```
```

Make an onchain request and define a callback entrypoint.

**Offchain Requests**

Coming Soon!