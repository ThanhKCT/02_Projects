Multi-Objective Optimization of Pile-System Cross-Sections for a 100,000-DWT Container Wharf: A Comparison Between MOFDA and MOSFOA

Thanh Do-Quang¹,\*, T. Vu-Huu¹, Thanh Cuong-Le²

¹ Faculty of Civil Engineering, Vietnam Maritime University, Haiphong City, Vietnam
² Faculty of Civil Engineering and Electricity, Ho Chi Minh City Open University, Vietnam
\*Corresponding author: thanhdq.ctt@viamru.edu.vn

**Abstract.** Pile-supported container wharves carry a large mass of pile material, so a pile cross-section can be selected through constrained multi-objective optimization rather than experience alone. This study formulates a discrete multi-objective problem for the cross-sections of prestressed spun-concrete piles and steel pipe piles at an actual 100,000-DWT container wharf (4,080 combinations), subject to structural constraints, a geotechnical bearing-capacity constraint under TCVN 10304:2025, and a pile-uplift constraint. Material mass and maximum lateral displacement are evaluated through a SAP2000 model coupled with MATLAB via OAPI. Two multi-objective metaheuristics previously reported by the same group, MOFDA (flow-direction search, hybrid leader selection) and MOSFOA (starfish-inspired search, run here as the enhanced E-MOSFOA variant), are compared on the identical problem, model, objectives, constraints and evaluation budget (12,550 finite-element calls/run, 30 independent runs each), benchmarked against a reference Pareto front from an exhaustive search of all 4,080 combinations (59 non-dominated solutions). E-MOSFOA converges faster and approaches the reference front more closely under the same budget (mean normalised IGD 0.000100 versus 0.000506 for MOFDA; Wilcoxon rank-sum p = 1.07×10⁻¹⁰), reaching the stable hypervolume region after only about 1,000–1,500 evaluations against roughly 5,000–7,000 for MOFDA, and attains higher, steadier coverage of the reference front (98.76% ± 0.88% versus 89.27% ± 4.46%). These findings offer a quantitative reference for algorithm selection in similarly constrained pile-cross-section design problems for port structures.

**Keywords:** multi-objective optimization; MOFDA algorithm; MOSFOA algorithm; pile cross-section design; pile-supported container wharf; SAP2000–MATLAB coupling.

1. Introduction

Pile-supported container wharves are a common structural form for large-tonnage seaports in Vietnam, and the pile system — prestressed spun-concrete (PHC) piles combined with steel pipe piles — dominates both load-bearing function and material cost. Constrained multi-objective optimization coupled with a finite-element model lets the trade-off between material mass and displacement be explored systematically rather than only verified for a single, experience-based design.

Two metaheuristic-based multi-objective algorithms have been developed and reported by this group: MOFDA, a flow-direction algorithm with hybrid leader selection, validated on benchmark functions, constrained engineering problems and a steel-frame structure [1]; and MOSFOA, a starfish-inspired algorithm offered as B-MOSFOA and the enhanced E-MOSFOA, validated on IMOP/UF/RM-MEDA benchmarks and a separate port structure [2]. Each was verified on a different structure under non-identical conditions, so no direct comparison had existed. This paper asks: under the same MATLAB–SAP2000 evaluation system, objectives, constraints and finite-element budget, how do MOFDA and MOSFOA differ in solution quality and convergence speed on one real pile-cross-section design problem — the 100,000-DWT Lach Huyen container wharf, 4,080 design combinations, structural and geotechnical constraints (TCVN 10304:2025) and pile uplift? The contributions are: (i) a discrete optimization formulation with structural, geotechnical and uplift constraints; (ii) an exhaustive reference Pareto front independent of either algorithm's search; and (iii) a quantitative comparison of MOFDA and E-MOSFOA via IGD, hypervolume, Pareto coverage, the Wilcoxon rank-sum test and FE-based convergence curves, with conclusions drawn only from the data in Section 3.

2. Research Method

2.1. Structure, Finite-Element Model and Design Variables

