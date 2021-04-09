var MyContract = artifacts.require("./NCToken.sol");
module.exports = function(deployer) {
  deployer.deploy(MyContract);
};
