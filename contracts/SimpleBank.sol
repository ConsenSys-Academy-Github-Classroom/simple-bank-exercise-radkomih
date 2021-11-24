/*
 * This exercise has been updated to use Solidity version 0.8.5
 * See the latest Solidity updates at
 * https://solidity.readthedocs.io/en/latest/080-breaking-changes.html
 */
// SPDX-License-Identifier: MIT
pragma solidity >=0.5.16 <0.9.0;

contract SimpleBank {
    mapping (address => uint) private balances;
    
    mapping (address => bool) public enrolled;

    address public owner = msg.sender;
    
    event LogEnrolled(address accountAddress);

    event LogDepositMade(address accountAddress, uint amount);
 
    event LogWithdrawal(address accountAddress, uint withdrawAmount, uint newBalance);

    // Fallback function - Called if other functions don't match call or
    // sent ether without data
    // Typically, called when invalid data is sent
    // Added so ether sent to this contract is reverted if the contract fails
    // otherwise, the sender's money is transferred to contract
    function () external payable {
        revert();
    }

    /// @notice Get balance
    /// @return The balance of the user
    function getBalance() public view returns (uint) {
      return balances[msg.sender];
    }

    /// @notice Enroll a customer with the bank
    /// @return The users enrolled status
    function enroll() public returns (bool) {
      address user = msg.sender;

      enrolled[user] = true;
      balances[user] = 0;

      emit LogEnrolled(user);

      return enrolled[user];
    }

    /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made
    function deposit() public payable returns (uint) {
      address user = msg.sender;
      uint amount = msg.value;

      require(enrolled[user] == true);

      balances[user] += amount;

      emit LogDepositMade(user, amount);

      return balances[user];
    }

    /// @notice Withdraw ether from bank
    /// @dev This does not return any excess ether sent to it
    /// @param withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user
    function withdraw(uint withdrawAmount) public returns (uint) {
      address payable user = msg.sender;

      require(balances[user] >= withdrawAmount);

      balances[user] -= withdrawAmount;

      user.transfer(withdrawAmount);

      emit LogWithdrawal(user, withdrawAmount, balances[user]);

      return balances[user];
    }
}
