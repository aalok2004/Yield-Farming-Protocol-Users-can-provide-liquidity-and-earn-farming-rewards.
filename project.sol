// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Simple ERC20 interface
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

// Mock ERC20 Token for testing - Staking Token
contract MockStakingToken {
    string public name = "Mock Staking Token";
    string public symbol = "MST";
    uint8 public decimals = 18;
    uint256 public totalSupply = 1000000 * 10**18; // 1 million tokens
    
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    constructor() {
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }
    
    function transfer(address to, uint256 amount) external returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }
    
    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
    
    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        require(allowance[from][msg.sender] >= amount, "Allowance exceeded");
        require(balanceOf[from] >= amount, "Insufficient balance");
        
        allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        
        emit Transfer(from, to, amount);
        return true;
    }
    
    // Mint function for testing
    function mint(address to, uint256 amount) external {
        totalSupply += amount;
        balanceOf[to] += amount;
        emit Transfer(address(0), to, amount);
    }
}

// Mock ERC20 Token for testing - Reward Token
contract MockRewardToken {
    string public name = "Mock Reward Token";
    string public symbol = "MRT";
    uint8 public decimals = 18;
    uint256 public totalSupply = 1000000 * 10**18; // 1 million tokens
    
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    constructor() {
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }
    
    function transfer(address to, uint256 amount) external returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }
    
    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
    
    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        require(allowance[from][msg.sender] >= amount, "Allowance exceeded");
        require(balanceOf[from] >= amount, "Insufficient balance");
        
        allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        
        emit Transfer(from, to, amount);
        return true;
    }
    
    // Mint function for testing
    function mint(address to, uint256 amount) external {
        totalSupply += amount;
        balanceOf[to] += amount;
        emit Transfer(address(0), to, amount);
    }
}

// Main Yield Farming Protocol Contract
contract YieldFarmingProtocol {
    // State variables
    IERC20 public stakingToken;
    IERC20 public rewardToken;
    address public owner;
    
    uint256 public rewardRate = 100; // 100 reward tokens per second
    uint256 public lastUpdateTime;
    uint256 public rewardPerTokenStored;
    
    mapping(address => uint256) public userRewardPerTokenPaid;
    mapping(address => uint256) public rewards;
    mapping(address => uint256) public balances;
    
    uint256 private _totalSupply;
    
    // Events
    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);
    
    constructor() {
        owner = msg.sender;
        
        // Deploy mock tokens automatically
        MockStakingToken stakingTokenContract = new MockStakingToken();
        MockRewardToken rewardTokenContract = new MockRewardToken();
        
        stakingToken = IERC20(address(stakingTokenContract));
        rewardToken = IERC20(address(rewardTokenContract));
        
        lastUpdateTime = block.timestamp;
        
        // Transfer some reward tokens to this contract for distribution
        rewardTokenContract.transfer(address(this), 500000 * 10**18); // 500k reward tokens
        
        // Give deployer some staking tokens for testing
        stakingTokenContract.transfer(msg.sender, 100000 * 10**18); // 100k staking tokens
    }
    
    // Modifiers
    modifier updateReward(address account) {
        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = block.timestamp;
        if (account != address(0)) {
            rewards[account] = earned(account);
            userRewardPerTokenPaid[account] = rewardPerTokenStored;
        }
        _;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    // View functions
    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }
    
    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }
    
    function rewardPerToken() public view returns (uint256) {
        if (_totalSupply == 0) {
            return rewardPerTokenStored;
        }
        return rewardPerTokenStored + 
            ((block.timestamp - lastUpdateTime) * rewardRate * 1e18) / _totalSupply;
    }
    
    function earned(address account) public view returns (uint256) {
        return (balances[account] * 
            (rewardPerToken() - userRewardPerTokenPaid[account])) / 1e18 + rewards[account];
    }
    
    // Get contract addresses for frontend integration
    function getTokenAddresses() external view returns (address, address) {
        return (address(stakingToken), address(rewardToken));
    }
    
    // Core Function 1: Stake tokens to earn rewards
    function stake(uint256 amount) external updateReward(msg.sender) {
        require(amount > 0, "Cannot stake 0 tokens");
        
        _totalSupply += amount;
        balances[msg.sender] += amount;
        
        require(
            stakingToken.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
        
        emit Staked(msg.sender, amount);
    }
    
    // Core Function 2: Withdraw staked tokens
    function withdraw(uint256 amount) external updateReward(msg.sender) {
        require(amount > 0, "Cannot withdraw 0 tokens");
        require(balances[msg.sender] >= amount, "Insufficient balance");
        
        _totalSupply -= amount;
        balances[msg.sender] -= amount;
        
        require(
            stakingToken.transfer(msg.sender, amount),
            "Transfer failed"
        );
        
        emit Withdrawn(msg.sender, amount);
    }
    
    // Core Function 3: Claim accumulated rewards
    function claimReward() external updateReward(msg.sender) {
        uint256 reward = rewards[msg.sender];
        require(reward > 0, "No rewards to claim");
        
        rewards[msg.sender] = 0;
        
        require(
            rewardToken.transfer(msg.sender, reward),
            "Reward transfer failed"
        );
        
        emit RewardPaid(msg.sender, reward);
    }
    
    // Convenience function to withdraw all tokens and claim rewards
    function exit() external updateReward(msg.sender) {
        uint256 stakedAmount = balances[msg.sender];
        uint256 rewardAmount = rewards[msg.sender];
        
        // Withdraw staked tokens if any
        if (stakedAmount > 0) {
            _totalSupply -= stakedAmount;
            balances[msg.sender] = 0;
            
            require(
                stakingToken.transfer(msg.sender, stakedAmount),
                "Stake transfer failed"
            );
            
            emit Withdrawn(msg.sender, stakedAmount);
        }
        
        // Claim rewards if any
        if (rewardAmount > 0) {
            rewards[msg.sender] = 0;
            
            require(
                rewardToken.transfer(msg.sender, rewardAmount),
                "Reward transfer failed"
            );
            
            emit RewardPaid(msg.sender, rewardAmount);
        }
        
        require(stakedAmount > 0 || rewardAmount > 0, "Nothing to exit");
    }
    
    // Owner functions for contract management
    function setRewardRate(uint256 _rewardRate) external onlyOwner updateReward(address(0)) {
        rewardRate = _rewardRate;
    }
    
    // Emergency function to recover tokens (only owner)
    function recoverToken(address tokenAddress, uint256 amount) external onlyOwner {
        require(tokenAddress != address(stakingToken), "Cannot recover staking token");
        IERC20(tokenAddress).transfer(owner, amount);
    }
    
    // Function to add more reward tokens to the contract
    function addRewardTokens(uint256 amount) external {
        require(
            rewardToken.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
    }
    
    // Get contract info for debugging
    function getContractInfo() external view returns (
        uint256 contractStakingBalance,
        uint256 contractRewardBalance,
        uint256 totalStaked,
        uint256 currentRewardRate
    ) {
        return (
            stakingToken.balanceOf(address(this)),
            rewardToken.balanceOf(address(this)),
            _totalSupply,
            rewardRate
        );
    }
}
