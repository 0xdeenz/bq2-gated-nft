import "@nomicfoundation/hardhat-toolbox";
import { config as dotenvConfig } from "dotenv"
import { readFileSync } from "fs"
import { HardhatUserConfig } from "hardhat/config";
import { resolve } from "path"
import "./tasks/deploy-bqt"

dotenvConfig({ path: resolve(__dirname, ".env") })
const mnemonic = readFileSync(".sneed").toString().trim();

const config: HardhatUserConfig = {
    solidity: "0.8.4",
    networks: {
        hardhat: {
            chainId: 1337,
            allowUnlimitedContractSize: true
        },
        polygonMumbai: {
            url: 'https://polygon-mumbai.blockpi.network/v1/rpc/public',
            chainId: 80001,
            accounts: {
                mnemonic
            },
            gasPrice: 10 * 10 ** 9
        },
    },
    etherscan: {
        apiKey: {
            polygonMumbai: process.env.ALCHEMY_API_KEY as string  // TODO: verify contract
        }
    },
};

export default config;
