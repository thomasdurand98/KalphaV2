pragma solidity ^0.8.12;

import "node_modules/erc721a/contracts/ERC721A.sol";

contract BasicNFT is ERC721A {
    uint256 public currentTokenId = 0;
    constructor() ERC721A("test","tt") {}

    function mint(uint256 _quant) public {
        _mint(msg.sender, _quant);
    }
}