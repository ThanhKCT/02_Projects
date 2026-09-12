// Build ICSCE 2026.docx from ICSCE 2026.md, following the styles extracted
// from the official ICSCE 2026.docx template (papertitle/author/address/
// abstract/keywords/heading1/heading2/tablecaption/figurecaption/image/
// equation/referenceitem).
const fs = require("fs");
const path = require("path");
const {
  Document, Packer, Paragraph, TextRun, HeadingLevel, AlignmentType,
  Table, TableRow, TableCell, WidthType, BorderStyle, ShadingType,
  LineRuleType, TabStopType, ImageRun, PageOrientation,
} = require("docx");

const FONT = "Times New Roman";
const MONO = "Consolas";
const ROOT = path.resolve(__dirname, "..");
const FIGS = path.join(__dirname, "figs_icsce2026");

// CLI: node build_icsce2026.js <input.md> <output.docx> <lang: en|vi>
const argMd = process.argv[2];
const argOut = process.argv[3];
const argLang = process.argv[4] || "en";
const MD_PATH = argMd ? path.resolve(argMd) : path.join(ROOT, "ICSCE 2026.md");
const OUT_PATH = argOut ? path.resolve(argOut) : path.join(ROOT, "ICSCE 2026.docx");
const LANG = argLang;

// Figure files: English axis labels for the EN paper, original Vietnamese
// MATLAB-generated axis labels for the VN paper.
const FIG_FILES = LANG === "vi"
  ? {
      2: path.join(ROOT, "Wharf100DWT", "results", "analysis", "reference_pareto_front.png"),
      3: path.join(ROOT, "Wharf100DWT", "results", "analysis", "convergence_IGD_HV_vs_FE.png"),
    }
  : {
      2: path.join(FIGS, "Fig2_reference_pareto_front_EN.png"),
      3: path.join(FIGS, "Fig3_convergence_IGD_HV_EN.png"),
    };

// ---- page geometry copied from the ICSCE 2026.docx template ----
const PAGE_W = 11906, PAGE_H = 16838;
const MARGIN = { top: 2948, bottom: 2948, left: 2495, right: 2495, header: 2381, footer: 2325 };
const USABLE_W = PAGE_W - MARGIN.left - MARGIN.right; // 6916

// ---- sizes (half-points) ----
const SZ = { title: 28, author: 20, affil: 18, body: 20, heading1: 24, heading2: 20, caption: 18, ref: 18 };

// ---------------------------------------------------------------------
// Inline **bold** / *italic* parser (handles escaped \* as a literal *)
// ---------------------------------------------------------------------
function parseInline(raw) {
  const ESC = "";
  let s = raw.replace(/\\\*/g, ESC);
  const segs = []; // {text, bold, italic, mono}
  const boldParts = s.split(/(\*\*[^*]+?\*\*)/g);
  for (const part of boldParts) {
    if (!part) continue;
    const mBold = part.match(/^\*\*([^*]+?)\*\*$/);
    if (mBold) {
      segs.push({ text: mBold[1], bold: true, italic: false, mono: false });
      continue;
    }
    const italParts = part.split(/(\*[^*]+?\*)/g);
    for (const ip of italParts) {
      if (!ip) continue;
      const mIt = ip.match(/^\*([^*]+?)\*$/);
      if (mIt) { segs.push({ text: mIt[1], bold: false, italic: true, mono: false }); continue; }
      // inline LaTeX math: $...$ (standalone $$...$$ display equations are
      // intercepted earlier and never reach this parser)
      const mathParts = ip.split(/(\$[^$]+?\$)/g);
      for (const mp of mathParts) {
        if (!mp) continue;
        const mMath = mp.match(/^\$([^$]+?)\$$/);
        if (mMath) segs.push({ text: mMath[1], bold: false, italic: false, mono: true });
        else segs.push({ text: mp, bold: false, italic: false, mono: false });
      }
    }
  }
  return segs.map(seg => ({ ...seg, text: seg.text.replace(new RegExp(ESC, "g"), "*") }));
}

function runs(raw, opts = {}) {
  const { size = SZ.body, italicAll = false, boldAll = false } = opts;
  return parseInline(raw).map(seg => new TextRun({
    text: seg.text,
    bold: seg.bold || boldAll,
    italics: seg.italic || italicAll,
    font: seg.mono ? MONO : FONT,
    size: seg.mono ? size - 2 : size,
  }));
}

// ---------------------------------------------------------------------
// Paragraph style helpers (values taken from styles.xml of the template)
// ---------------------------------------------------------------------
function pTitle(text) {
  return new Paragraph({
    alignment: AlignmentType.CENTER,
    spacing: { after: 480, line: 360, lineRule: LineRuleType.AT_LEAST },
    children: [new TextRun({ text, bold: true, font: FONT, size: SZ.title })],
  });
}

