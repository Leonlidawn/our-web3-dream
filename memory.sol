// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract MoodDiary {
  string mood;
/**
https://stackoverflow.com/questions/33839154/in-ethereum-solidity-what-is-the-purpose-of-the-memory-keyword

unknown length data is stored in heap(memory) which is slower to access, fixed length data
is stored in stack instead.

Since memory keyword can only be used in methods, 
by default memory is applied to function argument, 
so specifying memory keyword is actually redundant!

fixed length data:
  unit256
  int256
  bool
  bytes
  char

dynamic length data:
  string, which is same as char[]
  arrays

If you declare variables in functions without the memory keyword,
then solidity will try to use the storage structure.

here are defaults for the storage location,
depending on which type of variable it concerns:

- state variables: always in storage
- function arguments: always in memory
- local variables of struct, array or mapping type: reference storage by default
- local variables of value type (i.e. neither array, nor struct nor mapping): stored in the stack
 */

    //create a function that writes a mood to the smart contract
    function setMood(string memory _mood) public {
        mood = _mood;
    }

    //create a function the reads the mood from the smart contract
    function getMood() public view returns (string memory) {
        return mood;
    }
}

contract LearWeb3Token is ERC20 {
 
    //we can call extended class's constructor with this syntex
    constructor(string memory _name, string memory _symbol)
        ERC20(_name, _symbol)
    {
        //get some tokens ourselfs, by minting to the whoever deployed the contract, which is the sender in constructor
        //mint function is from ERC20
        _mint(msg.sender, 1000 * (10**18));
    }

    //mint tokens to whoever calls the mint funciton
    function mint() public {
        _mint(msg.sender, 1000 * (10**18));
    }
}
