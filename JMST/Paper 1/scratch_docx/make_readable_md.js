// Converts every $...$ / $$...$$ LaTeX math span in the final .md into a plain,
// human-readable rendering (Unicode subscript/superscript digits + symbols,
// "_x"/"^x" fallback otherwise) -- so the paper reads cleanly in ANY plain-text
// or markdown viewer that does not render LaTeX (GitHub, Notepad, Zalo, ...),
// instead of showing raw "$\dfrac{...}{...}$" source.
const fs = require("fs");
const path = require("path");

const SRC = path.resolve(__dirname, "..", "10.12 Paper1_JMST_Final.md");
const OUT = path.resolve(__dirname, "..", "10.12 Paper1_JMST_Final_readable.md");

const LATEX_SYMBOLS = {
  times: "×", pm: "±", mp: "∓", approx: "≈", propto: "∝", cdot: "·",
  circ: "°", ge: "≥", le: "≤", neq: "≠", infty: "∞",
  Delta: "Δ", delta: "δ", alpha: "α", beta: "β", gamma: "γ", theta: "θ",
  lambda: "λ", varphi: "φ", phi: "ϕ", pi: "π", mu: "μ", sigma: "σ", omega: "ω",
  epsilon: "ε", varepsilon: "ε", eta: "η", zeta: "ζ", kappa: "κ", rho: "ρ", tau: "τ", chi: "χ", psi: "ψ", xi: "ξ", nu: "ν",
  max: "max", min: "min",
};
const SUB_DIGIT = { 0: "₀", 1: "₁", 2: "₂", 3: "₃", 4: "₄", 5: "₅", 6: "₆", 7: "₇", 8: "₈", 9: "₉" };
const SUP_DIGIT = { 0: "⁰", 1: "¹", 2: "²", 3: "³", 4: "⁴", 5: "⁵", 6: "⁶", 7: "⁷", 8: "⁸", 9: "⁹" };

function findMatchingBrace(str, openIdx) {
  let depth = 0;
  for (let k = openIdx; k < str.length; k++) {
    if (str[k] === "{") depth++;
    else if (str[k] === "}") { depth--; if (depth === 0) return k; }
  }
  return str.length;
}

function parsePrimary(str, i) {
  const c = str[i];
  if (c === "\\") {
    let j = i + 1;
    if (j < str.length && /[a-zA-Z]/.test(str[j])) {
      let k = j;
      while (k < str.length && /[a-zA-Z]/.test(str[k])) k++;
      return handleCommand(str.slice(j, k), str, k);
    }
    const ch = str[j] || "";
    const escMap = { ",": " ", " ": " ", "%": "%", "\\": "\\" };
    return { text: escMap.hasOwnProperty(ch) ? escMap[ch] : ch, next: j + 1 };
  }
  if (c === "{") {
    const close = findMatchingBrace(str, i);
    return { text: parseSeq(str.slice(i + 1, close)), next: close + 1 };
  }
  return { text: c, next: i + 1 };
}

function readGroup(str, i) {
  while (str[i] === " ") i++;
  if (str[i] === "{") {
    const close = findMatchingBrace(str, i);
    return { text: parseSeq(str.slice(i + 1, close)), next: close + 1 };
  }
  return parsePrimary(str, i);
}

function needsParens(s) { return /[\s+\-×±=]/.test(s); }
function wrap(s) { return needsParens(s) ? `(${s})` : s; }

function handleCommand(cmd, str, i) {
  if (cmd === "dfrac" || cmd === "frac" || cmd === "tfrac") {
    const num = readGroup(str, i);
    const den = readGroup(str, num.next);
    return { text: `${wrap(num.text)}/${wrap(den.text)}`, next: den.next };
  }
  if (cmd === "sqrt") {
    let degree = "";
    let k = i;
    if (str[k] === "[") {
      const close = str.indexOf("]", k);
      degree = parseSeq(str.slice(k + 1, close));
      k = close + 1;
    }
    const rad = readGroup(str, k);
    const degSup = degree ? (/^[0-9]+$/.test(degree) ? degree.split("").map((d) => SUP_DIGIT[d]).join("") : `^${degree}`) : "";
    return { text: `${degSup}√(${rad.text})`, next: rad.next };
  }
  if (cmd === "text") {
    if (str[i] === "{") {
      const close = findMatchingBrace(str, i);
      return { text: str.slice(i + 1, close), next: close + 1 };
    }
    return { text: "", next: i };
  }
  const sym = LATEX_SYMBOLS.hasOwnProperty(cmd) ? LATEX_SYMBOLS[cmd] : cmd;
  return { text: sym, next: i };
}

function renderSub(s) {
  if (/^[0-9]+$/.test(s)) return s.split("").map((c) => SUB_DIGIT[c]).join("");
  return s.length > 1 ? `_{${s}}` : `_${s}`;
}
function renderSup(s) {
  if (s === "°") return "°";
  if (/^[0-9]+$/.test(s)) return s.split("").map((c) => SUP_DIGIT[c]).join("");
  return s.length > 1 ? `^{${s}}` : `^${s}`;
}

function parseSeq(str) {
  let out = "";
  let i = 0;
  while (i < str.length) {
    const atom = parsePrimary(str, i);
    i = atom.next;
    let piece = atom.text;
    let primeCount = 0;
    while (str[i] === "'") { primeCount++; i++; }
    if (primeCount > 0) piece += "'".repeat(primeCount);
    let sub = null, sup = null;
    while (str[i] === "_" || str[i] === "^") {
      const isSub = str[i] === "_";
      const arg = readGroup(str, i + 1);
      i = arg.next;
      if (isSub) sub = arg.text; else sup = arg.text;
    }
    if (sub !== null) piece += renderSub(sub);
    if (sup !== null) piece += renderSup(sup);
    out += piece;
  }
  return out;
}

function latexToPlain(latex) { return parseSeq(latex.trim()); }

// ---------- run over the .md file ----------
let md = fs.readFileSync(SRC, "utf-8");

md = md.replace(/\$\$([^$]+?)\$\$/g, (_, inner) => latexToPlain(inner));
md = md.replace(/\$([^$]+?)\$/g, (_, inner) => latexToPlain(inner));

fs.writeFileSync(OUT, md, "utf-8");
console.log("Wrote", OUT);
