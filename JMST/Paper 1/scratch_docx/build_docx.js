// Build Paper1_JMST.docx from Paper1_JMST_Draft_v1.md, matching JMST template styles.
const fs = require("fs");
const path = require("path");
const sizeOf = require("image-size").default || require("image-size");
const {
  Document, Packer, Paragraph, TextRun, HeadingLevel, AlignmentType,
  Table, TableRow, TableCell, WidthType, BorderStyle, ImageRun,
  ShadingType, VerticalAlign, TabStopType, TabStopPosition, PageBreak,
  SectionType,
  // Native Word equation (OMML) objects, used to render real LaTeX-like formulas
  // instead of literal "$...$" text. Aliased as OMath so it doesn't shadow the
  // built-in global `Math` object used elsewhere in this file (Math.round, ...).
  Math: OMath, MathRun, MathFraction, MathRadical,
  MathSubScript, MathSuperScript, MathSubSuperScript,
} = require("docx");

const ROOT = path.resolve(__dirname, "..");
const MD_PATH = process.env.MD_PATH_OVERRIDE
  ? path.resolve(process.env.MD_PATH_OVERRIDE)
  : path.join(ROOT, "Paper1_JMST_Draft_v1.md");
const FONT = "Times New Roman";
const COLOR_HEAD = "990033";
const SHADE_HEADER = "DEEAF6";

// ---------- sizes (half-points) ----------
const SZ = { title: 26, author: 24, h1: 22, h2: 22, body: 20, small: 18 };

// ---------- LaTeX ($...$ / $$...$$) -> native Word equation (OMML) ----------
// A small, targeted recursive-descent parser -- not a full LaTeX engine, just
// covers the constructs actually used in this paper: subscripts/superscripts
// (incl. combined and primes), \dfrac/\frac, \sqrt[n]{...}, \text{...} labels,
// common operators/Greek letters, and transparent "{,}" grouping (used to
// protect the Vietnamese decimal comma, e.g. "0{,}82" -> "0,82"). Everything
// else (letters/digits/punctuation) passes through as literal math runs, and
// Word's own OMML rendering takes care of italicizing variables while keeping
// digits upright -- matching normal mathematical typesetting automatically.
const LATEX_SYMBOLS = {
  times: "×", pm: "±", mp: "∓", approx: "≈", propto: "∝", cdot: "·",
  circ: "°", ge: "≥", le: "≤", neq: "≠", infty: "∞",
  Delta: "Δ", delta: "δ", alpha: "α", beta: "β", gamma: "γ", theta: "θ",
  lambda: "λ", varphi: "φ", phi: "ϕ", pi: "π", mu: "μ", sigma: "σ", omega: "ω",
  epsilon: "ε", varepsilon: "ε", eta: "η", zeta: "ζ", kappa: "κ", rho: "ρ", tau: "τ", chi: "χ", psi: "ψ", xi: "ξ", nu: "ν",
  max: "max", min: "min",
};

function findMatchingBrace(str, openIdx) {
  let depth = 0;
  for (let k = openIdx; k < str.length; k++) {
    if (str[k] === "{") depth++;
    else if (str[k] === "}") { depth--; if (depth === 0) return k; }
  }
  return str.length;
}

// Parses the single "unit" starting at str[i]: a command (\cmd, possibly with
// [..] / {..} arguments), a brace group (transparent -- parsed and spliced in),
// or one plain character. Returns { nodes: MathComponent[], next: index }.
function mathParsePrimary(str, i) {
  const c = str[i];
  if (c === "\\") {
    let j = i + 1;
    if (j < str.length && /[a-zA-Z]/.test(str[j])) {
      let k = j;
      while (k < str.length && /[a-zA-Z]/.test(str[k])) k++;
      const cmd = str.slice(j, k);
      return mathHandleCommand(cmd, str, k);
    }
    // escaped single char: \, (thin space), \% , \\ , etc.
    const ch = str[j] || "";
    const escMap = { ",": " ", " ": " ", "%": "%", "\\": "\\" };
    return { nodes: [new MathRun(escMap.hasOwnProperty(ch) ? escMap[ch] : ch)], next: j + 1 };
  }
  if (c === "{") {
    const close = findMatchingBrace(str, i);
    const { nodes } = mathParseSeq(str.slice(i + 1, close));
    return { nodes, next: close + 1 };
  }
  return { nodes: [new MathRun(c)], next: i + 1 };
}

