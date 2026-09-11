// Build BAI_BAO_MOFDA_MOSFOA_DOI_SANH.docx tu ban thao markdown da chot.
const fs = require('fs');
const path = require('path');
const {
  Document, Packer, Paragraph, TextRun, HeadingLevel, AlignmentType,
  Table, TableRow, TableCell, WidthType, BorderStyle, ImageRun,
  Tab, TabStopType, TabStopPosition, PageOrientation
} = require('docx');

const FONT = 'Times New Roman';
const SZ = 26; // 13pt
const SZ_SMALL = 22; // 11pt (table cells)

// ---------- helpers ----------

// Convert a light-LaTeX inline math snippet to plain readable text.
function mathToText(s) {
  return s
    .replace(/\\left\(/g, '(').replace(/\\right\)/g, ')')
    .replace(/\\left\[/g, '[').replace(/\\right\]/g, ']')
    .replace(/\\cdot/g, '·')
    .replace(/\\times/g, '×')
    .replace(/\\ge/g, '≥').replace(/\\le/g, '≤')
    .replace(/\\in/g, '∈')
    .replace(/\\arg\\min/g, 'argmin')
    .replace(/\\sum_j/g, 'Σⱼ').replace(/\\sum/g, 'Σ')
    .replace(/\\beta/g, 'β')
    .replace(/\\lambda/g, 'λ')
    .replace(/\\varepsilon/g, 'ε')
    .replace(/\\,/g, ' ')
    .replace(/\\quad/g, '   ')
    .replace(/\\frac\{([^{}]+)\}\{([^{}]+)\}/g, '($1)/($2)')
    .replace(/\\frac\{([^{}]+)\}\{([^{}]+)\}/g, '($1)/($2)') // second pass for nested-ish
    .replace(/\{,\}/g, ',')
    .replace(/[{}]/g, '');
}

// Parse inline markdown (**bold**, *italic*, $math$) into TextRun[]
function parseInline(text, baseOpts) {
  baseOpts = baseOpts || {};
  const runs = [];
  const re = /(\*\*[^*]+\*\*|\*[^*]+\*|\$[^$]+\$)/g;
  let last = 0, m;
  while ((m = re.exec(text)) !== null) {
    if (m.index > last) runs.push(new TextRun({ text: text.slice(last, m.index), font: FONT, size: SZ, ...baseOpts }));
    const tok = m[0];
    if (tok.startsWith('**')) {
      runs.push(new TextRun({ text: tok.slice(2, -2), bold: true, font: FONT, size: SZ, ...baseOpts }));
    } else if (tok.startsWith('$')) {
      runs.push(new TextRun({ text: mathToText(tok.slice(1, -1)), italics: true, font: FONT, size: SZ, ...baseOpts }));
    } else {
      runs.push(new TextRun({ text: tok.slice(1, -1), italics: true, font: FONT, size: SZ, ...baseOpts }));
    }
    last = re.lastIndex;
  }
  if (last < text.length) runs.push(new TextRun({ text: text.slice(last), font: FONT, size: SZ, ...baseOpts }));
  return runs;
}

function p(text, opts) {
  opts = opts || {};
  return new Paragraph({
    children: parseInline(text),
    spacing: { after: 160, line: 300 },
    alignment: opts.align || AlignmentType.JUSTIFIED,
    ...opts.pOpts,
  });
}

function h1(text, num) {
  return new Paragraph({
    text: text,
    heading: HeadingLevel.HEADING_1,
    spacing: { before: 320, after: 160 },
  });
}
function h2(text) {
  return new Paragraph({ text: text, heading: HeadingLevel.HEADING_2, spacing: { before: 240, after: 120 } });
}
function h3(text) {
  return new Paragraph({ text: text, heading: HeadingLevel.HEADING_3, spacing: { before: 200, after: 100 } });
}

// Centered display equation with right-aligned number via tab stop.
function eq(mathLine, number) {
  const text = mathToText(mathLine);
  return new Paragraph({
    tabStops: [{ type: TabStopType.RIGHT, position: TabStopPosition.MAX }],
    spacing: { before: 120, after: 120 },
    children: [
      new TextRun({ text: text, italics: true, font: FONT, size: SZ }),
      new TextRun({ children: [new Tab()], text: number ? `(${number})` : '', font: FONT, size: SZ }),
    ],
  });
}

function caption(text) {
  return new Paragraph({
    children: parseInline(text, { bold: false }),
    alignment: AlignmentType.CENTER,
    spacing: { before: 120, after: 240 },
  });
}

function image(filePath, widthPx, heightPx) {
  const data = fs.readFileSync(filePath);
  return new Paragraph({
    alignment: AlignmentType.CENTER,
    spacing: { before: 120, after: 60 },
    children: [
      new ImageRun({
        type: 'png',
        data: data,
        transformation: { width: widthPx, height: heightPx },
      }),
    ],
  });
}

function equalWidths(n, total) {
  const base = Math.floor(total / n);
  const arr = new Array(n).fill(base);
  arr[n - 1] = total - base * (n - 1);
  return arr;
}

function cellText(text, opts) {
  opts = opts || {};
  return new TableCell({
    width: { size: opts.width, type: WidthType.DXA },
    children: [new Paragraph({
      alignment: opts.align || AlignmentType.CENTER,
      children: parseInline(String(text), { size: SZ_SMALL }).map(r => {
        // re-wrap with small size explicitly (parseInline already applies baseOpts as spread before size, ensure size wins)
        return r;
      }),
    })],
    verticalAlign: 'center',
  });
}

function makeTable(headers, rows, total) {
  const n = headers.length;
  const widths = equalWidths(n, total);
  const headerRow = new TableRow({
    tableHeader: true,
    children: headers.map((hd, i) => new TableCell({
      width: { size: widths[i], type: WidthType.DXA },
      shading: { fill: 'D9D9D9' },
      children: [new Paragraph({
        alignment: AlignmentType.CENTER,
        children: [new TextRun({ text: hd, bold: true, font: FONT, size: SZ_SMALL })],
      })],
    })),
  });
  const bodyRows = rows.map(r => new TableRow({
    children: r.map((c, i) => cellText(c, { width: widths[i] })),
  }));
  return new Table({
    width: { size: total, type: WidthType.DXA },
    columnWidths: widths,
    rows: [headerRow, ...bodyRows],
  });
}

// ---------- content ----------

const PAGE_W = 11906, PAGE_H = 16838, MARGIN = 1440;
const USABLE = PAGE_W - 2 * MARGIN;

const figDir = path.join(__dirname, '..', 'Wharf100DWT', 'results', 'analysis');
const fig2 = path.join(figDir, 'reference_pareto_front.png');
const fig3 = path.join(figDir, 'convergence_IGD_HV_vs_FE.png');

const children = [];

// Title
children.push(new Paragraph({
  alignment: AlignmentType.CENTER,
  spacing: { after: 80 },
  children: [new TextRun({ text: 'TỐI ƯU ĐA MỤC TIÊU TIẾT DIỆN HỆ CỌC CẦU TÀU CONTAINER 100.000 DWT: ĐỐI SÁNH THUẬT TOÁN MOFDA VÀ MOSFOA', bold: true, size: 30, font: FONT }),
  ],
}));
children.push(new Paragraph({
  alignment: AlignmentType.CENTER,
  spacing: { after: 240 },
  children: [new TextRun({ text: 'MULTI-OBJECTIVE OPTIMIZATION OF PILE-SYSTEM CROSS-SECTIONS FOR A 100,000-DWT CONTAINER WHARF: A COMPARISON BETWEEN MOFDA AND MOSFOA', italics: true, bold: true, size: 24, font: FONT }),
  ],
}));

