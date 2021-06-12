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



await contract.methods.giveDoorCode("5467","5de7eb7d-1abc-4522-8c38-4f33f5cc0347").send({
    from:myContract.owner.address,gas:3000000
    })

    console.log("door code set")


}

main()
