//Now we are using ropsten ethereum testnet.

const Web3=require('web3');
const myContract=require('./houseLeaseConfigRopsten.json');
const HDWalletProvider=require('@truffle/hdwallet-provider');

//event listener has to run separately
const main=async()=>{
//HDWalletprovider does not support subscriptions!!!!!
  



const web3 = new Web3(new Web3.providers.WebsocketProvider(myContract.infura.ropsten_ws));

//abi and contract address
var contract=new web3.eth.Contract(myContract.abi,myContract.contract_address)






contract.events.leaseCreated({})
    .on('data', async function(event){
        console.log(event);
        // Do something here
    })
    


}

main()
