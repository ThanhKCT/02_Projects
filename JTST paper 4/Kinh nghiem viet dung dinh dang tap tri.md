# ResearchLab — Journal Manuscript Workflow Master

## Purpose

Master workflow for using Claude (or another AI assistant) to prepare scientific manuscripts for journals, conferences, and proceedings.

Core principle:

> **Outline → Scientific Manuscript → Content Freeze → Format Specification → Template Formatting → PDF QA → Final Approval**

Do not ask the AI to simultaneously invent the scientific content and independently guess the publication format.

---

## 1. Source Priority

For every project, provide, when available:

1. Research outline / proposal
2. Scientific data and results
3. Current manuscript draft
4. Official author guidelines
5. Official Word/LaTeX template
6. 1–2 published papers from the same venue

Use this priority order when sources conflict:

**Official guidelines > Official template > official submission instructions > published papers > manuscript > general conventions**

Published papers are **visual references**, not replacements for official requirements.

If a requirement is not explicitly supported by the supplied sources:

> **Do not guess. Mark `NEEDS REVIEW`.**

---

## 2. Stage 1 — Scientific Manuscript

First prepare the scientific manuscript from the approved outline and supplied research material.

Priorities:

- scientific logic;
- consistency between objective, method, results, and conclusions;
- reproducibility;
- correct terminology;
- appropriate references;
- faithful representation of the actual research.

Never:

- invent data;
- invent numerical results;
- invent experiments;
- invent references;
- invent citations;
- claim validation that was not performed;
- add methods that were not actually used.

Missing information must be marked `NEEDS INPUT`, not silently invented.

---

## 3. Stage 2 — Content Freeze

Before formatting, lock the scientific content.

Unless the author explicitly requests a change, do not alter:

- title;
- objectives;
- scope;
- research questions;
- design variables;
- objective functions;
- constraints;
- analysis model;
- algorithms;
- computational settings;
- number of runs;
- evaluation budget;
- numerical results;
- statistical results;
- tables;
- figures;
- equations;
- main conclusions;
- reference list.

During formatting:

- do not change numerical values;
- do not change equation meaning;
- do not rename variables;
- do not change algorithm names;
- do not add or remove results;
- do not silently round or recalculate values.

---

## 4. Stage 3 — Format Specification

Before editing the manuscript, inspect the official guideline and template.

Create `FORMAT_SPEC.md` containing:

| Item | Requirement | Source | Status |
|---|---|---|---|
| Page size | | | |
| Margins | | | |
| Header | | | |
| Footer | | | |
| Page number | | | |
| Title | | | |
| Authors | | | |
| Affiliation | | | |
| Abstract | | | |
| Keywords | | | |
| Body font | | | |
| Body size | | | |
| Heading 1 | | | |
| Heading 2 | | | |
| Equation | | | |
| Figure | | | |
| Figure caption | | | |
| Table | | | |
| Table caption | | | |
| References | | | |
| Page limit | | | |

For each item distinguish:

- explicitly specified;
- derived from official template;
- observed only in published papers;
- not specified.

Never turn an observation into an official requirement without evidence.

---

## 5. Stage 4 — Official Template as Master

If an official template exists:

> **Use the official template as the MASTER DOCUMENT.**

Do not create a blank Word document and imitate the appearance.

Preserve, where applicable:

- sections;
- margins;
- header;
- footer;
- page numbering;
- Word styles;
- paragraph styles;
- table structures;
- caption styles;
- equation styles.

Published papers are only visual references for how the template is used in practice.

---

## 6. Title / Authors / Affiliation

Use the exact approved title unless the author explicitly requests revision.

Do not:

- shorten the title;
- add a subtitle;
- alter terminology;
- arbitrarily change capitalization.

Place title, authors, affiliations, and corresponding-author information exactly according to the venue.

If author information is missing:

`NEEDS REVIEW`

Do not guess.

---

## 7. Abstract

Follow the exact word-count requirement in the official guideline.

After drafting, calculate and report the actual word count.

Example:

```text
Required: 200–300 words
Actual: 239 words
Status: PASS
```

Do not add new results.

Do not remove essential scientific results merely to meet a word limit.

If the abstract cannot satisfy the limit without damaging scientific meaning:

`NEEDS REVIEW`

---

## 8. Keywords

Follow the exact number and format required by the venue.

Keep terminology consistent with the manuscript.

---

## 9. Body Text and Headings

Use native Word styles from the official template whenever available.

Check:

- font;
- font size;
- alignment;
- line spacing;
- paragraph spacing;
- indentation;
- section numbering.

Do not introduce colors unless required.

Do not manually simulate headings when an appropriate Word style exists.

---

## 10. Equations — Critical Rule

All mathematical expressions must be inserted as:

> **Native Microsoft Word Equation / OMML objects**

Do **not** leave LaTeX source as ordinary paragraph text.

For example, do not leave:

```text
\mathbf{x} = [x_1,x_2,x_3]
```

as plain text.

Convert it into a real Word Equation.

Check:

- equation font;
- mathematical symbols;
- subscripts;
- superscripts;
- fractions;
- Greek letters;
- matrices/vectors;
- alignment;
- equation numbering.

Do not change mathematical meaning.

At final QA report:

```text
Equation check:
- Number of equations converted: XX
- Native Word Equation objects: PASS
- Remaining LaTeX source: NONE
```

---

## 11. Figures

Preserve scientific figure content.

Do not:

