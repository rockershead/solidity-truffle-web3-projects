//Now we are using ropsten ethereum testnet.

const Web3=require('web3');
const myContract=require('./houseLeaseConfigRopsten.json');
const HDWalletProvider=require('@truffle/hdwallet-provider');

//implementing events also
const main=async()=>{

  const provider=new HDWalletProvider(

    myContract.tenant.privateKey,
    myContract.infura.ropsten
  )

const web3=new Web3(provider)

//abi and contract address
var contract=new web3.eth.Contract(myContract.abi,myContract.contract_address)

var arr_object=[];
var id=0
var promises=[];

var res1=await contract.methods.listAllLeaseIds().call()    //array of leaseIds
console.log(res1)

res1.forEach( leaseId=> {

     promises.push(contract.methods.getLeaseData(leaseId).call().then(lease_info=>{
      
        id=id+1
    
      var new_object={"id":id,"uid":lease_info.uid,"landlordName":lease_info.landlordName,"home_addr":lease_info.home_addr,"lease_expiry":lease_info.timestamp,"price":lease_info.value}
      arr_object.push(new_object)


     }))
     
})
return Promise.all(promises).then(done=>{
    console.log(arr_object)
})

}

main()
