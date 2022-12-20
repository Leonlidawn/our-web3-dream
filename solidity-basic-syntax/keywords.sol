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
  - view: 
      - Functions which do not change any state values, no gas fee if called externally
      - If called internally from another non-view function, it will still cost gas,
        as that non-view function creates a transaction on Ethereum, and will still need to be verified from every node.
  - pure: 
      - Functions which do not change any state values, but also don't read any state values, 
      - can only call other pure functions
      - if caller function is not free, then this pure function costs gass fee.


modifiers
   - can be run before and/or after a function call. 
   - commonly used for restricting access to certain functions, validating input parameters
   - concept is similar to middlewares or decorators but more flexible

events
  - allow contracts to perform logging on the Ethereum blockchain. 
  - contract event logs can be parsed later to perform updates on the frontend interface.
  - can also be used as a cheap form of storage.
  
constructors
   - optional function that is executed when the contract is first deployed.


to send or receive eth
   - use call.value(p.amount)(p.data) to send
   - need both receive() and fallback() to receive eth.

library
  - similar to contracts in Solidity, but cannot contain any state variables, and cannot transfer ETH.
  - just provides a set of utility funcitons
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

contract Modifiers {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // Create a modifier that only allows a function to be called by the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;

      /* _ is a special character used inside modifiers, it tells
         Solidity to execute the function the modifier is used on.
         in this case, this modifier will first perform the check then
         run the caller function.
        */
    }

    // Create a function and apply the onlyOwner modifier on it
    function changeOwner(address _newOwner) public onlyOwner {
        // We will only reach this point if the modifier succeeds with its checks
        // So the caller of this transaction must be the current owner
        owner = _newOwner;
    }
}

contract Events {
    // Declare an event which logs an address and a string
    event TestCalled(address sender, string message);

    function test() public {
        // Log an event
        emit TestCalled(msg.sender, "Someone called test()!");
    }
}


// When inheriting from multiple contracts, if a function is defined multiple times, the right-most parent contract's function is used.
contract D is B, C {
    // D.foo() returns "C"
    // since C is the right-most parent with function foo();
    // override (B,C) means we want to override a method that exists in two parents
    function foo() public pure override (B, C) returns (string memory) {
        // super is a special keyword that is used to call functions
        // in the parent contract
        return super.foo();
    }
}



contract SendEther {
    function sendEth(address payable _to) public payable {
        // Just forward the ETH received in this payable function
        // to the given address
        uint amountToSend = msg.value;
        // call returns a bool value specifying success or failure
        //_to.call{value: msg.value}("") is same as to.call.value(msg.value)("")
        //usage is recipient.call.value(p.amount)(p.data)
        (bool success, bytes memory data) = _to.call{value: msg.value}("");
        require(success == true, "Failed to send ETH");
    }
}

contract ReceiveEther {
    /*
when ether is sent to this address:
   msg.data is empty
         ? receive 
            ? receive()
            : fallback()
         : fallback()

 */
    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

// calling external contracts
interface MinimalERC20 {
    // Just include the functions we are interested in
    // in the interface
    function balanceOf(address account) external view returns (uint256);
}

contract MyContract {
    MinimalERC20 externalContract;

    constructor(address _externalContract) {
        // Initialize a MinimalERC20 contract instance
        externalContract = MinimalERC20(_externalContract);
    }

    function mustHaveSomeBalance() public {
        // Require that the caller of this transaction has a non-zero
        // balance of tokens in the external ERC20 contract
        uint balance = externalContract.balanceOf(msg.sender);
        require(balance > 0, "You don't own any tokens of external contract");
    }
}


library SafeMath {
    function add(uint x, uint y) internal pure returns (uint) {
        uint z = x + y;
        // If z overflowed, throw an error
        require(z >= x, "uint overflow");
        return z;
    }
}

contract TestSafeMath {
    function testAdd(uint x, uint y) public pure returns (uint) {
        return SafeMath.add(x, y);
    }
}