pragma solidity >=0.5.0 <0.6.0;

import "./erc721.sol";
import "./safemath.sol";
import "./helper.sol";

contract AncestorOwnership is ERC721, Helper {

  using SafeMath for uint256;

  mapping (uint => address) ancestorApprovals;

  function balanceOf(address _owner) external view returns (uint256) {
    return ancestorCount[_owner];
  }

  function ownerOf(uint256 _tokenId) external view returns (address) {
    return ancestorToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ancestorCount[_to] = ancestorCount[_to].add(1);
    ancestorCount[msg.sender] = ancestorCount[msg.sender].sub(1);
    ancestorToOwner[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);
  }

  function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
    require (ancestorToOwner[_tokenId] == msg.sender || ancestorApprovals[_tokenId] == msg.sender);
    _transfer(_from, _to, _tokenId);
  }

  function approve(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {
    ancestorApprovals[_tokenId] = _approved;
    emit Approval(msg.sender, _approved, _tokenId);
  }

}
