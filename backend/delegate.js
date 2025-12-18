import { ethers } from "ethers";
import "dotenv/config";

const provider = new ethers.JsonRpcProvider(process.env.RPC_URL);
const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

const AEGIS_DELEGATION = process.env.AEGIS_DELEGATION;

async function delegate() {
  const delegationMessage = ethers.solidityPacked(
    ["string", "address"],
    ["EIP7702_DELEGATION", AEGIS_DELEGATION]
  );

  const delegationHash = ethers.keccak256(delegationMessage);
  const signature = await wallet.signMessage(
    ethers.getBytes(delegationHash)
  );

  console.log("Delegation signed");
  console.log("Delegation contract:", AEGIS_DELEGATION);
  console.log("Signature:", signature);
  
//   This signature authorises the delegation contract to act on behalf of the wallet

}

delegate();
