//only for tenant

const Web3=require('web3');
const myContract=require('../build/contracts/houseLease.json');


//implementing events also
const main=async()=>{

const web3=new Web3("http://localhost:9545")

const id=await web3.eth.net.getId()
const deployedNetwork=myContract.networks[id]

var contract=new web3.eth.Contract(myContract.abi,deployedNetwork.address)
const addresses=await web3.eth.getAccounts()


res1=await contract.methods.getLeaseData("f7d09c35-9c8a-4190-a373-ba8f1920f948").call()
console.log(res1)
await contract.methods.makePayment("f7d09c35-9c8a-4190-a373-ba8f1920f948","Peter Nierop").send({
from:addresses[3],gas:3000000
})







}

main()
