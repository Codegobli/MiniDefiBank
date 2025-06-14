# 🏦 MiniDeFiBank

A minimalistic DeFi-inspired smart contract for ETH deposits, interest accrual, and secure withdrawals — built with Solidity best practices and gas efficiency in mind.

## ✨ Features

- 🔒 Secure ETH deposits with limits (1 to 5 ETH)
- 💰 Annual interest (10%) claimable after 365 days
- ⏳ Cooldown-enforced withdrawals (24h delay)
- 🧠 Auto interest claim logic built-in (triggers on deposit/withdraw)
- 📉 Gas-optimized with custom errors, private/internal separation
- 🛑 Pausable & Ownable — OpenZeppelin security layer included

## 📂 Contract

- **Filename**: `MiniDeFiBank.sol`
- **Compiler**: Solidity ^0.8.20
- **Security**: `Ownable`, `Pausable`, `ReentrancyGuard` from OpenZeppelin

## 📈 Interest Logic

- Interest accrues annually at a fixed rate of **10%**.
- Can only be claimed **once per year**.
- Auto-claim handles past-due interest silently on deposits/withdrawals.

```solidity
uint interest = (balance * yearlyInterestRate * timeElapsed) / (100 * 365 days);

🔐 Key Custom Errors

InsufficientDepositAmount

InvalidDepositAmount

InsufficientBalance

CooldownNotElapsed

ClaimTimeNotMet

NoInterestToClaim


🚧 How It Works

1. Users deposit ETH (1–5 ETH)


2. ETH gets locked with timestamp tracking


3. After 365 days, they can manually claim interest


4. Auto-claim silently triggers if more than a year has passed


5. Withdrawal only allowed after a 24h cooldown



🧪 Contract Status

✅ Core logic complete

🚀 Testnet/mainnet deployment: coming soon

📄 License: MIT


🧠 Built With

Solidity

OpenZeppelin Contracts

🔬 Gas optimization + time-based logic

💡 Real-world DeFi mechanics, simplified



---

> For audit suggestions, improvements, or testing ideas, feel free to open an issue or PR!
