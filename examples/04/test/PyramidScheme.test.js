const PyramidScheme = artifacts.require('PyramidScheme');

contract('PyramidScheme', (accounts) => {
  it('sets the owner of the contract to the first account', async () => {
    const instance = await PyramidScheme.deployed();
    assert.equal(
      await instance.owner.call(),
      accounts[0],
      'owner is first account',
    );
  });

  it('allows signups and distributes credit', async () => {
    const instance = await PyramidScheme.deployed();
    await instance.signUp(accounts[0], {
      from: accounts[1],
      value: web3.utils.toWei('1', 'ether'),
    });

    assert.equal(
      await instance.parents.call(accounts[1]),
      accounts[0],
      'parent of recruit is recruiter',
    );

    assert.equal(
      await instance.credit.call(accounts[0]),
      web3.utils.toWei('1', 'ether'),
      'initiation fee is distributed to recruiter',
    );
  });

  // More tests...
});
