// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title APOCATLYPSE MEOW (APOCAT)
 * @dev The purr-fect apocalypse survival memecoin
 * "When the world ends, only cats survive... and meow."
 *
 * Features:
 * - Fixed supply: 690,420 APOCAT
 * - 0% fees - pure memecoin
 * - Trading control for fair launch
 * - Owner can renounce for full decentralization
 */
contract ApocalypseToken is ERC20, Ownable {

    uint256 public constant TOTAL_SUPPLY = 690420 * 10**18; // 690,420 APOCAT
    uint256 public constant POOL_ALLOCATION = 69042 * 10**18; // 10% for liquidity pool
    
    bool public tradingEnabled = false;

    event TradingEnabled(uint256 timestamp);

    constructor(address initialOwner) ERC20("APOCATLYPSE MEOW", "APOCAT") Ownable(initialOwner) {
        _mint(initialOwner, TOTAL_SUPPLY);
    }
    
    /**
     * @dev Enable trading - can only be called once by owner
     */
    function enableTrading() external onlyOwner {
        require(!tradingEnabled, "Trading already enabled");
        tradingEnabled = true;
        emit TradingEnabled(block.timestamp);
    }
    
    /**
     * @dev Override _update to add trading control (no fees, no limits)
     */
    function _update(address from, address to, uint256 amount) internal override {
        // Check trading enabled (except for minting and owner transfers)
        if (from != address(0) && from != owner()) {
            require(tradingEnabled, "Trading not enabled yet");
        }

        super._update(from, to, amount);
    }
    
    /**
     * @dev Burn tokens to reduce supply (deflationary)
     */
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
    
    /**
     * @dev Get contract information
     */
    function getContractInfo() external view returns (
        string memory name,
        string memory symbol,
        uint256 totalSupply,
        uint256 poolAllocation,
        bool isTradingEnabled
    ) {
        return (
            name(),
            symbol(),
            totalSupply(),
            POOL_ALLOCATION,
            tradingEnabled
        );
    }
}