The structure is a 100,000-DWT container wharf of the Lach Huyen international gateway port, Haiphong — an onshore quay on a high-piled deck. The analysed segment is about 75 m long, deck-top at +5.50 m, dredged bed at −16.0 m, for a design vessel of 330 m length and 14.8 m draught. Each segment has 132 prestressed spun-concrete piles and 60 steel pipe piles (D1016), 192 in total; pile cross-section is the design variable, applied uniformly per pile type, with position, rake and embedment length held fixed so that geotechnical constraints stay consistent across combinations. A linear-static SAP2000 model (4,913 joints, 1,734 frame and 4,488 shell elements) provides displacements and forces under the governing envelope combination "BAO KT"; the storm combination is outside this envelope and outside the present scope (Section 3.4). The pile tips sit in a stiff clay/weathered claystone layer (concrete piles) and a strongly fractured weathered rock layer (steel piles); pile-group interaction is not considered.

**Fig. 1.** SAP2000 model of the 100,000-DWT container wharf.

Three discrete design variables are used:

$$\mathbf{x} = [\,CatIdx_{BTCT},\ D_{steel},\ t_{steel}\,]$$  (1)

where $CatIdx_{BTCT}\in\{1,\dots,5\}$ indexes a row of the AMACCAO PHC-pile catalogue (Table 1, TCVN 7888:2014/JIS A 5373:2016 [3]); $D_{steel}\in[0.800,1.300]$ m (step 0.01 m, 51 values); $t_{steel}\in[0.010,0.025]$ m (step 0.001 m, 16 values) — giving $5\times51\times16=$ **4,080 combinations**.

**Table 1.** AMACCAO PHC-pile catalogue used (Class A, TCVN 7888:2014)

| CatIdx | D (m) | t (m) | A (m²) | Mcr (t·m) | Mu (t·m) | Pvl (t) |
|---|---:|---:|---:|---:|---:|---:|
| 1 | 0.600 | 0.100 | 0.15708 | 17.00 | 25.51 | 380 |
| 2 | 0.700 | 0.110 | 0.20389 | 26.00 | 39.00 | 500 |
| 3 | 0.800 | 0.120 | 0.25635 | 37.00 | 55.50 | 680 |
| 4 | 0.900 | 0.130 | 0.31447 | 48.95 | 73.42 | 880 |
| 5 | 1.000 | 0.130 | 0.35531 | 62.22 | 93.32 | 1,100 |

The two objectives are the pile material mass and the maximum lateral displacement:

$$f_1 = A(D,t)_{BTCT}\,\Sigma L_{BTCT}\,\gamma_{concrete} + A(D,t)_{steel}\,\Sigma L_{steel}\,\gamma_{steel}$$  (2)

$$f_2 = \max\!\left(\sqrt{U_1^{2}+U_2^{2}}\right)$$  (3)

with $\gamma_{concrete}=2.5$ t/m³, $\gamma_{steel}=7.85$ t/m³, under the "BAO KT" envelope.

2.2. Constraints and Reference Pareto Front

Structural constraints comprise: the concrete-pile axial force–moment interaction, using catalogue values directly, $N/P_{vl}+M/M_u-1\le 0$ (4); steel-pile stress $\sigma=N/A+M/W\le F_y/\gamma_M$ ($F_y=3{,}150$ kg/cm² [6], $\gamma_M=1.05$); and lateral displacement $U_{max}/U_{allow}-1\le 0$ ($U_{allow}=71.7$ mm, TCVN 11820-5:2021 [4]). The geotechnical constraint follows **TCVN 10304:2025 [5]**: a friction-pile formula for the concrete pile (clay tip) and an end-bearing-on-rock formula for the steel pile (fractured-rock tip, strength-reduction factor $K_s=0.32$, a conservative value adopted for lack of measured RQD), checked as $\gamma_n N_d\le R_k/\gamma_k$ ($\gamma_k=1.4$, $\gamma_n=1.15$, consequence class C2). An uplift check (18/360 steel piles found in tension, up to ≈31 t) uses shaft friction only ($\gamma_c=0.8$). All violations are combined into one penalty applied to both objectives:

$$F_k(\mathbf{x}) = f_k(\mathbf{x})\,\big[\,1+C\,P(\mathbf{x})\,\big],\quad k=1,2,\quad C=10$$  (5)

held fixed for both algorithms. All 4,080 combinations were evaluated by the same FE model to build a **reference Pareto front**, independent of either algorithm's search: 3,337/4,080 combinations proved feasible, yielding **59 non-dominated solutions**.

2.3. Compared Algorithms and Fair Evaluation Budget

*MOFDA* [1] extends the Flow Direction Algorithm with an external Pareto archive (adaptive grid) and a **hybrid leader-selection** rule scoring each archived solution as

