// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;


interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
}


contract AegisDelegation {
    address public immutable owner;
    IERC20 public immutable USDC;

    mapping(address => bool) public allowedAgents;

    uint256 public dailyLimit;
    uint256 public spentToday;
    uint256 public lastReset;

    uint256 public cooldown;
    uint256 public lastSpend;

    bool public killed;



    event AgentAllowed(address agent);
    event AgentRevoked(address agent);
    event Spend(address agent, uint256 amount);
    event KillSwitchActivated();

    constructor(
        address _owner,
        address _usdc,
        uint256 _dailyLimit,
        uint256 _cooldown
    ) {
        owner = _owner;
        USDC = IERC20(_usdc);
        dailyLimit = _dailyLimit;
        cooldown = _cooldown;
        lastReset = block.timestamp;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "NOT_OWNER");
        _;
    }

    modifier notKilled() {
        require(!killed, "KILLED");
        _;
    }


    function allowAgent(address agent) external onlyOwner {
        allowedAgents[agent] = true;
        emit AgentAllowed(agent);
    }

    function revokeAgent(address agent) external onlyOwner {
        allowedAgents[agent] = false;
        emit AgentRevoked(agent);
    }

    function activateKillSwitch() external onlyOwner {
        killed = true;
        emit KillSwitchActivated();
    }


    /**
     * This function is executed via EIP-7702 delegation
     * instead of direct EOA execution.
     */
    function execute(address target, bytes calldata data)
        external
        notKilled
    {
        require(allowedAgents[msg.sender], "AGENT_NOT_ALLOWED");

        // reset daily window
        if (block.timestamp > lastReset + 1 days) {
            spentToday = 0;
            lastReset = block.timestamp;
        }

        require(target == address(USDC), "ONLY_USDC");

        bytes4 selector;
        assembly {
            selector := calldataload(data.offset)
        }
        require(selector == IERC20.transfer.selector, "ONLY_TRANSFER");

        (, uint256 amount) =
            abi.decode(data[4:], (address, uint256));

        require(spentToday + amount <= dailyLimit, "LIMIT_EXCEEDED");
        require(block.timestamp >= lastSpend + cooldown, "COOLDOWN");

        spentToday += amount;
        lastSpend = block.timestamp;

        (bool success,) = target.call(data);
        require(success, "CALL_FAILED");

        emit Spend(msg.sender, amount);
    }
}
