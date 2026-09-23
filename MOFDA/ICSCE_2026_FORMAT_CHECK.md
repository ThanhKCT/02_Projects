# ICSCE 2026 FORMAT CHECK

Source manuscript: `ICSCE 2026.docx`
Regulation/template: `quy dinh ICSCE.docx`
Output: `ICSCE_2026_FINAL.docx`, `ICSCE_2026_FINAL.pdf`

## PASS

- **Title** — Times New Roman, Bold, 14pt, centered. Unchanged.
- **Author / Affiliation** — content and position unchanged; already matched template spacing/size (10pt author line, 9pt affiliation/address lines, centered).
- **Abstract** — unchanged wording; already 9pt, justified, indented both sides, within the 200–300 word range required by the template. Not shortened or rewritten.
- **Keywords** — unchanged, still the 6 original keywords, 9pt.
- **Body formatting** — Times New Roman, 10pt, justified, first-line indent, single spacing — already matched the template (the source file had been built against this template) and was left as-is where already correct.
- **Headings** — text/numbering of all headings unchanged (1. Introduction … 4. Conclusion and recommendations, Acknowledgments, Disclosure of Interests, References). Added `keepNext`/`keepLines` to all 13 heading paragraphs so no heading is stranded alone at the bottom of a page.
- **Tables** (Table 1, 2, 3) — data, values, and column structure unchanged. Captions confirmed above each table, 9pt, centered. Added `keepNext`/`keepLines` to all three table captions — this fixed a real defect where **Table 3**'s caption was stranded on the previous page while the table itself started on the next page; now caption and table move together.
- **Figures** (Fig. 1 placeholder, Fig. 2, Fig. 3) — images/placeholder untouched, centered, captions below in 9pt. Added `keepNext` to the image/placeholder paragraphs so a figure can no longer be separated from its caption across a page break.
- **References** — all 7 references unchanged (wording, order, DOIs). Already 9pt with hanging indent, matching the template's reference style.
- **Equation formatting** — see dedicated section below.
- **Conclusion structure** — restructured from one long paragraph into 4 numbered conclusions (see below), with a short bold lead‑in label per item. No sentence was reworded, no figure or number was changed — the original sentences were only split apart and numbered.
- **Placeholder dates removed** — the `Received: xx/xx/2026` / `Revised: xx/xx/2026` / `Accepted: xx/xx/2026` lines have been deleted, as instructed (author/editorial fields, not to be filled in by an automated pass).
- **Page numbers** — added, matching the template's own header pattern: mirrored header with a `PAGE` field, left‑aligned on even pages / right‑aligned on odd pages, no header on the title page (`titlePg`). The supplied template document itself uses exactly this pattern.
- **Margins / page size** — unchanged: A4 (11906×16838 twips), margins top/bottom 2948 twips, left/right 2495 twips — already identical to the template's own page setup.
- **No blank pages.** No table/figure/text overflow past the margins found on any of the 9 pages.

## MANUAL ACTION REQUIRED

- **Fig. 1** — left untouched exactly as instructed. The placeholder text `[Insert Fig. 1 – SAP2000 model image here]` and the caption `Fig. 1. SAP2000 model of the 100,000-DWT container wharf.` are preserved verbatim, in place, for the author to insert the image manually. Figures 2 and 3 were **not** renumbered.

## PAGE COUNT

- **Current final page count: 9 pages.**
- The supplied regulation file (`quy dinh ICSCE.docx`) does **not** state an explicit page-limit anywhere in its text. It is a formatting template/example (title/author/abstract/section/table/figure/reference conventions) and contains no numeric page-count requirement.
- No page limit has been invented or assumed. If ICSCE 2026 enforces a page limit through a separate call-for-papers document not supplied here, that should be checked against this 9-page count before submission.
- Note for the author: a file already in this project folder, `09.14 DE_XUAT_CHINH_SUA_ICSCE_6_TRANG.md`, suggests a personal/earlier target of 6 pages — that file was **not** treated as authoritative here (it is not the supplied regulation), but is flagged so you can reconcile it with the current 9-page count if a 6-page limit does in fact apply.

## CONTENT PRESERVATION

Confirmed — no scientific results, numerical values, statistical results, constraints, algorithm descriptions, or reference content were changed:

