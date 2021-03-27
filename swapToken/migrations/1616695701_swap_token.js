const swapToken = artifacts.require("./swapToken");

module.exports = function(deployer) {
  deployer.deploy(swapToken,"0x4f8f8dd722433b6d19f37ef3828c2f14c3b1fdb5");
};