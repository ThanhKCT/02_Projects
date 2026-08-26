// Build Paper1_JMST.docx from Paper1_JMST_Draft_v1.md, matching JMST template styles.
const fs = require("fs");
const path = require("path");
const sizeOf = require("image-size").default || require("image-size");
const {
  Document, Packer, Paragraph, TextRun, HeadingLevel, AlignmentType,
  Table, TableRow, TableCell, WidthType, BorderStyle, ImageRun,
  ShadingType, VerticalAlign, TabStopType, TabStopPosition, PageBreak,
} = require("docx");

const ROOT = path.resolve(__dirname, "..");
const MD_PATH = path.join(ROOT, "Paper1_JMST_Draft_v1.md");
const FONT = "Times New Roman";
const COLOR_HEAD = "990033";
const SHADE_HEADER = "DEEAF6";

// ---------- sizes (half-points) ----------
const SZ = { title: 26, author: 24, h1: 22, h2: 22, body: 20, small: 18 };

// ---------- inline markdown -> TextRun[] ----------
function parseInline(text, baseOpts = {}) {
  const runs = [];
  // tokenize: **bold**, *italic*, `code`
  const re = /(\*\*(.+?)\*\*|\*(.+?)\*|`([^`]+)`)/g;
  let last = 0;
  let m;
  while ((m = re.exec(text)) !== null) {
    if (m.index > last) pushPlain(text.slice(last, m.index), baseOpts, runs);
    if (m[2] !== undefined) pushPlain(m[2], { ...baseOpts, bold: true }, runs);
    else if (m[3] !== undefined) pushPlain(m[3], { ...baseOpts, italics: true }, runs);
    else if (m[4] !== undefined) pushCode(m[4], baseOpts, runs);
    last = re.lastIndex;
  }
  if (last < text.length) pushPlain(text.slice(last), baseOpts, runs);
  return runs;
}

function pushPlain(str, opts, runs) {
  if (!str) return;
  runs.push(new TextRun({ text: str, font: FONT, ...opts }));
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
    spacing: { before: 20, after: 20, line: 238, lineRule: "exact" },
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
    spacing: { before: 100, after: 40, line: 250, lineRule: "exact" },
    keepNext: true,
  });
}

function heading2(text) {
  return new Paragraph({
    children: parseInline(text, { size: SZ.h2, bold: true, italics: true, color: COLOR_HEAD }),
    spacing: { before: 70, after: 30, line: 250, lineRule: "exact" },
    keepNext: true,
  });
}

function tableTitle(text) {
  return new Paragraph({
    children: parseInline(text, { size: SZ.small, bold: true, italics: true }),
    alignment: AlignmentType.CENTER,
    spacing: { before: 80, after: 40, line: 260, lineRule: "exact" },
    keepNext: true,
  });
}

function figTitle(text) {
  return new Paragraph({
    children: parseInline(text, { size: SZ.small, bold: true, italics: true }),
    alignment: AlignmentType.CENTER,
    spacing: { before: 20, after: 80, line: 260, lineRule: "exact" },
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
    spacing: { before: 20, after: 20, line: 248, lineRule: "exact" },
  });
}

function refItem(text) {
  return new Paragraph({
    children: parseInline(text, { size: SZ.body }),
    alignment: AlignmentType.JUSTIFIED,
    indent: { left: 284, hanging: 284 },
    spacing: { before: 30, after: 30, line: 248, lineRule: "exact" },
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
        spacing: { before: 15, after: 15, line: 228, lineRule: "exact" },
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

    // author / email / DOI / plain lines before first "---"
    if (/^\*Email liên hệ:/.test(line)) { blocks.push({ t: "email", text: line.trim() }); i++; continue; }
    if (/^DOI:/.test(line)) { blocks.push({ t: "doi", text: line.trim() }); i++; continue; }
    if (/^🔶/.test(line)) { i++; continue; } // skip internal placeholder notes
    if (line.trim() === "EFFECTS OF EQUIVALENT PILE FIXITY DETERMINATION METHODS ON EFFECTIVE PILE LENGTH AND STRUCTURAL RESPONSE OF A PILED WHARF: A THREE-DIMENSIONAL SAP2000 NUMERICAL STUDY") {
      blocks.push({ t: "title_en", text: line.trim() }); i++; continue;
    }
    if (line.trim() === "NCKH*") { blocks.push({ t: "author", text: line.trim() }); i++; continue; }

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
  const out = [];
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
        out.push(new Paragraph({ children: parseInline(stripStars(b.text.replace("*", "")), { size: SZ.author, bold: true }), alignment: AlignmentType.CENTER, spacing: { before: 40, after: 40 } }));
        break;
      case "email":
        out.push(new Paragraph({ children: parseInline(b.text, { size: SZ.author, italics: true }), alignment: AlignmentType.CENTER, spacing: { before: 40, after: 40 } }));
        break;
      case "doi":
        out.push(new Paragraph({ children: parseInline(b.text, { size: SZ.small, italics: true }), alignment: AlignmentType.CENTER, spacing: { before: 80, after: 160 } }));
        break;

      case "abs_h_vi":
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
          out.push(content(b.text));
        }
        break;

      case "h1": flushAbstract(); out.push(heading1(b.text)); break;
      case "h2": flushAbstract(); out.push(heading2(b.text)); break;

      case "tabletitle": flushAbstract(); out.push(tableTitle(stripStars(b.text))); break;
      case "figtitle": flushAbstract(); out.push(figTitle(stripStars(b.text))); break;
      case "source": flushAbstract(); out.push(sourceLine(b.text.replace(/^\*|\*$/g, ""))); break;

      case "table": flushAbstract(); out.push(mdTable(b.rows, b.aligns)); break;

      case "image": {
        flushAbstract();
        const isFig4 = b.path.includes("Fig4");
        const isFig2 = b.path.includes("Fig2");
        const isFig3 = b.path.includes("Fig3");
        const maxW = isFig2 ? 250 : isFig4 ? 495 : 430;
        const maxH = isFig2 ? 300 : isFig4 ? 410 : 285;
        out.push(imageParagraph(b.path, maxW, maxH));
        break;
      }

      case "formula": flushAbstract(); out.push(formula(b.text)); break;

      case "bullets":
        flushAbstract();
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
  return out;
}

// special-case: turn "## Tài liệu tham khảo" (h1) into the underlined red reference-title style
function postProcessRefHeading(children) {
  return children; // heading1() already applies the JMST_Title level 01-like style; underline omitted for simplicity
}

// ---------- main ----------
const md = fs.readFileSync(MD_PATH, "utf-8");
const blocks = parseMarkdown(md);
const bodyChildren = buildBody(blocks);

const doc = new Document({
  styles: {
    default: {
      document: { run: { font: FONT, size: SZ.body }, paragraph: { alignment: AlignmentType.JUSTIFIED } },
    },
  },
  sections: [{
    properties: {
      page: {
        size: { width: 11906, height: 16838 },
        margin: { top: 1701, right: 1418, bottom: 1418, left: 1588 },
      },
    },
    children: bodyChildren,
  }],
});

Packer.toBuffer(doc).then((buf) => {
  const out = path.join(ROOT, "scratch_docx", "Paper1_JMST_build.docx");
  fs.writeFileSync(out, buf);
  console.log("Wrote", out);
});
