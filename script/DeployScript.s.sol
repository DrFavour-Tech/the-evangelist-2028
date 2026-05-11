// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../src/TheEvangelist2028.sol";
import "../src/MissionToken.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // 1. Deploy Mock Token
        MissionToken mtk = new MissionToken();

        // 2. Deploy NFT (Fee set to 10 MTK tokens)
        TheEvangelist2028 nft = new TheEvangelist2028(address(mtk), 10 * 10**18);

        vm.stopBroadcast();
    }
}