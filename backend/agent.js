import { ethers } from "ethers";
import fetch from "node-fetch";
import "dotenv/config";

/*
  The agent only knows:
  - an RPC
  - a signer (EOA)
  - how to pay USDC
*/

const provider = new ethers.JsonRpcProvider(process.env.RPC_URL);
const agentWallet = new ethers.Wallet(
  process.env.AGENT_PRIVATE_KEY, // agent-controlled key
  provider
);

// Standard USDC ABI
const usdcAbi = [
  "function transfer(address to, uint256 amount) external returns (bool)"
];

async function runAgent() {
  console.log("🤖 Agent running (Aegis-agnostic)");

  while (true) {
    try {
      // Call a paid API
      const res = await fetch("http://localhost:3000/paid-resource");

      if (res.status === 402) {
        const payment = await res.json();

        console.log("402 received. Preparing payment.");

        const usdc = new ethers.Contract(
          process.env.USDC_ADDRESS,
          usdcAbi,
          agentWallet
        );

        // This is a NORMAL Ethereum call
        const tx = await usdc.transfer(
          payment.recipient,
          payment.price
        );

        await tx.wait();
        console.log("✅ Payment succeeded:", tx.hash);
      }

    } catch (err) {
      console.error("❌ Transaction failed:", err.reason || err.message);
    }

    // Agent keeps running autonomously
    await new Promise(r => setTimeout(r, 5000));
  }
}

runAgent();