// Tom tat
children.push(h1('Tóm tắt'));
children.push(p('Cầu tàu container trên nền cọc có khối lượng vật liệu cho phần cọc lớn; việc lựa chọn tiết diện cọc ở giai đoạn thiết kế sơ bộ có thể được hỗ trợ bằng tối ưu đa mục tiêu có ràng buộc thay vì chỉ dựa vào kinh nghiệm. Nghiên cứu xây dựng bài toán tối ưu đa mục tiêu cho tiết diện hệ cọc bê tông ly tâm dự ứng lực và cọc ống thép của một cầu tàu container 100.000 DWT thực tế, với không gian thiết kế rời rạc gồm 4.080 tổ hợp (5 dòng catalogue cọc BTCT × 51 giá trị đường kính × 16 giá trị chiều dày cọc thép), hệ ràng buộc gồm các điều kiện kết cấu, địa kỹ thuật theo TCVN 10304:2025 và chống nhổ cọc. Hai hàm mục tiêu — khối lượng vật liệu và chuyển vị ngang lớn nhất — được đánh giá bằng mô hình phần tử hữu hạn SAP2000 kết nối MATLAB qua OAPI. Nghiên cứu đối sánh hai thuật toán tối ưu đa mục tiêu được phát triển và báo cáo trong các nghiên cứu của cùng nhóm — MOFDA (hướng dòng chảy, chọn thủ lĩnh lai) và MOSFOA (sao biển, bản thực nghiệm E-MOSFOA với điều khiển pha cosine, đột biến kiểu DE dẫn hướng thủ lĩnh và tinh chỉnh Gaussian giai đoạn cuối) — trên cùng một bài toán, cùng mô hình FEM, cùng hàm mục tiêu, cùng ràng buộc, cùng ngân sách đánh giá mô hình FEM (12.550 lần/lượt chạy), 30 lần chạy độc lập/thuật toán, đối chiếu với mặt Pareto tham chiếu của toàn bộ không gian thiết kế khảo sát thu được bằng vét cạn toàn bộ 4.080 tổ hợp (59 nghiệm không bị trội). Trong bài toán khảo sát, E-MOSFOA cho thấy khả năng hội tụ nhanh hơn và độ gần mặt Pareto tham chiếu tốt hơn trong cùng ngân sách đánh giá FEM (IGD trung bình 0,000100 so với 0,000506 của MOFDA, kiểm định Wilcoxon rank-sum p=1,07×10⁻¹⁰; đạt vùng ổn định của hypervolume chỉ sau ~1.000-1.500 lần đánh giá FEM so với ~5.000-7.000 lần của MOFDA). Về khả năng bao phủ mặt Pareto tham chiếu, E-MOSFOA đạt tỷ lệ cao hơn và ổn định hơn MOFDA (98,76% ± 0,88% so với 89,27% ± 4,46%, tính trên 59 nghiệm tham chiếu). Kết quả cung cấp cơ sở định lượng để tham khảo khi lựa chọn thuật toán tối ưu cho bài toán thiết kế tiết diện hệ cọc công trình cảng biển có ràng buộc phức hợp trong phạm vi khảo sát của nghiên cứu.'));
children.push(p('**Từ khóa:** tối ưu đa mục tiêu, thuật toán MOFDA, thuật toán MOSFOA, tiết diện cọc, cầu tàu trên nền cọc, kết nối SAP2000-MATLAB.'));

children.push(h1('Abstract'));
children.push(p('*(để trống)*'));

// Muc 1
children.push(h1('1. Mở đầu'));
children.push(p('Cầu tàu container trên nền cọc là dạng kết cấu phổ biến trong các bến cảng biển trọng tải lớn tại Việt Nam. Hệ cọc — thường kết hợp cọc bê tông cốt thép dự ứng lực (BTCT DƯL) ly tâm và cọc ống thép — là cấu kiện chịu lực chính, đồng thời chiếm tỷ trọng lớn trong khối lượng vật liệu và chi phí xây dựng. Tối ưu đa mục tiêu có ràng buộc, kết hợp trực tiếp với mô hình phần tử hữu hạn (FEM), cho phép khảo sát hệ thống hoá sự đánh đổi giữa khối lượng vật liệu và độ cứng/chuyển vị của hệ cọc, thay vì chỉ kiểm tra lại một phương án chọn trước theo kinh nghiệm.'));
children.push(p('Hai thuật toán tối ưu đa mục tiêu dựa trên metaheuristic được phát triển và báo cáo trong các nghiên cứu [1], [2]: MOFDA — thuật toán hướng dòng chảy đa mục tiêu với cơ chế chọn thủ lĩnh lai, đã được kiểm chứng trên 31 hàm chuẩn, 11 bài toán kỹ thuật có ràng buộc và ứng dụng cho một công trình khung thép thực tế [1]; và MOSFOA — thuật toán đa mục tiêu dựa trên hành vi tìm kiếm của sao biển (Starfish Optimization Algorithm), với hai biến thể B-MOSFOA và E-MOSFOA, đã được kiểm chứng trên các bộ benchmark IMOP/UF/RM-MEDA và ứng dụng cho một công trình cảng biển thực tế khác (cảng xăng dầu Hải Linh) [2]. Mỗi thuật toán đã được kiểm chứng trên một đối tượng công trình riêng, theo các điều kiện đánh giá không hoàn toàn giống nhau, nên chưa có cơ sở để so sánh trực tiếp hiệu năng của hai thuật toán trên cùng một bài toán kết cấu cụ thể.'));
children.push(p('*Câu hỏi trọng tâm của nghiên cứu này là: hai thuật toán MOFDA và MOSFOA, khi được thiết lập trên cùng một hệ thống đánh giá MATLAB–SAP2000, cùng hàm mục tiêu, cùng ràng buộc, cùng ngân sách đánh giá mô hình FEM, thể hiện khác biệt như thế nào về chất lượng và tốc độ hội tụ khi giải cùng một bài toán thiết kế tiết diện hệ cọc cầu tàu thực tế có ràng buộc kết cấu và địa kỹ thuật?* Nghiên cứu khảo sát cầu tàu container 100.000 DWT thuộc dự án cảng cửa ngõ quốc tế Hải Phòng (Lạch Huyện, Mục 2), với không gian thiết kế rời rạc gồm 4.080 tổ hợp (5 dòng catalogue cọc BTCT, miền đường kính/chiều dày cọc thép, Mục 3.1) và các ràng buộc kết cấu và địa kỹ thuật được xét, gồm sức chịu tải địa kỹ thuật theo TCVN 10304:2025 và chống nhổ cọc (Mục 3.4).'));
children.push(p('Đóng góp của bài báo gồm: (i) hình thành bài toán tối ưu rời rạc cho tiết diện hệ cọc với hệ ràng buộc gồm các điều kiện kết cấu, địa kỹ thuật và chống nhổ cọc; (ii) xây dựng mặt Pareto tham chiếu bằng vét cạn toàn bộ 4.080 tổ hợp làm chuẩn đối chiếu bên ngoài, không phụ thuộc vào kết quả tìm kiếm của bất kỳ thuật toán nào; (iii) đối sánh định lượng MOFDA và MOSFOA (bản thực nghiệm E-MOSFOA) trên **cùng một bài toán, cùng mô hình FEM, cùng hàm mục tiêu, cùng ràng buộc và cùng ngân sách đánh giá FEM**, mỗi thuật toán 30 lần chạy độc lập, đối chiếu với mặt Pareto tham chiếu bằng vét cạn — bằng các chỉ số IGD, hypervolume, khả năng bao phủ mặt Pareto tham chiếu và kiểm định Wilcoxon rank-sum, cùng đường cong hội tụ theo số lần đánh giá FEM. Bài báo không tuyên bố thuật toán nào vượt trội tuyệt đối trước khi trình bày kết quả; kết luận về sự khác biệt (nếu có) được rút ra trực tiếp từ số liệu thực nghiệm ở Mục 6.'));

