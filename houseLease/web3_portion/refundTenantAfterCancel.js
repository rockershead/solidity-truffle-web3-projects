//Now we are using ropsten ethereum testnet.

const Web3=require('web3');
const myContract=require('./houseLeaseConfigRopsten.json');
const HDWalletProvider=require('@truffle/hdwallet-provider');

//implementing events also
const main=async()=>{

    //for the main contract portion

    const web3_websocket = new Web3(new Web3.providers.WebsocketProvider(myContract.infura.ropsten_ws));

     //abi and contract address
     var contract_websocket=new web3_websocket.eth.Contract(myContract.abi,myContract.contract_address)


   //for the token contract portion
  const provider=new HDWalletProvider(

    myContract.holding_wallet.privateKey,
    myContract.infura.ropsten
  )

const web3=new Web3(provider)

//abi and contract address
var contract=new web3.eth.Contract(myContract.leaseTokenAbi,myContract.lease_token_contract_address)

contract_websocket.events.tenantCancelLease({})
.on('data', async function(event){
    console.log(event.returnValues);
    console.log(event.returnValues._tenantAddr);
    console.log(event.returnValues.value);
   

    await contract.methods.transfer(event.returnValues._tenantAddr,event.returnValues.value).send({
    from:myContract.holding_wallet.address,gas:3000000
})

console.log("refund sent")
    
})






}

main()
