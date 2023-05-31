// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract nftcontract is ERC721, Ownable {
    
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    Counters.Counter private _realEstateIds;
    
    mapping (uint256 => string) public _tokenURIs;
    mapping (uint256 => string) public _tokenName;
    mapping (uint256 => uint256) public _realEstateId;
    mapping (uint256 => string) public _realEstateURIs;
    mapping (uint256 => string) public _realEstateName;
    mapping (uint256 => address) public _realEstateOwner;
    mapping (uint256 => uint256) public _tokenPower;
    mapping (uint256 => uint256) public _numberOfFraction;

    event MintNFT(uint256 tokenId, address recipient, string tokenURI,string name,uint256 realEstateId_,uint256 tokenPower);
    event CreaterealEstate(uint256 realEstateId,string realEstateName,string realEstateURIs,uint256 _numberOfFraction,address realEstateOwner);

    string private _baseURIextended;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

    function setBaseURI(string memory baseURI_) external onlyOwner {
        _baseURIextended = baseURI_;
    }

    function mintNFT(address recipient, string memory tokenURI,string memory name,uint256 realEstateId_,uint256 _power)
        public
        returns (uint256)
    {
        require (
            _realEstateOwner[realEstateId_] == msg.sender, 'not realEstate owner'
        );
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
       // mintWithTokenURI(recipient, newItemId, tokenURI);
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);
        _setName(newItemId,name);
        _setPower(newItemId,_power);
        _realEstateId[newItemId] = realEstateId_; 
        emit MintNFT(newItemId,recipient,tokenURI,name,realEstateId_,_power);
        return newItemId;
    }

    function _setTokenURI(uint256 tokenId, string memory uri) internal {
        require(
            _exists(tokenId),
            'KIP17Metadata: URI set of nonexistent token'
        );
        _tokenURIs[tokenId] = uri;
    }

    function _setName(uint256 tokenId, string memory name) internal {
        require(
            _exists(tokenId),
            'KIP17Metadata: URI set of nonexistent token'
        );
        _tokenName[tokenId] = name;
    }

    function _setPower(uint256 tokenId,uint256 _power) internal {
        require(
            _exists(tokenId),
            'nft not exists'
        );
        _tokenPower[tokenId] = _power;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURIextended;
    }

    function createrealEstate(string memory realEstateName_,string memory realEstateURIs,uint256 numberOfFraction_) public {
        _realEstateIds.increment();
        uint256 newrealEstateId = _realEstateIds.current();
        _realEstateName[newrealEstateId] = realEstateName_;
        _realEstateOwner[newrealEstateId] = msg.sender;
        _realEstateURIs[newrealEstateId] = realEstateURIs;
        _numberOfFraction[newrealEstateId] = numberOfFraction_;
        emit CreaterealEstate(newrealEstateId,realEstateName_,realEstateURIs,numberOfFraction_,msg.sender);
    }

    function getPower (uint256 tokenId) public view returns(uint256) {
        return _tokenPower[tokenId];
    }

    function getrealEstateId (uint256 tokenId) public view returns(uint256) {
        return _realEstateId[tokenId];
    }

    function getrealEstateOwner (uint256 tokenId) public view returns(address) {
        return _realEstateOwner[tokenId];
    }
}