// Muc 2
children.push(h1('2. Đối tượng nghiên cứu và mô hình phần tử hữu hạn'));
children.push(h2('2.1. Mô tả công trình'));
children.push(p('Đối tượng nghiên cứu là cầu tàu container 100.000 DWT thuộc dự án cảng cửa ngõ quốc tế Hải Phòng (Lạch Huyện), kết cấu bến liền bờ dạng bệ cọc cao đài mềm. Mô hình phân tích đại diện cho một phân đoạn tiêu chuẩn dài khoảng 75 m, rộng mặt cầu 50 m, cao trình đỉnh bến +5,50 m và đáy bến sau nạo vét −16,0 m (Hải đồ). Tàu thiết kế 100.000 DWT có chiều dài 330 m, chiều rộng 45,5 m, mớn nước đầy tải 14,8 m.'));
children.push(h2('2.2. Hệ cọc'));
children.push(p('Hệ cọc của một phân đoạn gồm 132 cọc ống BTCT DƯL (bố trí thẳng đứng và xiên 6:1) và 60 cọc ống thép D1016 (xiên 6:1 và 7:1), tổng cộng 192 cọc. Tiết diện cọc được coi là biến thiết kế áp dụng đồng nhất cho toàn bộ cọc cùng loại; vị trí, độ xiên được giữ cố định trong tất cả các phương án khảo sát. Chiều dài ngàm cọc cũng được giữ cố định theo đúng cao độ mũi cọc của thiết kế gốc khi đường kính thay đổi (cọc BTCT L=29 m, mũi cọc tại cao độ −23,50 m; cọc thép L=30 m, mũi cọc tại cao độ −24,50 m) — giả thiết cần thiết để có thể áp dụng nhất quán ràng buộc địa kỹ thuật theo địa tầng thực (Mục 3.4) cho mọi phương án tiết diện.'));
children.push(h2('2.3. Mô hình SAP2000'));
children.push(p('Mô hình FEM tuyến tính tĩnh được xây dựng trong SAP2000, gồm 4.913 nút, 1.734 phần tử thanh và 4.488 phần tử tấm vỏ, đơn vị làm việc Tonf–m–°C. Vật liệu gồm bê tông M400 (dầm/bản), M800 (cọc BTCT), thép cọc (Fy = 3.150 kG/cm²), cốt thép A615Gr60 và tao dự ứng lực A416Gr270. Điều kiện biên gồm 192 nút ngàm biên phân đoạn và các nút gán lò xo nền theo phương dọc trục cọc. Kết quả trích xuất chuyển vị và nội lực dùng tổ hợp bao (combo envelope) "BAO KT", đã gộp sẵn các tổ hợp tải cơ bản trong mô hình tính toán; tổ hợp bão riêng nằm ngoài phạm vi đường bao này và chưa được đưa vào đợt tính toán tối ưu — giới hạn được nêu ở Mục 6.5.'));
children.push(caption('Hình 1. Mô hình SAP2000 của cầu tàu container 100.000 DWT'));
children.push(h2('2.4. Địa tầng và điều kiện mũi cọc'));
children.push(p('Địa tầng tại mặt cắt cọc (đọc từ bản vẽ mặt cắt ngang thiết kế gốc, cao độ so với Hải đồ, chỉ tính từ đáy nạo vét −16,00 m trở xuống) gồm: Lớp 9 (sét xám xanh, dẻo chảy, chỉ số sệt IL=0,87) từ khoảng −17,20 đến −21,91 m; Lớp 10 (sét pha cứng/đá sét kết phong hoá hoàn toàn, IL=−0,13) từ −21,91 đến khoảng −23,91 m; Lớp 11 (đá phong hoá mạnh, nứt nẻ) bên dưới. Mũi cọc BTCT (cao độ −23,50 m) nằm trong Lớp 10; mũi cọc thép (cao độ −24,50 m) nằm trong Lớp 11. Cọc được coi là bịt kín mũi cho cả hai loại (diện tích tính toán là diện tích đặc). Nghiên cứu không xét hiệu ứng nhóm cọc — mỗi cọc được kiểm tra sức chịu tải đơn lẻ (giới hạn nêu ở Mục 6.5).'));

// Muc 3
children.push(h1('3. Bài toán tối ưu đa mục tiêu'));
children.push(h2('3.1. Biến thiết kế'));
children.push(p('Bài toán được xây dựng dưới dạng tối ưu rời rạc với ba biến thiết kế:'));
children.push(eq('x = [CatIdx_BTCT, D_thép, t_thép]', '1'));
children.push(p('CatIdx_BTCT ∈ {1, 2, 3, 4, 5} là chỉ số dòng trong catalogue cọc bê tông ly tâm dự ứng lực (PHC) của nhà sản xuất AMACCAO, theo TCVN 7888:2014 và JIS A 5373:2016 [3], Class A (Bảng 1) — 5 dòng D600–D1000; phạm vi khảo sát được lựa chọn phù hợp với phạm vi tiết diện dự kiến của công trình; hiện tượng tập trung nghiệm Pareto tại biên được kiểm chứng lại ở Mục 6.1. D_thép ∈ [0,800; 1,300] m, bước 0,01 m (51 giá trị); t_thép ∈ [0,010; 0,025] m, bước 0,001 m (16 giá trị). Không gian tìm kiếm là tích của ba miền rời rạc: 5×51×16 = **4.080 tổ hợp**.'));
children.push(caption('Bảng 1. Catalogue cọc bê tông ly tâm AMACCAO sử dụng (Class A, TCVN 7888:2014)'));
children.push(makeTable(
  ['CatIdx', 'D (m)', 't (m)', 'A (m²)', 'Mcr (T.m)', 'Mu (T.m)', 'Pvl (T)'],
  [
    ['1', '0,600', '0,100', '0,15708', '17,00', '25,51', '380'],
    ['2', '0,700', '0,110', '0,20389', '26,00', '39,00', '500'],
    ['3', '0,800', '0,120', '0,25635', '37,00', '55,50', '680'],
    ['4', '0,900', '0,130', '0,31447', '48,95', '73,42', '880'],
    ['5', '1,000', '0,130', '0,35531', '62,22', '93,32', '1.100'],
  ], USABLE));
children.push(new Paragraph({ spacing: { before: 120, after: 160 }, children: [] }));
children.push(p('Nguồn: Catalogue cọc bê tông ly tâm AMACCAO PILE [3], quy đổi mô men kN.m sang T.m; hai dòng D600 và D1000 lấy trực tiếp từ cùng bảng catalogue gốc dùng cho D700–D900, cùng quy ước Class A, không suy đoán/nội suy.'));

children.push(h2('3.2. Hàm mục tiêu'));
children.push(p('Hai hàm mục tiêu được xét đồng thời:'));
children.push(eq('f₁ = A(D,t)_BTCT × ΣL_BTCT × γ_bt + A(D,t)_thép × ΣL_thép × γ_thép', '2'));
children.push(eq('f₂ = max(√(U₁² + U₂²))', '3'));
children.push(p('trong đó f₁ là tổng **khối lượng vật liệu** cọc (tấn, γ_bt = 2,5 T/m³, γ_thép = 7,85 T/m³); f₂ là chuyển vị ngang lớn nhất của cầu tàu trên tổ hợp bao "BAO KT", không xét thành phần đứng.'));

