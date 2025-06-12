// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./zombieHelper.sol";
//攻击僵尸合约
contract ZombieAttack is ZombieHelper {
    //随机数
    uint randNonce = 0;
    //胜率
    uint public attackVictoryProbability = 70;
    //生成随机数
    function randMod(uint _modulus) internal returns (uint) {
        randNonce++;
        return
            uint(
                keccak256(
                    abi.encodePacked(block.timestamp, msg.sender, randNonce)
                )
            ) % _modulus;
    }
    //设置胜率
    function setAttackVictoryProbability(
        uint _attackVictoryProbability
    ) public onlyOwner {
        attackVictoryProbability = _attackVictoryProbability;
    }
    //攻击
    function attack(
        uint _zombieId,
        uint _targetId
    ) external onlyOwnerOf(_zombieId) returns (uint) {
        require(
            msg.sender != zombieToOwner[_targetId],
            "The target zombie is yours!"
        );
        Zombie storage myZombie = zombies[_zombieId];
        require(_isReady(myZombie), "Your zombie is not ready!");
        Zombie storage enemyZombie = zombies[_targetId];
        uint rand = randMod(100);
        //胜利了
        if (rand <= attackVictoryProbability) {
            myZombie.winCount++;
            myZombie.level++;
            enemyZombie.lossCount++;
            //新建一个僵尸
            multiply(_zombieId, enemyZombie.dna);
            return _zombieId;
        } else {
            //失败了
            myZombie.lossCount++;
            enemyZombie.winCount++;
            _triggerCooldown(myZombie);
            return _targetId;
        }
    }
}
