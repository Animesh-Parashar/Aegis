# 🛡️ Aegis — Safe Autonomous Payments for AI Agents (EIP-7702)

> **Delegate spending authority once.
> Let agents pay autonomously — safely.**

Aegis is a **delegated execution policy** built on **EIP-7702** that allows users to safely authorize autonomous agents to make on-chain micropayments (e.g. x402 flows) **without giving them private keys or unlimited access to funds**.


---

## 🚨 The Problem

AI agents are starting to:

* pay for APIs, compute, and services
* run subscriptions
* make x402 micropayments autonomously

Today, this usually means:

* giving the agent a private key ❌
* trusting off-chain middleware ❌
* adding human approvals (kills autonomy) ❌

There is **no native way to bound an agent’s spending authority**.

---

## ✅ The Idea (Simple)

**Separate intent from authority.**

* Agents decide *when* to pay
* Aegis enforces *how much* they are allowed to pay

All enforcement happens **on-chain**, before execution.

---

## 🧠 Architecture Overview

```
┌──────────────┐
│   User EOA   │
│ (keeps keys) │
└──────┬───────┘
       │  EIP-7702 delegation (one-time)
       ▼
┌──────────────────────┐
│  AegisDelegation     │
│  (on-chain policy)   │
│  • spend limits      │
│  • cooldowns         │
│  • agent allowlist   │
│  • kill switch       │
└──────┬───────────────┘
       │
       ▼
┌──────────────────────┐
│  USDC / Target       │
│  Contracts           │
└──────────────────────┘
```

**Key point:**
After delegation, agents can transact **autonomously**, but **cannot exceed on-chain limits**.

---

## 🔁 Execution Flow (End-to-End)

```
1. User deploys AegisDelegation
2. User signs one EIP-7702 delegation
3. Agent runs autonomously
4. Agent hits an API → gets HTTP 402
5. Agent constructs USDC.transfer calldata
6. Transaction executes via AegisDelegation
7. Aegis enforces policy:
   - amount <= daily limit
   - cooldown respected
   - agent allowed
8. Payment succeeds or reverts deterministically
```

No human signing per transaction.
No middleware censorship.
No private keys shared.

---

## 🔐 What Aegis Enforces (On-Chain)

* ✅ Daily spending limits
* ✅ Cooldowns between spends
* ✅ Agent allowlist
* ✅ Token allowlist (USDC-only)
* ✅ Irreversible kill switch

If an agent loops, hallucinates, or is compromised:

* worst case = **bounded loss**
* never full wallet drain

---

## 🤝 x402 Compatibility

Aegis is **orthogonal** to x402.

* x402 handles **payment negotiation**
* Aegis handles **execution authority**

No changes to x402 are required.

---

## 🧱 Contracts

### `AegisDelegation.sol` (Core)

* Delegated execution policy
* Enforces all safety rules
* Remix-ready
* No external dependencies

### `AegisDelegationFactory.sol` (Optional)

* Deploys delegation contracts
* Improves UX for demos

---

## 🧪 Testnet Demo Scope

* AegisDelegation deployed on testnet
* EIP-7702 delegation from an EOA
* An autonomous agent script
* ✅ One successful payment
* ❌ One rejected payment (limit / cooldown)
* 🛑 Kill switch halting execution

No frontend required — focus is on **execution correctness**.

---

## ❌ What This Is NOT

* Not a transaction firewall
* Not AI prompt monitoring
* Not reputation scoring
* Not off-chain trust enforcement

Aegis enforces **authority**, not behavior.

---

## 🏆 Why This Matters

Aegis enables:

* safe autonomous subscriptions
* agent-driven payroll & micropayments
* AI marketplaces without custodial risk
* x402 adoption without fear of wallet drain

It’s a **missing primitive** for agent economies.

---

> **Aegis lets users safely delegate autonomous payments by enforcing spending authority on-chain, without breaking x402 autonomy or giving agents private keys.**

---
