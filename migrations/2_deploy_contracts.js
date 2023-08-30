const deployContract = artifacts.require('deployContract');

module.exports = async function(deployer, network, accounts) {
  await deployer.deploy(deployContract);

  // Retrieve deployed contract's address
  const deployedContract = await deployContract.deployed();

  console.log('Contract deployed:', deployedContract.address);

  // Log the Etherscan link
  if (network === 'mainnet') {
    console.log('Etherscan Link:', `https://etherscan.io/address/${deployedContract.address}`);
  } else {
    console.log('Etherscan Link is available for mainnet deployment only.');
  }
};
