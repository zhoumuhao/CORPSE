// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./zombieHelper.sol";
//僵尸喂食
contract ZombieFeeding is ZombieHelper {
    function feed(uint _zombieId) public onlyOwnerOf(_zombieId) {
        Zombie storage myZombie = zombies[_zombieId];
        //验证冷却时间
        require(_isReady(myZombie), "read time not arrive");
        //僵尸喂食次数 +1
        zombieFeedTimes[_zombieId] = zombieFeedTimes[_zombieId] + 1;
        //启动冷却时间
        _triggerCooldown(myZombie);
        //判断喂食是否满10次,如果满十次则新建一个僵尸
        if (zombieFeedTimes[_zombieId] % 10 == 0) {
            uint newDna = myZombie.dna - (myZombie.dna % 10) + 8;
            _createZombie("zombie's son", newDna);
        }
    }
}
