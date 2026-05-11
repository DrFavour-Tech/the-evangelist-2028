# The Evangelist 2028 - Task-Authorized NFT

An ERC-721 NFT collection built with **Foundry** that features a unique "Leader Authorization" gate. Only authorized addresses can mint, and they must pay a minting fee in ETH.

## 🚀 Deployment Details
- **Network:** Ethereum Sepolia
- **Contract Address:** `0xF819639df6aCD4e0E177B6BCA54103B638Fdb7C3`
- **Etherscan Link:** [View on Sepolia Etherscan](https://sepolia.etherscan.io/address/0xF819639df6aCD4e0E177B6BCA54103B638Fdb7C3)

## 🛠️ Tech Stack
- **Smart Contracts:** Solidity 0.8.24
- **Development Framework:** Foundry (Forge & Cast)
- **Storage:** IPFS (Pinata)
- **Tokens:** ERC-721 (NFT) & ERC-20 (Mission Token integration)

## ⚙️ Features
- **Authorization Gate:** The contract owner must call `authorizeLeader()` before a user can mint.
- **ETH Minting:** Authorized users can mint by sending 0.01 ETH.
- **Metadata:** Hosted on IPFS with decentralized JSON storage.

## 🧪 Testing & Deployment
To run tests locally:
```bash
forge test -vv

```shell
$ forge --help
$ anvil --help
$ cast --help
```
