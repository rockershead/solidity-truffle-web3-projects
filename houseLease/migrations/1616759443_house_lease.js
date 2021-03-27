const houseLease = artifacts.require("./houseLease");

module.exports = function(deployer) {
  deployer.deploy(houseLease);
};