- All numbers verified unchanged on the rendered pages: 4,080 combinations; 3,337/4,080 feasible; 59 non-dominated solutions; 30 independent runs; 12,550 FE/run; IGD 0.000100 vs 0.000506; HV values; Pareto coverage 98.76% ± 0.88% vs 89.27% ± 4.46%; all p-values (0.0419; 1.07×10⁻¹⁰; 6.53×10⁻¹¹; 3.14×10⁻¹¹); all catalogue/table values in Tables 1–3; all 7 references, in original order, with original DOIs.
- Title, author names, affiliations, abstract, keywords: byte-identical to the source.
- The only textual reorganization is the Conclusion split (same sentences, now numbered 1–4) and the removal of the empty Received/Revised/Accepted placeholder lines.

## EQUATION CHECK

All LaTeX-source text (previously shown literally in Consolas font, e.g. `\mathbf{x} = [\,CatIdx_{BTCT},...`) has been converted into real Word/OMML equation objects (native `<m:oMath>`), rendering with proper italic variables, subscripts, Greek letters, radicals, fractions, and equation numbers — no LaTeX source text remains anywhere in the manuscript. 51 expressions were converted in total:

**Numbered display equations** (kept centered, with the equation number right-aligned on the same line, numbering unchanged):
1. `x = [CatIdx_BTCT, D_steel, t_steel]` — (1)
2. `f₁ = A(D,t)_BTCT · ΣL_BTCT · γ_concrete + A(D,t)_steel · ΣL_steel · γ_steel` — (2)
3. `f₂ = max(√(U₁²+U₂²))` — (3)
4. `N/P_vl + M/M_u − 1 ≤ 0` — (4) (kept inline within its sentence, exactly as in the source)
5. `F_k(x) = f_k(x)[1+C·P(x)], k=1,2, C=10` — (5)

**Unnumbered display equations** (converted the same way, centered, no number in the source either):
- `s_i = GI_i + ε_i/(1+DE_i)` (hybrid leader-selection score, Section 2.3)
- `Pareto coverage (%) = distinct reference solutions found⁄59 × 100%` (Section 2.3)

**Inline equations/expressions** (45 total) — all converted to inline OMML in place, including: `σ = N/A + M/W ≤ F_y/γ_M`; `U_max/U_allow − 1 ≤ 0`; `γ_n N_d ≤ R_k/γ_k`; `GP = GP₀/2(1+cos(π·it/Max_it))`; `mutant_i = X_r1+F(X_r2−X_r3)+λ(X_leader−X_r1)`; `F = 0.5(1−it/Max_it)`; `FE = N_p[1+maxiter(β+1)] = N_p(Max_it+1)`; `(1−iter/Max_iter)^(2·randn)`; and all the standalone parameter/definition expressions (`CatIdx_BTCT∈{1,…,5}`, `D_steel∈[0.800,1.300]`, `t_steel∈[0.010,0.025]`, `γ_concrete=2.5`, `γ_steel=7.85`, `F_y=3,150`, `γ_M=1.05`, `U_allow=71.7`, `K_s=0.32`, `γ_k=1.4`, `γ_n=1.15`, `γ_c=0.8`, `N_p=50`, `maxiter=50`, `β=4`, `Max_it=250`, `N_r=100`, `nGrid=10`, `N=30`, `α=0.05`, `10⁻⁶`, `D_steel`, `λ=0.3`).

All variable names (`CatIdx_BTCT`, `D_steel`, `t_steel`, `f_1`, `f_2`, `N/P_vl`, `M/M_u`, `U_max/U_allow`, `F_k(x)`, `GI_i`, `DE_i`, `ε_i`, `GP`, `mutant_i`, `FE`, Pareto coverage) and every numeric value inside them are unchanged — only the rendering (LaTeX text → native equation object) changed.

Two minor rendering artifacts were found and corrected during visual QC: two expressions that ended in a bare `=` sign right before a following bold plain-text value (`5×51×16=` **4,080 combinations**, and `FE=N_p[…]=N_p(…)=` **12,550/run**) caused the equation renderer to insert a stray placeholder glyph. Fixed by moving the trailing `=` out of the math object into plain text immediately after it — the displayed result is identical (`5×51×16 = 4,080 combinations`), only the internal representation changed.

## OTHER NOTES

- A validator script flagged one schema-level style attribute (`<m:sty>` inside a math run's `rPr`) as unexpected against its local (partial) OOXML math schema copy. This is a completely standard, ubiquitous OOXML Math element (used by Word itself to mark upright vs. italic math characters); the equations were rendered and visually verified correctly via LibreOffice, and 30+ years of camera-ready Word math documents use this construct. This is very likely a limitation of the validator's bundled schema subset, not a real defect — but worth a quick open-in-Word check by the author before final submission, as a precaution.
- The DOCX header/footer additions use the same field-code page-numbering mechanism (`PAGE \* MERGEFORMAT`) as the supplied template, so Word will recalculate the page numbers automatically on open — no manual step needed.
