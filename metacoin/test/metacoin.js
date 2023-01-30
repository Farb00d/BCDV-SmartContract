const MetaCoin = artifacts.require("MetaCoin");

contract('MetaCoin', (accounts) => {
  it('should put 10000 MetaCoin in the first account', async () => {
    const metaCoinInstance = await MetaCoin.deployed();
    const balance = await metaCoinInstance.getBalance.call(accounts[0]);

    assert.equal(balance.valueOf(), 10000, "10000 wasn't in the first account");
  });
  it('should call a function that depends on a linked library', async () => {
    const metaCoinInstance = await MetaCoin.deployed();
    const metaCoinBalance = (await metaCoinInstance.getBalance.call(accounts[0])).toNumber();
    const metaCoinEthBalance = (await metaCoinInstance.getBalanceInEth.call(accounts[0])).toNumber();

    assert.equal(metaCoinEthBalance, 2 * metaCoinBalance, 'Library function returned unexpected function, linkage may be broken');
  });
  it('should send coin correctly', async () => {
    const metaCoinInstance = await MetaCoin.deployed();

    // Setup 2 accounts.
    const accountOne = accounts[0];
    const accountTwo = accounts[1];

    // Get initial balances of first and second account.
    const accountOneStartingBalance = (await metaCoinInstance.getBalance.call(accountOne)).toNumber();
    const accountTwoStartingBalance = (await metaCoinInstance.getBalance.call(accountTwo)).toNumber();

    // Make transaction from first account to second.
    const amount = 10;
    await metaCoinInstance.sendCoin(accountTwo, amount, { from: accountOne });

    // Get balances of first and second account after the transactions.
    const accountOneEndingBalance = (await metaCoinInstance.getBalance.call(accountOne)).toNumber();
    const accountTwoEndingBalance = (await metaCoinInstance.getBalance.call(accountTwo)).toNumber();

    assert.equal(accountOneEndingBalance, accountOneStartingBalance - amount, "Amount wasn't correctly taken from the sender");
    assert.equal(accountTwoEndingBalance, accountTwoStartingBalance + amount, "Amount wasn't correctly sent to the receiver");
  });


  //NEW TEST 

  //1- Testing Transferring MetaCoin from an account with insufficient balance:

  it('should fail when trying to transfer coins from an account with insufficient balance', async () => {
    const metaCoinInstance = await MetaCoin.deployed();
  
    // Setup 2 accounts.
    const accountOne = accounts[0];
    const accountTwo = accounts[1];

    // Get initial balance of first account.
    const accountOneStartingBalance = (await metaCoinInstance.getBalance.call(accountOne)).toNumber();

    // Make transaction from first account to second with an amount greater than the first account's balance.
    const amount = accountOneStartingBalance + 1;
    try {
      await metaCoinInstance.sendCoin(accountTwo, amount, { from: accountOne });
      assert.fail('The transaction should have thrown an error');
    } catch (error) {
      assert.include(
        error.message,
        'revert',
        `Expected "revert", but got ${error.message}`
      );
    }

    // Check that the balances of both accounts have not changed.
    const accountOneEndingBalance = (await metaCoinInstance.getBalance.call(accountOne)).toNumber();
    const accountTwoEndingBalance = (await metaCoinInstance.getBalance.call(accountTwo)).toNumber();

    assert.equal(accountOneEndingBalance, accountOneStartingBalance, "Sender's balance changed unexpectedly");
    assert.equal(accountTwoEndingBalance, 0, "Receiver's balance changed unexpectedly");
  });


  // 2- Testing the MetaCoin balance of an account after several transactions:
  it('should update the balance of an account after multiple transactions', async () => {
    const metaCoinInstance = await MetaCoin.deployed();
  
    // Setup 2 accounts.
    const accountOne = accounts[0];
    const accountTwo = accounts[1];

    // Get initial balances of first and second account.
    const accountOneStartingBalance = (await metaCoinInstance.getBalance.call(accountOne)).toNumber();
    const accountTwoStartingBalance = (await metaCoinInstance.getBalance.call(accountTwo)).toNumber();

    // Make first transaction from first account to second.
    const amountOne = 10;
    await metaCoinInstance.sendCoin(accountTwo, amountOne, { from: accountOne });

    // Make second transaction from second account to first.
    const amountTwo = 5;
    await metaCoinInstance.sendCoin(accountOne, amountTwo, { from: accountTwo });

    // Get balances of first and second account after the transactions.
    const accountOneEndingBalance = (await metaCoinInstance.getBalance.call(accountOne)).toNumber();
    const accountTwoEndingBalance = (await metaCoinInstance.getBalance.call(accountTwo)).toNumber();

    assert.equal(
      accountOneEndingBalance,
      accountOneStartingBalance - amountOne + amountTwo,
      "Account one's balance after multiple transactions is incorrect"
    );
    assert.equal(
      accountTwoEndingBalance,
      accountTwoStartingBalance + amountOne - amountTwo,
      "Account two's balance after multiple transactions is incorrect"
    );
  });



  
});
