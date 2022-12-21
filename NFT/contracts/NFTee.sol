
// SPDX-License-Identifier:MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTee is ERC721 {
  constructor() ERC721("NFTee","LL-NFT"){
    //MINTT 10 NFTs to myself
    _mint(msg.sender,1);
  }
}