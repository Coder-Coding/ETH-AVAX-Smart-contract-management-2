// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract UniqueBank {
    address payable public owner;
    uint256 public balance;

    struct Item {
        string name;
        uint256 price;
    }

    mapping(string => Item) public inventory;

    event Deposit(uint256 amount);
    event Withdraw(uint256 amount);
    event ItemBought(string itemName, uint256 itemPrice);

    constructor(uint initBalance) payable {
        owner = payable(msg.sender);
        balance = initBalance;

        // Initialize inventory items
        inventory["ball"] = Item("Ball", 2);
        inventory["pen"] = Item("Pen", 4);
    }

    function getBalance() public view returns (uint256) {
        return balance;
    }

    function deposit(uint256 _amount) public payable {
        require(msg.sender == owner, "You are not the owner of this account");

        uint256 _previousBalance = balance;

        // Perform transaction
        balance += _amount;

        // Assert transaction completed successfully
        assert(balance == _previousBalance + _amount);

        // Emit the event
        emit Deposit(_amount);
    }

    error InsufficientBalance(uint256 balance, uint256 withdrawAmount);

    function withdraw(uint256 _withdrawAmount) public {
        require(msg.sender == owner, "You are not the owner of this account");
        uint256 _previousBalance = balance;

        if (balance < _withdrawAmount) {
            revert InsufficientBalance({
                balance: balance,
                withdrawAmount: _withdrawAmount
            });
        }

        // Withdraw the given amount
        balance -= _withdrawAmount;

        // Assert the balance is correct
        assert(balance == (_previousBalance - _withdrawAmount));

        // Emit the event
        emit Withdraw(_withdrawAmount);
    }

    function viewItem(string memory _itemName) public view returns (string memory, uint256) {
    Item memory item = inventory[_itemName];
    return (item.name, item.price);
}

function buyItem(string memory _itemName) public {
    require(msg.sender == owner, "You are not the owner of this account");

    Item memory item = inventory[_itemName];
    require(item.price > 0, "Item not found in inventory");
    require(balance >= item.price, "Insufficient balance to buy the item");

    balance -= item.price;

    emit ItemBought(item.name, item.price);
}

}
