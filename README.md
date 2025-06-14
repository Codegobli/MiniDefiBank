# 🏦 MiniDeFiBank

**MiniDeFiBank** is a minimal ETH vault built in Solidity.  
Users can deposit ETH, earn 10% yearly interest, and claim it after a full year.

---

## 🔧 Features

- ⏳ **365-Day Lock-In** – Interest only claimable after a year
- ♻️ **Auto-Claim** – Triggers interest accrual during key interactions
- 🧊 **Cooldown Protection** – 24-hour delay between withdrawals
- 💸 **Gas Efficient** – Uses custom errors, minimal state writes, and clean logic
- 🔐 **Security First** – OpenZeppelin `ReentrancyGuard`, `Ownable`, `Pausable`

---

## 💼 Functions Overview

### `deposit(uint _amount)`
- Accepts deposits between 1–5 ETH
- Sets timestamps for interest & withdrawal tracking

### `withdraw(uint _amount)`
- Requires balance and cooldown to pass
- Auto-claims interest before processing

### `claimInterest()`
- Can only be called after 365 days since last claim
- Adds interest to user balance

### `autoClaim(address user)`
- Internal helper
- Triggers auto interest accrual if eligible

---

## 📄 Contract

You can view the full smart contract in [`miniDefiBank.sol`](./miniDefiBank.sol).

---

## 🧪 Future Add-ons

- Unit tests (using Foundry or Hardhat)
- Frontend interface
- Testnet deployment

## 📊 Tech Stack

- **Solidity** `^0.8.20`
- **OpenZeppelin Contracts** – Ownable, Pausable, ReentrancyGuard

---

## 🧪 Events

- `newdeposit(address, uint, uint)`
- `newwithdrawal(address, uint, uint)`
- `InterestClaimed(address, uint, uint)`
- `AutoInterestClaimed(address, uint, uint)`
- `UnexpectedDeposit(address, uint)`

---

## 📁 Project Structure
├── contracts/ │   └── miniDefiBank.sol ├── LICENSE └── README.md

---

## ⚖️ License

This project is licensed under the **MIT License**.

---

> Built with ❤️ by [Codegobi](https://github.com/Codegobi) – deploy, earn, repeat.
