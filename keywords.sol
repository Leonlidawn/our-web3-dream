// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";


/**
https://stackoverflow.com/questions/33839154/in-ethereum-solidity-what-is-the-purpose-of-the-memory-keyword

unknown length data is stored in heap(memory) which is slower to access, fixed length data
is stored in stack(storage) instead.

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

visibility Quanitifiers for variables:
- internal:
 - Internal functions/ Variables can only be used internally or by derived contracts.
 - by default funcitons are internal, which means it can be accessed within the contract by calling fn()

- external: 
  − External functions are meant to be called by other contracts. 
  - To call external function within contract this.function_name() call is required. 
  - State variables cannot be marked as external.

- public:
  - Public functions/ Variables can be used both externally and internally. 
  - For public state variable, Solidity automatically creates a getter function.

- private:
  − Private functions/ Variables can only be used internally and not even by derived contracts.



Getter functions (those which return values) can be declared either view or pure:
  - View: 
      - Functions which do not change any state values, no gas fee if called externally
      - If called internally from another non-view function, it will still cost gas,
        as that non-view function creates a transaction on Ethereum, and will still need to be verified from every node.
  - Pure: 
      - Functions which do not change any state values, but also don't read any state values, 
      - can only call other pure functions
      - if caller function is not free, then this pure function costs gass fee.

≈
 */

contract MoodDiary {
  //state variable
  string mood;

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


contract C {
   //private state variable
   uint private data;
   
   //public state variable
   uint public info;

   //constructor
   constructor() public {
      info = 10;
   }
   //private function
   function increment(uint a) private pure returns(uint) { return a + 1; }
   
   //public function
   function updateData(uint a) public { data = a; }
   function getData() public view returns(uint) { return data; }
   function compute(uint a, uint b) internal pure returns (uint) { return a + b; }
}

//External Contract
contract D {
   function readData() public returns(uint) {
      C c = new C();
      c.updateData(7);         
      return c.getData();
   }
}

//Derived Contract
contract E is C {
   uint private result;
   C private c;
   
   constructor() public {
      c = new C();
   }  
   function getComputedResult() public {      
      result = compute(3, 5); 
   }
   function getResult() public view returns(uint) { return result; }
   function getData() public view returns(uint) { return c.info(); }
}

contract ViewAndPure {
    // Declare a state variable
    uint public x = 1;

    // Promise not to modify the state (but can read state)
    function addToX(uint y) public view returns (uint) {
        return x + y;
    }

    // Promise not to modify or read from state
    function add(uint i, uint j) public pure returns (uint) {
        return i + j;
    }
}