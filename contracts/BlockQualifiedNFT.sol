// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@bq-core/contracts/interfaces/ICredentialsRegistry.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract BlockQualifiedNFT is ERC721, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    ICredentialsRegistry credentialsRegistry;
    uint256 immutable requiredCredential;

    constructor(
        address credentialsRegistryAddress,
        uint256 _requiredCredential
    ) ERC721("BlockQualifiedNFT", "BQT") {
        credentialsRegistry = ICredentialsRegistry(credentialsRegistryAddress);
        requiredCredential = _requiredCredential;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://github.com/0xdeenz/bq2";
    }

    function safeMint(
        address recipient,
        uint256 merkleTreeRoot,
        uint256 nullifierHash,
        uint256[8] calldata proof
    ) public onlyOwner {
        uint256 externalNullifier = uint(keccak256(abi.encode(
            recipient, 
            requiredCredential,
            this.symbol()
        )));

        credentialsRegistry.verifyCredentialOwnershipProof(
            requiredCredential,
            merkleTreeRoot,
            nullifierHash,
            uint256(uint160(recipient)),
            externalNullifier,
            proof
        );

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(recipient, tokenId);
    }
}
