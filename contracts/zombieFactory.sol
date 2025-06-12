// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;
import "./ownable.sol";
contract ZombieFactory is Ownable {
    //创建僵尸事件
    event NewZombie(uint zombieId, string name, uint dna);

    //基因位数=16
    uint dnaDigits = 16;
    //基因16位单位
    uint dnaModulus = 10 ** dnaDigits;
    //冷却时间
    uint public cooldownTime = 1 days;
    //僵尸价格
    uint public zombiePrice = 0.01 ether;
    //初始僵尸总数
    uint public zombieCount = 0;
    //僵尸结构体
    struct Zombie {
        string name; //名字
        uint dna; //基因
        uint16 winCount; //胜利次数
        uint16 lossCount; //失败次数
        uint32 level; //等级
        uint32 readyTime; //冷却时间
    }
    //僵尸数组
    Zombie[] public zombies;
    //僵尸id=>拥有者
    mapping(uint => address) public zombieToOwner;
    //拥有者=>僵尸数量
    mapping(address => uint) ownerZombieCount;
    //僵尸id=>喂食次数
    mapping(uint => uint) public zombieFeedTimes;

    //生成随机数
    function _generateRandomDna(
        string memory _str
    ) private view returns (uint) {
        return
            uint(keccak256(abi.encodePacked(_str, block.timestamp))) %
            dnaModulus;
    }

    //抽离 创建僵尸 私有函数
    function _createZombie(string memory _name, uint _dna) internal {
        zombies.push(Zombie(_name, _dna, 0, 0, 1, 0));
        uint id = zombies.length - 1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        zombieCount++;
        emit NewZombie(id, _name, _dna);
    }

    //创建僵尸
    function createZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0, "zombie is more");
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - (randDna % 10);
        _createZombie(_name, randDna);
    }

    //购买僵尸
    function buyZombie(string memory _name) public payable {
        require(ownerZombieCount[msg.sender] > 0, "zombie must than zero");
        require(msg.value > zombiePrice, "price less");
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - (randDna % 10) + 1;
        _createZombie(_name, randDna);
    }

    //设置僵尸价格
    function setZombiePrice(uint _price) external onlyOwner {
        zombiePrice = _price;
    }
}
