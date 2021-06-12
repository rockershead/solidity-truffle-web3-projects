pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;

import "./leaseToken.sol";


contract houseLease{
    
     
    address payable public holdingWalletAddr;
    address public token;
    
    
    
    
    
    mapping (string=>Landlord)   leaseLandlord;
    mapping(string=>Tenant)    leaseTenant;
    mapping (string=>string)  door_codes;
    string[] public LeaseIds; 
    mapping(string=>owner_lease_id[]) public owners;     //map owner's uid to their array of lease ids
	mapping(string=>string) public tenants;          //map tenant's uid to to their lease_id
    
    // Event trigger when the buyer performs the safepay
   event tenantPay(address tenant, string leaseId, uint value, uint256 timestamp);
   event doorCodeSent(string  doorCode,string  leaseId,uint256 timestamp);
   event leaseCreated(string  landlordName,address payable _landlordAddr,string  home_addr,uint256 timestamp,uint256 value,string  leaseId);
   event refundDone(string leaseId,uint256 value);
   event sendPayoutDone(string leaseId,uint256 value);
   
    
    
    struct Landlord{
        string owner_uid;
        string landlordName;
        string home_addr;
        uint256 timestamp; //timestamp is in unix timestamp
        uint256 value;
        address payable _landlordAddr;
        
     }
     
     struct Tenant{
         string tenant_uid;
         string tenantName;
         uint256 value;
         address payable _tenantAddr;
         
         
     }

     struct owner_lease_id{
      string leaseId;
      
      }
    
    
     
     
    
    
    
    //the one who deploys the contract is the holding wallet
    constructor(address payable _holdingWalletAddr,address _token) public{
        
        holdingWalletAddr= _holdingWalletAddr;
        token=_token;
        
    }
    //function called by landlord
    function createLease(string memory uid,string memory landlordName,string memory home_addr,uint256 timestamp,uint256 value,string memory leaseId) public {
        //value in wei
        leaseLandlord[leaseId]=Landlord(uid,landlordName,home_addr,timestamp,value,msg.sender);
        LeaseIds.push(leaseId);
        owners[uid].push(owner_lease_id(leaseId));
        emit leaseCreated(landlordName,msg.sender,home_addr,timestamp,value,leaseId);
        
        
    }

    function getLeaseData(string memory leaseId) public view returns (string memory uid,string memory landlordName,string memory home_addr,uint256 timestamp, uint256 value){
        
        Landlord memory p = leaseLandlord[leaseId];
        
	    return (p.owner_uid,p.landlordName,p.home_addr,p.timestamp, p.value);

      
    }
    
    
    function listAllLeaseIds() public view returns (string[] memory){
        
        
        return LeaseIds;
    }
    
     function listLandlordLeaseIds( string memory owner_uid) public view returns(owner_lease_id[] memory){

         return owners[owner_uid];
     }

    
    //function called by tenant
    function makePayment(string memory uid,string memory leaseId,string memory tenantName)  public  {

        leaseToken _token=leaseToken(address(token)); 
       
        Landlord memory p = leaseLandlord[leaseId];
        
        require(block.timestamp <= p.timestamp, "Time expired for payment");
        
        _token.transfer(holdingWalletAddr,p.value);
        
        leaseTenant[leaseId]=Tenant(uid,tenantName,p.value,msg.sender);
        tenants[uid]=leaseId;                              //so if user wants to buy another house,can check if tenant alr has  a house.
        emit tenantPay(msg.sender,leaseId,p.value,p.timestamp);
        
        
        
    }
    //function called by landlord
    function giveDoorCode(string memory doorCode,string memory leaseId)  public{
        
        Landlord memory p = leaseLandlord[leaseId];
        require(block.timestamp <= p.timestamp, "Time expired.");
        door_codes[leaseId]=doorCode;
        
        emit doorCodeSent(doorCode,leaseId,p.timestamp);
        
    }
    
    function getDoorCode(string memory tenant_uid,string memory leaseId) public view returns (string memory) {
        
        require(keccak256(abi.encodePacked(tenants[tenant_uid]))==keccak256(abi.encodePacked(leaseId)),"You are not authorised to view the door code.");
        return door_codes[leaseId];
        
        
    }
    
    //money paid out to landlord
    function sendPayout(string memory leaseId) public {

        
        
        require(bytes(door_codes[leaseId]).length!=0);//landlord give door code
        require(msg.sender==holdingWalletAddr);

        leaseToken _token=leaseToken(address(token)); 
        
        Landlord memory p = leaseLandlord[leaseId];
        _token.transfer(p._landlordAddr,p.value);
        
        emit sendPayoutDone(leaseId,p.value);
        
        
        
    }
    
    function refund(string memory leaseId) public {
         Landlord memory p = leaseLandlord[leaseId];
        
        require(block.timestamp > p.timestamp,"Time not expired yet.");
        require(bytes(door_codes[leaseId]).length==0,"Landlord has already given the door code.No refund given.");//landlord did not give door code
        require(msg.sender==holdingWalletAddr);

        leaseToken _token=leaseToken(address(token));
        
       
        
        Tenant memory t = leaseTenant[leaseId];
        _token.transfer(t._tenantAddr,t.value);
        delete(leaseTenant[leaseId]);
        tenants[t.tenant_uid]="";                 //now tenant uid has no lease id tied to it
        emit refundDone(leaseId,t.value);
        
    }
    
    
    
    
   
    
    
   
    
    
    
    
    
    
    
    
}


 