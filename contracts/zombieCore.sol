// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./zombieMarket.sol";
import "./zombieFeeding.sol";
import "./zombieAttack.sol";
//僵尸核心代码
contract ZombieCore is ZombieMarket,ZombieFeeding,ZombieAttack {
    //代币名称
    string public constant name = "MyCryptoZombie";
    //代币简写
    string public constant symbol = "MCZ";
    // 如果只是收 ETH，不带 calldata
    receive() external payable {
        // 接收 ETH 的代码
    }

    // 如果可能带 calldata（例如 msg.data 不为空）
    fallback() external payable {
        // 回退函数代码
    }

    //提现
    function withdraw() external onlyOwner {
        owner.transfer(address(this).balance);
    }
    //检查该合约余额
    function checkBalance() external view onlyOwner returns(uint) {
        return address(this).balance;
    }

}
