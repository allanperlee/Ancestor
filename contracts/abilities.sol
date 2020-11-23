pragma solidity >=0.5.0 <0.6.0;
import "./helper.sol";

contract Abilities is Helper {
    uint dateProbability = 50;
    uint bringHomeProbability = 40;
    uint traumatizeProbability = 20;
    uint donScalpProbability = 20;
    uint randNonce = 0;

   function randMod(uint _modulus) internal returns(uint) {
    randNonce = randNonce++;
    return uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % _modulus;
  }

    function _date(uint _ancestorId, uint _crush) external onlyOwnerOf(_ancestorId) {
        Ancestor storage myAncestor = ancestors[_ancestorId];
        Ancestor storage crush = ancestors[_crush];
        uint rand = randMod(100);
        if (rand <= dateProbability) {
            myAncestor.isTaken = true;
        } else {
            myAncestor.rejections = myAncestor.rejections.add(1);
            crush.scalps = crush.scalps.add(1);
            _triggerCooldown(myAncestor);
        }
    }

    function _bringHome(uint _ancestorId, uint _crush) external onlyOwnerOf(_ancestorId) {
        Ancestor storage myAncestor = ancestors[_ancestorId];
        Ancestor storage crush = ancestors[_crush];
        require(myAncestor.isTaken == true);       
        uint rand = randMod(100);
        if (rand <= bringHomeProbability) {
            myAncestor.canCrawl == true;
        } else {
            myAncestor.rejections = myAncestor.rejections.add(1);
            myAncestor.isTaken = false;
            crush.scalps = crush.scalps.add(1);
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
            myAncestor.canCrawl = false;
            _triggerCooldown(myAncestor);
        }
    }

    function _traumatize(uint _ancestorId, uint _crush) external onlyOwnerOf(_ancestorId) {
        Ancestor storage myAncestor = ancestors[_ancestorId];
        Ancestor storage crush = ancestors[_crush];
        require(myAncestor.traumaCount > uint32(0));
        uint rand = randMod(100);
        if (rand <= donScalpProbability) {
            myAncestor.traumaCount = myAncestor.traumaCount.add(1);
            partnerCount[msg.sender] = partnerCount[msg.sender].sub(1);
            } else {
            myAncestor.rejections = myAncestor.rejections.add(1);
            myAncestor.isTaken = false;
            crush.scalps = crush.scalps.sub(1);
            partnerCount[msg.sender] = partnerCount[msg.sender].sub(1);
            _triggerCooldown(myAncestor);
        }

    }

}