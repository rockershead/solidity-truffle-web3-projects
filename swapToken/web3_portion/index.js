const Web3=require('web3');
const myContract=require('../build/contracts/swapToken.json');


const main=async()=>{

const web3=new Web3("http://localhost:9545")

const id=await web3.eth.net.getId()
const deployedNetwork=myContract.networks[id]

var contract=new web3.eth.Contract(myContract.abi,deployedNetwork.address)
const addresses=await web3.eth.getAccounts()

const mainWallet=await contract.methods.getWallet().call()


var noEther=1;
await contract.methods.buyToken(BigInt(Number(noEther)*Math.pow(10,18))).send({
  from:addresses[1],
})

//const amountToSend = web3.utils.toWei("1", "ether"); //convert to wei value

///await web3.eth.sendTransaction({
   // from:addresses[1],
    //to:mainWallet,
    //value:amountToSend




   //})

balanceSeller = await web3.eth.getBalance(mainWallet)
console.log(balanceSeller)

balanceBuyer=await web3.eth.getBalance(addresses[1])
console.log(balanceBuyer)


}

main()
