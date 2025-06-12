// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./zombieFactory.sol";
//僵尸助手合约
contract ZombieHelper is ZombieFactory {
    //升级的费用
    uint public levelUpFee = 0.001 ether;
    //判断当前僵尸级数是否大于传进来的值
    modifier aboveLevel(uint _level, uint _zombieId) {
        require(zombies[_zombieId].level >= _level, "Level is not sufficient");
        _;
    }
    //判断当前僵尸是否属于发送者
    modifier onlyOwnerOf(uint _zombieId) {
        require(msg.sender == zombieToOwner[_zombieId], "Zombie is not yours");
        _;
    }
    //设置升级费用
    function setLevelUpFee(uint _fee) external onlyOwner {
        levelUpFee = _fee;
    }

    //升级僵尸
    function levelUp(uint _zombieId) external payable onlyOwnerOf(_zombieId) {
        require(msg.value == levelUpFee, "No enough money");
        zombies[_zombieId].level++;
    }
    //改变僵尸名字
    function changeName(
        uint _zombieId,
        string calldata _newName
    ) external aboveLevel(2, _zombieId) onlyOwnerOf(_zombieId) {
        zombies[_zombieId].name = _newName;
    }

    //获取当前发送者的所有僵尸
    function getZombiesByOwner(
        address _owner
    ) external view returns (uint[] memory) {
        uint[] memory result = new uint[](ownerZombieCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < zombies.length; i++) {
            if (zombieToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
    //设置冷却时间
    function _triggerCooldown(Zombie storage _zombie) internal {
        _zombie.readyTime =
            uint32(block.timestamp + cooldownTime) -
            uint32((block.timestamp + cooldownTime) % 1 days);
    }
    //是否已过冷却时间
    function _isReady(Zombie storage _zombie) internal view returns (bool) {
        return (_zombie.readyTime <= block.timestamp);
    }

    //僵尸合体
    function multiply(
        uint _zombieId,
        uint _targetDna
    ) internal onlyOwnerOf(_zombieId) {
        Zombie storage myZombie = zombies[_zombieId];
        require(_isReady(myZombie), "Zombie is not ready");
        uint targetDnaMod = _targetDna % dnaModulus;
        uint newDna = (myZombie.dna + targetDnaMod) / 2;
        //通过合体创建的新僵尸尾数为9
        newDna = newDna - (newDna % 10) + 9;
        //创建新僵尸
        _createZombie("NoName", newDna);
        //设置冷却时间
        _triggerCooldown(myZombie);
    }
}
