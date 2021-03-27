
pragma solidity ^0.5.16;

contract swapToken{
   
    
    
    address payable mainWallet;
    
    event Purchase(
        
        address buyer,
        uint256 amount
        
    );
    
    
    //set the one who deploys the contract as the main wallet
    constructor (address payable  _wallet) public{
        
        mainWallet=_wallet;
        
    }

    function getWallet() public view returns (address payable){


      return mainWallet;
    }
    
    function buyToken(uint256 noEther) external {
        
        
        //send ether to main wallet
        //msg.value is the value we put into the right hand side.the amount of ether.
        
        
        mainWallet.transfer(noEther);
         emit Purchase(msg.sender,1);
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
