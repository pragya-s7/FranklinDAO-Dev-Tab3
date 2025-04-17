// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IExpenseLogger {
    struct Expense {
        address payee;
        uint256 amount;
        address[] participants;
        string receiptURI;
        uint256 timestamp;
    }

    function logExpense(
        uint256 amount,
        address payee,
        address[] calldata participants,
        string calldata receiptURI
    ) external;

    function getExpense(uint256 id) external view returns (Expense memory);

    function getAllExpenses() external view returns (Expense[] memory);
}