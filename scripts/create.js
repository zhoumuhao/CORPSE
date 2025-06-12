const ZombieFactory = artifacts.require("ZombieFactory");

module.exports = async function (callback) {
  try {
    const accounts = await web3.eth.getAccounts();
    const user = accounts[0];

    const instance = await ZombieFactory.deployed();

    console.log("Creating zombie for account:", user);
    //构建僵尸
    const tx = await instance.createZombie("ChatZombie", { from: user });
    console.log("Transaction successful. Zombie created.");
    console.log("Tx hash:", tx.tx);

    const zombieCount = await instance.zombieCount();
    const zombie = await instance.zombies(zombieCount - 1);
    //打印僵尸信息
    console.log("Zombie Info:", {
      name: zombie.name,
      dna: zombie.dna.toString(),
      level: zombie.level.toString(),
      readyTime: zombie.readyTime.toString(),
    });
    callback();
  } catch (err) {
    console.error("Error:", err);
    callback(err);
  }
};