function pAuthors(text) {
  return new Paragraph({
    alignment: AlignmentType.CENTER,
    spacing: { after: 120 },
    children: runs(text, { size: SZ.author, boldAll: true }),
  });
}

function pAffil(lines) {
  // lines: array of strings, joined with line breaks, italic 9pt centered
  const children = [];
  lines.forEach((l, i) => {
    if (i > 0) children.push(new TextRun({ text: "", break: 1 }));
    children.push(...runs(l, { size: SZ.affil, italicAll: true }));
  });
  return new Paragraph({
    alignment: AlignmentType.CENTER,
    spacing: { after: 200, line: 220, lineRule: LineRuleType.AT_LEAST },
    children,
  });
}

function pAbstract(label, text) {
  return new Paragraph({
    indent: { left: 567, right: 567 },
    alignment: AlignmentType.JUSTIFIED,
    spacing: { before: 600, after: 360, line: 220, lineRule: LineRuleType.AT_LEAST },
    children: [
      new TextRun({ text: label + " ", bold: true, font: FONT, size: SZ.affil }),
      ...runs(text, { size: SZ.affil }),
    ],
  });
}

function pKeywords(label, text) {
  const segs = runs(text, { size: SZ.affil });
  return new Paragraph({
    indent: { left: 567, right: 567 },
    alignment: AlignmentType.LEFT,
    spacing: { before: 220 },
    children: [new TextRun({ text: label + " ", bold: true, font: FONT, size: SZ.affil }), ...segs],
  });
}

function pHeading1(text) {
  return new Paragraph({
    spacing: { before: 360, after: 240, line: 300, lineRule: LineRuleType.AT_LEAST },
    alignment: AlignmentType.LEFT,
    children: [new TextRun({ text, bold: true, font: FONT, size: SZ.heading1 })],
  });
}

function pHeading2(text) {
  return new Paragraph({
    spacing: { before: 360, after: 160 },
    alignment: AlignmentType.LEFT,
    children: [new TextRun({ text, bold: true, font: FONT, size: SZ.heading2 })],
  });
}

function pBody(text, { firstPara = false } = {}) {
  return new Paragraph({
    alignment: AlignmentType.JUSTIFIED,
    indent: { firstLine: firstPara ? 0 : 227 },
    children: runs(text, { size: SZ.body }),
  });
}

// Standalone LaTeX display equation, e.g. "$$...$$  (1)" or "$$...$$" alone.
// Rendered as literal LaTeX source (monospace) for the author to convert
// manually in Word's own equation editor; the trailing (n) label, if any,
// is right-aligned via a tab stop, matching the template's equation style.
function pLatexEquation(text) {
  const m = text.match(/^\$\$(.*)\$\$\s*(\([0-9]+[a-z]?\))?\s*$/s);
  const latex = m ? m[1].trim() : text;
  const label = m && m[2] ? m[2] : "";
  const half = Math.round(USABLE_W / 2);
  const tabs = [
    { type: TabStopType.CENTER, position: half },
    { type: TabStopType.RIGHT, position: USABLE_W },
  ];
  const runChildren = [
    new TextRun({ text: "\t", font: FONT, size: SZ.body }),
    new TextRun({ text: latex, font: MONO, size: SZ.body - 2 }),
  ];
  if (label) runChildren.push(new TextRun({ text: "\t" + label, font: FONT, size: SZ.body }));
  return new Paragraph({
    tabStops: tabs,
    spacing: { before: 160, after: 160 },
    children: runChildren,
  });
}

function pTableCaption(text) {
  return new Paragraph({
    alignment: AlignmentType.CENTER,
    spacing: { before: 240, after: 120, line: 220, lineRule: LineRuleType.AT_LEAST },
    children: runs(text, { size: SZ.caption }),
  });
}

function pFigCaption(text) {
  return new Paragraph({
    alignment: AlignmentType.CENTER,
    spacing: { before: 120, after: 240, line: 220, lineRule: LineRuleType.AT_LEAST },
    children: runs(text, { size: SZ.caption }),
  });
}

function pImagePlaceholder(note) {
  return new Paragraph({
    alignment: AlignmentType.CENTER,
    spacing: { before: 240, after: 120 },
    border: {
      top: { style: BorderStyle.DASHED, size: 6, color: "999999" },
      bottom: { style: BorderStyle.DASHED, size: 6, color: "999999" },
      left: { style: BorderStyle.DASHED, size: 6, color: "999999" },
      right: { style: BorderStyle.DASHED, size: 6, color: "999999" },
    },
    children: [new TextRun({ text: note, italics: true, font: FONT, size: SZ.body, color: "666666" })],
  });
}