- modify data;
- alter plotted values;
- change axis meaning;
- fabricate missing figures.

Only adjust:

- size;
- resolution where appropriate;
- alignment;
- placement;
- caption;
- wrapping.

If a figure is missing, leave an explicit author insertion point unless instructed otherwise:

```text
[FIGURE X — TO BE INSERTED BY AUTHOR]
```

Do not delete a missing-figure placeholder without instruction.

Keep numbering consistent.

---

## 12. Tables

Preserve:

- values;
- rows;
- columns;
- units;
- statistical values;
- labels.

Only modify formatting unless explicitly instructed.

Check:

- caption location;
- table width;
- font;
- alignment;
- borders;
- row height;
- page breaks;
- repeated header rows where appropriate.

Never silently change numerical data.

---

## 13. References

Follow the official reference style.

Check:

- numbering;
- authors;
- title;
- journal/conference;
- volume/issue;
- pages/article number;
- year;
- DOI;
- punctuation;
- indentation;
- hyperlink appearance.

Do not invent missing bibliographic information.

Do not add references merely because they seem useful.

If a reference is incomplete:

`NEEDS REVIEW`

---

## 14. Page Limit

Do not infer a page limit.

If the official guideline explicitly states one:

1. report the limit;
2. count current pages;
3. report the difference.

If the paper exceeds the limit, do **not** automatically delete substantive content.

First propose:

1. reduce excessive whitespace;
2. optimize figure size;
3. optimize table size;
4. reduce unnecessary spacing;
5. remove redundant prose;
6. merge genuinely repetitive paragraphs.

Obtain author approval before deleting substantive scientific content.

---

## 15. Placeholder Check

Before finalization, search for:

```text
TO BE VERIFIED
[TO BE VERIFIED]
TODO
TBD
NEEDS REVIEW
INSERT
PLACEHOLDER
xx/xx/20xx
[...]
```

No unresolved placeholder may remain in the final manuscript unless it is an intentional author insertion point.

Report all unresolved items.

---

## 16. Final PDF Rendering

After formatting:

1. save DOCX;
2. render/export to PDF;
3. inspect every page visually.

Check:

- header;
- footer;
- page number;
- blank pages;
- text overflow;
- table overflow;
- figure overflow;
- broken equations;
- equation-number alignment;
- caption separation;
- stranded headings;
- excessive white space;
- line wrapping;
- inconsistent fonts;
- unintended colors.

Do not rely only on text extraction.

---

## 17. Final QA Checklist

```text
[ ] Official guideline checked
[ ] Official template checked
[ ] Published examples checked where useful
[ ] FORMAT_SPEC created
[ ] Content Freeze respected

[ ] Title
[ ] Authors
[ ] Affiliations
[ ] Corresponding author
[ ] Abstract word count
[ ] Keywords
[ ] Body font
[ ] Body size
[ ] Heading styles
[ ] Equations
[ ] Equation numbering
[ ] Figures
[ ] Figure captions
[ ] Tables
[ ] Table captions
[ ] References
[ ] DOI formatting
[ ] Header
[ ] Footer
[ ] Page number
[ ] Margins
[ ] Page count
[ ] No overflow
[ ] No blank page
[ ] No unintended color
[ ] No unresolved placeholder
[ ] No missing figure
[ ] No missing table
[ ] No LaTeX source as plain text

[ ] Scientific numerical values unchanged
[ ] Scientific conclusions unchanged
[ ] No invented data
[ ] No invented references
```

---

## 18. Final Report

Create `FORMAT_CHECK.md` containing:

### A. Source files

List:

- manuscript;
- official guideline;
- official template;
- published-paper references.

### B. Requirements

Summarize the applicable formatting requirements.

### C. Changes made

List every formatting change.

### D. Scientific-content preservation

Confirm:

- numerical results unchanged;
- methodology unchanged;
- equations unchanged in meaning;
- conclusions unchanged;
- no data invented.

### E. Remaining issues

List only `NEEDS REVIEW` items.

### F. Page count

```text
Required: XX pages
Actual: XX pages
Status: PASS / REVIEW
```

If no explicit page limit exists:

```text
Page limit: NOT SPECIFIED IN SUPPLIED GUIDELINE
```

### G. Equation check

Report the number of equations converted to native Word Equation objects.

### H. Final status

Use only:

- `PASS`
- `REVIEW REQUIRED`

Do not use subjective scores.

---

## 19. Output Files

When file generation is requested, provide:

```text
01_FORMAT_SPEC.md
02_MANUSCRIPT_FINAL.docx
03_MANUSCRIPT_FINAL.pdf
04_FORMAT_CHECK.md
```

Use project-specific filenames where appropriate.

---

# 20. Master Command for Future Projects

Copy this command when starting a new paper:

> **Apply the ResearchLab Journal Manuscript Workflow to this project.**
>
> First inspect the research outline, manuscript, official author guidelines, official template, and published examples.
>
> Create `FORMAT_SPEC.md` before changing the manuscript.
>
> Then format the manuscript according to the official requirements.
>
> Preserve the scientific content and all numerical results.
>
> Use the official template as the master document when available.
>
> Convert all mathematical expressions into native Word Equation/OMML objects.
>
> Render the final document to PDF and perform page-by-page visual QA.
>
> Create the final DOCX, PDF, and FORMAT_CHECK report.
>
> Do not infer requirements that are not explicitly supported by the supplied sources. Mark uncertain items as `NEEDS REVIEW`.
