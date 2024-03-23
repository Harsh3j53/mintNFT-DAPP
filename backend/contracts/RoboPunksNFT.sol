// SPDX-License-Identifier: UNLICENSED OR MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract RoboPunksNFT is ERC721, Ownable {
    // State variables
    uint256 public mintPrice;
    uint256 public totalSupply;
    uint256 public maxSupply;
    uint256 public maxPerWallet;
    bool public isPublicMintEnabled;
    string internal baseTokenUri;
    address public withdrawWallet;

    mapping(uint256 => bool) private _exists;
    mapping(address => uint256) public walletMints;

    // Constructor
    constructor() ERC721("RoboPunksNFT", "RP") Ownable(msg.sender) {
        mintPrice = 0.02 ether;
        totalSupply = 0;
        maxSupply = 1000;
        maxPerWallet = 3;
    }

    // Function to set isPublicMintEnabled, accessible only by owner
    function setisPublicMintEnabled(bool isPublicMintEnabled_) external onlyOwner {
        isPublicMintEnabled = isPublicMintEnabled_;
    }

    function setbaseTokenUri(string calldata baseTokenUri_) external onlyOwner {
        baseTokenUri = baseTokenUri_;
    }

    function tokenURI(uint256 tokenId_) public view override returns (string memory) {
        require(_exists[tokenId_], "Token does not exist");
        return string(abi.encodePacked(baseTokenUri, Strings.toString(tokenId_), ".json"));
    }

    function withdraw() external onlyOwner {
        (bool success, ) = payable(withdrawWallet).call{value: address(this).balance}('');
        require(success, 'Withdraw failed');
    }

    function mint(uint256 quantity_) public payable {
        require(isPublicMintEnabled, 'Minting not enabled');
        require(msg.value == quantity_ * mintPrice, 'Wrong mint value');
        require(totalSupply + quantity_ <= maxSupply, 'Sold out');
        require(walletMints[msg.sender] + quantity_ <= maxPerWallet, 'Exceed max wallet');

        // Mint tokens here and update state variables
        for (uint256 i = 0; i < quantity_; i++) {
            // Increment totalSupply and walletMints
            totalSupply++;
            walletMints[msg.sender]++;
            // Mint new token
            _safeMint(msg.sender, totalSupply);
            // Mark token as existing
            _exists[totalSupply] = true;
        }
    }
}
