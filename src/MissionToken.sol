// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MissionToken is ERC20 {
    constructor() ERC20("Mission Token", "MTK") {
        // Mint 1 million tokens so I can you distribute them for testing
        _mint(msg.sender, 1_000_000 * 10**18);
    }
}