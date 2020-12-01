const Ancestor = artifacts.require("./abilities.sol");
const utils = require("./utils.js");

contract("Ancestor", accounts => {
  let contractInstance;
  const ancestorNames = ["bruno", "bruna"];

  beforeEach(async () => {
    contractInstance = await Ancestor.deployed();
    seed = 1234;
  })
  //this test passes
  it("...should create a new, random Ancestor", async () => {
    const result = await contractInstance._makeRandomAncestor(ancestorNames[0], seed, { from: accounts[0] });
    assert.equal(result.receipt.status, true);
  });

  //so far allows two Ancestors per account
 it("...should not allow two Ancestors", async () =>{
    await contractInstance._makeRandomAncestor(ancestorNames[0], seed, { from: accounts[0] });
    await utils.shouldThrow(await contractInstance._makeRandomAncestor(ancestorNames[1], seed, {from: accounts[0]})); 
  });

  //it("...should allow the Ancestor to date", async () => {
    //const result = await contractInstance._makeRandomAncestor(ancestorNames[0], seed, {from: accounts[0]});
    //const id = result.logs[0].args.ancestorId.toNumber();
    //const resultTwo = await contractInstance._makeRandomAncestor(ancestorNames[1], seed, {from: accounts[1]});
    //const idTwo = result.logs[1].args.ancestorId.toNumber();
    //await time.increase(time.duration.days(1));
    //await contractInstance._date(id, idTwo, {from: accounts[0]}, {from: accounts[1]});
    //assert.equal(result.receipt.status, true);
  //})
});
