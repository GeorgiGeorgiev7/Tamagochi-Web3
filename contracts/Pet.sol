// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Market.sol";

contract Pet is ERC721 {
    Market private _market;
    mapping(uint256 => uint256) private _starve;
    mapping(address => uint256[]) private _petsOf;

    modifier onlyToken() {
        require(
            _msgSender() == address(_market.token()),
            "Only token is allowed to perform this operation"
        );
        _;
    }

    constructor() ERC721("Pet", "PET") {
        _market = Market(_msgSender());
    }

    function market() public view returns (Market) {
        return _market;
    }

    function petsOf(address owner) public view returns (uint256[] memory) {
        return _petsOf[owner];
    }

    function mint(string memory petName) external {
        uint256 tokenId = getTokenId(msg.sender, petName);
        _safeMint(_msgSender(), tokenId);
        _starve[tokenId] = block.timestamp + 4 hours;
    }

    function feed(uint256 tokenId) external onlyToken {
        require(_starve[tokenId] > block.timestamp, "Pet is death");
        _starve[tokenId] = block.timestamp + 4 hours;
    }

    function getTokenId(address owner, string memory petName)
        public
        pure
        returns (uint256)
    {
        return uint256(keccak256(abi.encodePacked(owner, petName)));
    }
}