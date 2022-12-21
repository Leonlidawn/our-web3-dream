//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.17;


contract Whitelist{

  uint8 public maxListedAddresses;

  mapping(address => bool) public list;

  uint8 public listedAddressCount;

  constructor(uint8 _maxListedAddresses) {
    maxListedAddresses = _maxListedAddresses;
  }

  function addAddressToWhitelist () public {
    require(!list[msg.sender], "Sender has already been whitelisted.");
    require(maxListedAddresses < listedAddressCount, "Limit reached. No more addresses can be whitelisted.");
    list[msg.sender] = true;
    listedAddressCount++;
  }

}