// Parses the argument of a _ / ^ : a full {..} group, a single \command, or
// exactly one plain character -- standard LaTeX single-token convention.
function mathParseArgument(str, i) {
  if (str[i] === "{") {
    const close = findMatchingBrace(str, i);
    const { nodes } = mathParseSeq(str.slice(i + 1, close));
    return { nodes, next: close + 1 };
  }
  return mathParsePrimary(str, i);
}

function mathReadMandatoryGroup(str, i) {
  while (str[i] === " ") i++;
  return mathParseArgument(str, i);
}

function mathHandleCommand(cmd, str, i) {
  if (cmd === "dfrac" || cmd === "frac" || cmd === "tfrac") {
    const num = mathReadMandatoryGroup(str, i);
    const den = mathReadMandatoryGroup(str, num.next);
    return { nodes: [new MathFraction({ numerator: num.nodes, denominator: den.nodes })], next: den.next };
  }
  if (cmd === "sqrt") {
    let degree;
    let k = i;
    if (str[k] === "[") {
      const close = str.indexOf("]", k);
      degree = mathParseSeq(str.slice(k + 1, close)).nodes;
      k = close + 1;
    }
    const radicand = mathReadMandatoryGroup(str, k);
    return { nodes: [new MathRadical({ degree, children: radicand.nodes })], next: radicand.next };
  }
  if (cmd === "text") {
    if (str[i] === "{") {
      const close = findMatchingBrace(str, i);
      return { nodes: [new MathRun(str.slice(i + 1, close))], next: close + 1 };
    }
    return { nodes: [new MathRun("")], next: i };
  }
  const sym = LATEX_SYMBOLS.hasOwnProperty(cmd) ? LATEX_SYMBOLS[cmd] : cmd;
  return { nodes: [new MathRun(sym)], next: i };
}

// Parses a full math string into a flat MathComponent[] sequence, handling
// postfix primes ('), subscripts (_) and superscripts (^) on each unit.
function mathParseSeq(str) {
  const nodes = [];
  let i = 0;
  while (i < str.length) {
    const atom = mathParsePrimary(str, i);
    i = atom.next;
    let primeCount = 0;
    while (str[i] === "'") { primeCount++; i++; }
    let sup = primeCount > 0 ? [new MathRun("′".repeat(primeCount))] : null;
    let sub = null;
    while (str[i] === "_" || str[i] === "^") {
      const isSub = str[i] === "_";
      const arg = mathParseArgument(str, i + 1);
      i = arg.next;
      if (isSub) sub = arg.nodes; else sup = arg.nodes;
    }
    if (sub && sup) nodes.push(new MathSubSuperScript({ children: atom.nodes, subScript: sub, superScript: sup }));
    else if (sub) nodes.push(new MathSubScript({ children: atom.nodes, subScript: sub }));
    else if (sup) nodes.push(new MathSuperScript({ children: atom.nodes, superScript: sup }));
    else nodes.push(...atom.nodes);
  }
  return { nodes };
}

function parseLatexToMathChildren(latex) {
  return mathParseSeq(latex.trim()).nodes;
}

function mathInline(latex) {
  return new OMath({ children: parseLatexToMathChildren(latex) });
}

