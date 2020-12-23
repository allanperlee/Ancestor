const Ancestor = artifacts.require("./abilities.sol");
const utils = require("./utils.js");
const time = require("./time.js");

contract("Ancestor", accounts => {
  let contractInstance;
  const ancestorNames = ["bruno", "bruna"];

  beforeEach(async () => {
    contractInstance = await Ancestor.deployed();
  })
  
  //this test passes
  it("...should create a new, random Ancestor", async () => {
    const result = await contractInstance._makeRandomAncestor(ancestorNames[0], { from: accounts[0] });
    assert.equal(result.receipt.status, true);
  });

  //reverts transaction
 it("...should not allow two Ancestors", async () =>{
    await contractInstance._makeRandomAncestor(ancestorNames[0], { from: accounts[0] });
    await utils.shouldThrow( contractInstance._makeRandomAncestor(ancestorNames[1], {from: accounts[0]})); 
  });

  it("...should allow the Ancestor to date", async () => {
    const luckyNumber = 1;
    //first ancestor and its respective Id
    const result = await contractInstance._makeRandomAncestor(ancestorNames[0],  {from: accounts[0]});
    const id = result.logs[0].args.ancestorId.toNumber();
    //second ancestor and respective id
    const resultTwo = await contractInstance._makeRandomAncestor(ancestorNames[1], {from: accounts[1]});
    const idTwo = result.logs[1].args.ancestorId.toNumber();
    //used the import time to accelerate the time from creation of ancestor to "tomorrow"
    await time.increase(time.duration.days(1));
    await contractInstance._date(id, idTwo, luckyNumber, {from: accounts[0]});
    assert.equal(result.receipt.status, true);
  })
});