$$s_i = GI_i + \dfrac{\varepsilon_i}{1+DE_i}$$

($GI_i$ grid index, $DE_i$ local density, $\varepsilon_i\in[0,1]$ random perturbation), the leader being the lowest-scoring individual — favouring sparse regions while limiting premature convergence relative to plain roulette-wheel selection.

*MOSFOA*, run here as **E-MOSFOA** [2], extends the Starfish Optimization Algorithm [7] with a Pareto archive plus three refinements: cosine phase control, $GP=\tfrac{GP_0}{2}\big(1+\cos(\pi\, it/Max\_it)\big)$, replacing a fixed exploration probability; a leader-guided DE-mutation, $mutant_i = X_{r1}+F(X_{r2}-X_{r3})+\lambda(X_{leader}-X_{r1})$, $F=0.5(1-it/Max\_it)$, $\lambda=0.3$; and an archive-based Gaussian refinement active in the final 20% of iterations. Both algorithms have each been separately validated on an actual port/marine structure [1, 2].

MOFDA ($N_p=50$, $maxiter=50$, $\beta=4$ neighbours/individual) and E-MOSFOA ($N_p=50$, $Max\_it=250$) use different loop structures, so **finite-element evaluations (FE)** rather than iterations are used as the common cost unit: $FE=N_p[1+maxiter(\beta+1)]=N_p(Max\_it+1)=$ **12,550/run** for both, with $Max\_it=5\times maxiter$. Both share the same archive capacity ($N_r=100$), grid resolution ($nGrid=10$) and $N=30$ independent runs.

