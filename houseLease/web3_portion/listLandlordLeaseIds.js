//Now we are using ropsten ethereum testnet.

const Web3=require('web3');
const myContract=require('./houseLeaseConfigRopsten.json');
const HDWalletProvider=require('@truffle/hdwallet-provider');

//implementing events also
const main=async()=>{

  const provider=new HDWalletProvider(

    myContract.owner.privateKey,
    myContract.infura.ropsten
  )

const web3=new Web3(provider)

//abi and contract address
var contract=new web3.eth.Contract(myContract.abi,myContract.contract_address)

var arr_object=[];
var id=0
var promises=[];

 contract.methods.listLandlordLeaseIds().call({from:myContract.owner.address}).then(res=>{console.log(res[0])})

   //var res1=await contract.methods.listTenants("60c3ee96-c66b-4740-b96e-36a3336a6cb9").call({from:myContract.owner.address})
   ///console.log(res1)


}



main()
