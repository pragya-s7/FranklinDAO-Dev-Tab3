// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@zetachain/protocol-contracts/contracts/ZetaReceiver.sol";
import "@zetachain/protocol-contracts/contracts/ZetaInterfaces.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DebtSettlement is ZetaReceiver {
    address public immutable zetaToken;

    struct Debt {
        address payer;
        address payee;
        uint256 amount;
        string metadataURI;
        bool settled;
    }

    mapping(bytes32 => Debt) public debts;

    event ExpenseLogged(bytes32 indexed expenseId, address payer, address payee, uint256 amount, string uri);
    event DebtSettled(bytes32 indexed expenseId, address payer, uint256 amount);

    constructor(address connector, address _zetaToken) ZetaReceiver(connector) {
        zetaToken = _zetaToken;
    }

    function onZetaMessage(ZetaInterfaces.ZetaMessage calldata zetaMessage) external override onlyZetaConnector {
        (address payer, address payee, uint256 amount, string memory uri) =
            abi.decode(zetaMessage.message, (address, address, uint256, string));

        bytes32 expenseId = keccak256(abi.encode(payer, payee, amount, block.timestamp));

        debts[expenseId] = Debt({
            payer: payer,
            payee: payee,
            amount: amount,
            metadataURI: uri,
            settled: false
        });

        emit ExpenseLogged(expenseId, payer, payee, amount, uri);
    }

    function settleDebt(bytes32 expenseId) external {
        Debt storage d = debts[expenseId];
        require(!d.settled, "Already settled");
        require(d.amount > 0, "Invalid debt");

        d.settled = true;

        bool success = IERC20(zetaToken).transferFrom(msg.sender, d.payee, d.amount);
        require(success, "Payment failed");

        emit DebtSettled(expenseId, msg.sender, d.amount);
    }
}