children.push(h2('3.3. Ràng buộc kết cấu'));
children.push(p('Ba nhóm ràng buộc kết cấu được áp dụng: (i) tương tác lực dọc trục – mô men cọc BTCT theo công thức do nhà sản xuất khuyến nghị cho cọc ly tâm dự ứng lực [3], dùng trực tiếp Mu/Pvl của từng dòng catalogue (Bảng 1):'));
children.push(eq('N/Pvl + M/Mu − 1 ≤ 0', '4'));
children.push(p('(ii) ứng suất cọc thép σ = N/A + M/W ≤ Fy/γM, với Fy = 3.150 kG/cm² (TCVN 9245:2012 [6], tiêu chuẩn vật liệu) và γM = 1,05; và (iii) chuyển vị ngang U_max/U_allow − 1 ≤ 0, với U_allow = 71,7 mm theo TCVN 11820-5:2021 [4], Điều 8.9, Bảng 12 (1/300 chiều cao bến, H = 21,5 m).'));

children.push(h2('3.4. Ràng buộc địa kỹ thuật'));
children.push(p('Ràng buộc sức chịu tải địa kỹ thuật được xác định theo **TCVN 10304:2025 [5]** (Điều 7.1, 7.2), dựa trên địa tầng thực tại mặt cắt cọc (Mục 2.4) và chỉ tiêu cơ lý gốc của dự án. Cọc BTCT (mũi trong Lớp 10, đất dính) dùng công thức cọc ma sát Rk = γc(γR,R·qb·A + u·ΣγR,f·fi·hi) (công thức (9), Điều 7.2.2.1), qb tra theo độ sâu và chỉ số sệt IL (Bảng 2), fi tra theo loại đất (Bảng 3). Cọc thép (mũi trong Lớp 11, đá phong hoá mạnh nứt nẻ) dùng công thức cọc chống tựa đá Rk = γc·qb·A (công thức (5)/(6), Điều 7.2.1.1), với qb xác định từ cường độ kháng nén một trục bão hoà nước Rc,n và hệ số giảm cường độ theo mức độ nứt nẻ Ks (Bảng 1 TCVN 10304:2025) — Ks = 0,32 (ứng với hạng mục "nứt nẻ mạnh", RQD 50–75%, lấy cận dưới do không có số liệu RQD thật, là giả thiết thận trọng). Điều kiện đủ khả năng chịu tải: γn·Nd ≤ Rk/γk (công thức (2), Điều 7.1.6.1), với γk = 1,4 (xác định bằng tính toán theo bảng tra) và γn = 1,15 (công trình cấp hậu quả C2, đã xác nhận với hồ sơ phân cấp).'));
children.push(p('**Ràng buộc chống nhổ cọc (uplift)** được áp dụng cho cọc thép, dựa trên khảo sát cho thấy 18/360 cọc thép chịu kéo (lực dọc tới xấp xỉ 31 T) dưới tổ hợp bao "BAO KT" (cọc BTCT trong toàn bộ dự án luôn chịu nén, 792/792 trường hợp kiểm tra). Sức chịu tải kéo dùng công thức chỉ tính ma sát thân theo Điều 7.2.2.4, với hệ số γc = 0,8 (do chiều dài ngàm cọc ≥ 4 m); hệ số γk cho trường hợp kéo tra riêng theo Điều 7.1.6.1 (phụ thuộc số lượng cọc trong móng, không phải theo phương pháp xác định như trường hợp nén) — với 192 cọc/phân đoạn (≥ 21 cọc), γk = 1,4, trùng giá trị số với trường hợp nén nhưng khác cơ sở xác định.'));
children.push(p('Vi phạm mọi ràng buộc được chuẩn hóa và tổng hợp thành hàm phạt nhân đồng thời lên cả hai mục tiêu:'));
children.push(eq('Fk(x) = fk(x) × [1 + C×P(x)], k = 1,2', '5'));
children.push(p('với C = 10. Hệ số phạt C = 10 được giữ cố định cho cả hai thuật toán trong toàn bộ thí nghiệm nhằm bảo đảm cùng một quy tắc xử lý vi phạm ràng buộc.'));

children.push(h2('3.5. Mặt Pareto tham chiếu — vét cạn toàn bộ không gian tìm kiếm'));
children.push(p('Không gian thiết kế 4.080 tổ hợp được đánh giá trực tiếp qua cùng mô hình FEM để xây dựng **mặt Pareto tham chiếu của toàn bộ không gian thiết kế khảo sát** — độc lập với quá trình tìm kiếm của hai thuật toán (Mục 5.1), không phụ thuộc vào kết quả tìm kiếm của bất kỳ thuật toán nào — cho phép đối chiếu mỗi thuật toán với chuẩn này, không chỉ đối chiếu hai thuật toán với nhau. Mặt Pareto này chỉ đúng trong phạm vi 4.080 tổ hợp đã khảo sát, không phải mặt Pareto tối ưu tuyệt đối của bài toán liên tục. Toàn bộ 4.080 tổ hợp được đánh giá thành công, xác định 3.337 tổ hợp khả thi (743 tổ hợp bị loại do vi phạm ràng buộc cứng) và **59 nghiệm không bị trội**, trình bày và thảo luận chi tiết ở Mục 6.1.'));

// Muc 4
children.push(h1('4. Hai thuật toán đối sánh'));
children.push(h2('4.1. MOFDA'));
children.push(p('Thuật toán Hướng dòng chảy đa mục tiêu (Multi-Objective Flow Direction Algorithm – MOFDA) [1] là một mở rộng đa mục tiêu của Flow Direction Algorithm (FDA) đơn mục tiêu — thuật toán vật lý mô phỏng dòng chảy nước mưa (runoff) di chuyển về điểm thấp nhất của lưu vực theo địa hình, dùng nguyên lý D8 để xác định hướng lân cận. Mỗi cá thể (dòng chảy) X(i) sinh β vị trí lân cận quanh nó; vị trí mới được cập nhật theo độ dốc cục bộ giữa cá thể và lân cận tốt nhất (leader), kết hợp trọng số suy giảm phi tuyến theo tiến độ vòng lặp để cân bằng thăm dò/khai thác.'));
children.push(p('MOFDA bổ sung vào khung FDA gốc hai cơ chế cho bài toán đa mục tiêu: (i) một **kho lưu trữ ngoài** (external archive) lưu các nghiệm không bị trội, với cơ chế kiểm soát vượt dung lượng dựa trên lưới thích nghi (adaptive grid) chia không gian mục tiêu thành các siêu lập phương (hypercube); (ii) một **chiến lược chọn thủ lĩnh lai** (hybrid leader selection) — đóng góp mới của [1] so với phiên bản MOFDA nguyên bản dùng roulette-wheel selection cổ điển. Chiến lược lai chấm điểm mỗi cá thể trong kho lưu trữ theo:'));
children.push(eq('s_i = GI_i + ε_i/(1+DE_i)'));
children.push(p('trong đó GIi là chỉ số ô lưới, DEi là mật độ cục bộ (số cá thể cùng chia sẻ ô lưới), εi ∈ [0,1] là nhiễu ngẫu nhiên nhỏ duy trì đa dạng; thủ lĩnh được chọn là cá thể có điểm số thấp nhất, ưu tiên vùng thưa nghiệm nhưng có kiểm soát mức ngẫu nhiên nhằm giảm nguy cơ hội tụ sớm so với roulette-wheel selection thuần túy. Ràng buộc được xử lý bằng hàm phạt nhân (tương tự cách tiếp cận của nghiên cứu này, xem Mục 3.3).'));
children.push(p('MOFDA đã được kiểm chứng trên các bộ hàm chuẩn (ZDT, DTLZ, MMF, UF) và một số bài toán kỹ thuật có ràng buộc (giàn, dầm hàn, SRN, OSY), cho kết quả cạnh tranh so với một số thuật toán đa mục tiêu khác trên các chỉ số hội tụ/phân bố phổ biến (IGD/GD/STE). MOFDA cũng đã được áp dụng cho một công trình thực tế — tối ưu khung thép nhà chờ bến phà Đồng Bài, đảo Cát Hải, Hải Phòng, kết nối MATLAB–SAP2000 qua SM Toolbox.'));
children.push(p('**Tham số MOFDA dùng trong nghiên cứu này**: quần thể Np=50, β=4 hướng lân cận/cá thể, dung lượng kho lưu trữ Nr=100, số ô lưới nGrid=10, maxiter=50 vòng lặp — tổng ngân sách đánh giá FEM FE=Np[1+maxiter(β+1)]=12.550.'));

