const Ancestor = artifacts.require("./abilities.sol");

contract("Ancestor", accounts => {
  it("...should create a new, random Ancestor", async () => {
    const contractInstance = await Ancestor.deployed();
    
    // Create a new Ancestor
    const result = await contractInstance.makeRandomAncestor("bruno", { from: accounts[0] });

    // Will reuse this for a getter function such as getting the ID or amount of ancestors to account
    //const storedData = await simpleStorageInstance.get.call();
  
    assert.equal(result.receipt.status, true);
  });
});