function pImage(filePath, widthIn) {
  const buf = fs.readFileSync(filePath);
  return new Paragraph({
    alignment: AlignmentType.CENTER,
    spacing: { before: 240, after: 120 },
    children: [new ImageRun({ data: buf, transformation: widthIn, type: "png" })],
  });
}

function pAckPlaceholder(text) {
  return new Paragraph({
    alignment: AlignmentType.JUSTIFIED,
    indent: { firstLine: 0 },
    children: [new TextRun({ text, italics: true, font: FONT, size: SZ.body, color: "666666" })],
  });
}

function pReference(num, text) {
  return new Paragraph({
    indent: { left: 567, hanging: 567 },
    spacing: { line: 220, lineRule: LineRuleType.AT_LEAST },
    alignment: AlignmentType.JUSTIFIED,
    children: [new TextRun({ text: `[${num}] `, font: FONT, size: SZ.ref }), ...runs(text, { size: SZ.ref })],
  });
}

function pFooterLine(text) {
  return new Paragraph({
    alignment: AlignmentType.LEFT,
    spacing: { before: 60 },
    children: [new TextRun({ text, font: FONT, size: SZ.affil, italics: true })],
  });
}

// ---------------------------------------------------------------------
// Markdown table -> docx Table
// ---------------------------------------------------------------------
function parseAlign(cell) {
  const c = cell.trim();
  if (c.startsWith(":") && c.endsWith(":")) return AlignmentType.CENTER;
  if (c.endsWith(":")) return AlignmentType.RIGHT;
  return AlignmentType.LEFT;
}

function buildTable(lines) {
  const rows = lines.map(l => l.trim().replace(/^\|/, "").replace(/\|$/, "").split("|").map(c => c.trim()));
  const header = rows[0];
  const aligns = rows[1].map(parseAlign);
  const body = rows.slice(2);
  const nCols = header.length;
  const colWidth = Math.floor(USABLE_W / nCols);

  function cell(text, isHeader, align) {
    return new TableCell({
      width: { size: colWidth, type: WidthType.DXA },
      shading: isHeader ? { type: ShadingType.CLEAR, fill: "D9D9D9" } : undefined,
      margins: { top: 40, bottom: 40, left: 80, right: 80 },
      children: [new Paragraph({
        alignment: align,
        children: runs(text, { size: SZ.caption, boldAll: isHeader }),
      })],
    });
  }

  const trHeader = new TableRow({
    tableHeader: true,
    children: header.map((h, i) => cell(h, true, aligns[i])),
  });
  const trBody = body.map(r => new TableRow({
    children: r.map((c, i) => cell(c, false, aligns[i] || AlignmentType.LEFT)),
  }));

  return new Table({
    width: { size: USABLE_W, type: WidthType.DXA },
    columnWidths: new Array(nCols).fill(colWidth),
    borders: {
      top: { style: BorderStyle.SINGLE, size: 4, color: "000000" },
      bottom: { style: BorderStyle.SINGLE, size: 4, color: "000000" },
      left: { style: BorderStyle.SINGLE, size: 4, color: "000000" },
      right: { style: BorderStyle.SINGLE, size: 4, color: "000000" },
      insideHorizontal: { style: BorderStyle.SINGLE, size: 2, color: "999999" },
      insideVertical: { style: BorderStyle.SINGLE, size: 2, color: "999999" },
    },
    rows: [trHeader, ...trBody],
  });
}

// ---------------------------------------------------------------------
// Parse ICSCE 2026.md into blocks (blank-line separated)
// ---------------------------------------------------------------------
const raw = fs.readFileSync(MD_PATH, "utf8");
const rawLines = raw.split(/\r?\n/);

// group into blocks: consecutive non-blank lines form one block (array of lines)
const blocks = [];
let cur = [];
for (const line of rawLines) {
  if (line.trim() === "") {
    if (cur.length) { blocks.push(cur); cur = []; }
  } else {
    cur.push(line);
  }
}
if (cur.length) blocks.push(cur);

// Section-heading vocabulary that differs between the English and
// Vietnamese versions of the paper.
const ABSTRACT_RE = LANG === "vi" ? /^\*\*Tóm tắt\.\*\*/ : /^\*\*Abstract\.\*\*/;
const KEYWORDS_RE = LANG === "vi" ? /^\*\*Từ khóa:\*\*/ : /^\*\*Keywords:\*\*/;
const KEYWORDS_LABEL = LANG === "vi" ? "Từ khóa:" : "Keywords:";
const UNNUMBERED_HEADINGS = LANG === "vi"
  ? ["Lời cảm ơn", "Xung đột lợi ích", "Tài liệu tham khảo"]
  : ["Acknowledgments", "Disclosure of Interests", "References"];
const REFERENCES_HEADING = LANG === "vi" ? "Tài liệu tham khảo" : "References";
const FOOTER_RE = LANG === "vi"
  ? /^Ngày nhận bài:|^Ngày nhận bản sửa:|^Ngày duyệt đăng:/
  : /^Received:|^Revised:|^Accepted:/;
