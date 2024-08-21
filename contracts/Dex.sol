// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@uniswap/v2-core/contracts/UniswapV2Factory.sol";
import "@uniswap/v2-periphery/contracts/UniswapV2Router02.sol";

contract Dex{

    address public factory;
    address public router;

    constructor(address _factory){
    factory = _factory;
    }

    function addLiquidity(address _tokenA, address _tokenB, uint _amountA,uint _amountB, uint _amountAMin,uint _amountBMin, address to, uint deadline) external returns(uint amountA, uint amountB,uint liquidity){
        return IUinswapV2Router02(router).addLiquidity(
            tokenA,tokenB,amountA,amountB,amountAMin,amountBMin,to,deadline
        );
    }
    // function removeLiquidity(){}
    // function swapToken(){}
}