# -*- coding: utf-8 -*-
import csv
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import matplotlib.font_manager as fm

plt.rcParams['font.family'] = 'DejaVu Sans'  # ho tro unicode co ban; dau tieng Viet dung Times New Roman khi chen vao Word

def read_csv(path):
    with open(path, encoding='utf-8-sig') as f:
        return list(csv.DictReader(f))

CAT_COLOR = {'1': '#1f77b4', '2': '#ff7f0e', '3': '#2ca02c'}
CAT_LABEL = {'1': 'CatIdx 1 (D700-t110)', '2': 'CatIdx 2 (D800-t120)', '3': 'CatIdx 3 (D900-t130)'}
CAT_MARKER = {'1': 'o', '2': 's', '3': '^'}

# ---------------- Hinh 2: mat Pareto that (16 nghiem) ----------------
pareto = read_csv('pareto_16_bruteforce.csv')
fig, ax = plt.subplots(figsize=(7, 5), dpi=200)
for cat in ['1', '2', '3']:
    pts = [r for r in pareto if r['CatIdx'] == cat]
    if not pts:
        continue
    ax.scatter([float(r['f1_tan']) for r in pts], [float(r['f2_mm']) for r in pts],
               c=CAT_COLOR[cat], marker=CAT_MARKER[cat], s=70, edgecolor='k', linewidth=0.5,
               label=CAT_LABEL[cat], zorder=3)
pareto_sorted = sorted(pareto, key=lambda r: float(r['f1_tan']))
ax.plot([float(r['f1_tan']) for r in pareto_sorted], [float(r['f2_mm']) for r in pareto_sorted],
        color='gray', linewidth=1, linestyle='--', zorder=1, alpha=0.6)
ax.set_xlabel('f1 - Khoi luong vat lieu coc (tan)', fontsize=11)
ax.set_ylabel('f2 - Chuyen vi ngang lon nhat (mm)', fontsize=11)
ax.set_title('Mat Pareto that cua bai toan (16 nghiem, liet ke toan bo)', fontsize=12)
ax.legend(fontsize=9, loc='upper right')
ax.grid(True, linestyle=':', alpha=0.5)
fig.tight_layout()
fig.savefig('Hinh2_Pareto_that_16nghiem.png')
plt.close(fig)

# ---------------- Hinh 3: doi chieu MOFDA (14) vs Pareto that (16) ----------------
comp = read_csv('fig3_comparison_mofda_vs_true.csv')
true_pts = [r for r in comp if r['source'] == 'True_Pareto']
mofda_pts = [r for r in comp if r['source'] == 'MOFDA']

fig, ax = plt.subplots(figsize=(7, 5), dpi=200)
ax.scatter([float(r['f1_tan']) for r in true_pts], [float(r['f2_mm']) for r in true_pts],
           facecolors='none', edgecolors='#1f77b4', marker='o', s=140, linewidth=1.6,
           label='Pareto that (16 nghiem, brute-force)', zorder=2)
matched = [r for r in mofda_pts if r['matched_both'] == '1']
unmatched = [r for r in mofda_pts if r['matched_both'] != '1']
ax.scatter([float(r['f1_tan']) for r in matched], [float(r['f2_mm']) for r in matched],
           c='#2ca02c', marker='x', s=90, linewidth=2.2,
           label=f'MOFDA - trung khop ({len(matched)}/{len(mofda_pts)})', zorder=4)
if unmatched:
    ax.scatter([float(r['f1_tan']) for r in unmatched], [float(r['f2_mm']) for r in unmatched],
               c='#d62728', marker='x', s=90, linewidth=2.2,
               label=f'MOFDA - khong trung ({len(unmatched)}/{len(mofda_pts)})', zorder=4)
ax.set_xlabel('f1 - Khoi luong vat lieu coc (tan)', fontsize=11)
ax.set_ylabel('f2 - Chuyen vi ngang lon nhat (mm)', fontsize=11)
ax.set_title('Doi chieu mat Pareto MOFDA (14 nghiem) voi mat Pareto that (16 nghiem)', fontsize=11)
ax.legend(fontsize=9, loc='upper right')
ax.grid(True, linestyle=':', alpha=0.5)
fig.tight_layout()
fig.savefig('Hinh3_Doichieu_MOFDA_vs_that.png')
plt.close(fig)

print('OK: da luu Hinh2_Pareto_that_16nghiem.png va Hinh3_Doichieu_MOFDA_vs_that.png')
print('So diem: pareto=%d, mofda_total=%d, matched=%d, unmatched=%d' % (len(pareto), len(mofda_pts), len(matched), len(unmatched)))
