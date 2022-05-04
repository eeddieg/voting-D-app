export class ContractDetails {
  ElectionJSON = require("../../smart_contract/contracts/artifacts/Election.json");

  getAbi() {
    return this.ElectionJSON.abi;
  }
  getBytecode() {
    return this.ElectionJSON.data.bytecode;
  }
}
