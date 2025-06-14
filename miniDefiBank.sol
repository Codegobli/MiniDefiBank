// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Import OpenZeppelin Contracts for security best practices
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// Custom error definitions for gas-efficient error handling
error InsufficientDepositAmount(uint sent, uint expected);
error InvalidDepositAmount(uint sent);
error InsufficientBalance(uint requested, uint balance);
error CooldownNotElapsed();
error TransferFailed();
error DepositNotFound();
error NoInterestToClaim();
error Insufficientfunds();
error ClaimTimeNotMet();

/// @title Mini DeFi Bank
/// @notice A minimal interest-accruing deposit contract with cooldown and claim logic
contract miniDefiBank is Ownable, Pausable, ReentrancyGuard {

    // Cooldown between withdrawals to prevent rapid withdrawals
    uint public cooldownperiod = 24 hours;

    // Annual interest rate (10%)
    uint public yearlyInterestRate = 10;

    // Tracks user balances
    mapping (address => uint) public balances;

    // Tracks last withdrawal timestamp
    mapping (address => uint) public lastWithdrawTime;

    // Tracks last deposit timestamp
    mapping (address => uint) public lastDepositTime;

    // Tracks last interest claim timestamp
    mapping (address => uint) public lastClaimTime;

    // Events for logging contract activity
    event newdeposit (address indexed sender, uint amount, uint timestamp);
    event newwithdrawal (address indexed sender, uint amount, uint timestamp);
    event UnexpectedDeposit(address indexed sender, uint amount);
    event InterestClaimed(address indexed sender, uint InterestAmount, uint timestamp);
    event AutoInterestClaimed (address indexed sender, uint interest, uint timestamp);

    /// @dev Ensures the user has enough deposited balance
    modifier hasDeposited (uint _amount){
        if (balances[msg.sender] < _amount || balances[msg.sender] == 0)
            revert InsufficientBalance(_amount, balances[msg.sender]);
        _;
    }

    /// @dev Enforces cooldown period between withdrawals
    modifier cooldown (){
        if (block.timestamp < lastWithdrawTime[msg.sender] + cooldownperiod)
            revert CooldownNotElapsed();
        _;
    }

    /// @notice Pause contract functions (onlyOwner)
    function pause() external onlyOwner {
        _pause();
    }

    /// @notice Unpause contract functions (onlyOwner)
    function unpause() external onlyOwner {
        _unpause();
    }

    /// @notice Initializes the contract with the deployer as the owner
    constructor() Ownable(msg.sender) {}

    /// @notice Handles unexpected ETH transfers directly to the contract
    receive() external payable { 
        emit UnexpectedDeposit(msg.sender, msg.value);
    }

    /// @notice Handles fallback calls with data or bad selectors
    fallback() external payable {}

    /// @notice User deposits ETH into the bank
    /// @param _amount The amount (in whole ETH) to deposit
    function deposit(uint _amount) external payable {
        autoClaim(msg.sender);

        if (msg.value != _amount * 1 ether) {
            revert InsufficientDepositAmount(msg.value, _amount);
        }

        if (msg.value < 1 ether || msg.value > 5 ether) {
            revert InvalidDepositAmount(msg.value);
        }

        balances[msg.sender] += msg.value;
        lastDepositTime[msg.sender] = block.timestamp;

        // Set withdrawal and claim timestamps if first time
        if (lastWithdrawTime[msg.sender] == 0) {
            lastWithdrawTime[msg.sender] = block.timestamp;
        }

        if (lastClaimTime[msg.sender] == 0) {
            lastClaimTime[msg.sender] = block.timestamp;
        }

        emit newdeposit(msg.sender, msg.value, block.timestamp);
    }

    /// @notice Returns the current balance held by the contract
    function getContractBalance () public view returns(uint){
        return address(this).balance;
    }

    /// @notice Withdraw a specific amount of ETH from the bank
    /// @param _amount Amount to withdraw (in wei)
    function withdraw (uint _amount)
        external
        nonReentrant
        hasDeposited(_amount)
        cooldown
        whenNotPaused
    {
        autoClaim(msg.sender);

        balances[msg.sender] -= _amount;
        lastWithdrawTime[msg.sender] = block.timestamp;

        (bool success, ) = msg.sender.call{value: _amount}("");
        if (!success) revert TransferFailed();

        emit newwithdrawal(msg.sender, _amount, block.timestamp);
    }

    /// @notice Allows the owner to withdraw any stray/unexpected funds
    /// @param _amount Amount to withdraw
    function withdrawUnexpectedFunds(uint _amount) external onlyOwner {
        (bool success, ) = owner().call{value: _amount}("");
        require(success, "Transfer failed");
    }

    /// @notice Calculates the accrued interest for a user
    /// @param sender The user address
    /// @return interest The interest amount based on full years elapsed
    function calcAccruedInterest(address sender) public view returns (uint) {
        uint balance = balances[sender];
        uint lastClaim = lastClaimTime[sender];

        // 
       if (lastClaim == 0 || balance == 0) {
        return 0;
    }

        uint timeElapsed = block.timestamp - lastClaim;

        // Simple interest calculation
        uint interest = (balance * yearlyInterestRate * timeElapsed) / (100 * 365 days);

        return interest;
    }

    /// @notice Claim interest after 365 days
    function claimInterest() external {
        if (block.timestamp < lastClaimTime[msg.sender] + 365 days)
            revert ClaimTimeNotMet();

        if (balances[msg.sender] == 0)
            revert DepositNotFound();
        
        uint interestAmount = calcAccruedInterest(msg.sender);

        if (interestAmount == 0)
            revert NoInterestToClaim();

        if (address(this).balance < interestAmount)
            revert Insufficientfunds();

        balances[msg.sender] += interestAmount;
        lastClaimTime[msg.sender] = block.timestamp;

        emit InterestClaimed(msg.sender, interestAmount, block.timestamp);
    }

    /// @notice Automatically claims interest for user if more than 395 days passed
    /// @dev Called internally before other operations
    function autoClaim(address user) private {
        
    uint fullYears = (block.timestamp - lastClaimTime[user]) / 365 days;

    if (fullYears > 0 && balances[user] > 0) {
        uint interest = (balances[user] * yearlyInterestRate * fullYears) / 100;
        balances[user] += interest;
        lastClaimTime[user] += fullYears * 365 days;

        emit AutoInterestClaimed(user, interest, block.timestamp);
    
}

    }
}
