// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@zetachain/protocol-contracts/contracts/ZetaInteractor.sol";
import "@zetachain/protocol-contracts/contracts/ZetaReceiver.sol";
import "@zetachain/protocol-contracts/contracts/ZetaInterfaces.sol";

contract ExpenseLogger is ZetaInteractor {
    address public immutable zetaToken;

    event ExpenseSentCrossChain(
        address indexed payer,
        address indexed payee,
        uint256 amount,
        string metadataURI,
        uint256 destinationChainId
    );

    constructor(address connector, address _zetaToken) ZetaInteractor(connector) {
        zetaToken = _zetaToken;
    }

    function logExpenseCrossChain(
        address payee,
        uint256 amount,
        string calldata metadataURI,
        uint256 destinationChainId
    ) external {
        bytes memory message = abi.encode(msg.sender, payee, amount, metadataURI);
        _send(
            destinationChainId,
            zetaToken,
            abi.encodePacked(payee),
            0,
            message,
            500_000
        );

        emit ExpenseSentCrossChain(msg.sender, payee, amount, metadataURI, destinationChainId);
    }
}