Each algorithm was run 30 times against the exhaustive reference front, compared via the two-sided Wilcoxon rank-sum test ($\alpha=0.05$) on **IGD** (normalised by the reference front's range), **hypervolume (HV)** (fixed reference point for both algorithms) and **Pareto coverage**:

$$\text{Pareto coverage (\%)} = \dfrac{\text{distinct reference solutions found}}{59}\times 100\%$$

using a $10^{-6}$ fitness-matching tolerance fixed in advance.

3. Experimental Results and Reviews

3.1. Reference Pareto Front

Material mass of the 59 reference solutions ranges **3,317.3–5,189.4 t**, displacement **9.83–16.27 mm**, both well inside the TCVN 11820-5:2021 limit. Boundary clustering (Table 2) shows the Pareto solutions concentrate strongly toward the upper end of $D_{steel}$ (about 70% within the top 5% of its range) and, more weakly, toward the largest CatIdx_BTCT row — indicating that the search range may not fully capture the trade-off region at still-larger diameters (Section 3.4).

**Table 2.** Boundary clustering on the 59 reference solutions

| Design variable | Domain | At upper bound | Within 5% of upper bound | At/near lower bound |
|---|---|---:|---:|---:|
| CatIdx_BTCT | [1, 5] | 18/59 (30.5%) | 18/59 (30.5%) | 0 |
| D_steel (m) | [0.800, 1.300] | 17/59 (28.8%) | 41/59 (69.5%) | 0 |
| t_steel (m) | [0.010, 0.025] | 2/59 (3.4%) | 2/59 (3.4%) | 0 |

**Fig. 2.** Reference Pareto front (59 solutions) over the feasible combinations explored.

3.2. Per-Algorithm Results and Direct Comparison

Over 30 independent runs each (Table 3), both algorithms fill the 100-solution archive every run, but E-MOSFOA covers the 59-solution reference front more fully and more consistently (98.76% ± 0.88% versus 89.27% ± 4.46% for MOFDA) and attains a lower IGD (0.000100 versus 0.000506).

**Table 3.** Statistics over 30 runs; Wilcoxon rank-sum test versus MOFDA

| Metric | MOFDA (mean ± SD) | E-MOSFOA (mean ± SD) | p-value |
|---|---:|---:|---:|
| GD (normalised) | 0.000031 ± 0.000081 | 0.000000 ± 0.000000 | 0.0419 |
| IGD (normalised) | 0.000506 ± 0.000182 | 0.000100 ± 0.000074 | 1.07×10⁻¹⁰ |
| HV (fixed reference point) | 41,654.0150 ± 0.0064 | 41,654.0214 ± 0.0002 | 6.53×10⁻¹¹ |
| Pareto coverage (/59) | 52.67 ± 2.63 (89.27%) | 58.27 ± 0.52 (98.76%) | 3.14×10⁻¹¹ |

All four differences are statistically significant at $\alpha=0.05$; the HV and GD gaps are numerically small since both algorithms approach the same stable region, so the comparison rests mainly on **IGD** and **convergence speed against FE** rather than on the final HV gap. Convergence curves (Fig. 3) show E-MOSFOA reaching the stable HV region after only ≈1,000–1,500 FE, against ≈5,000–7,000 FE for MOFDA, with its mean IGD curve lying below MOFDA's throughout the search. This is consistent with E-MOSFOA's cosine phase-control schedule, which drives exploration-to-exploitation transition explicitly from early in the search, unlike MOFDA's decaying weight $(1-iter/Max\_iter)^{2\cdot randn}$, which depends heavily on a random term each iteration; the leader-guided mutation and late-stage Gaussian refinement may further help E-MOSFOA track the front once a good region is found. This is offered as a mechanism-level reading of the data, not a separate sensitivity analysis isolating each mechanism.

**Fig. 3.** Convergence curves of IGD and HV against the number of FEM evaluations.

3.3. Scope Limitations

The concentration of Pareto solutions near the upper bound of $D_{steel}$ means the search range may not fully capture the trade-off region at larger diameters, though the algorithm comparison itself remains valid since both are judged against the same reference front. $K_s=0.32$ for the fractured-rock layer is a conservative assumption pending measured RQD data ($\gamma_n=1.15$ is, by contrast, confirmed). Pile-group interaction, the storm load combination, and p–y soil–pile interaction are outside the present scope, which is limited to linear-static analysis.

4. Conclusion and recommendations

A discrete multi-objective optimization problem was formulated for the pile-system cross-sections of a 100,000-DWT container wharf (4,080 combinations; structural, TCVN 10304:2025 geotechnical, and uplift constraints), and an exhaustive reference Pareto front (59 solutions) was built as an external, algorithm-independent benchmark; this front shows boundary clustering toward larger $D_{steel}$, a scope limitation for generalising absolute values. Comparing MOFDA and E-MOSFOA on the identical problem, model, objectives, constraints and FE budget (30 runs each), E-MOSFOA attains a markedly lower IGD (0.000100 versus 0.000506, p = 1.07×10⁻¹⁰), converges roughly five times faster in FE terms, and covers the reference front more fully and steadily (98.76% ± 0.88% versus 89.27% ± 4.46%). Within the scope examined, E-MOSFOA is therefore the more favourable choice on convergence speed — without implying a universal advantage on other structural problems — and these results give a quantitative reference for algorithm selection in similarly constrained port pile-design problems. Before the optimized mass/displacement values are used in a formal design, the limitations of Section 3.3 (search range at large $D_{steel}$, the $K_s$ assumption, no pile-group effect) should be reconfirmed against fuller field and design data.

Acknowledgments

This research was financially supported by Vietnam Maritime University.

Disclosure of Interests

The authors have no competing interests to declare that are relevant to the content of this article.

References

1. Vu-Huu, T., Khatir, S., Cuong-Le, T.: Real-World Steel Frame Optimization Using a Hybrid Leader Selection-Based Multi-Objective Flow Direction Algorithm. International Journal for Numerical Methods in Engineering 126(15), e70098 (2025). https://doi.org/10.1002/nme.70098

2. Do-Quang, T., Vu-Huu, T., Le, C.T.: Multi-objective Optimization of Marine Structures Using an Enhanced Starfish Algorithm. Proceedings of the Institution of Civil Engineers – Structures and Buildings (2026). https://doi.org/10.1680/jstbu.26.00159

3. AMACCAO PILE: Catalogue and technical specifications of AMACCAO spun concrete piles D300–D1200, following TCVN 7888:2014 and JIS A 5373:2016 (2014).

4. Ministry of Science and Technology: TCVN 11820-5:2021 — Port and Harbour Engineering — Design Requirements — Part 5: Quay Structures (2021).

5. Vietnam Standards and Quality Institute: TCVN 10304:2025 (2nd edition) — Pile Foundation Design (2025).

6. Ministry of Science and Technology: TCVN 9245:2012 — Steel Pipe Piles (2012).

7. Zhong, C., et al.: Starfish optimization algorithm (SFOA): a bio-inspired metaheuristic algorithm for global optimization compared with 100 optimizers. Neural Computing and Applications, 3641–3683 (2025).

---

Received: xx/xx/2026

Revised: xx/xx/2026

Accepted: xx/xx/2026
