const Web3=require('web3');
const myContract=require('../build/contracts/houseLease.json');

//implementing events also
const main=async()=>{

const web3=new Web3("http://localhost:9545")

const id=await web3.eth.net.getId()
const deployedNetwork=myContract.networks[id]

var contract=new web3.eth.Contract(myContract.abi,deployedNetwork.address)
const addresses=await web3.eth.getAccounts()


//var instance=contract.at('0x36812138c0e64b241e41aA0576016F16D30E1153')
var event=contract.events.leaseCreated

// watch for changes
event.listen(function(error, result){
    
    if (!error)
        console.log(result);
});






}

main()
