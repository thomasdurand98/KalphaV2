pragma solidity ^0.8.13;

import "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "node_modules/erc721a/contracts/ERC721A.sol";
import "lib/openzeppelin-contracts/contracts/utils/Strings.sol";

contract KalphaV2 is ERC721A {
    using Strings for uint256;
    
    uint256 public maxSupply = 300;
    mapping(address => uint256) whitelist;
    string public baseTokenURI;

    constructor(string memory _baseUri) ERC721A("test","tt") {
        baseTokenURI = _baseUri;
    }

    function mintOwnerV1() public {
        uint256 supply = totalSupply();
        require(supply + whitelist[msg.sender] <= maxSupply, "max supply");
        require(whitelist[msg.sender] > 0, "You don't have the possibility to mint");
        _safeMint(msg.sender, whitelist[msg.sender]);
        whitelist[msg.sender] = 0;
    }

    function mintAdmin(address _dest) public onlyOwner {
        uint256 supply = totalSupply();
        require(supply < maxSupply);
        _safeMint(_dest, 1);
    }

    function transferNft(address _from, address _to, uint256 _tokenId) public onlyOwner {
        ERC721A.transferFromOwner(_from, _to, _tokenId);
    } 

    function addWhitelist(address[] calldata _addrArr, uint256[] calldata _quantArr) public onlyOwner {
        require(_addrArr.length > 0, "the address array is null");
        require(_quantArr.length > 0, "the quant array is null");
        for (uint256 i = 0; i < _addrArr.length; i++) {
            whitelist[_addrArr[i]] = _quantArr[i];
        }
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        string memory baseURI = baseTokenURI;
        return bytes(baseURI).length > 0
            ? string(abi.encodePacked(baseURI, tokenId.toString()))
            : "";
    }

    function setBaseURI(string memory _baseURI) public onlyOwner {
        baseTokenURI = _baseURI;
    }
}