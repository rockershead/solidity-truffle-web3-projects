pragma solidity ^0.5.16;

contract leaseToken {
    string public constant name = "Lease Token";
    string public constant symbol = "LTOK";
    uint8 public constant decimals=18;

    event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
    event Transfer(address indexed from, address indexed to, uint256 tokens);

    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;

    uint256 totalSupply_;
    
    //take note tx.origin is used in the other functions becoz I am using another contract to call this contract.
    

    using SafeMath for uint256;

   constructor() public {
        totalSupply_ = 10000000* (uint256(10) ** decimals);
        
        balances[msg.sender] = totalSupply_;
   }

    function totalSupply() public view returns (uint256) {
	    return totalSupply_;
    }

    

  

    function balanceOf(address tokenOwner) public view returns (uint256) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint256 numTokens) public returns (bool) {
        
        
        
        require(numTokens <= balances[tx.origin], "Sender there's no enough funds.");

        balances[tx.origin] = balances[tx.origin].sub(numTokens);
        balances[receiver] = balances[receiver].add(numTokens);
        emit Transfer(tx.origin, receiver, numTokens);
        return true;
        
        
    }

    function approve(address delegate, uint256 numTokens) public returns (bool) {
        allowed[tx.origin][delegate] = numTokens;
        emit Approval(tx.origin, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public view returns (uint256) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public returns (bool) {
        require(numTokens <= balances[owner], "Owner there's no enough funds.");
        require(numTokens <= allowed[owner][tx.origin], "Sender there's no enough funds.");

        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][tx.origin] = allowed[owner][tx.origin].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
}

library SafeMath {
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
      assert(b <= a);
      return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
      uint256 c = a + b;
      assert(c >= a);
      return c;
    }
}