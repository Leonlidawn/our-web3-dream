//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.17;


contract Whitelist{

  uint8 public maxListedAddresses;

  //keep in mind that mapping does not allow traversing. 
  //it only support getting value with key input, just like a function.
  //it expects frontend to provide the key in the getter.
  //therefore frontend has no way to know what keys are there. store keys in array if desired.
  mapping(address => bool) public list;

  uint8 public listedAddressCount;

  constructor(uint8 _maxListedAddresses) {
    maxListedAddresses = _maxListedAddresses;
  }

  function addAddressToWhitelist () public {
    require(!list[msg.sender], "Sender has already been whitelisted.");
    require(maxListedAddresses > listedAddressCount, "Limit reached. No more addresses can be whitelisted.");
    list[msg.sender] = true;
    listedAddressCount++;
  }

}