children.push(h2('4.2. MOSFOA (bản chạy: E-MOSFOA)'));
children.push(p('MOSFOA là biến thể đa mục tiêu của Starfish Optimization Algorithm (SFOA) [7] — thuật toán đơn mục tiêu mô phỏng hành vi tìm kiếm của sao biển, gồm cơ chế "arm-twist" (xoay cánh, thăm dò đa chiều), "energy-step" (bước năng lượng, thăm dò chiều thấp) và "preying" (bắt mồi, khai thác dựa trên 5 cá thể lân cận và thủ lĩnh). Nghiên cứu gốc [2] phát triển hai phiên bản đa mục tiêu: **B-MOSFOA** (Base) giữ nguyên các phương trình di chuyển gốc của SFOA, bổ sung kho lưu trữ Pareto ngoài, kiểm soát đa dạng dựa trên lưới thích nghi và chọn thủ lĩnh theo xác suất nghịch mật độ ô lưới Pi=c/Ni; và **E-MOSFOA** (Enhanced) — phiên bản dùng để chạy thực nghiệm trong nghiên cứu này — xây trên nền B-MOSFOA, bổ sung ba cơ chế:'));
children.push(p('1. **Điều khiển pha theo cosine** (cosine-phase control): thay xác suất thăm dò cố định GP0 của SFOA gốc bằng lịch trình giảm mượt'));
children.push(eq('GP = (GP₀/2)·(1 + cos(π·it/Max_it))'));
children.push(p('giúp chuyển đổi thăm dò→khai thác diễn ra liên tục thay vì đột ngột.'));
children.push(p('2. **Đột biến kiểu DE dẫn hướng bởi thủ lĩnh** (leader-guided DE-mutation) kết hợp lai ghép nhị thức (binomial crossover), kích hoạt trong pha thăm dò:'));
children.push(eq('mutanti = Xr1 + F·(Xr2 − Xr3) + λ·(Xleader − Xr1),   F = 0,5·(1 − it/Max_it)'));
children.push(p('với hệ số hút về thủ lĩnh λ=0,3, xác suất lai ghép CR=0,5 — hệ số khuếch đại đột biến F giảm tuyến tính theo tiến độ vòng lặp (bước "energy-step" thích nghi).'));
children.push(p('3. **Tinh chỉnh Gaussian giai đoạn cuối dựa trên kho lưu trữ** (archive-based Gaussian refinement), chỉ kích hoạt trong 20% vòng lặp cuối (it ≥ 0,8·Max_it): chọn cá thể tham chiếu X* = argmin Σj fi,j trong kho lưu trữ rồi tái sinh một phần quần thể quanh X* bằng nhiễu Gauss, trong khi quy tắc trội Pareto vẫn quyết định nghiệm nào được giữ lại.'));
children.push(p('Trên các bộ benchmark IMOP/UF/RM-MEDA, E-MOSFOA đạt kết quả cạnh tranh so với một số thuật toán đa mục tiêu khác trên các chỉ số hội tụ/phân bố, với chi phí đánh giá hàm tương đối thấp trong nhóm so sánh. E-MOSFOA cũng đã được áp dụng cho một công trình thực tế — cảng xăng dầu Hải Linh, Hải Phòng (bến cập tàu, bến neo, cầu tàu chính), kết nối MATLAB–SAP2000.'));
children.push(p('**Tham số E-MOSFOA dùng trong nghiên cứu này**: quần thể Np=50, dung lượng kho lưu trữ Nr=100, số ô lưới nGrid=10, GP0=0,5, λ=0,3, CR=0,5, Max_it=250 vòng lặp — tổng ngân sách đánh giá FEM FE=Np(Max_it+1)=12.550, khớp chính xác với ngân sách MOFDA (Mục 4.1) do Max_it=5×maxiter.'));

children.push(h2('4.3. Ngân sách đánh giá công bằng'));
children.push(p('Hai thuật toán có cơ chế cập nhật và cấu trúc vòng lặp khác nhau: MOFDA dùng Np=50, maxiter=50, β=4; E-MOSFOA dùng Np=50, Max_it=250 — số vòng lặp của hai thuật toán KHÔNG bằng nhau và không nên coi là đơn vị so sánh trực tiếp. Để bảo đảm công bằng về chi phí tính toán, hai thuật toán được so sánh trên cùng ngân sách đánh giá mô hình FEM, FE=12.550 lần/lần chạy — số vòng lặp được thiết lập riêng theo cơ chế cập nhật của từng thuật toán để đạt cùng ngân sách này (Max_it=5×maxiter do mỗi vòng lặp MOFDA thực hiện β+1=5 lần đánh giá/cá thể trong khi mỗi vòng lặp E-MOSFOA thực hiện 1 lần). FE được dùng làm đơn vị chung để đánh giá chi phí tìm kiếm vì mỗi lần đánh giá đòi hỏi thực hiện một lần phân tích mô hình FEM SAP2000 — bước chiếm phần lớn thời gian tính toán của toàn hệ thống. Hai thuật toán còn thiết lập chung: cùng hệ thống đánh giá MATLAB–SAP2000 (hàm mục tiêu, ràng buộc, cơ chế lưu trữ Pareto archive/grid, rời rạc hoá biến thiết kế), cùng Nr=100, cùng nGrid=10, cùng N=30 lần chạy độc lập/thuật toán.'));

// Muc 5
children.push(h1('5. Phương pháp đối sánh'));
children.push(h2('5.1. Mặt Pareto tham chiếu'));
children.push(p('Mặt Pareto thu được bằng vét cạn toàn bộ 4.080 tổ hợp (Mục 3.5) đóng vai trò **chuẩn đối chiếu độc lập** cho cả hai thuật toán — điểm mạnh trung tâm của phép đối sánh: cả MOFDA và E-MOSFOA đều được đối chiếu với cùng một mặt Pareto tham chiếu, thay vì chỉ so sánh trực tiếp hai tập kết quả với nhau.'));
children.push(h2('5.2. Quy trình thực nghiệm'));
children.push(p('Mỗi thuật toán được thực hiện 30 lần chạy độc lập với các hạt giống ngẫu nhiên khác nhau, cùng ngân sách đánh giá mô hình FEM FE = 12.550/lần chạy (MOFDA: Np=50, β=4, maxiter=50; MOSFOA/E-MOSFOA: Np=50, Max_it=250 — số vòng lặp khác nhau nhưng cùng ngân sách FE, xem Mục 4.3), trên cùng hệ thống đánh giá MATLAB–SAP2000 (cùng hàm mục tiêu, cùng ràng buộc, cùng cơ chế lưu trữ nghiệm Pareto archive/grid, cùng cách rời rạc hoá biến thiết kế). Kết quả giữa hai nhóm được so sánh bằng kiểm định Wilcoxon rank-sum hai phía với mức ý nghĩa α = 0,05.'));
children.push(h2('5.3. Bộ chỉ số đối sánh'));
children.push(p('Bộ chỉ số ưu tiên trong bài chính: **IGD** (inverted generational distance, chuẩn hoá theo min-max của mặt Pareto tham chiếu để tránh so sánh trực tiếp hai mục tiêu có thang đo khác nhau — khối lượng ~10³ tấn so với chuyển vị ~10⁻² m), **HV** (hypervolume, sử dụng cùng một điểm tham chiếu cố định cho mọi lần chạy của cả hai thuật toán), **Pareto coverage** và **kiểm định Wilcoxon rank-sum** (α=0,05) để xác định ý nghĩa thống kê của khác biệt quan sát được. GD (generational distance) được giữ lại ở Mục 6 vì bổ sung thông tin không trùng lặp hoàn toàn với IGD trong trường hợp này (xem Mục 6.4.1).'));
children.push(p('**Định nghĩa Pareto coverage** — dùng tiêu chí so khớp trên fitness trong ngưỡng sai số 10⁻⁶ để chống ảnh hưởng của sai số dấu phẩy động (cố định trước khi chạy và không điều chỉnh theo kết quả quan sát được), để xác định một nghiệm tham chiếu là "được tìm thấy" khi có ít nhất một nghiệm trong kho lưu trữ khớp với nó trong ngưỡng này. Vì kho lưu trữ (archive) có dung lượng tối đa 100 nghiệm trong khi mặt Pareto tham chiếu chỉ có 59 nghiệm (Mục 3.5), Pareto coverage được định nghĩa trên số nghiệm tham chiếu **phân biệt** được tìm thấy, không phải số mục trong kho lưu trữ khớp với tham chiếu:'));
children.push(eq('Pareto coverage (%) = [số nghiệm PHÂN BIỆT thuộc mặt Pareto tham chiếu (59 nghiệm) được tìm thấy] / 59 × 100%'));

