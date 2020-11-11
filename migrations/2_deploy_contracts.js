var Abilities = artifacts.require("./abilities.sol");

module.exports = function(deployer) {
  deployer.deploy(Abilities);
};
