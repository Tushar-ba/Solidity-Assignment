require('@nomiclabs/hardhat-ethers');
require('@nomiclabs/hardhat-waffle');
require('dotenv').config();

module.exports = {
    solidity: {
        version: '0.8.20',
        settings: {
            optimizer: {
                enabled: true,
                runs: 200,
            },
        },
    },
    networks: {
        hardhat: {
            chainId: 1337,  // Default Hardhat network
        },
        localhost: {
            url: 'http://127.0.0.1:8545',  // Localhost Hardhat network
            chainId: 1337,  // Ensure this matches the Hardhat chainId
        },
        mumbai: {
            url: `https://polygon-amoy.g.alchemy.com/v2/${process.env.POLYGON_API_KEY}`,
            accounts: [`0x${process.env.PRIVATE_KEY}`],
            chainId: 80002,
        },
    },
};
