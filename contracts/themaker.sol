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
        ancestorCount[msg.sender] = ancestorCount[msg.sender].add(1);
        emit NewAncestor(id, _name, _dna);
    }

    function _makeRandomDNA(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function _makeRandomAncestor(string memory _name) public {
        require(ancestorCount[msg.sender] == 0);
        uint randDna = _makeRandomDNA(_name);
        randDna = randDna - randDna % 100;
        _createAncestor(_name, randDna);
    }
}