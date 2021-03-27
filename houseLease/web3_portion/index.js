const Web3=require('web3');
const myContract=require('../build/contracts/houseLease.json');

//implementing events also
const main=async()=>{

const web3=new Web3("http://localhost:9545")

const id=await web3.eth.net.getId()
const deployedNetwork=myContract.networks[id]

var contract=new web3.eth.Contract(myContract.abi,deployedNetwork.address)
const addresses=await web3.eth.getAccounts()


//user 1 create lease

var number_of_ether=1
await contract.methods.createLease("John","Blk 508 Woodlands St 11 #06-76",1617069447,BigInt(Number(number_of_ether)*Math.pow(10,18)),"f7d09c35-9c8a-4190-a373-ba8f1920f948").send({
from:addresses[1],gas:3000000
})



contract.events.leaseCreated({}).on('data', event=>console.log(event))




//user 2 create lease
var number_of_ether=2
await contract.methods.createLease("Azman","Blk 509 Woodlands St 11 #06-76",1617069447,BigInt(Number(number_of_ether)*Math.pow(10,18)),"2178720d-d2b6-4d03-b866-71dba95c1021").send({
  from:addresses[2],gas:3000000
})


var res1=await contract.methods.getLeaseData("f7d09c35-9c8a-4190-a373-ba8f1920f948").call()
console.log(res1)
var res2=await contract.methods.getLeaseData("2178720d-d2b6-4d03-b866-71dba95c1021").call()
console.log(res2)

}

main()
