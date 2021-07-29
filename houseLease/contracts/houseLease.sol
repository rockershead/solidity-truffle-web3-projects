pragma solidity ^0.6.1;
pragma experimental ABIEncoderV2;

import "./leaseToken.sol";

//rmb that the user's wallet address is used as a form of identification for the users
contract houseLease{
    
     
    address payable  holdingWalletAddr;
    address public token;
    
    uint index;
    uint index1;
    uint index2;
    uint256 price;
    
    
    
    
    mapping (string=>Landlord)   leaseLandlord;
    mapping(string=>Tenant[])  leaseTenant;       //  map leaseId to array of Tenant profiles
    mapping (string=>doorCode[])  door_codes;      //map leaseId to array of doorCode struct
    string[] public LeaseIds; 
    mapping(address=>owner_lease_id[])  owners;     //map owner's wallet address to their array of lease ids
	mapping(address=>string)  tenants;          //map tenant's wallet address to to their lease_id

    
    
    // Event trigger when the buyer performs the safepay
   event tenantPay(address tenant, string leaseId, uint value, uint256 timestamp);
   event doorCodeSent(string  doorCode,string  leaseId,uint256 timestamp);
   event leaseCreated(string  landlordName,address payable _landlordAddr,string  home_addr,uint256 timestamp,uint256 value,string  leaseId);
   event refundDone(string leaseId,uint256 value);
   event sendPayoutDone(string leaseId,uint256 value);
   event tenantCancelLease(address payable _tenantAddr,string leaseId,uint256 value);
   
    
    
    struct Landlord{
        
        string landlordName;
        string home_addr;
        uint256 timestamp; //timestamp is in unix timestamp
        uint256 value;
        address payable _landlordAddr;
        
     }
     
     struct Tenant{
         
         string tenantName;
         uint256 value;
         address payable _tenantAddr;
         uint256 age;
         string race;
         
         
     }
     
     

     struct owner_lease_id{
      string leaseId;
      
      }

      struct doorCode{
         string leaseId;
         address payable _tenantAddr;
         string door_code;
      }

      
    
    
     
     
    
    
    
    //the one who deploys the contract is the holding wallet
    constructor(address payable _holdingWalletAddr,address _token) public{
        
        holdingWalletAddr= _holdingWalletAddr;
        token=_token;
        
    }
    //function called by landlord
    function createLease(string memory landlordName,string memory home_addr,uint256 timestamp,uint256 value,string memory leaseId) public {
        //value in wei
        
        leaseLandlord[leaseId]=Landlord(landlordName,home_addr,timestamp,value,msg.sender);
        LeaseIds.push(leaseId);
        owners[msg.sender].push(owner_lease_id(leaseId));
        emit leaseCreated(landlordName,msg.sender,home_addr,timestamp,value,leaseId);
        
        
    }

    function getLeaseData(string memory leaseId) public view returns (string memory landlordName,string memory home_addr,uint256 timestamp, uint256 value,address owner_wallet_address){
        
        Landlord memory p = leaseLandlord[leaseId];
        
	    return (p.landlordName,p.home_addr,p.timestamp, p.value,p._landlordAddr);

      
    }
    
    
    function listAllLeaseIds() public view returns (string[] memory){
        
        
        return LeaseIds;
    }
    //the owner who calls this function can only see his leases.
     function listLandlordLeaseIds() public view returns(owner_lease_id[] memory){

         return owners[msg.sender];
     }
     //tenant who calls this function can only view his lease
     function listTenantLeaseIds() public view returns(string memory){
       return tenants[msg.sender]; //returns leaseId

     }

    //the owner who calls this function can only delete his own leases
     
     function deleteLandlordLeaseId(string memory leaseId) public{
         
         //check leaseId belong to which owner address
         Landlord memory s = leaseLandlord[leaseId];
         require(s._landlordAddr==msg.sender,"You are not authorised to delete this lease id.");
         
             
         //1
           //Check if tenants are interested in this leaseId
          require(leaseTenant[leaseId].length==0,"There are tenants interested on this lease.Wait for money to be refunded back to tenant");



         //2
         delete (leaseLandlord[leaseId]);

         //3
         for(uint i=0;i<LeaseIds.length;i++)
         {  
             if(keccak256(abi.encodePacked(LeaseIds[i]))==keccak256(abi.encodePacked(leaseId)))
             { index1=i;}
         }
         for(uint j=index1;j<LeaseIds.length-1;j++)
         {
             LeaseIds[j]=LeaseIds[j+1];
         }
         LeaseIds.pop();

         //4

         for(uint m=0;m<owners[msg.sender].length;m++)
         {  
             owner_lease_id memory p=owners[msg.sender][m];
             if(keccak256(abi.encodePacked(p.leaseId))==keccak256(abi.encodePacked(leaseId)))
             { index=m;}
         }
         for(uint n=index;n<owners[msg.sender].length-1;n++)
         {
             owners[msg.sender][n]=owners[msg.sender][n+1];
         }
         owners[msg.sender].pop();



     }

    
    //function called by tenant
    function makePayment(string memory leaseId,string memory tenantName,uint256 age,string memory race)  public  {
        require(door_codes[leaseId].length==0,"Landlord has already allocated to a tenant"); //once landlord give door code alr, dont accept anymore payments/booking
        leaseToken _token=leaseToken(address(token)); 
       
        Landlord memory p = leaseLandlord[leaseId];
        require(msg.sender!=p._landlordAddr,"You are the landlord.You are not allowed to pay for the house");
        
        require(block.timestamp <= p.timestamp, "Time expired for payment");
        
        _token.transfer(holdingWalletAddr,p.value);

        
         
        
        leaseTenant[leaseId].push(Tenant(tenantName,p.value,msg.sender,age,race));
        tenants[msg.sender]=leaseId;                              //so if user wants to buy another house,can check if tenant alr has  a house.
        
        
        emit tenantPay(msg.sender,leaseId,p.value,p.timestamp);
        
        
        
    }
      //tenant who calls this function can only delete the leaseId that he booked and get refunded for that
      function deleteTenantLeaseId(string memory leaseId) public{

        //1)delete particular Tenant struct from leaseTenant[leaseId]
           uint index_to_delete;
         for(uint i=0;i<leaseTenant[leaseId].length;i++)
         {  
             Tenant memory p=leaseTenant[leaseId][i];
             if(p._tenantAddr==msg.sender)
             { index_to_delete=i;
                price=p.value;}
         }
         for(uint j=index_to_delete;j<leaseTenant[leaseId].length-1;j++)
         {
             leaseTenant[leaseId][j]=leaseTenant[leaseId][j+1];
         }
         leaseTenant[leaseId].pop();


        //2) 
             delete tenants[msg.sender];

             emit tenantCancelLease(msg.sender, leaseId, price);

      }


     //the owner who calls this function can only see his/her tenants
     function listTenants(string memory leaseId) public view returns(Tenant[] memory){
         //need to make sure leaseId belong only to this owner
         Landlord memory s = leaseLandlord[leaseId];
         require(s._landlordAddr==msg.sender,"You are not authorised to view tenants who have applied for this lease id.");
         return leaseTenant[leaseId];
     }


    //function called by landlord
    function giveDoorCode(string memory door_code,string memory leaseId,address payable tenantAddr)  public{
         
          //1)check if tenant made payment
          require(keccak256(abi.encodePacked(tenants[tenantAddr]))==keccak256(abi.encodePacked(leaseId)),"This tenant still has not made payment");
          
          
          //2)
        Landlord memory p = leaseLandlord[leaseId];
        require(p._landlordAddr==msg.sender,"You are not authorised to give door code for this lease id.");
        require(block.timestamp <= p.timestamp, "Time expired.");

        
        //check if he has given door code to any other people.ensure that array only has 1 struct.
        require(door_codes[leaseId].length==0,"You have already given the door code to somebody");
        //3)this step to ensure other people who choose same leaseid do not get to see door code
        door_codes[leaseId].push(doorCode(leaseId,tenantAddr,door_code));
        
        emit doorCodeSent(door_code,leaseId,p.timestamp);
        
    }
    //identify the tenant by his/her wallet address
    function getDoorCode(string memory leaseId) public view returns (string memory) {
        
        
         require(door_codes[leaseId].length!=0,"No door codes given yet");
        
        string memory door_code;
      //only 1 struct in array
        
           
            doorCode memory p=door_codes[leaseId][0];
            require(p._tenantAddr==msg.sender,"You are not authorised to receive the door code");
           door_code=p.door_code;
            
        

        
        return door_code;
        
        
    }
    
    //money paid out to landlord
    function sendPayout(string memory leaseId) public {

        
        //door_codes[leaseId] returns  an array of structs.In this case there will be only 1 struct
        require((door_codes[leaseId]).length!=0,"Landlord has not given door code yet");//means landlord give door code
        doorCode memory p=door_codes[leaseId][0];
        require(keccak256(abi.encodePacked(p.door_code))!="","Landlord has given an empty door code");
        require(msg.sender==holdingWalletAddr);

        leaseToken _token=leaseToken(address(token)); 
        
        Landlord memory s = leaseLandlord[leaseId];
        _token.transfer(s._landlordAddr,s.value);
        
        emit sendPayoutDone(leaseId,s.value);
        
        
        
    }


    function refund(string memory leaseId) public {
         Landlord memory p = leaseLandlord[leaseId];
        
        require(block.timestamp > p.timestamp,"Time not expired yet.");
        //1
        if((door_codes[leaseId]).length!=0)
        {
         doorCode memory d=door_codes[leaseId][0];
        require(keccak256(abi.encodePacked(d.door_code))=="","Landlord has given the door code a tenant, so no refund");
        }
        

        
        
        require(msg.sender==holdingWalletAddr);

        leaseToken _token=leaseToken(address(token));
        
        



        //have to refund to those who did not get the door code.can be all except 1 tenant or all tenants 
                     
        if((door_codes[leaseId]).length==0)
        {  //can be a case where no door codes were given to anyone
           if((leaseTenant[leaseId]).length!=0)
           {  
               for(uint i=0;i<(leaseTenant[leaseId]).length;i++)
               {
                   Tenant memory t = leaseTenant[leaseId][i];
                    _token.transfer(t._tenantAddr,t.value);
                    tenants[t._tenantAddr]="";  //now tenant wallet address has no lease id tied to it



             
               }

               //delete all elements in the leaseTenant[leaseId] array
               delete leaseTenant[leaseId]; 

               

           }

        }

        else
        {
            // case where  door codes were given to 1 person but not others
            Tenant memory temp_struct;

            for(uint i=0;i<(leaseTenant[leaseId]).length;i++)
               {
                   Tenant memory t = leaseTenant[leaseId][i];
                   doorCode memory d=door_codes[leaseId][0];
                   if(t._tenantAddr!=d._tenantAddr)
                   {  //refund to tenant addresses that were not given the door code
                            _token.transfer(t._tenantAddr,t.value);
                            tenants[t._tenantAddr]="";   //now tenant wallet address has no lease id tied to it
                   }  

                   else{
                        temp_struct=leaseTenant[leaseId][i];
                   }
                   
                    



             
               }

             delete leaseTenant[leaseId];

             leaseTenant[leaseId][0]=temp_struct;


        }



        
       // emit refundDone(leaseId,t.value);
        
    }
    
    
    
    
}