// ---------- inline markdown -> (TextRun | Math)[] ----------
function parseInline(text, baseOpts = {}) {
  const runs = [];
  // tokenize: $$display math$$, $inline math$, **bold**, *italic*, `code`
  const re = /(\$\$([^$]+?)\$\$)|(\$([^$]+?)\$)|(\*\*(.+?)\*\*)|(\*(.+?)\*)|(`([^`]+)`)/g;
  let last = 0;
  let m;
  while ((m = re.exec(text)) !== null) {
    if (m.index > last) pushPlain(text.slice(last, m.index), baseOpts, runs);
    if (m[2] !== undefined) runs.push(mathInline(m[2]));
    else if (m[4] !== undefined) runs.push(mathInline(m[4]));
    else if (m[6] !== undefined) pushPlainWithMath(m[6], { ...baseOpts, bold: true }, runs);
    else if (m[8] !== undefined) pushPlainWithMath(m[8], { ...baseOpts, italics: true }, runs);
    else if (m[10] !== undefined) pushCode(m[10], baseOpts, runs);
    last = re.lastIndex;
  }
  if (last < text.length) pushPlain(text.slice(last), baseOpts, runs);
  return runs;
}

function pushPlain(str, opts, runs) {
  if (!str) return;
  runs.push(new TextRun({ text: str, font: FONT, ...opts }));
}

// Like pushPlain, but also resolves any $...$/$$...$$ math nested inside a
// **bold**/*italic* span (e.g. "— **không có $\gamma_c$**" in Bảng 3) so the
// formula still renders as a real equation instead of literal LaTeX text.
function pushPlainWithMath(str, opts, runs) {
  const re = /(\$\$([^$]+?)\$\$)|(\$([^$]+?)\$)/g;
  let last = 0;
  let m;
  while ((m = re.exec(str)) !== null) {
    if (m.index > last) pushPlain(str.slice(last, m.index), opts, runs);
    runs.push(mathInline(m[2] !== undefined ? m[2] : m[4]));
    last = re.lastIndex;
  }
  if (last < str.length) pushPlain(str.slice(last), opts, runs);
}

// Math-mode renderer: identifier tokens (incl. Unicode letters, Greek, Vietnamese) become
// italic, with a "_subscript" suffix (only the identifier/number run right after "_")
// rendered as italic subscript. Everything else (operators, numbers, punctuation, spaces)
// passes through as plain (upright) text -- standard math typesetting convention.
const TOKEN_RE = /([\p{L}][\p{L}0-9']*)(_([\p{L}0-9]+))?/gu;
function pushCode(str, opts, runs) {
  let last = 0;
  let m;
  TOKEN_RE.lastIndex = 0;
  while ((m = TOKEN_RE.exec(str)) !== null) {
    if (m.index > last) pushPlain(str.slice(last, m.index), opts, runs);
    runs.push(new TextRun({ text: m[1], font: FONT, italics: true, ...opts }));
    if (m[3]) runs.push(new TextRun({ text: m[3], font: FONT, italics: true, subScript: true, ...opts }));
    last = TOKEN_RE.lastIndex;
  }
  if (last < str.length) pushPlain(str.slice(last), opts, runs);
}

// ---------- paragraph builders ----------
function content(text, opts = {}) {
  return new Paragraph({
    children: parseInline(text, { size: SZ.body }),
    alignment: AlignmentType.JUSTIFIED,
    spacing: { before: 20, after: 20, line: 238, lineRule: "atLeast" },
    indent: opts.noIndent ? undefined : { firstLine: 284 },
    ...opts.pOpts,
  });
}

function formula(text) {
  const runs = [];
  pushCode(text.replace(/^`|`$/g, ""), { size: SZ.body }, runs);
  return new Paragraph({
    children: runs,
    alignment: AlignmentType.LEFT,
    indent: { left: 284 },
    spacing: { before: 120, after: 120 },
  });
}

function heading1(text) {
  return new Paragraph({
    children: parseInline(text, { size: SZ.h1, bold: true, color: COLOR_HEAD }),
    spacing: { before: 100, after: 40, line: 250, lineRule: "atLeast" },
    keepNext: true,
  });
}

function heading2(text) {
  return new Paragraph({
    children: parseInline(text, { size: SZ.h2, bold: true, italics: true, color: COLOR_HEAD }),
    spacing: { before: 70, after: 30, line: 250, lineRule: "atLeast" },
    keepNext: true,
  });
}

function tableTitle(text) {
  return new Paragraph({
    children: parseInline(text, { size: SZ.small, bold: true, italics: true }),
    alignment: AlignmentType.CENTER,
    spacing: { before: 80, after: 40, line: 260, lineRule: "atLeast" },
    keepNext: true,
  });
}

function figTitle(text) {
  return new Paragraph({
    children: parseInline(text, { size: SZ.small, bold: true, italics: true }),
    alignment: AlignmentType.CENTER,
    spacing: { before: 20, after: 80, line: 260, lineRule: "atLeast" },
  });
}

function sourceLine(text) {
  return new Paragraph({
    children: parseInline(text, { size: SZ.small, italics: true }),
    alignment: AlignmentType.RIGHT,
    spacing: { before: 10, after: 80 },
  });
}

function bulletItem(text) {
  return new Paragraph({
    children: parseInline("• " + text, { size: SZ.body }),
    alignment: AlignmentType.JUSTIFIED,
    indent: { left: 284, hanging: 284 },
    spacing: { before: 20, after: 20, line: 248, lineRule: "atLeast" },
  });
}

function refItem(text) {
  return new Paragraph({
    children: parseInline(text, { size: SZ.body }),
    alignment: AlignmentType.JUSTIFIED,
    indent: { left: 284, hanging: 284 },
    spacing: { before: 30, after: 30, line: 248, lineRule: "atLeast" },
  });
}

function imageParagraph(relPath, maxWidthPx, maxHeightPx) {
  const abs = path.join(ROOT, relPath);
  const dim = sizeOf(fs.readFileSync(abs));
  let w = dim.width, h = dim.height;
  const scale = Math.min(maxWidthPx / w, maxHeightPx / h, 1);
  w = Math.round(w * scale);
  h = Math.round(h * scale);
  return new Paragraph({
    children: [
      new ImageRun({ type: "png", data: fs.readFileSync(abs), transformation: { width: w, height: h } }),
    ],
    alignment: AlignmentType.CENTER,
    spacing: { before: 120, after: 20 },
  });
}

// ---------- table builder ----------
function cellBorders() {
  const b = { style: BorderStyle.SINGLE, size: 4, color: "000000" };
  return { top: b, bottom: b, left: b, right: b };
}

function makeCell(text, { header = false, align = AlignmentType.LEFT, widthDxa } = {}) {
  return new TableCell({
    width: { size: widthDxa, type: WidthType.DXA },
    verticalAlign: VerticalAlign.CENTER,
    shading: header ? { type: ShadingType.CLEAR, fill: SHADE_HEADER } : undefined,
    borders: cellBorders(),
    margins: { top: 20, bottom: 20, left: 60, right: 60 },
    children: [
      new Paragraph({
        children: parseInline(text, { size: SZ.small, bold: header }),
        alignment: header ? AlignmentType.CENTER : align,
        spacing: { before: 15, after: 15, line: 228, lineRule: "atLeast" },
      }),
    ],
  });
}

const USABLE_WIDTH_DXA = 8900;

function computeColumnWidths(rows) {
  const nCols = rows[0].length;
  const maxLen = new Array(nCols).fill(0);
  for (const r of rows) {
    for (let i = 0; i < nCols; i++) {
      const len = (r[i] || "").replace(/[`*]/g, "").length;
      if (len > maxLen[i]) maxLen[i] = len;
    }
  }
  const MIN_CHARS = 6;
  const weights = maxLen.map((l) => Math.max(l, MIN_CHARS));
  const total = weights.reduce((a, b) => a + b, 0);
  return weights.map((w) => Math.round((w / total) * USABLE_WIDTH_DXA));
}

