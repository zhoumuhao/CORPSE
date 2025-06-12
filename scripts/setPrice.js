const ZombieFactory = artifacts.require("ZombieFactory");

module.exports = async function (callback) {
  try {
    const accounts = await web3.eth.getAccounts();
    const user = accounts[0];
    const instance = await ZombieFactory.deployed();
    //设置僵尸者的价格
    const price1 = web3.utils.toWei("0.001", "ether");
    await instance.setZombiePrice(price1, { from: user });
    const currentPrice = await instance.zombiePrice();
    console.log("Zombie price set successfully.");
    console.log(
      "Current zombie price:",
      web3.utils.fromWei(currentPrice, "ether"),
      "ETH",
    );
    callback();
  } catch (err) {
    console.error("Error:", err);
    callback(err);
  }
};
