import { task, types } from "hardhat/config"

task("deploy:bqt", "Deploy a Block Qualified gated NFT")
    .addPositionalParam("credentialsRegistryAddress")
    .addPositionalParam("requiredCredential")
    .addOptionalParam("logs", "Print the logs", true, types.boolean)
    .setAction( 
        async({ 
            credentialsRegistryAddress, 
            requiredCredential,
            logs
        }, 
        { ethers } 
        ): Promise<any> => {
            const BlockQualifiedNFTFactory = await ethers.getContractFactory("BlockQualifiedNFT")
            const blockQualifiedNFT = await BlockQualifiedNFTFactory.deploy(credentialsRegistryAddress, requiredCredential)

            await blockQualifiedNFT.deployed()

            if (logs) {
                console.info(`Block Qualified NFT deployed to ${blockQualifiedNFT.address}`)
            }
        })