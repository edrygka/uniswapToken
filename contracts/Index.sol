//SPDX-License-Identifier: Unlicense

pragma solidity 0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";

contract Index is Ownable, ERC20 {
    IUniswapV2Router02 private uniswapRouter;
    address public addressA;
    address public addressB;
    address public addressC;
    address public uniswapRouterAddress;

    IERC20 public TokenA;
    IERC20 public TokenB;
    IERC20 public TokenC;

    uint8 constant koefA = 50;
    uint8 constant koefB = 25;
    uint8 constant koefC = 25;
    
    uint constant trashold = 600000; // 10 minutes
    
    constructor(address _adrA, address _adrB, address _adrC, address _uniswapAddr) ERC20("Index", "IDX") {
        addressA = _adrA;
        addressB = _adrB;
        addressC = _adrC;
        uniswapRouterAddress = _uniswapAddr;
        TokenA = IERC20(addressA);
        TokenB = IERC20(addressB);
        TokenC = IERC20(addressC);
        uniswapRouter = IUniswapV2Router02(_uniswapAddr);
    }
    
    /**
     * @dev Approve all tokens to uniswap address
     */
    function approveTokensForUniswap(uint32 amount) external onlyOwner {
        TokenA.approve(uniswapRouterAddress, amount);
        TokenB.approve(uniswapRouterAddress, amount);
        TokenC.approve(uniswapRouterAddress, amount);
    }
    
    /**
     * @dev Adds liquidity token pair to uniswap factory
     */
    function registratePool(address token) private onlyOwner {
        uniswapRouter.addLiquidity(token, address(this), 100, 100, 10, 10, address(this), block.timestamp + trashold);
    }
    
    /**
     * @dev Takes all tokens from sender and swaps them to index tokensA
     */
    function mintValue(uint32 amountA, uint32 amountB, uint32 amountC) public {
        require(amountA > 0 && amountB > 0 && amountC > 0, "Token values should be greater than 0");

        // TODO: prevent division vulnurability
        swapToken(TokenA, amountA * koefA, getPair(addressA, address(this)), msg.sender);
        swapToken(TokenB, amountB * koefB, getPair(addressB, address(this)), msg.sender);
        swapToken(TokenC, amountC * koefC, getPair(addressC, address(this)), msg.sender);
    }
    
    // TODO: mintSwapValue - charge Index token and receive A, B, C
    
    
    function swapToken(IERC20 Token, uint32 amount, address[] memory path, address to) private {
        Token.transferFrom(msg.sender, address(this), amount);
        uniswapRouter.swapExactTokensForTokens(amount, 0, path, to, block.timestamp + trashold);
    }
    
    
    /**
     * @dev Gets maximum reserves for passed token pair
     */
    function getAmountOutMin(address[] memory path, uint amountIn) external view returns (uint) {
        uint[] memory amountOutMins = uniswapRouter.getAmountsOut(amountIn, path);

        return amountOutMins[path.length - 1];
    }
    
    function getPair(address adr1, address adr2) private pure returns (address[] memory) {
        address[] memory path = new address[](2);
        path[0] = adr1;
        path[1] = adr2;

        return path;
    }
}
