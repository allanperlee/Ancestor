pragma solidity >=0.4.21 <0.7.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/abilities.sol";

contract TestAncestor {

  function testItCreatesNewAncestor() public {
    Abilities ancestor = Abilities(DeployedAddresses.Abilities());

    ancestor._makeRandomAncestor("bruno");

    bool expected = true;
    
    Assert.equal(ancestor, expected, "It should make an ancestor named Bruno.");
  }

}
