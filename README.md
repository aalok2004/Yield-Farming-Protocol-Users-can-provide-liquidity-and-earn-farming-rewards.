# Yield Farming Protocol

## Project Description

A decentralized yield farming smart contract that allows users to stake tokens and earn rewards over time. Users deposit staking tokens into the protocol and receive reward tokens proportional to their stake duration and amount.

## Project Vision

To create a transparent, secure, and efficient yield farming platform that democratizes access to passive income generation in the DeFi ecosystem. Our protocol provides users with a simple yet powerful tool to maximize token utility while contributing to protocol liquidity.

## Key Features

### 🔒 **Secure Staking System**
- Stake ERC-20 tokens with proper validation
- Safe transfer mechanisms prevent vulnerabilities
- Real-time balance tracking

### 💰 **Fair Reward Distribution** 
- Time-weighted reward calculations
- Continuous reward accumulation
- Proportional distribution based on stake size

### 🔄 **Flexible Operations**
- **Stake**: Deposit tokens to earn rewards
- **Withdraw**: Remove staked tokens anytime
- **Claim**: Collect accumulated rewards
- **Exit**: Withdraw all stakes and claim all rewards

### 📊 **Transparent Analytics**
- Track total staked tokens
- Monitor individual balances and rewards
- Public reward rate visibility

### ⚡ **Gas Optimized**
- Efficient reward calculations
- Minimal storage operations
- Reduced transaction costs

## Future Scope

### 🚀 **Phase 1 - Enhanced Features**
- Multiple token pair support
- Dynamic reward rate adjustments
- Optional lock-up periods for higher yields
- Emergency pause/unpause functionality

### 🏛️ **Phase 2 - Governance**
- DAO governance for protocol parameters
- Community proposal system
- Decentralized treasury management
- Native token economics

### 🌐 **Phase 3 - Advanced DeFi**
- Cross-chain compatibility
- Yield aggregation across protocols
- NFT staking integration
- Smart contract insurance

### 🔧 **Phase 4 - Ecosystem**
- Mobile application interface
- Advanced analytics dashboard
- Third-party API integration
- Educational resources

### 🤝 **Phase 5 - Partnerships**
- DEX integrations
- Lending protocol compatibility
- Institutional investor features
- Regulatory compliance framework

## Quick Start

### Deploy
```bash
1. Copy Project.sol to Remix IDE
2. Compile with Solidity ^0.8.19
3. Deploy YieldFarmingProtocol contract
4. Contract auto-creates tokens and distributes initial supply
```

### Test
```solidity
// 1. Check your staking token balance
stakingToken.balanceOf(your_address)

// 2. Approve contract to spend tokens
stakingToken.approve(contract_address, amount)

// 3. Stake tokens
stake(1000 * 10**18)

// 4. Check earned rewards
earned(your_address)

// 5. Claim rewards
claimReward()
```

## Contract Functions

| Function | Description |
|----------|-------------|
| `stake(amount)` | Deposit tokens to start earning rewards |
| `withdraw(amount)` | Remove staked tokens |
| `claimReward()` | Collect accumulated rewards |
| `exit()` | Withdraw all stakes and claim all rewards |
| `earned(address)` | View pending rewards for an account |
| `balanceOf(address)` | View staked balance for an account |

## Security Features

- ✅ Overflow/underflow protection (Solidity ^0.8.19)
- ✅ Reentrancy protection through state updates
- ✅ Input validation on all functions
- ✅ Access control for administrative functions
- ✅ Event emission for transparency

## Auto-Setup

The contract automatically:
- Creates Mock Staking Token (MST) and Mock Reward Token (MRT)
- Transfers 100,000 staking tokens to deployer
- Loads 500,000 reward tokens into contract
- Initializes reward distribution system

## License

MIT License - Free to use, modify, and distribute

---

**Ready to deploy and start earning yields! 🚀**
<img width="1365" height="721" alt="Screenshot 2025-09-27 142200" src="https://github.com/user-attachments/assets/6eca858e-fbd8-4eca-bc90-8d9e5c471605" />
