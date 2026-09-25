# ICSCE 2026 — Round 2 changelog

Edits applied directly to `ICSCE_2026_FINAL.docx`. No numerical results, statistics,
constraints, algorithm mechanisms, conclusions, or scope were changed — only notation,
presentation, and two textual corrections listed below.

## Notation changes
- Design variables renamed throughout (equations, Table 2, Sections 3.1/3.3, Conclusion):
  `CatIdx_BTCT → x1`, `D_steel → x2`, `t_steel → x3`. Domains unchanged: x1∈{1,…,5},
  x2∈[0.800,1.300] m, x3∈[0.010,0.025] m → still 5×51×16 = 4,080 combinations.
- Introduced compact vector notation: design vector `x = (x1, x2, x3)` (Eq. 1), objective
  vector `F(x) = [f1(x), f2(x)]` with `f1 = M` (total pile mass) and `f2 = umax` (max
  lateral displacement) — Eqs. (2)–(3) kept unchanged underneath this relabeling.
- Constraints in Section 2.2 restructured around `gi(x) ≤ 0, i = 1,…,5`, defined once
  (g1 = axial force–moment, g2 = steel stress, g3 = displacement, g4 = geotechnical
  bearing capacity, g5 = uplift), removing the repeated long descriptive clauses before
  each formula (Eqs. 4–5 numbering and all values/citations unchanged).
- Introduced `PFref` as shorthand for "the reference Pareto front" (defined once in 2.2).
- `_BTCT` / `_steel` subscripts that denote **pile type** (not the design variables), e.g.
  in Eq. (2)'s mass formula and in Fy/γM, were left untouched — only the three design-variable
  symbols were renamed.

## Equation fixes
- Converted 51 remaining LaTeX-style/plain expressions to real Word equations in Round 1;
  this round's "rà soát" pass found and fixed a real defect: **pure-numeric equations
  (no letter/variable, e.g. `5×51×16`, `10⁻⁶`, and the three p-values `1.07×10⁻¹⁰`,
  `6.53×10⁻¹¹`, `3.14×10⁻¹¹`) rendered visibly oversized** relative to surrounding text.
  Root cause: LibreOffice's math engine sizes such equations independently of the
  paragraph's font size, and a per-run `<w:sz>` override was tested and found both
  ineffective for that renderer and not schema-valid in that position.
  **Fix applied:** these 7 pure-numeric instances were reverted to cleanly formatted
  Unicode text (proper ×, −, superscript characters) — verified visually correct in
  every location (Abstract, Section 2.1, Section 2.3, Table 3 ×3, Conclusion). All other
  equations containing a variable/letter (x1, x2, x3, f1, f2, gi, Ks, γn, Np, α, λ, etc.)
  remain real Word equation objects and were re-verified to render at the correct size.
- Fixed a real bug found during QA: the D_steel→x2 substitutions had produced an invalid
  `<m:oMath><m:oMath>…</m:oMath></m:oMath>` double-nesting in 4 places (Sections 3.1, 3.3,
  Conclusion points 1 and 4), which made those equations render as blank/missing. Corrected
  by splicing the bare equation content instead of a second full equation wrapper.

## Table 2 changes
- Row labels only: `CatIdx_BTCT → x1`, `D_steel (m) → x2 (m)`, `t_steel (m) → x3 (m)`.
- All numeric values unchanged (domains, at-upper-bound counts, percentages).

## Section 3.3 correction
- Fixed a broken cross-reference: two instances of "(Section 3.4)" pointed to a
  non-existent section — corrected to "(Section 3.3)" (the actual Scope Limitations
  section), in Sections 2.1 and 3.1.
- The "upper bound of D_steel" sentence now reads "upper bound of x2" (notation rename
  above); wording otherwise unchanged. No new limitations were added.

## References added
- [8] Zhou, Qu, Li, Zhao, Suganthan, Zhang (2011), "Multiobjective evolutionary
  algorithms: A survey of the state of the art," Swarm and Evolutionary Computation
  1(1), 32–49. https://doi.org/10.1016/j.swevo.2011.03.001 — cited in Introduction.
- [9] Zitzler, Thiele, Laumanns, Fonseca, da Fonseca (2003), "Performance assessment of
  multiobjective optimizers: an analysis and review," IEEE Trans. Evolutionary
  Computation 7(2), 117–132. https://doi.org/10.1109/TEVC.2003.810758 — cited in
  Section 2.3 next to IGD/HV/Pareto-coverage.
- [10] Derrac, García, Molina, Herrera (2011), "A practical tutorial on the use of
  nonparametric statistical tests…," Swarm and Evolutionary Computation 1(1), 3–18.
  https://doi.org/10.1016/j.swevo.2011.02.002 — cited in Section 2.3 next to the
  Wilcoxon rank-sum test.
- All three DOIs verified against Crossref before insertion (title/authors/journal/
  volume/pages/year all confirmed to match). NSGA-II was deliberately not cited, since
  the manuscript neither uses nor compares against it. All 10 references are now cited
  at least once in the text.

## Formatting corrections
- Section 3.2: reworded "All four differences are statistically significant at α=0.05"
  to "The Wilcoxon rank-sum test indicates statistically significant differences
  between the two algorithms for all four metrics (α=0.05)" — attributes the result to
  the named test; no numbers changed.
- No change to Title/Author/Abstract wording, Keywords, headings, Figures 1–3 (Fig. 1
  placeholder untouched), or the References' order/DOIs for [1]–[7].

## Final page count
- **9 pages** (unchanged from before this round — the notation compaction in Sections
  2.1–2.2 offset the added references and citation sentences, so the manuscript did not
  grow).
- Abstract word count re-checked: 222 words (within the 200–300 requirement), no citations.
- Re-validated: XML well-formed, 0 new schema errors, all paragraphs/tables/figures
  intact, all 68 remaining equations render correctly at their surrounding text's size.
