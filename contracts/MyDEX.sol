// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./MyTokenFactory.sol";
import "./MyTokenPair.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MyDEX {
    MyTokenFactory public factory;

    constructor(address _factory) {
        factory = MyTokenFactory(_factory);
    }

    function addLiquidity(address tokenA, address tokenB, uint amountA, uint amountB) external {
    address pair = factory.getPair(tokenA, tokenB);
    require(pair != address(0), "Pair does not exist");

    // Transfer tokens to the pair contract
    IERC20(tokenA).transferFrom(msg.sender, pair, amountA);
    IERC20(tokenB).transferFrom(msg.sender, pair, amountB);

    // Call the mint function with the correct parameters
    MyTokenPair(pair).mint(msg.sender, amountA, amountB);
}

    function swapTokens(address tokenIn, address tokenOut, uint amountIn) external {
        address pair = factory.getPair(tokenIn, tokenOut);
        require(pair != address(0), "Pair does not exist");

        IERC20(tokenIn).transferFrom(msg.sender, pair, amountIn);
        
        (uint reserveIn, uint reserveOut) = MyTokenPair(pair).getReserves();
        uint amountOut = (amountIn * reserveOut) / reserveIn; // Simple swap logic
        IERC20(tokenOut).transfer(msg.sender, amountOut);
    }

    function removeLiquidity(address tokenA, address tokenB, uint liquidity) external {
        address pair = factory.getPair(tokenA, tokenB);
        require(pair != address(0), "Pair does not exist");

        // Call the burn function
        (uint amountA, uint amountB) = MyTokenPair(pair).burn(msg.sender);

        // Transfer the amounts back to the user
        IERC20(tokenA).transfer(msg.sender, amountA);
        IERC20(tokenB).transfer(msg.sender, amountB);
    }
}