pragma solidity >=0.5.0 <0.6.0;
import "./themaker.sol";

contract Helper is TheMaker {
    
  uint levelUpFee = 0.001 ether;

    modifier onlyOwnerOf(uint _ancestorId) {
        require(msg.sender == ancestorToOwner[_ancestorId]);
        _;
    }
    
  function withdraw(uint _ancestorId) external onlyOwnerOf(_ancestorId) {
    msg.sender.transfer(address(this).balance);
  }

  function setLevelUpFee(uint _fee) external onlyOwner {
    levelUpFee = _fee;
  }

  function levelUp(uint _ancestorId) external payable {
    require(msg.value == levelUpFee);
    ancestors[_ancestorId].traumaCount = ancestors[_ancestorId].traumaCount.add(1);
  }

  function getAncestorsByOwner(address _owner) external view returns(uint[] memory) {
    uint[] memory result = new uint[](ancestorCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i < ancestors.length; i++) {
      if (ancestorToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }

  function _triggerCooldown(Ancestor storage _ancestor) internal {
    _ancestor.readyTime = uint32(now + cooldownTime);
  }

  function _isReady(Ancestor storage _ancestor) internal view returns (bool) {
      return (_ancestor.readyTime <= now);
  }
}