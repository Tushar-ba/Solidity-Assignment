// scripts/deploy.js
const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    const factory = await (await ethers.getContractFactory("MyTokenFactory")).deploy();
    await factory.deployed();
    console.log("MyTokenFactory deployed to:", factory.address);

    const dex = await (await ethers.getContractFactory("MyDEX")).deploy(factory.address);
    await dex.deployed();
    console.log("MyDEX deployed to:", dex.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });