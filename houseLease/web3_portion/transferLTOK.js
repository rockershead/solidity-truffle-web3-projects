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



//take note addresses[0] is the deployer wallet and addresses[1] is the holdingWallet

//assume that the tenant has paid for the LTOK and the contract deployer is distributing the LTOK
var number_of_LTOK=30000
await contract.methods.transfer(addresses[3],BigInt(Number(number_of_LTOK)*Math.pow(10,18))).send({
    from:addresses[0],gas:3000000
    })




//check if tenant received LTOK
var res1=await contract.methods.balanceOf(addresses[3]).call()
console.log(res1)


}

main()
