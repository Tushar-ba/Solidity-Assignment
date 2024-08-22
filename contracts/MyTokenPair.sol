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
    require(amount0 > 0 && amount1 > 0, "Invalid liquidity amounts");
    reserve0 += amount0; // Update reserve for token0
    reserve1 += amount1; // Update reserve for token1
    balanceOf[to] += amount0 + amount1; // Mint liquidity tokens
    }
    function burn(address to) external returns (uint amount0, uint amount1) {
        uint liquidity = balanceOf[to];
        require(liquidity > 0, "No liquidity to burn");
        
        amount0 = liquidity * reserve0 / totalSupply();
        amount1 = liquidity * reserve1 / totalSupply();

        balanceOf[to] = 0;
        reserve0 -= amount0;
        reserve1 -= amount1;
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

    function totalSupply() public view returns (uint) {
        return reserve0 + reserve1;
    }

    function sqrt(uint x) internal pure returns (uint y) {
        if (x == 0) return 0;
        else {
            uint z = (x + 1) / 2;
            y = x;
            while (z < y) {
                y = z;
                z = (x / z + z) / 2;
            }
        }
    }
}