// Muc 6
children.push(h1('6. Kết quả và thảo luận'));
children.push(h2('6.1. Mặt Pareto tham chiếu'));
children.push(p('Vét cạn toàn bộ 4.080 tổ hợp thiết kế theo hệ ràng buộc nêu tại Mục 3.4 xác định được **3.337/4.080 tổ hợp khả thi** (743 tổ hợp bị loại do vi phạm hình học/ràng buộc cứng), trong đó **59 nghiệm không bị trội** tạo thành mặt Pareto tham chiếu chính thức. Khối lượng vật liệu dao động **3.317,3–5.189,4 tấn**, chuyển vị ngang lớn nhất dao động **9,83–16,27 mm** — đều thấp hơn nhiều giới hạn cho phép theo TCVN 11820-5:2021.'));
children.push(p('**Kiểm chứng hiện tượng "dồn biên" (boundary clustering)** — được nêu là giả thuyết cần kiểm chứng lại (Mục 3.1), kiểm tra trực tiếp trên dữ liệu chính thức, không giả định trước:'));
children.push(caption('Bảng 2. Kiểm chứng hiện tượng dồn biên trên 59 nghiệm Pareto tham chiếu chính thức'));
children.push(makeTable(
  ['Biến thiết kế', 'Miền khảo sát', 'Số nghiệm tại đúng cận trên', 'Số nghiệm trong 5% dải sát cận trên', 'Số nghiệm tại/gần cận dưới'],
  [
    ['CatIdx_BTCT (1=D600...5=D1000)', '[1, 5]', '18/59 (30,5%)', '18/59 (30,5%)', '0'],
    ['D_thép (m)', '[0,800; 1,300]', '17/59 (28,8%)', '41/59 (69,5%)', '0'],
    ['t_thép (m)', '[0,010; 0,025]', '2/59 (3,4%)', '2/59 (3,4%)', '0'],
  ], USABLE));
children.push(new Paragraph({ spacing: { before: 120, after: 160 }, children: [] }));
children.push(p('Số liệu chính thức **cho thấy rõ hiện tượng dồn biên đối với đường kính cọc thép (D_thép)**: gần 70% nghiệm Pareto nằm trong 5% dải sát cận trên của miền khảo sát (1,275–1,300 m), và không có nghiệm nào gần cận dưới. Dồn biên tương tự nhưng yếu hơn quan sát được ở CatIdx_BTCT (30,5% tại cận trên, tức dòng D1000). Ngược lại, chiều dày cọc thép (t_thép) phân bố trải đều trong miền khảo sát, không thể hiện dồn biên rõ rệt. Kết quả cho thấy các nghiệm Pareto có xu hướng tập trung về cận trên của D_thép; do đó, chưa thể loại trừ khả năng miền khảo sát hiện tại chưa bao quát hết vùng đánh đổi ở phía đường kính lớn hơn. Hiện tượng này được xử lý như một giới hạn của phạm vi khảo sát trong nghiên cứu, thảo luận thêm ở Mục 6.5.'));
children.push(image(fig2, 500, 382));
children.push(caption('Hình 2. Mặt Pareto tham chiếu gồm 59 nghiệm trên nền các tổ hợp khả thi.'));

children.push(h2('6.2–6.3. Kết quả từng thuật toán (30 lần chạy độc lập, Np=50, FE=12.550/lần)'));
children.push(p('Do dung lượng kho lưu trữ (archive) được đặt bằng 100, trong khi mặt Pareto tham chiếu gồm 59 nghiệm (Mục 3.5), repository cuối cùng của mỗi lần chạy có thể chứa cả các nghiệm không thuộc mặt Pareto tham chiếu; vì vậy khả năng bao phủ mặt Pareto (Pareto coverage, định nghĩa ở Mục 5.3) được đánh giá riêng trên 59 nghiệm tham chiếu, không tính theo kích thước kho lưu trữ.'));
children.push(caption('Bảng 3. Thống kê 30 lần chạy độc lập của MOFDA và E-MOSFOA'));
children.push(makeTable(
  ['Chỉ số', 'MOFDA (Np=50, maxiter=50)', 'E-MOSFOA (Np=50, Max_it=250)'],
  [
    ['GD (chuẩn hoá)', '0,000031 ± 0,000081', '0,000000 ± 0,000000'],
    ['IGD (chuẩn hoá)', '0,000506 ± 0,000182', '0,000100 ± 0,000074'],
    ['HV (W cố định = [70.340,29 tấn; 0,631374 m])', '41.654,0150 ± 0,0064', '41.654,0214 ± 0,0002'],
    ['Kích thước kho lưu trữ (repository)', '100,0 ± 0,0', '100,0 ± 0,0'],
    ['Pareto coverage (số nghiệm phân biệt/59 nghiệm tham chiếu)', '52,67 ± 2,63 (89,27% ± 4,46%)', '58,27 ± 0,52 (98,76% ± 0,88%)'],
  ], USABLE));
children.push(new Paragraph({ spacing: { before: 120, after: 160 }, children: [] }));
children.push(p('Cả hai thuật toán đều đạt kho lưu trữ đầy (100 nghiệm/lần chạy). Về khả năng bao phủ mặt Pareto tham chiếu (59 nghiệm), E-MOSFOA đạt trung bình 58,27/59 (98,76% ± 0,88%) — gần đầy đủ nhưng không tuyệt đối ở mọi lần chạy. MOFDA đạt trung bình 52,67/59 (89,27% ± 4,46%) — thấp hơn và biến động giữa các lần chạy lớn hơn. Trong bài toán khảo sát, cả hai thuật toán đều đạt mức bao phủ cao, trong đó E-MOSFOA cho kết quả cao hơn và ổn định hơn.'));

