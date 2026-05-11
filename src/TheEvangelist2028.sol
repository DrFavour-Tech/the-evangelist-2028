// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract TheEvangelist2028 is ERC721, Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;
    using Strings for uint256;

    uint256 public constant MAX_LEADERS = 1000;
    uint256 public constant ETH_FEE = 0.01 ether;
    uint256 public totalMinted;
    
    IERC20 public missionToken;
    uint256 public tokenFee;

    // Your provided IPFS CID
    string private constant IPFS_BASE = "ipfs://bafybeidapxrrur52r6wnt2k5u5o2vnm27x6npsn4ibg43oeg3427uehs7q/";

    mapping(address => bool) public isAuthorized; 
    mapping(address => bool) public hasMinted;

    constructor(address _missionToken, uint256 _tokenFee) 
        ERC721("The Evangelist 2028", "EVNG28") 
        Ownable(msg.sender) 
    {
        missionToken = IERC20(_missionToken);
        tokenFee = _tokenFee;
    }

    modifier canMint() {
        require(isAuthorized[msg.sender], "Evangelist: Task not verified");
        require(!hasMinted[msg.sender], "Evangelist: Leader already registered");
        require(totalMinted < MAX_LEADERS, "Evangelist: Capacity Reached");
        _;
    }

    function authorizeLeader(address leader) external onlyOwner {
        isAuthorized[leader] = true;
    }

    function mintWithETH() external payable canMint nonReentrant {
        require(msg.value >= ETH_FEE, "Insufficient ETH Fee");
        _performMint(msg.sender);
    }

    function mintWithToken() external canMint nonReentrant {
        missionToken.safeTransferFrom(msg.sender, owner(), tokenFee);
        _performMint(msg.sender);
    }

    function _performMint(address to) internal {
        totalMinted++;
        hasMinted[to] = true;
        _safeMint(to, totalMinted);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        _requireOwned(tokenId);
        // This ensures the NFT pulls the metadata file (1.json, 2.json, etc.)
        return string(abi.encodePacked(IPFS_BASE, tokenId.toString(), ".json"));
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}