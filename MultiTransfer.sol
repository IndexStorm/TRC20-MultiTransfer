// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface ITRC20 {
    function balanceOf(address account) external view returns (uint256);

    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

contract MultiTransfer {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function transfer(
        ITRC20 token,
        address sender,
        address[] calldata recipients,
        uint256[] calldata amounts
    ) public onlyOwner returns (bool success) {
        require(recipients.length == amounts.length);
        uint256 total = 0;

        for (uint8 i = 0; i < amounts.length; i++) {
            total += amounts[i];
        }

        require(total <= token.balanceOf(address(sender)));

        for (uint8 j = 0; j < recipients.length; j++) {
            token.transferFrom(sender, recipients[j], amounts[j]);
        }

        return true;
    }

    function destroy(address payable _to) public onlyOwner {
        selfdestruct(_to);
    }
}