children.push(h2('6.4. Đối sánh trực tiếp MOFDA và E-MOSFOA'));
children.push(h3('6.4.1. Kiểm định Wilcoxon rank-sum (30 vs 30, α = 0,05)'));
children.push(caption('Bảng 4. Kiểm định Wilcoxon rank-sum MOFDA và E-MOSFOA'));
children.push(makeTable(
  ['Chỉ số', 'MOFDA (TB±ĐLC)', 'E-MOSFOA (TB±ĐLC)', 'p-value', 'Kết luận'],
  [
    ['GD', '0,000031 ± 0,000081', '0,000000 ± 0,000000', '0,0419', 'Khác biệt có ý nghĩa thống kê ở α=0,05, mức độ khác biệt thực tế nhỏ (cả hai gần 0)'],
    ['IGD', '0,000506 ± 0,000182', '0,000100 ± 0,000074', '1,07×10⁻¹⁰', 'Khác biệt có ý nghĩa thống kê; E-MOSFOA có IGD thấp hơn'],
    ['HV', '41.654,0150 ± 0,0064', '41.654,0214 ± 0,0002', '6,53×10⁻¹¹', 'Khác biệt có ý nghĩa thống kê; chênh lệch tuyệt đối rất nhỏ, cả hai đạt gần vùng ổn định'],
    ['Pareto coverage (/59)', '52,67 ± 2,63', '58,27 ± 0,52', '3,14×10⁻¹¹', 'Khác biệt có ý nghĩa thống kê'],
  ], USABLE));
children.push(new Paragraph({ spacing: { before: 120, after: 160 }, children: [] }));
children.push(p('Trong bài toán cầu tàu container 100.000 DWT được khảo sát, kiểm định Wilcoxon rank-sum (α=0,05) cho thấy khác biệt có ý nghĩa thống kê ở cả 4 chỉ số. Đối với **IGD**, E-MOSFOA đạt giá trị trung bình thấp hơn MOFDA khoảng 5 lần (0,000100 so với 0,000506) — đây là chỉ số phản ánh rõ nhất mức độ gần mặt Pareto tham chiếu trong thí nghiệm này. Đối với **HV**, khác biệt có ý nghĩa thống kê nhưng chênh lệch tuyệt đối rất nhỏ do cả hai thuật toán đều đạt gần vùng ổn định — không nên dùng riêng p-value của HV để suy ra mức độ ưu thế kỹ thuật lớn. Đối với **GD**, khác biệt có ý nghĩa ở α=0,05 (p≈0,042) nhưng mức độ khác biệt thực tế nhỏ vì cả hai thuật toán đã gần 0; GD được giữ lại (Mục 5.3) vì vẫn cho thấy E-MOSFOA đạt giá trị 0 tuyệt đối (std=0) mà IGD chuẩn hoá không thể hiện rõ bằng. Đối với **Pareto coverage**, E-MOSFOA đạt trung bình cao hơn và ổn định hơn (98,76% ± 0,88% so với 89,27% ± 4,46%), khác biệt có ý nghĩa thống kê rất mạnh. Trọng tâm của phép đối sánh trong nghiên cứu này đặt vào **IGD và tốc độ hội tụ theo số lần đánh giá FE** (Mục 6.4.2) hơn là chênh lệch HV cuối cùng, vì đây là các chỉ số phân biệt rõ nhất hai thuật toán trong thí nghiệm.'));

children.push(h3('6.4.2. Tốc độ hội tụ theo số lần đánh giá FEM (FE)'));
children.push(p('Đường cong IGD/HV trung bình theo FE (30 lần chạy/thuật toán, dải ±1 độ lệch chuẩn) được dựng từ kho lưu trữ Pareto ghi lại tại mỗi vòng lặp trong quá trình chạy, dùng cùng điểm tham chiếu HV cố định cho cả hai thuật toán để bảo đảm so sánh được trực tiếp (Hình 3).'));
children.push(image(fig3, 520, 416));
children.push(caption('Hình 3. Đường cong hội tụ IGD và HV theo số lần đánh giá FEM.'));
children.push(p('**E-MOSFOA đạt vùng ổn định của HV sớm hơn trong cùng ngân sách FE**: E-MOSFOA đạt vùng ổn định của HV (~41.654) sau khoảng 1.000–1.500 lần đánh giá FEM, trong khi MOFDA đạt vùng ổn định tương đương sau khoảng 5.000–7.000 lần đánh giá FEM. Đơn vị so sánh ở đây là FE (số lần đánh giá mô hình FEM) — không so sánh theo số vòng lặp vì hai thuật toán có cấu trúc iteration khác nhau (Mục 4.3).'));
children.push(p('Đường IGD trung bình của E-MOSFOA nằm dưới đường của MOFDA trong suốt quá trình tìm kiếm, nhất quán với kết quả tổng hợp ở Mục 6.4.1.'));
children.push(p('Cả hai thuật toán đều hội tụ về cùng một vùng nghiệm (HV cuối cùng chênh lệch không đáng kể về mặt tuyệt đối). **Khác biệt nổi bật giữa hai thuật toán thể hiện ở tốc độ hội tụ; đồng thời E-MOSFOA cũng cho khả năng bao phủ mặt Pareto tham chiếu cao hơn trong thí nghiệm này** (Mục 6.4.1).'));

children.push(h3('6.4.3. Nhận xét cơ chế'));
children.push(p('Tốc độ hội tụ nhanh hơn của E-MOSFOA quan sát được ở Mục 6.4.2 phù hợp với giả thuyết rằng cơ chế điều khiển pha cosine (Mục 4.2) — chuyển pha thăm dò→khai thác được điều khiển tường minh và mượt theo hàm cosine ngay từ đầu quá trình tìm kiếm, khác với trọng số suy giảm phi tuyến của MOFDA (Mục 4.1) vốn phụ thuộc nhiều vào thành phần ngẫu nhiên ở mỗi vòng lặp — có thể góp phần vào khác biệt này. Đột biến kiểu DE dẫn hướng thủ lĩnh và tinh chỉnh Gaussian giai đoạn cuối của E-MOSFOA cũng có thể góp phần giúp thuật toán bám sát nhanh mặt Pareto một khi đã xác định được vùng lân cận tốt. Đây là nhận xét định hướng dựa trên đối chiếu cơ chế đã mô tả ở Mục 4 với số liệu thực nghiệm quan sát được. **Đây không phải là phân tích độ nhạy riêng cho từng cơ chế** — không khẳng định cơ chế nào là nguyên nhân duy nhất hay đã được kiểm chứng tách biệt.'));

children.push(h2('6.5. Giới hạn nghiên cứu'));
const limits = [
  'Kết quả cho thấy các nghiệm Pareto có xu hướng tập trung về cận trên của D_thép (Mục 6.1, và ở mức độ thấp hơn là CatIdx_BTCT); do đó, chưa thể loại trừ khả năng miền khảo sát hiện tại chưa bao quát hết vùng đánh đổi ở phía đường kính lớn hơn. Kết quả đối sánh thuật toán (Mục 6.4) vẫn có giá trị vì cả hai thuật toán được đánh giá trên cùng mặt Pareto tham chiếu và cùng miền khảo sát, nhưng phạm vi khái quát hoá kết quả tuyệt đối (giá trị khối lượng/chuyển vị cụ thể) cần thận trọng.',
  'Ràng buộc địa kỹ thuật còn một giả thiết chưa được xác nhận đầy đủ bằng số liệu khảo sát thật: hệ số giảm cường độ theo nứt nẻ Ks = 0,32 cho Lớp 11 (giả thiết do thiếu số liệu RQD thật). Hệ số cấp hậu quả công trình γn = 1,15 (cấp C2) đã được xác nhận với hồ sơ phân cấp, không còn là giả thiết mở.',
  'Không xét hiệu ứng nhóm cọc — mỗi cọc được kiểm tra sức chịu tải địa kỹ thuật đơn lẻ.',
  'Tổ hợp bão riêng nằm ngoài phạm vi tổ hợp bao "BAO KT" được dùng trong đợt tính toán tối ưu.',
  'Mô hình chỉ xét phân tích tuyến tính tĩnh, chưa xét tương tác đất–cọc chi tiết kiểu p–y.',
];
limits.forEach(t => children.push(new Paragraph({
  bullet: { level: 0 },
  spacing: { after: 120, line: 300 },
  alignment: AlignmentType.JUSTIFIED,
  children: parseInline(t),
})));
children.push(p('Các giới hạn này không làm mất giá trị của phép đối sánh thuật toán trong cùng miền bài toán, nhưng hạn chế phạm vi khái quát hóa các giá trị thiết kế tuyệt đối.'));

