// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IDebtSettlement {
    function recordDebt(address from, address to, uint256 amount) external;

    function settleDebt(address to) external;

    function settleReciprocal(address counterparty) external;

    function getDebt(address from, address to) external view returns (uint256);

    function usdcToken() external view returns (address);
}
