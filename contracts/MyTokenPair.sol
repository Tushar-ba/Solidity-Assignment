// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MyTokenPair {
    address public token0;
    address public token1;
    uint public reserve0;
    uint public reserve1;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;

    constructor(address _token0, address _token1) {
        token0 = _token0;
        token1 = _token1;
    }

    function mint(address to, uint amount0, uint amount1) external {
        balanceOf[to] += amount0 + amount1; // Update the balance of the user
        reserve0 += amount0; // Update reserve for token0
        reserve1 += amount1; // Update reserve for token1
    }

    function burn(address to) external returns (uint amount0, uint amount1) {
        amount0 = reserve0; // Get current reserves
        amount1 = reserve1;
        reserve0 = 0; // Reset reserves
        reserve1 = 0;
        balanceOf[to] = 0; // Reset user balance
    }

    function getReserves() external view returns (uint, uint) {
        return (reserve0, reserve1);
    }

    function approve(address spender, uint amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        return true;
    }

    function transfer(address to, uint amount) external returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        return true;
    }
}