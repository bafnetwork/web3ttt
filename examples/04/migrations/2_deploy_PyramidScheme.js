const PyramidScheme = artifacts.require('PyramidScheme');

module.exports = (deployer, network, accounts) => {
  // Deploys with the first account as the owner
  deployer.deploy(PyramidScheme, accounts[0]);
};
