import Web3 from "web3";
import Abilities from './../build/contracts/Abilities.json';

const options = {
  web3: {
    block: false,
    customProvider: new Web3("ws://localhost:7545"),
  },
  contracts: [Abilities],
  events: {
    Abilities: ["New Ancestor"],
  },
};

export default options;
