//Now we are using ropsten ethereum testnet.

const Web3=require('web3');
const myContract=require('./houseLeaseConfigRopsten.json');
const HDWalletProvider=require('@truffle/hdwallet-provider');

//implementing events also
const main=async()=>{

  const provider=new HDWalletProvider(

    myContract.tenant.privateKey,
    myContract.infura.ropsten
  )

const web3=new Web3(provider)

//abi and contract address
var contract=new web3.eth.Contract(myContract.abi,myContract.contract_address)

lease_id=await contract.methods.tenants(myContract.tenant.uid).call()
console.log(lease_id)

res1=await contract.methods.getDoorCode("3Hz1jaYhetOtRP3EvCPNHDCFpdw2",lease_id).call()

    console.log(res1)


}

main()
