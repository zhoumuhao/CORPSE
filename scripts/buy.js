const ZombieFactory = artifacts.require("ZombieFactory");

module.exports = async function (callback) {
  try {
    const accounts = await web3.eth.getAccounts();
    const user = accounts[0];
    const instance = await ZombieFactory.deployed();
    console.log("====测试第二节内容====");
    //以太币（Ether）单位的数值转换为 Wei 单位
    const price = web3.utils.toWei("0.1", "ether");
    //购买一个僵尸
    const tt = await instance.buyZombie("ThreeZombie", {
      from: user,
      value: price,
    });
    console.log("buyZombie Transaction successful. Tx Hash:", tt.tx);
    //拥有者僵尸数量
    const zombieCount1 = await instance.ownerZombieCount(user);
    console.log("User zombie count:", zombieCount1.toString());
    callback();
  } catch (err) {
    console.error("Error:", err);
    callback(err);
  }
};
