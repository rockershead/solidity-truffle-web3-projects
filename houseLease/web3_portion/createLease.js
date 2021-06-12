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

//const id=await web3.eth.net.getId()
//const deployedNetwork=myContract.networks[id]

//var contract=new web3.eth.Contract(myContract.abi,deployedNetwork.address)
//const addresses=await web3.eth.getAccounts()

//take note addresses[0] is the deployer wallet and addresses[1] is the holdingWallet
//user 1 create lease


//var number_of_LTOK=12000
//await contract.methods.createLease(myContract.owner.uid,"Peter","Blk 508 Woodlands St 11 #06-77",1623311313,BigInt(Number(number_of_LTOK)*Math.pow(10,18)),"5de7eb7d-1abc-4522-8c38-4f33f5cc0347").send({
//from:myContract.owner.address
//})


//console.log("done")






//user 2 create lease
//var number_of_ether=2
//await contract.methods.createLease("Azman","Blk 509 Woodlands St 11 #06-76",1617069447,BigInt(Number(number_of_ether)*Math.pow(10,18)),"2178720d-d2b6-4d03-b866-71dba95c1021").send({
  //from:addresses[2],gas:3000000
//})


//var res1=await contract.methods.getLeaseData("9a090665-ffb2-4699-85ac-bde8151efba6").call()
//console.log(res1)
//var res2=await contract.methods.getLeaseData("2178720d-d2b6-4d03-b866-71dba95c1021").call()
////console.log(res2)

var res1=await contract.methods.listAllLeaseIds().call()
console.log(res1)
    


}

main()