const TABLE_CAPTION_RE = LANG === "vi" ? /^\*\*Bảng \d+\.\*\*/ : /^\*\*Table \d+\.\*\*/;
const FIG_CAPTION_RE = LANG === "vi" ? /^\*\*Hình (\d+)\.\*\*/ : /^\*\*Fig\. (\d+)\.\*\*/;
const FIG1_PLACEHOLDER = LANG === "vi"
  ? "[Chèn Hình 1 – ảnh mô hình SAP2000 tại đây]"
  : "[Insert Fig. 1 – SAP2000 model image here]";

const children = [];
let idx = 0;

// Block 0: title
children.push(pTitle(blocks[idx][0].trim())); idx++;
// Block 1: authors line
children.push(pAuthors(blocks[idx][0].trim())); idx++;
// Block 2: affiliation lines (each its own single-line block until the
// "Corresponding author" line, which is also part of the affiliation group)
{
  const affilLines = [];
  while (idx < blocks.length) {
    const blk = blocks[idx];
    if (ABSTRACT_RE.test(blk[0].trim())) break;
    for (const l of blk) affilLines.push(l.trim());
    idx++;
    if (blk.some(l => /^\\\*(Corresponding|Tác giả liên hệ)/.test(l.trim()))) break;
  }
  children.push(pAffil(affilLines));
}

let inReferences = false;

function headingDepth(t) {
  const m = t.match(/^(\d+(?:\.\d+)*)\.\s+/);
  if (!m) return 0;
  return m[1].split(".").length;
}

for (; idx < blocks.length; idx++) {
  const block = blocks[idx];
  const first = block[0].trim();

  if (first === "---") continue; // separator, skip

  if (ABSTRACT_RE.test(first)) {
    const m = first.match(new RegExp(ABSTRACT_RE.source + "\\s*(.*)$"));
    children.push(pAbstract(LANG === "vi" ? "Tóm tắt." : "Abstract.", m[1]));
    continue;
  }
  if (KEYWORDS_RE.test(first)) {
    const m = first.match(new RegExp(KEYWORDS_RE.source + "\\s*(.*)$"));
    children.push(pKeywords(KEYWORDS_LABEL, m[1]));
    continue;
  }

  if (UNNUMBERED_HEADINGS.includes(first)) {
    children.push(pHeading1(first));
    if (first === REFERENCES_HEADING) inReferences = true;
    continue;
  }

  if (!inReferences && /^\d+\.\s+\S/.test(first) && headingDepth(first) === 1) {
    children.push(pHeading1(first)); continue;
  }
  if (!inReferences && headingDepth(first) >= 2) {
    children.push(pHeading2(first)); continue;
  }

  if (inReferences && /^\d+\.\s/.test(first)) {
    const m = first.match(/^(\d+)\.\s+(.*)$/);
    children.push(pReference(m[1], m[2]));
    continue;
  }

  if (FOOTER_RE.test(first)) {
    for (const l of block) children.push(pFooterLine(l.trim()));
    continue;
  }

  if (TABLE_CAPTION_RE.test(first)) {
    children.push(pTableCaption(first));
    // next block should be the markdown table
    const tblBlock = blocks[idx + 1];
    if (tblBlock && tblBlock[0].trim().startsWith("|")) {
      children.push(buildTable(tblBlock));
      idx++;
    }
    continue;
  }

  if (FIG_CAPTION_RE.test(first)) {
    const m = first.match(FIG_CAPTION_RE);
    const n = m[1];
    if (n === "1") {
      children.push(pImagePlaceholder(FIG1_PLACEHOLDER));
    } else if (FIG_FILES[n]) {
      const isSquare = n === "3";
      children.push(pImage(FIG_FILES[n], isSquare ? { width: 400, height: 400 } : { width: 440, height: Math.round(440 / (1700 / 1300)) }));
    }
    children.push(pFigCaption(first));
    continue;
  }

  // Standalone LaTeX display equation: the whole block is one line that
  // starts with "$$" (optionally followed by "  (n)" on the same line).
  if (/^\$\$/.test(first)) {
    children.push(pLatexEquation(first));
    continue;
  }

  // default: body paragraph. join multi-line block with spaces (shouldn't
  // normally happen since paragraphs are authored as single long lines)
  const text = block.join(" ").trim();
  children.push(pBody(text));
}

const doc = new Document({
  sections: [{
    properties: {
      page: {
        size: { width: PAGE_W, height: PAGE_H },
        margin: MARGIN,
      },
    },
    children,
  }],
});

Packer.toBuffer(doc).then(buf => {
  fs.writeFileSync(OUT_PATH, buf);
  console.log("Wrote:", OUT_PATH, buf.length, "bytes");
});
