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

    require(IERC20(tokenA).transferFrom(msg.sender, address(this), amountA), "Transfer of tokenA failed");
    require(IERC20(tokenB).transferFrom(msg.sender, address(this), amountB), "Transfer of tokenB failed");

    MyTokenPair(pair).mint(msg.sender, amountA, amountB);
}

    function swapTokens(address tokenIn, address tokenOut, uint amountIn) external {
    address pair = factory.getPair(tokenIn, tokenOut);
    require(pair != address(0), "Pair does not exist");

    MyTokenPair pairContract = MyTokenPair(pair);
    (uint reserveIn, uint reserveOut) = pairContract.getReserves();

    uint amountOut = (amountIn * reserveOut) / (reserveIn + amountIn); // Simple swap logic
    
    require(IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn), "Transfer of tokenIn failed");
    require(IERC20(tokenOut).transfer(msg.sender, amountOut), "Transfer of tokenOut failed");

    // Update reserves
    if (tokenIn == pairContract.token0()) {
        pairContract.updateReserves(reserveIn + amountIn, reserveOut - amountOut);
    } else {
        pairContract.updateReserves(reserveOut - amountOut, reserveIn + amountIn);
    }
}

function removeLiquidity(address tokenA, address tokenB, uint liquidity) external {
    address pair = factory.getPair(tokenA, tokenB);
    require(pair != address(0), "Pair does not exist");

    MyTokenPair pairContract = MyTokenPair(pair);
    
    // Transfer liquidity tokens from user to pair contract
    require(pairContract.transferFrom(msg.sender, pair, liquidity), "Transfer failed");

    // Call the burn function
    (uint amountA, uint amountB) = pairContract.burn(msg.sender);

    // Ensure that the burn function returns expected amounts
    require(amountA > 0 && amountB > 0, "Invalid burn amounts");

    // Transfer the amounts back to the user
    require(IERC20(tokenA).transfer(msg.sender, amountA), "Token A transfer failed");
    require(IERC20(tokenB).transfer(msg.sender, amountB), "Token B transfer failed");
}


}