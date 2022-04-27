async function main() {
  const ethers = require("ethers");
  // const Ganache = require("ganache");

  // const ganache = Ganache.provider(ganacheOptions);
  // const provider = new ethers.providers.Web3Provider(ganache);

  const provider = new ethers.providers.JsonRpcProvider();

  // // Getting the accounts
  // const signer0 = provider.getSigner(0);

  // console.log("signer0", signer0);

  let address = "0xf68b8b01A962ad86e4aeaC1b71CE489Fae28b816";
  provider.getBalance(address).then((balance) => {
    // balance is a BigNumber (in wei); format is as a sting (in ether)
    let etherString = ethers.utils.formatEther(balance);

    console.log("Balance: " + etherString);
  });

  // Getting the accounts
  // const signer0 = provider.getSigner(0);

  // console.log("signer0 address", signer0.getAddress());
  // console.log("signer0 balance", signer0.getBalance(["latest"]));
  const accounts = await provider.listAccounts();
  console.log("accounts", accounts);

  const balance = await provider.getBalance(
    "0x5d46f043DCB2429049CC6361B04154c893fe74f2"
  );
  console.log(
    "ballance of 0x5d46f043DCB2429049CC6361B04154c893fe74f2",
    balance
  );
}

main();
