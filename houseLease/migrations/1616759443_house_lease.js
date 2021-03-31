const houseLease = artifacts.require("./houseLease");
const leaseToken=artifacts.require("./leaseToken");

module.exports = function(deployer) {
  

  deployer.deploy(leaseToken).then(function() {
    return deployer.deploy(houseLease,"0x40a9f0f8b4cce6110de86f576bcb24c61e22e59e",leaseToken.address);
  });
};