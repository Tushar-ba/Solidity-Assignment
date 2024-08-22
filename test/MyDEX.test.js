// test/MyDEX.test.js
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MyDEX", function () {
    let dex;
    let factory;
    let tokenA;
    let tokenB;
    let owner;
    let user;

    before(async () => {
        [owner, user] = await ethers.getSigners();

        // Deploy Mock ERC20 Tokens
        const Token = await ethers.getContractFactory("ERC20Mock");
        tokenA = await Token.deploy("Token A", "TKA", ethers.utils.parseEther("10000"));
        tokenB = await Token.deploy("Token B", "TKB", ethers.utils.parseEther("10000"));

        // Deploy MyTokenFactory
        factory = await (await ethers.getContractFactory("MyTokenFactory")).deploy();
        await factory.deployed();

        // Deploy MyDEX
        dex = await (await ethers.getContractFactory("MyDEX")).deploy(factory.address);
        await dex.deployed();

        // Create a pair
        await factory.createPair(tokenA.address, tokenB.address);

        // Transfer some tokens to the user for testing
        await tokenA.transfer(user.address, ethers.utils.parseEther("10"));
        await tokenB.transfer(user.address, ethers.utils.parseEther("10"));
    });

    it("should add liquidity correctly", async function () {
        await tokenA.approve(dex.address, ethers.utils.parseEther("100"));
        await tokenB.approve(dex.address, ethers.utils.parseEther("100"));

        await dex.addLiquidity(tokenA.address, tokenB.address, ethers.utils.parseEther("100"), ethers.utils.parseEther("100"));

        const pairAddress = await factory.getPair(tokenA.address, tokenB.address);
        const pair = await ethers.getContractAt("MyTokenPair", pairAddress);
        const reserves = await pair.getReserves();

        expect(reserves[0]).to.equal(ethers.utils.parseEther("100")); // Token A reserve
        expect(reserves[1]).to.equal(ethers.utils.parseEther("100")); // Token B reserve
    });

    it("should swap tokens correctly", async function () {
        await tokenA.connect(user).approve(dex.address, ethers.utils.parseEther("10"));

        await dex.connect(user).swapTokens(tokenA.address, tokenB.address, ethers.utils.parseEther("10"));

        const userTokenBBalance = await tokenB.balanceOf(user.address);
        expect(userTokenBBalance).to.be.gt(0); // User should have received some Token B
    });

    it("should remove liquidity correctly", async function () {
        const pairAddress = await factory.getPair(tokenA.address, tokenB.address);
        const pair = await ethers.getContractAt("MyTokenPair", pairAddress);

        const liquidity = await pair.balanceOf(owner.address);
        expect(liquidity).to.be.gt(0); // Ensure the owner has liquidity tokens

        await pair.approve(dex.address, liquidity);
        await dex.removeLiquidity(tokenA.address, tokenB.address, liquidity);

        const ownerTokenABalance = await tokenA.balanceOf(owner.address);
        const ownerTokenBBalance = await tokenB.balanceOf(owner.address);

        expect(ownerTokenABalance).to.be.gt(0); // Owner should have received some Token A
        expect(ownerTokenBBalance).to.be.gt(0); // Owner should have received some Token B
    });
});