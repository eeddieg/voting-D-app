const ethers = require("ethers");
const fs = require("fs");

function writeToFile(arr) {
  const path = process.cwd();
  const fileName = path + "/candidates.txt";

  try {
    for (let i = 0; i < arr.length; i++) {
      let context = arr[i];
      if (i == 0) {
        fs.writeFileSync(fileName, context, { flag: "w+" });
      } else {
        fs.writeFileSync(fileName, context, { flag: "a+" });
      }
    }
  } catch (err) {
    console.error(err);
  }
}

async function createBytes(size) {
  let candidates = [];
  for (let i = 0; i < size; i++) {
    let name = "Candidate " + (i + 1);
    const bytes = ethers.utils.formatBytes32String(name);
    const tmp = '\"' + bytes +'\"' + "\n";
    candidates.push(tmp);
  }
  writeToFile(candidates);
}

pop = 5;
createBytes(pop);