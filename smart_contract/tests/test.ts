import * as fs from "fs";

const content = fs.readFileSync("foo.txt", "utf8");

console.log(content);