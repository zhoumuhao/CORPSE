// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

abstract contract ERC721{
  event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
  event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);

  function balanceOf(address _owner) public virtual view returns (uint256 _balance);
  function ownerOf(uint256 _tokenId) public virtual view returns (address _owner);
  function transfer(address _to, uint256 _tokenId) virtual public;
  function approve(address _to, uint256 _tokenId) virtual public;
  function takeOwnership(uint256 _tokenId) virtual public;
}
