# Solidity Assignment DEX

- [Setup](#setup)
- [Testing](#testing)
- [Deployment](#deployment)
- [ERC20Mock Contract](#erc20mock-contract)
- [MyTokenPair Contract](#mytokenpair-contract)
- [MyTokenFactory Contract](#mytokenfactory-contract)
- [MyDEX Contract](#mydex-contract)
- [Contract Functions](#contract-functions)



## Setup 
- Clone this repo using this command  "git clone https://github.com/Tushar-ba/Solidity-Assignment.git"
- npm i --force to install the packages. 

## Testing 

cd into root directory and execute the following command 

npx hardhat test 
the console should show a result of this type:-
![Result](./images/Testing%20result.png)

## Deployment
- create a .env file in the root directory and paste the following there
### POLYGON_API_KEY= YOUR ALCHEMY API key (get one from here `https://dashboard.alchemy.com/` select   ) 
### PRIVATE_KEY=YOUR PRIVATE KEY (from metamask)

- After this run this command in root directory:-

npx hardhat run scripts/deploy.js --network mumbai 

The expected result if the deployment was successfull should look like this:-
![Result](./images/Depolyment%20result.png)



# Information about the few functions used in contracts and about the contract itself

## ERC20Mock.sol 
This contract is used to mint tokens which will be used in the DEX 

## MyTokenPair.sol

To include information about the `MyTokenPair` contract in your README file, you can summarize its key features, functions, and usage. Here's a suggested structure:

---

## MyTokenPair Contract

### Overview
The `MyTokenPair` contract is a custom implementation of a liquidity pool that follows the principles of Automated Market Makers (AMM). It is designed to manage the reserves of two ERC-20 tokens and facilitate liquidity provision and removal in a decentralized manner. This contract is inspired by decentralized exchange mechanisms, offering a simplified and customizable approach to creating liquidity pairs.

### Features
- **Liquidity Pool:** Manages reserves of two ERC-20 tokens (`token0` and `token1`) and allows users to provide and withdraw liquidity.
- **Minting Liquidity:** Users can mint liquidity tokens by depositing `token0` and `token1` into the pool, receiving liquidity tokens proportional to the square root of the product of the amounts deposited.
- **Burning Liquidity:** Users can burn their liquidity tokens to withdraw a proportional share of the reserves (`token0` and `token1`).
- **ERC-20 Compliance:** Implements standard ERC-20 functions, allowing transfer, approval, and allowance of liquidity tokens.
- **Debugging Events:** Includes events for tracking internal state and debugging.

### Contract Structure

#### State Variables
- `token0`, `token1`: Addresses of the two ERC-20 tokens in the pair.
- `reserve0`, `reserve1`: Current reserves of `token0` and `token1`.
- `balanceOf`: Mapping to track the balance of liquidity tokens for each address.
- `allowance`: Mapping to track allowances for third-party transfers of liquidity tokens.
- `_totalSupply`: Total supply of liquidity tokens in circulation.



#### Functions

- **Constructor:** Initializes the contract with the addresses of the two tokens (`token0` and `token1`).
  
- **`totalSupply()`**: Returns the total supply of liquidity tokens.
  
- **`transfer(address to, uint256 amount)`**: Transfers liquidity tokens to another address.
  
- **`approve(address spender, uint256 amount)`**: Approves an allowance for a spender to transfer liquidity tokens on behalf of the caller.
  
- **`transferFrom(address from, address to, uint256 amount)`**: Transfers liquidity tokens from one address to another, using an approved allowance.
  
- **`mint(address to, uint amount0, uint amount1)`**: Allows users to provide liquidity by depositing `token0` and `token1`. Mints liquidity tokens proportional to the geometric mean of the deposited amounts.
  
- **`burn(address to)`**: Burns liquidity tokens to withdraw a proportional share of the reserves (`token0` and `token1`).
  
- **`getReserves()`**: Returns the current reserves of `token0` and `token1`.
  
- **`updateReserves(uint _reserve0, uint _reserve1)`**: Allows external updates to the reserves (use with caution).
  
- **`sqrt(uint x)`**: Internal utility function to calculate the square root of a given value.

### Usage

1. **Deploy the Contract:**
   - Deploy the `MyTokenPair` contract with the addresses of two ERC-20 tokens.

2. **Mint Liquidity:**
   - Call the `mint` function, providing amounts of `token0` and `token1` to deposit into the pool.
   - Receive liquidity tokens in return.

3. **Burn Liquidity:**
   - Call the `burn` function to withdraw `token0` and `token1` in proportion to the liquidity tokens burned.

4. **Transfer and Manage Tokens:**
   - Use standard ERC-20 functions to transfer liquidity tokens or set allowances for third-party transfers.

### Notes
- The contract includes a simple square root function to calculate liquidity, which may be optimized or replaced depending on specific use cases.
- The `updateReserves` function should be used with caution as it directly modifies the reserve values.
- The `burn` function is designed to be called from within the contract; ensure liquidity tokens are transferred to the contract's address before calling it.



---

To include information about the `MyTokenFactory` contract in your README file, you can summarize its key features, functions, and usage. Here's a suggested structure:

---

## MyTokenFactory Contract

### Overview
The `MyTokenFactory` contract is designed to create and manage instances of `MyTokenPair` contracts, facilitating the creation of liquidity pairs between two ERC-20 tokens. This factory contract allows users to easily create new token pairs, keep track of all pairs created, and retrieve the address of an existing pair.

### Features
- **Pair Creation:** Allows the creation of new `MyTokenPair` contracts between two ERC-20 tokens.
- **Pair Management:** Stores and retrieves the addresses of token pairs, ensuring that each pair is unique.
- **Event Logging:** Emits events when new pairs are created, allowing for easy tracking and monitoring.
- **Pair Tracking:** Keeps a list of all created pairs and provides access to the total number of pairs.

### Contract Structure

#### State Variables
- `getPair`: A nested mapping that stores the addresses of token pairs. The mapping allows you to retrieve the `MyTokenPair` contract address by providing two token addresses.
- `allPairs`: An array that stores the addresses of all `MyTokenPair` contracts created by this factory.



#### Functions

- **`createPair(address tokenA, address tokenB)`**: 
  - **Description:** Creates a new `MyTokenPair` contract for the provided tokens (`tokenA` and `tokenB`).
  - **Requirements:** 
    - The tokens must be different (i.e., `tokenA` cannot equal `tokenB`).
    - The pair must not already exist.
  - **Returns:** The address of the newly created `MyTokenPair` contract.
  - **Operation:** 
    - Deploys a new `MyTokenPair` contract.
    - Updates the `getPair` mapping to store the pair address.
    - Adds the pair to the `allPairs` array.
    - Emits the `PairCreated` event.

- **`allPairsLength()`**: 
  - **Description:** Returns the total number of pairs created by the factory.
  - **Returns:** The length of the `allPairs` array.

### Usage

1. **Deploy the Contract:**
   - Deploy the `MyTokenFactory` contract to manage and create token pairs.

2. **Create a New Pair:**
   - Call the `createPair` function with the addresses of two ERC-20 tokens.
   - The function will return the address of the newly created `MyTokenPair` contract.
   - The pair will be added to the factory's internal tracking.

3. **Retrieve a Pair:**
   - Use the `getPair` mapping to find the address of a pair by providing the two token addresses.
   - The pair can be retrieved in either order, thanks to the reverse mapping.

4. **Track All Pairs:**
   - Access the `allPairs` array to see all pairs created by the factory.
   - Use the `allPairsLength` function to get the total number of pairs.

### Notes
- The `createPair` function ensures that each pair of tokens can only be created once, preventing duplicate pairs.
- The `getPair` mapping allows efficient retrieval of pair addresses, supporting both `tokenA, tokenB` and `tokenB, tokenA` orders.
- The contract assumes that all token addresses provided are valid ERC-20 tokens.



---

## MyDEX Contract

### Overview
The `MyDEX` contract is a decentralized exchange (DEX) that facilitates adding liquidity, swapping tokens, and removing liquidity for token pairs created by the `MyTokenFactory` contract. It leverages the existing `MyTokenPair` contracts to manage reserves, mint liquidity tokens, and handle token swaps between users.

### Features
- **Add Liquidity:** Allows users to add liquidity to a specific token pair, minting new liquidity tokens in return.
- **Swap Tokens:** Facilitates token swaps between two tokens in a pair based on the reserves held by the pair contract.
- **Remove Liquidity:** Enables users to remove liquidity from a token pair, burning liquidity tokens and returning the underlying tokens.

### Contract Structure

#### State Variables
- `factory`: An instance of the `MyTokenFactory` contract, used to interact with and retrieve token pairs.

#### Functions

- **`constructor(address _factory)`**: 
  - **Description:** Initializes the `MyDEX` contract by setting the `MyTokenFactory` contract address.
  - **Parameters:** 
    - `_factory`: The address of the deployed `MyTokenFactory` contract.

- **`addLiquidity(address tokenA, address tokenB, uint amountA, uint amountB)`**: 
  - **Description:** Adds liquidity to a specified token pair, minting new liquidity tokens in exchange.
  - **Parameters:**
    - `tokenA`, `tokenB`: The addresses of the two tokens for the pair.
    - `amountA`, `amountB`: The amounts of `tokenA` and `tokenB` to be added to the liquidity pool.
  - **Operation:**
    - Checks if the pair exists.
    - Transfers the specified amounts of `tokenA` and `tokenB` from the user to the contract.
    - Mints new liquidity tokens in proportion to the provided amounts and transfers them to the user.

- **`swapTokens(address tokenIn, address tokenOut, uint amountIn)`**: 
  - **Description:** Swaps a specified amount of `tokenIn` for `tokenOut` using the reserves of the token pair.
  - **Parameters:**
    - `tokenIn`: The address of the token being swapped.
    - `tokenOut`: The address of the token to be received.
    - `amountIn`: The amount of `tokenIn` being provided for the swap.
  - **Operation:**
    - Checks if the pair exists.
    - Calculates the amount of `tokenOut` based on the current reserves and the provided `amountIn`.
    - Transfers `tokenIn` from the user to the contract.
    - Transfers the calculated amount of `tokenOut` from the contract to the user.
    - Updates the reserves in the `MyTokenPair` contract to reflect the swap.

- **`removeLiquidity(address tokenA, address tokenB, uint liquidity)`**: 
  - **Description:** Removes liquidity from a specified token pair, burning the liquidity tokens and returning the underlying tokens to the user.
  - **Parameters:**
    - `tokenA`, `tokenB`: The addresses of the two tokens for the pair.
    - `liquidity`: The amount of liquidity tokens to be burned.
  - **Operation:**
    - Checks if the pair exists.
    - Transfers the specified amount of liquidity tokens from the user to the pair contract.
    - Calls the `burn` function on the `MyTokenPair` contract to burn the liquidity tokens and return the underlying tokens.
    - Transfers the returned `tokenA` and `tokenB` amounts from the contract to the user.


### Notes
- Ensure that the token pair exists before attempting to add liquidity, swap tokens, or remove liquidity.
- The contract assumes that all token addresses provided are valid ERC-20 tokens.
- The swap logic uses a simplified formula and may not include fees or slippage adjustments typically found in more advanced AMM models.


```
Deploying contracts with the account: 0x49f51e3C94B459677c3B1e611DB3E44d4E6b1D55
- Token A deployed to: 0x14Ec70b86852B030C7411f73F9C026AFA89875d1 (https://amoy.polygonscan.com/address/0x14Ec70b86852B030C7411f73F9C026AFA89875d1)
- Token B deployed to: 0x4C033EB7Baf936cF2FFED08D1C948106641095cf
- MyTokenFactory deployed to: 0x84156870499fb4ee52570c1263590ecf49BA6796 (https://amoy.polygonscan.com/address/0x84156870499fb4ee52570c1263590ecf49BA6796)
- Token pair created at address: 0x5ECbA0A774cf0892d39ccF988658004A548a39cb (https://amoy.polygonscan.com/address/0x5ECbA0A774cf0892d39ccF988658004A548a39cb)
- MyDEX deployed to: 0x24f6f055B8fc1218d760D871bF93e167e0CbfE9B (https://amoy.polygonscan.com/address/0x24f6f055B8fc1218d760D871bF93e167e0CbfE9B)

Liquidity added to the DEX


