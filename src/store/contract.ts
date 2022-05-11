import store from "@/store";
import { ContractFactory, providers, Wallet } from "ethers";

export class ContractInfo {
  Owner = "0x8d1463E58b6d327Ba92442d95B4e40c42DFA68DA";
  OwnerPrivateKey =
    "0x38168ccec41fda8a0c9e076c276dc25072f6a26c7887a7d19216260f1fc41ca6";

  // Owner = "0x3C05160d4271AF77c035a4551B8F0711E7d9b5eb";
  // OwnerPrivateKey =
  //   "0x219fa91aa1e11124f03c788dffa54ddb3f4a5c96235223877a03c0bcc74ded08";
  ElectionJSON = require("../../smart_contract/contracts/artifacts/Election.json");

  ContractAddress = "0x3d89Ed4c2c341EeE588Bf8BB3d1ec244C9ba9606";

  getAbi() {
    return this.ElectionJSON.abi;
  }

  getBytecode() {
    return this.ElectionJSON.data.bytecode;
  }

  getContractAddress() {
    return this.ContractAddress;
  }

  getOwner() {
    return this.Owner;
  }
  getOwnerPrivateKey() {
    return this.OwnerPrivateKey;
  }

  async deployContract() {
    const abi = await store.getters.ABI;
    const bytecode = await store.getters.Bytecode;

    const provider = new providers.JsonRpcProvider("http://127.0.0.1:8545");

    const wallet = new Wallet(this.getOwnerPrivateKey(), provider);

    const factory = new ContractFactory(abi, bytecode, wallet);

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    await factory.deploy().then((contract: any) => {
      store.dispatch("storeContractAddress", contract.address);
      store.dispatch("storeContract", contract);
    });
  }
}
