pragma solidity >=0.5.0 <0.6.0;
import "./helper.sol";

contract Abilities is Helper {
    uint dateProbability = 50;
    uint bringHomeProbability = 40;
    uint traumatizeProbability = 20;
    uint donScalpProbability = 20;

    function _date(uint _ancestorId, uint _crush, uint _luckyNumber) external onlyOwnerOf(_ancestorId) {
        Ancestor storage myAncestor = ancestors[_ancestorId];
        Ancestor storage crush = ancestors[_crush];
        uint rand = _randomGenerator(_luckyNumber) % 100;
        if (rand <= dateProbability) {
            myAncestor.isTaken = true;
        } else {
            myAncestor.rejections = myAncestor.rejections.add(1);
            crush.scalps = crush.scalps.add(1);
            _triggerCooldown(myAncestor);
        }
    }

    function _bringHome(uint _ancestorId, uint _crush, uint _luckyNumber) external onlyOwnerOf(_ancestorId) {
        Ancestor storage myAncestor = ancestors[_ancestorId];
        Ancestor storage crush = ancestors[_crush];
        require(myAncestor.isTaken == true);       
        uint rand =  _randomGenerator(_luckyNumber) % 100;
        if (rand <= bringHomeProbability) {
            myAncestor.canCrawl == true;
        } else {
            myAncestor.rejections = myAncestor.rejections.add(1);
            myAncestor.isTaken = false;
            crush.scalps = crush.scalps.add(1);
            _triggerCooldown(myAncestor);
        }
    }
    
    function donScalp(uint _ancestorId, uint _luckyNumber) external onlyOwnerOf(_ancestorId) {
        Ancestor storage myAncestor = ancestors[_ancestorId];
        require(myAncestor.canCrawl == true);
        uint rand = _randomGenerator(_luckyNumber) % 100;
        if (rand <= traumatizeProbability) {
            myAncestor.traumaCount = myAncestor.scalps.add(1);
        } else {
            myAncestor.rejections = myAncestor.rejections.add(1);
            myAncestor.canCrawl = false;
            _triggerCooldown(myAncestor);
        }
    }

    function _traumatize(uint _ancestorId, uint _crush, uint _luckyNumber) external onlyOwnerOf(_ancestorId) {
        Ancestor storage myAncestor = ancestors[_ancestorId];
        Ancestor storage crush = ancestors[_crush];
        require(myAncestor.traumaCount > uint32(0));
        uint rand = _randomGenerator(_luckyNumber) % 100;
        if (rand <= donScalpProbability) {
            myAncestor.traumaCount = myAncestor.traumaCount.add(1);
            } else {
            myAncestor.rejections = myAncestor.rejections.add(1);
            myAncestor.isTaken = false;
            crush.scalps = crush.scalps.sub(1);
            _triggerCooldown(myAncestor);
        }

    }

}