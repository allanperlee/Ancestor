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


      uint dateProbability = 50;
    uint bringHomeProbability = 40;
    uint traumatizeProbability = 20;
    uint donScalpProbability = 20;
    uint randNonce = 0;

   function randMod(uint _modulus) internal returns(uint) {
    randNonce = randNonce++;
    return uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % _modulus;
  }

    function _date(uint _ancestorId) external onlyOwnerOf(_ancestorId) {
        Ancestor storage myAncestor = ancestors[_ancestorId];
        uint rand = randMod(100);
        if (rand <= dateProbability) {
            myAncestor.isTaken = true;
        } else {
            myAncestor.rejections = myAncestor.rejections.add(1);
            _triggerCooldown(myAncestor);
        }
    }

    function _bringHome(uint _ancestorId) external onlyOwnerOf(_ancestorId) {
        Ancestor storage myAncestor = ancestors[_ancestorId];
        require(myAncestor.isTaken == true);       
        uint rand = randMod(100);
        if (rand <= bringHomeProbability) {
            myAncestor.canCrawl == true;
        } else {
            myAncestor.rejections = myAncestor.rejections.add(1);
            _triggerCooldown(myAncestor);
        }
    }
    
    function donScalp(uint _ancestorId) external onlyOwnerOf(_ancestorId) {
        Ancestor storage myAncestor = ancestors[_ancestorId];
        require(myAncestor.canCrawl == true);
        uint rand = randMod(100);
        if (rand <= traumatizeProbability) {
            myAncestor.traumaCount = myAncestor.scalps.add(1);
        } else {
            myAncestor.rejections = myAncestor.rejections.add(1);
            _triggerCooldown(myAncestor);
        }
    }

    function _traumatize(uint _ancestorId) external onlyOwnerOf(_ancestorId) {
        Ancestor storage myAncestor = ancestors[_ancestorId];
        require(myAncestor.traumaCount > uint32(0));
        uint rand = randMod(100);
        if (rand <= donScalpProbability) {
            myAncestor.traumaCount = myAncestor.traumaCount.add(1);
        } else {
            myAncestor.rejections = myAncestor.rejections.add(1);
            _triggerCooldown(myAncestor);
        }

    }
}