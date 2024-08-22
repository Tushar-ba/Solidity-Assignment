// scripts/deploy_uniswap.js
const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    // Deploy Uniswap V2 Factory
    const Factory = await ethers.getContractFactory("@uniswap/v2-core/contracts/UniswapV2Factory.sol:UniswapV2Factory");
    const factory = await Factory.deploy(deployer.address);
    await factory.deployed();
    console.log("Uniswap V2 Factory deployed to:", factory.address);

    // Deploy Uniswap V2 Router
    const Router = await ethers.getContractFactory("@uniswap/v2-periphery/contracts/UniswapV2Router02.sol:UniswapV2Router02");
    const router = await Router.deploy(factory.address, ethers.constants.AddressZero);
    await router.deployed();
    console.log("Uniswap V2 Router deployed to:", router.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });