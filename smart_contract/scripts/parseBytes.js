const ethers = require("ethers");
const fs = require("fs");

async function parseBytes(file) {
  let content;
  try {
    content = fs.readFileSync(file, "utf-8");
  } catch (e) {
    console.log(e);
  }

  const arr = content.split("\n")// const bytes = args[0];

  for (let i = 0; i < arr.length -1; i++) {
    let name = arr[i];
    name = name.slice(1);
    name = name.slice(0, name.length - 1);
    name = ethers.utils.parseBytes32String(name);
    console.log(name);
  }
}

const path = process.cwd();
const fileName = path + "/candidates.txt";
parseBytes(fileName);
