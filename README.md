# 🛡️ Aegis - Pre-Execution Enforcement for Autonomous AI Agents  
### Safe Delegated Payments via EIP-7702

> **Delegate authority once.  
> Enforce limits forever.  
> Let agents act — without risking total loss.**

Aegis is a **pre-execution enforcement layer** for autonomous AI agents, built using **EIP-7702 delegation**.  
It allows users to authorize agents to make on-chain payments (e.g. x402 flows) **without sharing private keys and without granting unbounded authority**.

Aegis enforces *what an agent is allowed to do* **before execution**, deterministically, on-chain.

---

## 🚨 The Problem

AI agents increasingly:
- pay for APIs, compute, and services
- run recurring subscriptions
- perform x402 micropayments autonomously

Today, autonomy usually requires:
- handing an agent a private key ❌
- trusting off-chain middleware ❌
- inserting human approvals (breaks autonomy) ❌

This creates a binary choice:
> **Full control or full risk**

There is no native, on-chain primitive for **bounded delegation of economic authority**.

---

## ✅ The Core Idea

### Separate **decision-making** from **execution authority**.

- Agents decide *when* to act
- Aegis enforces *what is allowed to execute*

All enforcement happens **on-chain, before state transition**.

This is not monitoring.  
This is not reputation.  
This is **hard execution control**.

---

## 🧠 Architecture Overview

```
       ┌──────────────────────────┐
       │      User EOA Asset      │
       │    (Private Key Safe)    │
       └────────────┬─────────────┘
                    │
          [ Signature / EIP-7702 ]
          "Points to Aegis Logic"
                    │
                    ▼
       ┌──────────────────────────┐
       │   AegisDelegation Smart  │
       │    Implementation Logic  │
       ├──────────────────────────┤
       │  ENFORCEMENT POLICIES:   │
       │                          │
       │ • Spend Limits (Daily)   │
       │ • Cooldown / Timelocks   │
       │ • Agent Role-Based Access│
       │ • Asset/Token Allowlist  │
       │ • Recovery / Kill-Switch │
       └────────────┬─────────────┘
                    │
            [ Validated Call ]
                    │
                    ▼
       ┌──────────────────────────┐
       │     Target Protocols     │
       │   (USDC / DEX / x402)    │
       └──────────────────────────┘
```

**Key property:**  
After delegation, agents operate autonomously, **but cannot exceed on-chain policy constraints**.



## 🔁 End-to-End Execution Flow

```

(1) User deploys AegisDelegation
(2) User signs an EIP-7702 delegation (one-time)
(3) Agent operates autonomously
(4) Agent encounters HTTP 402 (x402 payment request)
(5) Agent constructs calldata (e.g. USDC.transfer)
(6) Call is routed via AegisDelegation
(7) Aegis enforces policy:
- amount ≤ limit
- cooldown respected
- agent authorized
- token allowed
- kill-switch inactive
(8) Transaction:
→ executes successfully
→ or reverts deterministically

```

No per-tx human signing.  
No off-chain trust.  
No silent failure modes.

---

## 🔐 What Aegis Enforces (On-Chain)

- ✅ Daily / rolling spend limits
- ✅ Cooldown intervals
- ✅ Agent allowlisting
- ✅ Token allowlisting (e.g. USDC-only)
- ✅ Irreversible kill switch

Failure modes are explicit and bounded.

If an agent:
- loops
- hallucinates
- is compromised

**Worst case = capped loss.  
Never total wallet drain.**

---

## 🔗 x402 Compatibility

Aegis is **orthogonal** to x402.

- x402 → *payment negotiation*
- Aegis → *execution authority*

No changes to x402 are required.
Aegis simply enforces whether payment may execute.

---

## 🧱 Contract Structure

### `AegisDelegation.sol` (Core)

- EIP-7702 compatible delegation target
- Stateless enforcement logic
- Deterministic reverts
- No external dependencies

### `AegisDelegationFactory.sol` (Optional)

- UX helper for deploying delegations
- Not required for correctness

---

## 🧪 Testnet Demo Scope

- AegisDelegation deployed on testnet
- EIP-7702 delegation from EOA
- Autonomous agent script
- ✅ One successful payment
- ❌ One reverted payment (limit / cooldown)
- 🛑 Kill switch halting all execution

No frontend required — focus is **execution correctness**.

---

## ❌ What Aegis Is Not

- ❌ Not a reputation system
- ❌ Not agent scoring
- ❌ Not post-execution attribution
- ❌ Not off-chain middleware
- ❌ Not prompt monitoring

Aegis enforces **authority**, not intent or behavior.

---

## 🧩 Position in the Agent Trust Stack

```
       ┌──────────────────────────────┐
       │     REPUTATION & AUDIT       │
       │  (Post-Execution Trust)      │
       ├──────────────────────────────┤
       │ • ERC-8004 Attestations      │
       │ • DKG / Threshold Logging    │
       │ • Success/Failure Metrics    │
       └──────────────▲───────────────┘
                      │
              [ On-Chain Proof ]
                      │
       ┌──────────────────────────────┐
       │     AEGIS ENFORCEMENT        │
       │  (Execution Guardrails)      │
       ├──────────────────────────────┤
       │ • EIP-7702 Delegation        │
       │ • Real-time Policy Checks    │
       │ • Asset Isolation (x402)     │
       └──────────────▲───────────────┘
                      │
              [ Restricted Call ]
                      │
       ┌──────────────────────────────┐
       │    AGENT DECISION LAYER      │
       │  (Intelligence & Intent)     │
       ├──────────────────────────────┤
       │ • LLM Reasoning (RAG)        │
       │ • Tool / Function Calling    │
       │ • Signed Intent Generation   │
       └──────────────────────────────┘

```

Aegis handles **ex-ante safety**.  
Reputation systems handle **ex-post accountability**.

Both are necessary. Neither replaces the other.

---

## 🏆 Why This Matters

Aegis enables:
- safe autonomous subscriptions
- agent-driven micropayments
- non-custodial AI marketplaces
- x402 adoption without catastrophic risk

It introduces a **missing primitive**:
> **Bounded, revocable economic authority for autonomous agents**

---

> **Aegis lets users delegate autonomous payments safely by enforcing execution authority on-chain — without breaking autonomy and without exposing private keys.**

---
