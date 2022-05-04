"use strict";
exports.__esModule = true;
var fs = require("fs");
var content = fs.readFileSync("foo.txt", "utf8");
console.log(content);
