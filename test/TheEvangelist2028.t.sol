// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/TheEvangelist2028.sol";
import {MissionToken} from "../src/MissionToken.sol";

contract TheEvangelist2028Test is Test {
    TheEvangelist2028 public nft;
    MissionToken public mtk;

    // Test Addresses
    address public owner = address(1);
    address public leader = address(2);
    address public randomUser = address(3);

    uint256 public constant MTK_FEE = 10 * 10**18; // 10 MTK tokens

    function setUp() public {
        // Run the setup as the owner
        vm.startPrank(owner);
        
        // 1. Deploy the Mission Token
        mtk = new MissionToken();
        
        // 2. Deploy the NFT contract
        nft = new TheEvangelist2028(address(mtk), MTK_FEE);
        
        vm.stopPrank();
    }

    /**
     * TEST 1: Security - Ensure unauthorized users cannot mint
     */
    function test_FailMintWithoutAuthorization() public {
        vm.deal(randomUser, 1 ether);
        vm.prank(randomUser);
        
        vm.expectRevert("Evangelist: Task not verified");
        nft.mintWithETH{value: 0.01 ether}();
    }

    /**
     * TEST 2: Success - Authorization and Minting with ETH
     */
    function test_MintWithETH() public {
        // Owner authorizes the leader
        vm.prank(owner);
        nft.authorizeLeader(leader);

        // Leader pays 0.01 ETH to mint
        vm.deal(leader, 1 ether);
        vm.prank(leader);
        nft.mintWithETH{value: 0.01 ether}();

        assertEq(nft.balanceOf(leader), 1);
        assertEq(nft.totalMinted(), 1);
    }

    /**
     * TEST 3: Success - Minting with Mission Token (ERC20)
     */
    function test_MintWithToken() public {
        // 1. Owner authorizes leader
        vm.prank(owner);
        nft.authorizeLeader(leader);

        // 2. Transfer some MTK to the leader for testing
        vm.prank(owner);
        mtk.transfer(leader, 50 * 10**18);

        // 3. Leader MUST "approve" the NFT contract to spend their tokens
        vm.startPrank(leader);
        mtk.approve(address(nft), MTK_FEE);
        
        // 4. Mint
        nft.mintWithToken();
        vm.stopPrank();

        assertEq(nft.balanceOf(leader), 1);
        assertEq(mtk.balanceOf(owner), (1000000 - 50 + 10) * 10**18); // Owner gets the fee back
    }

    /**
     * TEST 4: Limit - Ensure one person cannot buy the whole event
     */
    function test_CannotMintTwice() public {
        vm.prank(owner);
        nft.authorizeLeader(leader);

        vm.deal(leader, 1 ether);
        vm.startPrank(leader);
        
        nft.mintWithETH{value: 0.01 ether}();
        
        vm.expectRevert("Evangelist: Leader already registered");
        nft.mintWithETH{value: 0.01 ether}();
        vm.stopPrank();
    }
}