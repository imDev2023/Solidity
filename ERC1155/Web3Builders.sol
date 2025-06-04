// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Pausable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/finance/PaymentSplitter.sol";

contract Web3Builders is ERC1155, Ownable, ERC1155Pausable, ERC1155Supply, PaymentSplitter {
    uint256 public publicPrice = 0.01 ether;
    uint public allowListPrice = 0.001 ether;
    uint256 public maxSupply = 100;
    uint256 public maxPerWallet = 3;

    bool public publicMintOpen;
    bool public allowListMintOpen = true;

    mapping(address => bool) public allowList;
    mapping(address => uint256) public purchasesPerWallet;

    constructor(address initialOwner,
        address[] memory _payees,
        uint256[] memory _shares
    )

        ERC1155("ipfs://Qmaa6TuP2s9pSKczHF4rwWhTKUdygrrDs8RmYYqCjP3Hye/")
        PaymentSplitter(_payees, _shares)
        Ownable(initialOwner)
    {}

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function editMintWindows(bool _publicMintOpen, bool _allowListMintOpen) external onlyOwner{
        publicMintOpen = _publicMintOpen;
        allowListMintOpen = _allowListMintOpen;
    }

    // Create a function to set the allowList;
    function setAllowList(
        address[] calldata addresses
    ) external onlyOwner{
        for(uint256 i = 0; i< addresses.length; i++){
            allowList[addresses[i]] = true;
        }
    }

    function allowListMint(
        uint256 id, 
        uint256 amount) 
        public payable {

        require(allowListMintOpen, "Allowlist Mint Close");
        require(msg.value == 0.001 ether * amount, "Not enough funds");
        require(allowList[msg.sender], "You are not on the Allow List");
        internalMint(id, amount);
    }

    // Add Supply tracking
    function PublicMint(uint256 id, uint256 amount)
        public payable 
        
    {   
        require(publicMintOpen, "Public Mint Closed");
        require(msg.value == publicPrice * amount, "WRONG! Not enough funds sent");
        internalMint(id, amount);
    }

    function internalMint(uint256 id, uint256 amount) internal{
        require(purchasesPerWallet[msg.sender] + amount <= maxPerWallet, "Wallet Limit Reached");
        require(id <2, "Sorry looks like you are trying to mint the wrong NFT");
        require(totalSupply(id) * amount< maxSupply, "We Are Sold Out");
        _mint(msg.sender, id, amount, "");
        purchasesPerWallet[msg.sender] += amount;
    }
  // Two Ways to write withdrawal  functions: 1
   function withdraw(address _addr) external onlyOwner{
    uint256 balance = address(this).balance; // get the balance of the contract
    payable(_addr).transfer(balance);
   }
       // Two Ways to write withdrawal  functions: 2
        //   function withdraw() external onlyOwner{
        //     uint256 balance = address(this).balance;
        //     Address.sendValue(payable(msg.sender), balance);
        // }

     function uri(uint256 _id) public view virtual override returns (string memory) {
        require(exists(_id), "URI: nonexistent token");
        return string(abi.encodePacked(super.uri(_id), Strings.toString(_id), ".json"));
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
    }

    // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256[] memory ids, uint256[] memory values)
        internal
        override(ERC1155, ERC1155Pausable, ERC1155Supply)
    {
        super._update(from, to, ids, values);
    }
}
