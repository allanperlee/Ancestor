import React, { Component } from "react";
import Abilities from "./contracts/Abilities.json";
import getWeb3 from "./getWeb3";

import "./App.css";

class App extends Component {
  state = { ancestorName: "", web3: null, accounts: null, contract: null, newValue: "" };
  
  componentDidMount = async () => {
    try {
      const contractAddr = '0x844A5f9f0d57c3f69eBfeDbE721Df2324C8fCC280';
      
      // Get network provider and web3 instance.
      const web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      const accounts = await web3.eth.getAccounts();

      // Get the contract instance.
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = Abilities.networks[networkId];
      const instance = new web3.eth.Contract(
        Abilities.abi,
        deployedNetwork && deployedNetwork.address,
      );

      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.setState({ web3, accounts, contract: instance }, this.runExample);
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  };

  async handleChange(event) {
    this.setState({newValue: event.target.value});
  }

  async handleSubmit(event) {
    event.preventDefault();

    const {accounts, contract} = this.state;
    await contract._makeRandomAncestor(this.state.newValue, { from: accounts[0] })
    const response = await contract.ancestorCount();
    this.setState({ancestorName: response});
  }

  runExample = async () => {
    const { accounts, contract } = this.state;

    // Stores a given value
    await contract.methods._makeRandomAncestor("").send({ from: accounts[0] });

    // Get the value from the contract to prove it worked.
    const response = await contract.methods.ancestorCount(accounts[0]).call();

    // Update state with the result.
    this.setState({ ancestorName: response });
  };

  render() {
    if (!this.state.web3) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    return (
      <div className="App">
        <h1>Good to Go!</h1>
        <p>Your Truffle Box is installed and ready.</p>
        <h2>Smart Contract Example</h2>
        <p>
          If your contracts compiled and migrated successfully, below will show
          a stored value of 5 (by default).
        </p>
        <p>
          Try changing the value stored on <strong>line 40</strong> of App.js.
        </p>
        <div>The stored value is: {this.state.storageValue}</div>
        <form onSubmit={this.handleSubmit}>
          <input type="text" value={this.state.newValue} onChange={this.handleChange.bind}{...this}/>
          <input type="submit" value="Submit"/>
        </form>
      </div>
    );
  }
  }

export default App;