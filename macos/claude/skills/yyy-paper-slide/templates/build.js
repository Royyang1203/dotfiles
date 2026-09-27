// build.js — entry point. Reads content.md, renders with the engine, writes the pptx.
// Run:  node build.js
const fs = require("fs");
const path = require("path");
const { buildDeck } = require("./engine");
const custom = require("./custom");

const md = fs.readFileSync(path.join(__dirname, "content.md"), "utf8");
buildDeck({ md, custom, out: "deck.pptx" }).then(f => console.log("WROTE", f));
