// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract Web3Builder is ERC20, ERC20Permit {
    constructor() ERC20("Web3Builder", "W3B") ERC20Permit("Web3Builder") {
        _mint(msg.sender, 10000 * 10 ** decimals());
    }
}
