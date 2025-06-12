// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./zombieOwnership.sol";
//僵尸市场合约
contract ZombieMarket is ZombieOwnership {
    //僵尸出售构造体
    struct zombieSales{
        address payable seller;
        uint price;
    }
    //出售市场列表
    mapping(uint=>zombieSales) public zombieShop;
    //市场个数
    uint shopZombieCount;
    //税率
    uint public tax = 0.01 ether;
    //出售最近价格
    uint public minPrice = 0.01 ether;
    //出售事件
    event SaleZombie(uint indexed zombieId,address indexed seller);
    //购买事件
    event BuyShopZombie(uint indexed zombieId,address indexed buyer,address indexed seller);
    //出售方法
    function saleMyZombie(uint _zombieId,uint _price)public onlyOwnerOf(_zombieId){
        require(_price>=minPrice+tax,'Your price must > minPrice+tax');
        zombieShop[_zombieId] = zombieSales(payable(msg.sender),_price);
        shopZombieCount = shopZombieCount+1;
        emit SaleZombie(_zombieId,msg.sender);
    }
    //购买方法
    function buyShopZombie(uint _zombieId)public payable{
        require(msg.value >= zombieShop[_zombieId].price,'No enough money');
        //出售
        _transfer(zombieShop[_zombieId].seller,msg.sender, _zombieId);
        zombieShop[_zombieId].seller.transfer(msg.value - tax);
        //把钱扣除税金转给出售者
        delete zombieShop[_zombieId];
        //市场总数减一
        shopZombieCount = shopZombieCount-1;
        //出发购买事件
        emit BuyShopZombie(_zombieId,msg.sender,zombieShop[_zombieId].seller);
    }
    //获取出售僵尸市场id
    function getShopZombies() external view returns(uint[] memory) {
        uint[] memory result = new uint[](shopZombieCount);
        uint counter = 0;
        for (uint i = 0; i < zombies.length; i++) {
            if (zombieShop[i].price != 0) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
    //设置税金
    function setTax(uint _value)public onlyOwner{
        tax = _value;
    }
    //设置最小金额
    function setMinPrice(uint _value)public onlyOwner{
        minPrice = _value;
    }
}
