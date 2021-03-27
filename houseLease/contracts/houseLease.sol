pragma solidity ^0.5.16;


contract houseLease{
    
     
    address payable public holdingWalletAddr;
    
    
    
    
    
    mapping (string=>Landlord)   leaseLandlord;
    mapping(string=>Tenant)    leaseTenant;
    mapping (string=>string)  door_codes;
    
    // Event trigger when the buyer performs the safepay
   event tenantPay(address tenant, string leaseId, uint value, uint256 timestamp);
   event doorCodeSent(string  doorCode,string  leaseId,uint256 timestamp);
   event leaseCreated(string  landlordName,address payable _landlordAddr,string  home_addr,uint256 timestamp,uint256 value,string  leaseId);
   event refundDone(string leaseId,uint256 value);
   event sendPayoutDone(string leaseId,uint256 value);
   
    
    
    struct Landlord{
        string landlordName;
        string home_addr;
        uint256 timestamp; //timestamp is in unix timestamp
        uint256 value;//number of wei to pay for house
        address payable _landlordAddr;
        
     }
     
     struct Tenant{
         string tenantName;
         uint256 value;//in wei
         address payable _tenantAddr;
         
         
     }
     
     
    
    
    
    //the one who deploys the contract is the holding wallet
    constructor() public{
        
        holdingWalletAddr= msg.sender;
        
    }
    //function called by landlord
    function createLease(string memory landlordName,string memory home_addr,uint256 timestamp,uint256 value,string memory leaseId) public {
        //value in wei
        leaseLandlord[leaseId]=Landlord(landlordName,home_addr,timestamp,value,msg.sender);
        emit leaseCreated(landlordName,msg.sender,home_addr,timestamp,value,leaseId);
        
        
    }

    function getLeaseData(string memory leaseId) public view returns (string memory landlordName, uint256 value){
        
        Landlord memory p = leaseLandlord[leaseId];
        
	    return (p.landlordName, p.value);

      
    }
    
    //function called by tenant
    function makePayment(string calldata  leaseId,string calldata  tenantName)  external  {
        
       
        Landlord memory p = leaseLandlord[leaseId];
        
        require(block.timestamp <= p.timestamp, "Time expired for payment");
        
        holdingWalletAddr.transfer(p.value);
        
        leaseTenant[leaseId]=Tenant(tenantName,p.value,msg.sender);
        emit tenantPay(msg.sender,leaseId,p.value,p.timestamp);
        
        
        
    }
    //function called by landlord
    function giveDoorCode(string memory doorCode,string memory leaseId)  public{
        
        Landlord memory p = leaseLandlord[leaseId];
        require(block.timestamp <= p.timestamp, "Time expired.");
        door_codes[leaseId]=doorCode;
        
        emit doorCodeSent(doorCode,leaseId,p.timestamp);
        
    }
    
    function getDoorCode(string memory leaseId) public view returns (string memory) {
        
        return door_codes[leaseId];
        
        
    }
    
    //money paid out to landlord
    function sendPayout(string memory leaseId) public {
        
        require(bytes(door_codes[leaseId]).length!=0);//landlord give door code
        require(msg.sender==holdingWalletAddr);
        
        Landlord memory p = leaseLandlord[leaseId];
        p._landlordAddr.transfer(p.value);
        
        emit sendPayoutDone(leaseId,p.value);
        
        
        
    }
    
    function refund(string memory leaseId) public {
        
        
        Landlord memory p = leaseLandlord[leaseId];
        require(block.timestamp > p.timestamp);
        require(bytes(door_codes[leaseId]).length==0);//landlord did not give door code
        require(msg.sender==holdingWalletAddr);
        
        Tenant memory t = leaseTenant[leaseId];
        t._tenantAddr.transfer(t.value);
        emit refundDone(leaseId,t.value);
        
    }
    
    
    
    
   
    
    
   
    
    
    
    
    
    
    
    
}


 