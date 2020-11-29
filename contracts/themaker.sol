pragma solidity >=0.5.0 <0.6.0;
import "./ownable.sol";
import "./safemath.sol";
import "./vrf.sol";

contract TheMaker is Ownable, RandomNumberConsumer {
    using SafeMath for uint256;
    using SafeMath16 for uint16;
    using SafeMath32 for uint32;
    
    event NewAncestor(uint id, string name, uint dna);
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 days;
    
    struct Ancestor{
        string name;
        uint dna;
        uint16 scalps;
        uint32 readyTime;
        uint32 traumaCount;
        uint32 rejections;
        bool isTaken;
        bool canCrawl;
    }

    Ancestor[] public ancestors;

    mapping (uint => address) public ancestorToOwner;
    mapping (address => uint) public ancestorCount;

    function _createAncestor(string memory _name, uint _dna) internal {
        uint id = ancestors.push(Ancestor(_name, _dna, 0, uint32(now + cooldownTime), uint32(0), uint32(0), false, false)) - 1;
        ancestorToOwner[id] = msg.sender;
        emit NewAncestor(id, _name, _dna);
    }

    function _makeRandomAncestor(string memory _name, uint256 userSeed) public {
        require(ancestorCount[msg.sender] == 0);
        bytes32 requestId = requestRandomness(keyHash, fee, userSeed);
        return requestId;
    }

     /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        randomResult = randomness;
         _createAncestor(_name, randomness);
    }
}
}