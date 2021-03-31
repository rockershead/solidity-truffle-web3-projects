//to be done by deployer of contract


const Web3=require('web3');
const myContract=require('../build/contracts/leaseToken.json');

//implementing events also
const main=async()=>{

const web3=new Web3("http://localhost:9545")

const id=await web3.eth.net.getId()
const deployedNetwork=myContract.networks[id]

var contract=new web3.eth.Contract(myContract.abi,deployedNetwork.address)
const addresses=await web3.eth.getAccounts()








//check balance of holding wallet
var res1=await contract.methods.balanceOf(addresses[1]).call()
console.log(res1)

//check balance of owner

var res3=await contract.methods.balanceOf(addresses[2]).call()
console.log(res3)

//check balance of tenant

var res2=await contract.methods.balanceOf(addresses[3]).call()
console.log(res2)



}

main()
