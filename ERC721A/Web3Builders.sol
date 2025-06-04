// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "https://github.com/exo-digital-labs/ERC721R/blob/main/contracts/IERC721R.sol";
import "https://github.com/exo-digital-labs/ERC721R/blob/main/contracts/ERC721A.sol";

contract Web3Builders is ERC721, Ownable {
  
  uint256 public constant pricePerMint = 1 ether;
  uint256 public constant maxMintPerUser = 5;


    constructor(address initialOwner)
        ERC721("Web3Builders", "Web3")
        Ownable(initialOwner)
    {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmbseRTJWSsLfhsiWwuB2R7EtN93TxfoaMz1S5FXtsFEUB/";
    }

    function safeMint(uint256 quantity) public {
      require(msg.value >= quantity * pricePerMint, "Not Enough Funds");
      require(_numberMinted(msg.sender) * quantity <=maxMintPerUser, "Mint Limit");


        _safeMint(msg.sender, quantity);
    }
}
