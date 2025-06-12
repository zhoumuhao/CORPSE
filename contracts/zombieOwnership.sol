// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;


import "./zombieHelper.sol";
import "./erc721.sol";

contract ZombieOwnership is ZombieHelper, ERC721 {
  //映射批准token给谁
  mapping (uint => address) zombieApprovals;
  //查询余额
  function balanceOf(address _owner) public view override returns (uint256 _balance) {
    return ownerZombieCount[_owner];
  }
  //查询该token的拥有者
  function ownerOf(uint256 _tokenId) public view override returns (address _owner) {
    return zombieToOwner[_tokenId];
  }
  //内部交易
  function _transfer(address _from, address _to, uint256 _tokenId) internal {
    //接受者僵尸数量加一
    ownerZombieCount[_to] = ownerZombieCount[_to]+1;
    //发送者僵尸数量加一
    ownerZombieCount[_from] = ownerZombieCount[_from]-1;
    //僵尸所有者重新赋值
    zombieToOwner[_tokenId] = _to;
    //触发交易事件
    emit Transfer(_from, _to, _tokenId);
  }
  //外部交易
  function transfer(address _to, uint256 _tokenId) public override onlyOwnerOf(_tokenId) {
    _transfer(msg.sender, _to, _tokenId);
  }
   //批准
  function approve(address _to, uint256 _tokenId) public override onlyOwnerOf(_tokenId) {
    zombieApprovals[_tokenId] = _to;
    emit Approval(msg.sender, _to, _tokenId);
  }
  //接受僵尸
  function takeOwnership(uint256 _tokenId) public override {
    require(zombieApprovals[_tokenId] == msg.sender,"appro is not match");
    address ownerOrigin = ownerOf(_tokenId);
    _transfer(ownerOrigin, msg.sender, _tokenId);
  }
}