// Muc 7
children.push(h1('7. Kết luận'));
children.push(p('Bài báo đã đối sánh hai thuật toán tối ưu đa mục tiêu MOFDA và MOSFOA (bản thực nghiệm E-MOSFOA) — được phát triển và báo cáo trong các nghiên cứu [1], [2], mỗi thuật toán đã được kiểm chứng trên một công trình khác nhau — trên cùng một bài toán, cùng mô hình FEM, cùng hàm mục tiêu, cùng ràng buộc và cùng ngân sách đánh giá FEM cho thiết kế tiết diện hệ cọc cầu tàu container 100.000 DWT thực tế. Các kết luận chính gồm:'));
children.push(p('(1) Đã hình thành bài toán tối ưu rời rạc cho tiết diện hệ cọc với không gian thiết kế gồm 4.080 tổ hợp và hệ ràng buộc gồm các điều kiện kết cấu, địa kỹ thuật theo TCVN 10304:2025 và chống nhổ cọc.'));
children.push(p('(2) Vét cạn toàn bộ 4.080 tổ hợp xác định mặt Pareto tham chiếu của toàn bộ không gian thiết kế khảo sát, gồm 59 nghiệm, dùng làm chuẩn đối chiếu bên ngoài — không phụ thuộc kết quả tìm kiếm của thuật toán nào — cho cả hai thuật toán. Số liệu chính thức cho thấy rõ hiện tượng dồn biên (boundary clustering) đối với đường kính cọc thép — gần 70% nghiệm Pareto nằm sát cận trên miền khảo sát; do đó, chưa thể loại trừ khả năng miền khảo sát hiện tại chưa bao quát hết vùng đánh đổi ở phía đường kính lớn hơn — đây là một giới hạn của phạm vi khảo sát cần lưu ý khi khái quát hoá kết quả tuyệt đối.'));
children.push(p('(3) Trong bài toán cầu tàu container 100.000 DWT được khảo sát, E-MOSFOA đạt IGD thấp hơn MOFDA (0,000100 so với 0,000506; kiểm định Wilcoxon rank-sum p=1,07×10⁻¹⁰) và cho tốc độ hội tụ nhanh hơn khi đánh giá theo số lần phân tích FEM (đạt vùng ổn định của hypervolume sau khoảng 1.000–1.500 lần đánh giá FEM, so với khoảng 5.000–7.000 lần của MOFDA). Đồng thời, E-MOSFOA đạt khả năng bao phủ mặt Pareto tham chiếu cao hơn và ổn định hơn (98,76% ± 0,88% so với 89,27% ± 4,46%, tính trên 59 nghiệm tham chiếu; p=3,14×10⁻¹¹).'));
children.push(p('(4) Kết quả này cho thấy E-MOSFOA là lựa chọn có lợi về tốc độ hội tụ đối với bài toán khảo sát, trong khi không đủ cơ sở để khẳng định ưu thế phổ quát của thuật toán đối với các bài toán kết cấu khác. Trong bối cảnh ngân sách đánh giá FEM là yếu tố chi phối thời gian thực nghiệm (do chi phí tính toán SAP2000 lặp lại), kết quả này cung cấp cơ sở định lượng để tham khảo khi lựa chọn thuật toán tối ưu cho các bài toán thiết kế tiết diện hệ cọc công trình cảng biển có điều kiện tương tự. Kết quả chỉ được diễn giải trong phạm vi bài toán, miền thiết kế và mô hình tính toán đã khảo sát.'));
children.push(p('Trước khi áp dụng kết quả tối ưu (khối lượng/chuyển vị cụ thể của các nghiệm Pareto) cho thiết kế chính thức, cần lưu ý các giới hạn nêu ở Mục 6.5, đặc biệt là khả năng miền khảo sát chưa bao quát hết vùng đánh đổi ở phía đường kính lớn của D_thép, giả thiết Ks = 0,32 cho Lớp 11 (thiếu số liệu RQD thật) cần xác nhận lại với số liệu đầy đủ hơn, và giới hạn về hiệu ứng nhóm cọc chưa được xét.'));

children.push(h1('Lời cảm ơn'));
children.push(p('(nếu có)'));

children.push(h1('TÀI LIỆU THAM KHẢO'));
const refs = [
  'Vu-Huu, T., S. Khatir, and T. Cuong-Le, *Real-World Steel Frame Optimization Using a Hybrid Leader Selection-Based Multi-Objective Flow Direction Algorithm.* International Journal for Numerical Methods in Engineering, 2025. 126(15): p. e70098. https://doi.org/10.1002/nme.70098',
  'Do-Quang, T., T. Vu-Huu, and C.T. Le, *Multi-objective Optimization of Marine Structures Using an Enhanced Starfish Algorithm.* Proceedings of the Institution of Civil Engineers – Structures and Buildings, 2026. https://doi.org/10.1680/jstbu.26.00159',
  'AMACCAO PILE (2014), *Catalogue và thông số kỹ thuật cọc bê tông ly tâm AMACCAO D300-D1200*, theo TCVN 7888:2014 và JIS A 5373:2016.',
  'Bộ Khoa học và Công nghệ (2021), *TCVN 11820-5:2021 — Công trình cảng biển – Yêu cầu thiết kế – Phần 5: Công trình bến*.',
  'Viện Tiêu chuẩn Chất lượng Việt Nam (2025), *TCVN 10304:2025 (Xuất bản lần 2) — Thiết kế móng cọc*.',
  'Bộ Khoa học và Công nghệ, *TCVN 9245:2012 — Cọc ống thép*.',
  'Zhong, C., et al., *Starfish optimization algorithm (SFOA): a bio-inspired metaheuristic algorithm for global optimization compared with 100 optimizers.* Neural Computing and Applications, 2025(5): p. 3641-3683.',
];
refs.forEach((r, i) => children.push(new Paragraph({
  spacing: { after: 160, line: 300 },
  alignment: AlignmentType.JUSTIFIED,
  indent: { left: 480, hanging: 480 },
  children: [new TextRun({ text: `[${i + 1}] `, font: FONT, size: SZ }), ...parseInline(r)],
})));

children.push(p('Ngày nhận bài: xx/xx/2026'));
children.push(p('Ngày nhận bản sửa: xx/xx/2026'));
children.push(p('Ngày duyệt đăng: xx/xx/2026'));

// ---------- document ----------
const doc = new Document({
  styles: {
    default: {
      document: { run: { font: FONT, size: SZ } },
      heading1: { run: { font: FONT, size: 28, bold: true, color: '000000' }, paragraph: { spacing: { before: 320, after: 160 } } },
      heading2: { run: { font: FONT, size: 26, bold: true, color: '000000' }, paragraph: { spacing: { before: 240, after: 120 } } },
      heading3: { run: { font: FONT, size: 26, bold: true, italics: true, color: '000000' }, paragraph: { spacing: { before: 200, after: 100 } } },
    },
  },
  sections: [{
    properties: {
      page: {
        size: { width: PAGE_W, height: PAGE_H },
        margin: { top: MARGIN, bottom: MARGIN, left: MARGIN, right: MARGIN },
      },
    },
    children: children,
  }],
});

Packer.toBuffer(doc).then(buf => {
  const outPath = path.join(__dirname, 'BAI_BAO_MOFDA_MOSFOA_DOI_SANH.docx');
  fs.writeFileSync(outPath, buf);
  console.log('Da tao:', outPath);
});
