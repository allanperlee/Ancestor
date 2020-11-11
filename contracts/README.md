# The-Ancestor

NFT horror game inspired by Junji Ito. Users can create an Ancestor and interact with other players's Ancestor. The objective of the game involves the Ancestor's dating life. The NFT of each user must achieve certain statuses before gaining other abilities. The statuses involve being taken, being able to crawl, being able to traumatize their partner, and donning a scalp from one of their ancestors.

The Solidity smart contract has three contracts that inherit from TheMaker contract. Abilities contract contains the actions the player can take in improving stats for their NFT. The helper contract contains functions for the players to view the amount of Ancestors each player has and other functions that involve ownership transfer. TheMaker contract inherits from the ERC-721 interface. The Ownership contract inherits from the Ownable contract.

The API used will be the Web3.js API to interact with the external functions on Abilities contract. 