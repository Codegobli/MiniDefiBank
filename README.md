# Mini DeFi Bank

A secure, interest-accruing decentralized finance bank built on Ethereum. This contract allows users to deposit ETH and earn annual interest with built-in security features and automated claim mechanisms.

## 📋 Overview

Mini DeFi Bank is a Solidity smart contract that provides a secure way for users to deposit ETH and earn interest over time. The contract implements robust security measures including reentrancy protection, cooldown periods, and pausable functionality to ensure fund safety.

## ✨ Features

- **Interest Accrual**: 10% annual interest on deposited funds
- **Automated Claims**: Automatic interest calculation and claiming
- **Security First**: Reentrancy protection and withdrawal cooldowns
- **Admin Controls**: Pausable functionality for emergency scenarios
- **Gas Efficiency**: Custom error handling for reduced gas costs
- **Transparent Tracking**: Comprehensive event logging

## 🏗️ Contract Architecture

### Core Components

- **Interest Calculation**: Time-based interest accrual with automatic compounding
- **Balance Management**: Secure tracking of user deposits and interest
- **Cooldown System**: 24-hour withdrawal cooldown to prevent rapid withdrawals
- **Auto-Claim**: Automated interest claiming after 395+ days

### Security Features

- Reentrancy protection using OpenZeppelin's `ReentrancyGuard`
- Pausable functionality for emergency stops
- Withdrawal cooldown periods
- Owner-only administrative functions
- Input validation and bounds checking

## 📖 Usage

### Deposit Funds

```solidity
// Deposit between 1-5 ETH
function deposit(uint _amount) external payable;
```

### Withdraw Funds

```solidity
// Withdraw specific amount (subject to cooldown)
function withdraw(uint _amount) external;
```

### Claim Interest

```solidity
// Manually claim accrued interest after 365 days
function claimInterest() external;
```

## 🔧 API Reference

### Core Functions

| Function | Description | Access |
|----------|-------------|---------|
| `deposit()` | Deposit ETH (1-5 ETH range) | Public |
| `withdraw()` | Withdraw deposited funds | Public |
| `claimInterest()` | Manually claim interest | Public |
| `calcAccruedInterest()` | Calculate user's accrued interest | Public View |
| `getContractBalance()` | Get contract's ETH balance | Public View |

### Administrative Functions

| Function | Description | Access |
|----------|-------------|---------|
| `pause()` | Pause contract operations | Owner only |
| `unpause()` | Unpause contract operations | Owner only |
| `withdrawUnexpectedFunds()` | Recover stray funds | Owner only |

### Events

- `newdeposit`: Emitted on successful deposits
- `newwithdrawal`: Emitted on successful withdrawals
- `InterestClaimed`: Emitted on manual interest claims
- `AutoInterestClaimed`: Emitted on automatic interest claims
- `UnexpectedDeposit`: Emitted on direct ETH transfers

## 🛠️ Development

### Prerequisites

- Solidity ^0.8.20
- OpenZeppelin Contracts
- Hardhat/Foundry development environment

### Installation

```bash
npm install @openzeppelin/contracts
```

### Key Parameters

- **Deposit Range**: 1-5 ETH
- **Annual Interest Rate**: 10%
- **Withdrawal Cooldown**: 24 hours
- **Manual Claim Period**: 365 days
- **Auto-Claim Trigger**: 395+ days

## 🔒 Security Features

### Access Control
- Owner-only administrative functions
- Pausable mechanism for emergency stops

### Financial Safeguards
- Reentrancy protection on withdrawals
- Cooldown periods between withdrawals
- Deposit amount limits (1-5 ETH)
- Balance verification before transfers

### Error Handling
- Custom errors for gas efficiency
- Comprehensive input validation
- Transfer success verification

## 📊 Interest Calculation

### Formula
```
Interest = (Balance × Interest Rate × Time Elapsed) / (100 × 365 days)
```

### Claim Mechanisms
1. **Manual Claim**: Users can claim after exactly 365 days
2. **Auto-Claim**: Automatic claiming after 395+ days during operations

## 🚀 Deployment

### Constructor
```solidity
constructor() Ownable(msg.sender)
```

### Verification
```solidity
// Verify contract deployment
// Ensure proper OpenZeppelin imports are available
```

## ⚠️ Important Notes

- **Deposit Limits**: Only accepts deposits between 1-5 ETH
- **Cooldown Period**: 24-hour wait between withdrawals
- **Interest Timing**: Manual claims require exactly 365 days
- **Auto-Claim**: Triggered after 395+ days during user operations
- **Direct Transfers**: Unexpected ETH transfers are logged but not added to user balance

## 🔍 Testing

### Test Coverage Areas
- Deposit functionality with amount validation
- Withdrawal with cooldown enforcement
- Interest calculation accuracy
- Auto-claim functionality
- Security measures (reentrancy, access control)
- Emergency pause functionality

## 📄 License

MIT License - see SPDX-License-Identifier in contract header

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/improvement`)
3. Commit changes (`git commit -am 'Add new feature'`)
4. Push branch (`git push origin feature/improvement`)
5. Open Pull Request

## Support

For technical support or security concerns:
- Review contract events for transaction tracking
- Check user balances and timestamps via view functions
- Contact contract owner for administrative issues

---

**Built with 🔒 for secure DeFi operations**
