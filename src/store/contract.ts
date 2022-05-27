import store from "@/store";
import { ContractFactory, ethers, providers, Wallet } from "ethers";

export class ContractInfo {
  ElectionJSON = require("../../smart_contract/contracts/artifacts/Election.json");

  // Owner = "0x3C05160d4271AF77c035a4551B8F0711E7d9b5eb";
  // OwnerPrivateKey = "0x219fa91aa1e11124f03c788dffa54ddb3f4a5c96235223877a03c0bcc74ded08";

  ContractAddress = "0x5BF4c03c6e3D1EAdFe8dCBF940ADC4c2f0f9839A";
  OwnerPrivateKey = "";

  getAbi() {
    return this.ElectionJSON.abi;
  }

  async getAccounts() {
    let accountsList: string[] = [];
    const provider = new ethers.providers.JsonRpcProvider();

    await provider.listAccounts().then((accounts: any) => {
      accountsList = accounts;
      store.dispatch("storeAccounts", accountsList);
    });
    return accountsList;
  }

  getBytecode() {
    return this.ElectionJSON.data.bytecode;
  }

  getContractAddress() {
    return this.ContractAddress;
  }

  async getOwner() {
    let owner = "";
    const provider = new ethers.providers.JsonRpcProvider();

    await provider.listAccounts().then((accounts) => {
      owner = accounts[0];
      store.dispatch("storeOwner", owner);
    });
    return owner;
  }

  getOwnerPrivateKey() {
    return this.OwnerPrivateKey;
  }

  // async deployContract() {
  //   const abi = await store.getters.ABI;
  //   const bytecode = await store.getters.Bytecode;

  //   const provider = new providers.JsonRpcProvider("http://127.0.0.1:8545");

  //   const wallet = new Wallet(this.getOwnerPrivateKey(), provider);

  //   const factory = new ContractFactory(abi, bytecode, wallet);

  //   // eslint-disable-next-line @typescript-eslint/no-explicit-any
  //   await factory.deploy().then((contract: any) => {
  //     store.dispatch("storeContractAddress", contract.address);
  //     store.dispatch("storeContract", contract);
  //   });
  // }
}