function mdTable(rows, aligns) {
  const header = rows[0];
  const body = rows.slice(1);
  const widths = computeColumnWidths(rows);
  const trs = [];
  trs.push(new TableRow({
    tableHeader: true,
    children: header.map((c, i) => makeCell(c, { header: true, widthDxa: widths[i] })),
  }));
  for (const r of body) {
    trs.push(new TableRow({
      children: r.map((c, i) => makeCell(c, { align: aligns[i] === "right" ? AlignmentType.RIGHT : AlignmentType.LEFT, widthDxa: widths[i] })),
    }));
  }
  return new Table({
    width: { size: USABLE_WIDTH_DXA, type: WidthType.DXA },
    columnWidths: widths,
    rows: trs,
  });
}

// ---------- markdown parser (tailored to this document) ----------
function parseMarkdown(md) {
  md = md.replace(/<!--[\s\S]*?-->/, ""); // strip internal comment block
  const lines = md.split("\n");
  const blocks = [];
  let i = 0;
  while (i < lines.length) {
    let line = lines[i];
    if (line.trim() === "" || line.trim() === "---") { i++; continue; }

    if (line.startsWith("# ")) { blocks.push({ t: "title_vi", text: line.slice(2).trim() }); i++; continue; }
    if (line.startsWith("## ")) { blocks.push({ t: "h1", text: line.slice(3).trim() }); i++; continue; }
    if (line.startsWith("### ")) { blocks.push({ t: "h2", text: line.slice(4).trim() }); i++; continue; }

    if (line.startsWith("![")) {
      const m = line.match(/\]\(([^)]+)\)/);
      blocks.push({ t: "image", path: m[1] });
      i++; continue;
    }

    if (line.startsWith("|")) {
      const tableLines = [];
      while (i < lines.length && lines[i].startsWith("|")) { tableLines.push(lines[i]); i++; }
      const rows = tableLines
        .filter((l) => !/^\|[\s:-]+\|$/.test(l.replace(/[^|:-]/g, (c) => (c === "|" || c === ":" || c === "-" ? c : "X"))) || true)
        .map((l) => l.slice(1, -1).split("|").map((c) => c.trim()));
      // detect & remove the separator row (---|---|...)
      const sepIdx = rows.findIndex((r) => r.every((c) => /^:?-+:?$/.test(c)));
      let aligns = [];
      if (sepIdx >= 0) {
        aligns = rows[sepIdx].map((c) => (c.endsWith(":") ? "right" : "left"));
        rows.splice(sepIdx, 1);
      }
      blocks.push({ t: "table", rows, aligns });
      continue;
    }

    if (/^-\s+\*\*/.test(line) || /^- /.test(line)) {
      const items = [];
      while (i < lines.length && /^- /.test(lines[i])) { items.push(lines[i].slice(2).trim()); i++; }
      blocks.push({ t: "bullets", items });
      continue;
    }

    if (line.startsWith(">")) {
      const items = [];
      while (i < lines.length && lines[i].startsWith(">")) { items.push(lines[i].slice(1).trim()); i++; }
      blocks.push({ t: "blockquote", items });
      continue;
    }

    if (line.startsWith("[")) {
      // reference entry (possibly wraps to next physical line only if blank-line separated; treat single line)
      blocks.push({ t: "ref", text: line.trim() });
      i++; continue;
    }

    // formula-only paragraph: whole line wrapped in single backticks
    if (/^`[^`]+`$/.test(line.trim())) {
      blocks.push({ t: "formula", text: line.trim() });
      i++; continue;
    }

    // display-math paragraph: whole line wrapped in $$...$$ (real LaTeX -> OMML equation)
    if (/^\$\$.+\$\$$/.test(line.trim())) {
      const t = line.trim();
      blocks.push({ t: "displaymath", text: t.slice(2, -2) });
      i++; continue;
    }

    // author / email / DOI / plain lines before first "---"
    if (/^\*Email liên hệ:/.test(line)) { blocks.push({ t: "email", text: line.trim() }); i++; continue; }
    if (/^DOI:/.test(line)) { blocks.push({ t: "doi", text: line.trim() }); i++; continue; }
    if (/^🔶/.test(line)) { i++; continue; } // skip internal placeholder notes
    if (line.trim() === "EFFECTS OF EQUIVALENT PILE FIXITY DETERMINATION METHODS ON EFFECTIVE PILE LENGTH AND STRUCTURAL RESPONSE OF A PILED WHARF: A THREE-DIMENSIONAL SAP2000 NUMERICAL STUDY") {
      blocks.push({ t: "title_en", text: line.trim() }); i++; continue;
    }
    if (line.trim() === "NCKH*" || line.includes("ĐỖ QUANG THÀNH")) { blocks.push({ t: "author", text: line.trim() }); i++; continue; }
    if (line.includes("Trường Đại học Hàng hải Việt Nam")) { blocks.push({ t: "affiliation", text: line.trim() }); i++; continue; }

    if (line.startsWith("**Tóm tắt**")) { blocks.push({ t: "abs_h_vi" }); i++; continue; }
    if (line.startsWith("**Từ khóa**")) { blocks.push({ t: "kw_vi", text: line.trim() }); i++; continue; }
    if (line.startsWith("**Abstract**")) { blocks.push({ t: "abs_h_en" }); i++; continue; }
    if (line.startsWith("**Keywords**")) { blocks.push({ t: "kw_en", text: line.trim() }); i++; continue; }

    // table/figure caption bold lines
    if (/^\*\*(Bảng|Hình) \d+\./.test(line)) {
      blocks.push({ t: line.startsWith("**Bảng") ? "tabletitle" : "figtitle", text: line.trim() });
      i++; continue;
    }
    // source line
    if (/^\*Nguồn:/.test(line)) { blocks.push({ t: "source", text: line.trim() }); i++; continue; }

    // default: normal paragraph
    blocks.push({ t: "p", text: line.trim() });
    i++;
  }
  return blocks;
}

function stripStars(s) { return s.replace(/^\*\*|\*\*$/g, ""); }

function buildBody(blocks) {
  // JMST template: title/author/DOI block is a single-column section; everything
  // from the Abstract box onward (Tóm tắt...references) flows in a 2-column
  // section (continuous, no page break) — confirmed from the template's own
  // document.xml (<w:cols w:num="2".../> section starts right at the abstract).
  //
  // A table/figure sized to the FULL page width (USABLE_WIDTH_DXA=8900) does not
  // fit a single ~4280-twip column and gets clipped by Word if placed inline in
  // the 2-column flow. The fix used here mirrors real 2-column journal layout:
  // every wide table/figure gets its own temporary "continuous, 1-column" mini
  // section (matching a full-page-width container exactly), sandwiched between
  // ordinary 2-column sections for the surrounding running text.
  const frontOut = [];
  let out = frontOut;
  const bodySections = []; // {cols, children}[]
  let curCols = null;
  let curChildren = null;
  const setCols = (n) => {
    if (curCols === n) return;
    if (curChildren !== null && curChildren.length) bodySections.push({ cols: curCols, children: curChildren });
    curCols = n;
    curChildren = [];
    out = curChildren;
  };
  let abstractBuf = null; // collects paragraphs for the abstract box table
  const flushAbstract = () => {
    if (abstractBuf) {
      out.push(new Table({
        width: { size: 100, type: WidthType.PERCENTAGE },
        rows: [new TableRow({ children: [new TableCell({
          width: { size: 100, type: WidthType.PERCENTAGE },
          borders: { top: { style: BorderStyle.DOUBLE, size: 6 }, bottom: { style: BorderStyle.DOUBLE, size: 6 }, left: { style: BorderStyle.DOUBLE, size: 6 }, right: { style: BorderStyle.DOUBLE, size: 6 } },
          margins: { top: 100, bottom: 100, left: 150, right: 150 },
          children: abstractBuf,
        })] })],
      }));
      out.push(new Paragraph({ text: "", spacing: { before: 120, after: 0 } }));
      abstractBuf = null;
    }
  };

  for (const b of blocks) {
    switch (b.t) {
      case "title_vi":
        out.push(new Paragraph({ children: parseInline(b.text, { size: SZ.title, bold: true }), alignment: AlignmentType.CENTER, spacing: { before: 80, after: 80, line: 290, lineRule: "auto" } }));
        break;
      case "title_en":
        out.push(new Paragraph({ children: parseInline(b.text, { size: SZ.title }), alignment: AlignmentType.CENTER, spacing: { before: 60, after: 80, line: 290, lineRule: "auto" } }));
        break;
      case "author":
        out.push(new Paragraph({ children: parseInline(stripStars(b.text), { size: SZ.author, bold: true }), alignment: AlignmentType.CENTER, spacing: { before: 40, after: 40 } }));
        break;
      case "affiliation":
        out.push(new Paragraph({ children: parseInline(b.text, { size: SZ.author }), alignment: AlignmentType.CENTER, spacing: { before: 0, after: 40 } }));
        break;
      case "email":
        out.push(new Paragraph({ children: parseInline(b.text, { size: SZ.author, italics: true }), alignment: AlignmentType.CENTER, spacing: { before: 40, after: 40 } }));
        break;
      case "doi":
        out.push(new Paragraph({ children: parseInline(b.text, { size: SZ.small, italics: true }), alignment: AlignmentType.CENTER, spacing: { before: 80, after: 160 } }));
        break;

      case "abs_h_vi":
        setCols(2); // enter the body — starts 2-column
        abstractBuf = [];
        abstractBuf.push(new Paragraph({ children: [new TextRun({ text: "Tóm tắt", font: FONT, bold: true, size: SZ.body + 2 })], spacing: { before: 80, after: 40 } }));
        break;
      case "abs_h_en":
        abstractBuf.push(new Paragraph({ children: [new TextRun({ text: "Abstract", font: FONT, bold: true, size: SZ.body + 2 })], spacing: { before: 120, after: 40 } }));
        break;
      case "kw_vi":
      case "kw_en": {
        const m = b.text.match(/^\*\*(.+?)\*\*:\s*\*(.+)\*\.?\*?$/);
        const label = m ? m[1] : (b.t === "kw_vi" ? "Từ khóa" : "Keywords");
        const rest = m ? m[2] : b.text;
        abstractBuf.push(new Paragraph({
          children: [new TextRun({ text: label + ": ", font: FONT, bold: true, italics: true, size: SZ.body }), ...parseInline(rest, { size: SZ.body, italics: true })],
          spacing: { before: 80, after: 40, line: 240, lineRule: "auto" },
        }));
        break;
      }
      case "p":
        if (abstractBuf) {
          abstractBuf.push(new Paragraph({ children: parseInline(b.text, { size: SZ.body, italics: true }), alignment: AlignmentType.JUSTIFIED, spacing: { before: 40, after: 40 } }));
        } else {
          flushAbstract();
          setCols(2);
          out.push(content(b.text));
        }
        break;

      case "h1": flushAbstract(); setCols(2); out.push(heading1(b.text)); break;
      case "h2": flushAbstract(); setCols(2); out.push(heading2(b.text)); break;

      case "tabletitle": flushAbstract(); setCols(1); out.push(tableTitle(stripStars(b.text))); break;
      case "figtitle": flushAbstract(); setCols(1); out.push(figTitle(stripStars(b.text))); break;
      case "source": flushAbstract(); setCols(1); out.push(sourceLine(b.text.replace(/^\*|\*$/g, ""))); break;

      case "table": flushAbstract(); setCols(1); out.push(mdTable(b.rows, b.aligns)); break;

      case "image": {
        flushAbstract();
        setCols(1);
        const isFig4 = b.path.includes("Fig4");
        const isFig2 = b.path.includes("Fig2");
        const isFig3 = b.path.includes("Fig3");
        const maxW = isFig2 ? 250 : isFig4 ? 495 : 430;
        const maxH = isFig2 ? 300 : isFig4 ? 362 : 285;
        out.push(imageParagraph(b.path, maxW, maxH));
        break;
      }

      case "formula": flushAbstract(); setCols(2); out.push(formula(b.text)); break;

      case "displaymath":
        flushAbstract();
        setCols(2);
        out.push(new Paragraph({
          children: [mathInline(b.text)],
          alignment: AlignmentType.CENTER,
          spacing: { before: 120, after: 120 },
        }));
        break;

      case "bullets":
        flushAbstract();
        setCols(2);
        for (const it of b.items) out.push(bulletItem(it));
        break;

      case "blockquote":
        // "Ngày nhận bài / Ngày nhận bản sửa / Ngày duyệt đăng" — per JMST §27.3 these 3
        // lines are filled in BY THE EDITORIAL OFFICE, not the author; omitted from the
        // submitted manuscript body (kept in the .md source for reference).
        flushAbstract();
        break;

      case "ref": {
        flushAbstract();
        setCols(2);
        // strip trailing internal placeholder notes (🔶 [...]) — tracked in the .md comment block instead
        const cleanText = b.text.replace(/\s*🔶\s*\*?\[[^\]]*\]\*?/g, "");
        out.push(refItem(cleanText));
        break;
      }

      default: break;
    }

    if (b.text === "Tài liệu tham khảo") {
      // handled by h1 case already; nothing extra
    }
  }
  flushAbstract();
  if (curChildren !== null && curChildren.length) bodySections.push({ cols: curCols, children: curChildren });
  return { front: frontOut, bodySections };
}

// special-case: turn "## Tài liệu tham khảo" (h1) into the underlined red reference-title style
function postProcessRefHeading(children) {
  return children; // heading1() already applies the JMST_Title level 01-like style; underline omitted for simplicity
}

// ---------- main ----------
const md = fs.readFileSync(MD_PATH, "utf-8").replace(/\r\n/g, "\n");
const blocks = parseMarkdown(md);
const { front, bodySections } = buildBody(blocks);

// Matches the JMST template's own two sections (verified against its document.xml):
//   section 1 — title/author/DOI block, single column, bottom margin 1418
//   section 2+ — Tóm tắt/Abstract onward (references included), continuous (no
//               page break from the previous section), 2 columns w/ 340-twip
//               gutter, bottom margin 1701 — except every wide table/figure,
//               which gets its own temporary continuous 1-column mini-section
//               (see buildBody) so it isn't clipped by the ~4280-twip column width.
const BODY_PAGE = { size: { width: 11906, height: 16838 } };
const doc = new Document({
  styles: {
    default: {
      document: { run: { font: FONT, size: SZ.body }, paragraph: { alignment: AlignmentType.JUSTIFIED } },
    },
  },
  sections: [
    {
      properties: {
        page: { ...BODY_PAGE, margin: { top: 1701, right: 1418, bottom: 1418, left: 1588 } },
        column: { count: 1 },
      },
      children: front,
    },
    ...bodySections.map((s) => ({
      properties: {
        type: SectionType.CONTINUOUS,
        page: { ...BODY_PAGE, margin: { top: 1701, right: 1418, bottom: 1701, left: 1588 } },
        column: s.cols === 2 ? { count: 2, space: 340 } : { count: 1 },
      },
      children: s.children,
    })),
  ],
});

Packer.toBuffer(doc).then((buf) => {
  const out = process.env.OUT_PATH_OVERRIDE
    ? path.resolve(process.env.OUT_PATH_OVERRIDE)
    : path.join(ROOT, "scratch_docx", "Paper1_JMST_build.docx");
  fs.writeFileSync(out, buf);
  console.log("Wrote", out);
});
