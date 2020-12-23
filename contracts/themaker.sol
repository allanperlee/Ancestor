pragma solidity >=0.5.0 <0.6.0;
import "./ownable.sol";
import "./safemath.sol";

contract TheMaker is Ownable {
    using SafeMath for uint256;
    using SafeMath16 for uint16;
    using SafeMath32 for uint32;
    
    event NewAncestor(uint id, string name, uint dna);
    
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 days;
    uint mintSeed = 1234;

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
    mapping (address => uint) ancestorCount;

    function _makeAncestor(string memory _name, uint _dna) internal {
        uint id = ancestors.push(Ancestor(_name, _dna, 0, uint32(now + cooldownTime), uint32(0), uint32(0), false, false)) - 1;
        ancestorToOwner[id] = msg.sender;
        ancestorCount[msg.sender]++;
        emit NewAncestor(id, _name, _dna);
    }

    function _generateRandomDna(uint seed) private view returns (uint) {
        uint rand = _randomGenerator(seed);
        return rand % dnaModulus;
    }

    function _makeRandomAncestor(string memory _name) public {
        require(ancestorCount[msg.sender] == 0);
        uint dna = _generateRandomDna(mintSeed);
        dna = dna - dna % 100;
        _makeAncestor(_name, dna);
    }

    function _randomGenerator(uint seed) internal view returns (uint) {
        return uint(keccak256(abi.encode(blockhash(block.number - 1), seed)));
    }
}