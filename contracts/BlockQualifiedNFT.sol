// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@bq-core/contracts/interfaces/ICredentialsRegistry.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract BlockQualifiedNFT is ERC721 {
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
    ) public {
        // formatBytes32String("bq-demo-credential-gated-token")
        uint256 externalNullifier = 0x62712d64656d6f2d63726564656e7469616c2d67617465642d746f6b656e0000;

        uint256 signal = uint256(uint160(recipient));

        credentialsRegistry.verifyCredentialOwnershipProof(
            requiredCredential,
            merkleTreeRoot,
            nullifierHash,
            signal,
            externalNullifier,
            proof
        );

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(recipient, tokenId);
    }
}
