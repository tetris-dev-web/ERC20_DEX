// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./CICToken.sol";

contract DEX {

    using SafeERC20 for IERC20;

    event Bought(uint256 amount);
    event Sold(uint256 amount);

    // CICToken
    IERC20 public token;

    constructor() {
        token = new CICToken();
    }

    // The return value is token's address in javascript side.
    function getTokenAddress() public view returns (IERC20) {
        return token;
    }

    function buy() public payable {
        uint256 amountToBuy = msg.value;
        uint256 dexBalance = token.balanceOf(address(this));

        require(amountToBuy > 0, "You need to send some ether");
        require(dexBalance >= amountToBuy, "Not enough tokens in the reserve");

        // transfer tokens from smart contract to msg sender
        token.safeTransfer(msg.sender, amountToBuy);
        emit Bought(amountToBuy);
    }

    function sell(uint256 _amount) public {
        require(_amount > 0, "You need to sell at least some tokens");

        uint256 allowance = token.allowance(msg.sender, address(this));
        require(allowance >= _amount, "Check the token allowance");

        // transfer tokens from msg sender to smart contract
        token.safeTransferFrom(msg.sender, address(this), _amount);

        // transfer ether to msg sender
        payable(msg.sender).transfer(_amount);
        emit Sold(_amount);
    }
}