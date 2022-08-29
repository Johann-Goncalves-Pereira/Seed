import { Elm } from "../Main.elm";
import { Storage } from "./Ports/storage";
// import { Scroll } from "./Ports/scroll";

import "./Load/loadStyles.ts";

const rootNode = document.querySelector("#root");

const app: Elm = Elm.Main.init({
  node: rootNode,
  flags: "Initial Message",
});

// Scroll(app);
Storage(app);
