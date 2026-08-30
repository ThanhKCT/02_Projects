const fs = require('fs');
const {
  Document, Packer, Paragraph, TextRun, HeadingLevel, AlignmentType,
  Table, TableRow, TableCell, WidthType, BorderStyle, ShadingType,
  SectionType, Header, Footer, PageNumber, VerticalAlign, TabStopType, TabStopPosition
} = require('docx');

// ===== Mau sac / font theo dung style JMST that (trich tu styles.xml) =====
const MAROON = '990033';
const FONT = 'Times New Roman';

// ----- Helper builders khop dung tung style JMST -----
function pTitleVN(text) {
  return new Paragraph({
    alignment: AlignmentType.CENTER,
    spacing: { before: 80, after: 80 },
    children: [new TextRun({ text, bold: true, size: 26, font: FONT })],
  });
}
function pTitleEN(text) {
  return new Paragraph({
    alignment: AlignmentType.CENTER,
    spacing: { before: 60, after: 80 },
    children: [new TextRun({ text, size: 26, font: FONT })],
  });
}
function pAuthorName(runs) {
  return new Paragraph({ alignment: AlignmentType.CENTER, spacing: { before: 40, after: 40 }, children: runs });
}
function pAuthorAddEmail(text, opts = {}) {
  return new Paragraph({
    alignment: AlignmentType.CENTER,
    spacing: { before: 40, after: 40 },
    children: [new TextRun({ text, italics: true, size: 24, font: FONT, ...opts })],
  });
}
function pAbstractLabel(text) {
  return new Paragraph({
    spacing: { before: 80, after: 40 },
    children: [new TextRun({ text, bold: true, size: 22, font: FONT })],
  });
}
function pAbstractBody(text) {
  return new Paragraph({
    alignment: AlignmentType.JUSTIFIED,
    spacing: { before: 40, after: 40 },
    children: [new TextRun({ text, italics: true, size: 20, font: FONT })],
  });
}
function pKeywords(label, text) {
  return new Paragraph({
    spacing: { before: 40, after: 80 },
    children: [
      new TextRun({ text: label + ': ', bold: true, size: 20, font: FONT }),
      new TextRun({ text, italics: true, size: 20, font: FONT }),
    ],
  });
}
function pSectionTitle(text) {
  return new Paragraph({
    spacing: { before: 160, after: 80 },
    children: [new TextRun({ text, bold: true, size: 22, font: FONT, color: MAROON })],
  });
}
function pSubTitle(text) {
  return new Paragraph({
    spacing: { before: 120, after: 80 },
    children: [new TextRun({ text, bold: true, italics: true, size: 22, font: FONT, color: MAROON })],
  });
}
function pBody(text, opts = {}) {
  return new Paragraph({
    alignment: AlignmentType.JUSTIFIED,
    spacing: { before: 40, after: 40 },
    indent: { firstLine: 284 },
    children: Array.isArray(text) ? text : [new TextRun({ text, size: 20, font: FONT, ...opts })],
  });
}
function pBodyNoIndent(children) {
  return new Paragraph({
    alignment: AlignmentType.JUSTIFIED,
    spacing: { before: 40, after: 40 },
    children,
  });
}
function pEquation(text, num) {
  return new Paragraph({
    spacing: { before: 80, after: 80 },
    tabStops: [{ type: TabStopType.RIGHT, position: TabStopPosition.MAX }],
    children: [
      new TextRun({ text: '    ' + text, size: 20, font: FONT, italics: true }),
      new TextRun({ text: '\t(' + num + ')', size: 20, font: FONT }),
    ],
  });
}
function pTableTitle(text) {
  return new Paragraph({
    alignment: AlignmentType.CENTER,
    spacing: { before: 60, after: 60 },
    children: [new TextRun({ text, bold: true, italics: true, size: 18, font: FONT })],
  });
}
function pSource(text) {
  return new Paragraph({
    alignment: AlignmentType.RIGHT,
    spacing: { before: 20, after: 20 },
    children: [new TextRun({ text, italics: true, size: 18, font: FONT })],
  });
}
function pFigPlaceholder(text) {
  // Dung bang 1 o co vien thay vi border cua Paragraph -- docx-js sap xep lai
  // thu tu phan tu border cua Paragraph theo mot thu tu co dinh (top,bottom,
  // left,right) khac chuan OOXML (can top,left,bottom,right), gay loi validate
  // XSD. Border cua Table/TableCell thi serialize dung thu tu, nen dung bang.
  // Rong 4200 DXA (~2.9") de vua 1 cot bao 2 cot (khong phai bang rong toan
  // trang -- nhung bang rong dung section rieng 1-cot, xem duoi).
  return new Table({
    width: { size: 4200, type: WidthType.DXA },
    columnWidths: [4200],
    borders: {
      top: { style: BorderStyle.SINGLE, size: 6, color: 'FF0000' },
      left: { style: BorderStyle.SINGLE, size: 6, color: 'FF0000' },
      bottom: { style: BorderStyle.SINGLE, size: 6, color: 'FF0000' },
      right: { style: BorderStyle.SINGLE, size: 6, color: 'FF0000' },
    },
    rows: [new TableRow({ children: [new TableCell({
      width: { size: 4200, type: WidthType.DXA },
      margins: { top: 100, left: 100, bottom: 100, right: 100 },
      children: [new Paragraph({
        alignment: AlignmentType.CENTER,
        children: [new TextRun({ text, bold: true, color: 'FF0000', size: 20, font: FONT })],
      })],
    })] })],
  });
}
function pFigTitle(text) {
  return new Paragraph({
    alignment: AlignmentType.CENTER,
    spacing: { before: 40, after: 160 },
    children: [new TextRun({ text, bold: true, italics: true, size: 18, font: FONT })],
  });
}
function pRefTitle(text) {
  return new Paragraph({
    spacing: { before: 160, after: 80 },
    children: [new TextRun({ text, bold: true, size: 22, font: FONT, color: MAROON, underline: {} })],
  });
}
function pRef(text) {
  return new Paragraph({
    alignment: AlignmentType.JUSTIFIED,
    spacing: { before: 20, after: 20 },
    indent: { left: 284, hanging: 284 },
    children: [new TextRun({ text, size: 20, font: FONT })],
  });
}

function dataCell(text, opts = {}) {
  return new TableCell({
    width: { size: opts.width || 1000, type: WidthType.DXA },
    verticalAlign: VerticalAlign.CENTER,
    shading: opts.header ? { type: ShadingType.CLEAR, fill: 'DEEAF6' } : undefined,
    margins: { top: 40, left: 60, bottom: 40, right: 60 },
    children: [new Paragraph({
      alignment: AlignmentType.CENTER,
      children: [new TextRun({ text: String(text), size: 18, font: FONT, bold: !!opts.header, italics: !!opts.italic })],
    })],
  });
}

function buildTable(headers, rows, colWidths) {
  return new Table({
    width: { size: colWidths.reduce((a, b) => a + b, 0), type: WidthType.DXA },
    columnWidths: colWidths,
    borders: {
      top: { style: BorderStyle.SINGLE, size: 4 }, left: { style: BorderStyle.SINGLE, size: 4 },
      bottom: { style: BorderStyle.SINGLE, size: 4 }, right: { style: BorderStyle.SINGLE, size: 4 },
      insideHorizontal: { style: BorderStyle.SINGLE, size: 2 }, insideVertical: { style: BorderStyle.SINGLE, size: 2 },
    },
    rows: [
      new TableRow({ children: headers.map((h, i) => dataCell(h, { header: true, width: colWidths[i] })) }),
      ...rows.map(r => new TableRow({ children: r.map((c, i) => dataCell(c, { width: colWidths[i] })) })),
    ],
  });
}

// =========================================================================
// NOI DUNG BAI BAO
// =========================================================================
const section1Children = [
  pTitleVN('TỐI ƯU HÓA ĐA MỤC TIÊU TIẾT DIỆN CỌC CẦU TÀU CONTAINER 100.000 DWT BẰNG THUẬT TOÁN MOFDA'),
  pTitleEN('MULTI-OBJECTIVE OPTIMIZATION OF PILE CROSS-SECTIONS FOR A 100,000-DWT CONTAINER WHARF USING THE MOFDA ALGORITHM'),
  pAuthorName([
    new TextRun({ text: '[Họ và tên tác giả]', bold: true, size: 24, font: FONT }),
    new TextRun({ text: '1*', bold: true, size: 24, font: FONT, superScript: true }),
  ]),
  pAuthorAddEmail('1[Tên Khoa/Viện], [Tên trường/đơn vị công tác]'),
  pAuthorAddEmail('*Email liên hệ: [điền địa chỉ email liên hệ chính thức của tác giả]'),
  pAuthorAddEmail('DOI: https://doi.org/10.65154/jmst.%ID', { italics: false }),

  pAbstractLabel('Tóm tắt'),
  pAbstractBody('Cầu tàu container trên nền cọc có khối lượng vật liệu cọc lớn, trong khi thiết kế hiện hành thường chọn tiết diện theo kinh nghiệm, chưa khai thác bài toán tối ưu có ràng buộc. Bài báo ứng dụng thuật toán MOFDA (Multi-Objective Flow Direction Algorithm), đã công bố và kiểm chứng, để tối ưu tiết diện hệ cọc (bê tông ly tâm dự ứng lực và ống thép) của một cầu tàu container 100.000 DWT thực tế. Biến thiết kế gồm chỉ số catalogue cọc bê tông ly tâm (3 lựa chọn theo TCVN 7888:2014) và kích thước cọc thép rời rạc hóa, tạo không gian 243 tổ hợp. Hai mục tiêu là khối lượng vật liệu cọc và chuyển vị ngang lớn nhất, đánh giá qua mô hình SAP2000 kết nối MATLAB qua OAPI, chạy song song 8 tiến trình. Do không gian nhỏ, toàn bộ 243 tổ hợp được liệt kê để xác định mặt Pareto thật (16 nghiệm) đối chiếu. MOFDA tìm được 14 nghiệm không bị trội, trong đó 8/16 trùng khớp chính xác mặt Pareto thật, xác nhận thuật toán hội tụ đúng hướng dù chưa bao phủ hết không gian tối ưu. Khối lượng vật liệu dao động 3.030,6–4.298,3 tấn ứng chuyển vị 11,9–13,9 mm, thấp hơn nhiều giới hạn 71,7 mm theo TCVN 11820-5:2021. Nghiên cứu cung cấp cơ sở định lượng cho lựa chọn tiết diện cọc bến cảng, minh chứng khả năng áp dụng MOFDA với mô hình FEM thật.'),
  pKeywords('Từ khóa', 'tối ưu đa mục tiêu, thuật toán MOFDA, tiết diện cọc, cầu tàu trên nền cọc, kết nối SAP2000-MATLAB'),

  pAbstractLabel('Abstract'),
  pAbstractBody('Container wharves on pile foundations require large quantities of pile material, yet current practice typically sizes pile cross-sections by experience followed by verification, rather than through systematic constrained optimization. This paper applies the Multi-Objective Flow Direction Algorithm (MOFDA), a previously published and validated algorithm, to optimize the pile cross-sections (prestressed spun concrete piles and steel pipe piles) of a real 100,000-DWT container wharf in Vietnam. The design variables comprise a catalogue index for the concrete pile (three choices per TCVN 7888:2014) and steel pile dimensions discretized on a fixed grid, yielding a search space of 243 combinations. The two objectives are pile material mass and the maximum lateral displacement under the governing load envelope, evaluated through a SAP2000 finite-element model coupled to MATLAB via OAPI, executed in parallel across eight instances. Because the discrete search space is small, all 243 combinations were exhaustively enumerated to establish the true Pareto front (16 solutions), used as ground truth. MOFDA found 14 non-dominated solutions, of which 8 of 16 exactly matched the true Pareto front, confirming correct convergence despite a budget insufficient to recover the full optimal set. Pile material mass ranged from 3,030.6 to 4,298.3 tonnes against lateral displacements of 11.9-13.9 mm, well below the 71.7 mm allowable limit per TCVN 11820-5:2021. The study provides a quantitative basis for pile cross-section selection and demonstrates the practical applicability of MOFDA coupled directly with a genuine finite-element model.'),
  pKeywords('Keywords', 'multi-objective optimization, MOFDA algorithm, pile cross-section, piled wharf, SAP2000-MATLAB coupling'),
];

// ---- Doan 2 cot A: 1. Mo dau .. het 3.1 phan gioi thieu bien (truoc Bang 1) ----
const bodyA = [
  pSectionTitle('1. Mở đầu'),
  pBody('Cầu tàu container trên nền cọc là dạng kết cấu phổ biến trong các bến cảng biển trọng tải lớn tại Việt Nam. Hệ cọc — thường kết hợp cọc bê tông cốt thép dự ứng lực (BTCT DƯL) ly tâm và cọc ống thép — là cấu kiện chịu lực chính, đồng thời chiếm tỷ trọng lớn trong khối lượng vật liệu và chi phí xây dựng. Quy trình thiết kế phổ biến hiện nay là chọn trước tiết diện cọc theo kinh nghiệm hoặc catalogue thương mại, sau đó kiểm tra lại bằng mô hình phần tử hữu hạn (FEM) — một quy trình thuận (forward design) chưa được hệ thống hóa thành bài toán tối ưu có ràng buộc.'),
  pBody('Các thuật toán tối ưu dựa trên metaheuristic (GA, PSO, GWO, WOA, các biến thể thuật toán dòng chảy...) đã được ứng dụng rộng rãi cho tối ưu kết cấu khung thép, giàn, dầm. Thuật toán Flow Direction đa mục tiêu (MOFDA) là một thuật toán đã được công bố, với cơ chế lựa chọn thủ lĩnh lai (hybrid leader selection) thay cho phương pháp bánh xe roulette truyền thống, đã được kiểm chứng trên 31 hàm chuẩn, 11 bài toán kỹ thuật có ràng buộc và một công trình khung thép thực tế [1]. Bài báo này kế thừa MOFDA đã được kiểm chứng, mở rộng ứng dụng sang một đối tượng kết cấu mới: hệ cọc công trình bến cảng, gồm hai loại vật liệu, chịu tải trọng phức hợp, kết hợp trực tiếp với mô hình FEM thật thay vì hàm mục tiêu giải tích hay mô hình thay thế.'),
  pBody('Việc ứng dụng thuật toán tối ưu đa mục tiêu kết hợp trực tiếp với mô hình FEM thật cho bài toán tiết diện hệ cọc công trình bến cảng, theo đúng hệ tiêu chuẩn thiết kế công trình cảng biển Việt Nam hiện hành, chưa được công bố trong tài liệu tiếng Việt. Mục tiêu của bài báo là: (i) hình thành bài toán tối ưu đa mục tiêu cho tiết diện cọc của một cầu tàu 100.000 DWT thực tế, với biến thiết kế theo catalogue thương mại thật và ràng buộc theo tiêu chuẩn Việt Nam hiện hành; (ii) xây dựng khung kết nối MOFDA (MATLAB) với SAP2000 qua OAPI, chạy song song nhiều tiến trình; (iii) đối chiếu kết quả MOFDA với mặt Pareto thật, qua đó xác nhận độ tin cậy của thuật toán trong bài toán cụ thể này.'),
  pBody('Cần nhấn mạnh phạm vi bài báo: (1) MOFDA được sử dụng như công cụ đã kiểm chứng, không phải đối tượng phát triển mới, do đó bài báo không so sánh MOFDA với các thuật toán tối ưu đa mục tiêu khác; (2) hồ sơ thiết kế kỹ thuật của công trình chỉ được sử dụng để dựng mô hình FEM đầu vào, không nhằm mục đích đánh giá hay phê bình hồ sơ thiết kế gốc.'),

  pSectionTitle('2. Đối tượng nghiên cứu và mô hình phần tử hữu hạn'),
  pSubTitle('2.1. Mô tả công trình'),
  pBody('Đối tượng nghiên cứu là cầu tàu container 100.000 DWT thuộc dự án cảng cửa ngõ quốc tế Hải Phòng (Lạch Huyện), kết cấu bến liền bờ dạng bệ cọc cao đài mềm. Mô hình phân tích đại diện cho một phân đoạn tiêu chuẩn dài khoảng 75 m, rộng mặt cầu 50 m, cao trình đỉnh bến +5,50 m và đáy bến sau nạo vét −16,0 m (Hải đồ). Tàu thiết kế 100.000 DWT có chiều dài 330 m, chiều rộng 45,5 m, mớn nước đầy tải 14,8 m.'),
  pFigPlaceholder('[CHÈN HÌNH 1 TẠI ĐÂY: Phối cảnh/hình chiếu tổng thể mô hình SAP2000 3D của cầu tàu 100.000 DWT]'),
  pFigTitle('Hình 1. Mô hình SAP2000 3D của cầu tàu container 100.000 DWT'),
  pSubTitle('2.2. Hệ cọc'),
  pBody('Hệ cọc của một phân đoạn gồm 132 cọc ống BTCT DƯL D800-540 (bố trí thẳng đứng và xiên 6:1) và 60 cọc ống thép D1016-T16 (xiên 6:1 và 7:1), tổng cộng 192 cọc. Trong bài toán tối ưu này, tiết diện cọc được coi là biến thiết kế áp dụng đồng nhất cho toàn bộ cọc cùng loại; vị trí, độ xiên và chiều dài cọc giữ nguyên theo hồ sơ.'),
  pSubTitle('2.3. Mô hình SAP2000'),
  pBody('Mô hình FEM tuyến tính tĩnh được xây dựng trong SAP2000, gồm 4.913 nút, 1.734 phần tử thanh và 4.488 phần tử tấm vỏ, đơn vị làm việc Tonf–m–°C. Vật liệu gồm bê tông M400 (dầm/bản), M800 (cọc BTCT), thép cọc, cốt thép A615Gr60 và tao dự ứng lực A416Gr270. Điều kiện biên gồm 192 nút ngàm biên phân đoạn và 178 nút gán lò xo nền theo phương dọc trục cọc. Mô hình bao gồm 36 tổ hợp tải cơ bản; trong đó 35/36 tổ hợp đã được gộp sẵn thành một tổ hợp bao dạng đường bao (envelope) trong mô hình gốc, được sử dụng trực tiếp cho việc trích xuất chuyển vị và nội lực. Tổ hợp bão riêng (hệ số vượt tải 1,25 cho tải cần trục khi có bão) nằm ngoài phạm vi đường bao này và chưa được đưa vào campaign tối ưu — giới hạn được nêu rõ tại mục 4.4.'),

  pSectionTitle('3. Phương pháp'),
  pSubTitle('3.1. Bài toán tối ưu đa mục tiêu'),
  pBody('Bài toán có ba biến thiết kế:'),
  pEquation('x = [CatIdx_BTCT, D_thép, t_thép]', '1'),
  pBody('trong đó CatIdx_BTCT là chỉ số dòng trong catalogue cọc bê tông ly tâm dự ứng lực (PHC) của nhà sản xuất AMACCAO, theo TCVN 7888:2014 và JIS A 5373:2016 [2], giới hạn trong ba dòng nằm trong miền nghiên cứu ban đầu 0,70–0,90 m (Bảng 1). Đường kính và chiều dày cọc BTCT không còn là hai biến độc lập — mỗi đường kính catalogue tương ứng đúng một chiều dày cố định. Cọc ống thép (D1016-T16) chưa có catalogue thương mại tương ứng nên được rời rạc hóa theo lưới cố định: D_thép trong [0,90; 1,10] m bước 25 mm (9 giá trị), t_thép trong [0,012; 0,020] m bước 1 mm (9 giá trị). Không gian tìm kiếm là tích của ba miền rời rạc: 3×9×9 = 243 tổ hợp.'),
];

// ---- Doan 1 cot: Bang 1 (7 cot, can rong hon 1 cot bao) ----
const table1Block = [
  pTableTitle('Bảng 1. Catalogue cọc bê tông ly tâm AMACCAO sử dụng (Class A, TCVN 7888:2014)'),
  buildTable(
    ['CatIdx', 'D (m)', 't (m)', 'A (m²)', 'Mcr (T.m)', 'Mu (T.m)', 'Pvl (T)'],
    [
      ['1', '0,700', '0,110', '0,20389', '26,00', '39,00', '500'],
      ['2', '0,800', '0,120', '0,25635', '37,00', '55,50', '680'],
      ['3', '0,900', '0,130', '0,31447', '48,95', '73,42', '880'],
    ],
    [900, 900, 900, 1100, 1100, 1100, 1000]
  ),
  pSource('Nguồn: Catalogue cọc bê tông ly tâm AMACCAO PILE [2], quy đổi mô men kN.m sang T.m.'),
];

// ---- Doan 2 cot B: tiep tuc muc 3.1 (f1,f2,rang buoc) .. het 4.1 cau dan Bang 2 ----
const bodyB = [
  pBody('Hai hàm mục tiêu được xét đồng thời:'),
  pEquation('f₁ = A(D,t)_BTCT × ΣL_BTCT × γ_bt + A(D,t)_thép × ΣL_thép × γ_thép', '2'),
  pEquation('f₂ = max(√(U₁² + U₂²))', '3'),
  pBody('trong đó f₁ là tổng khối lượng vật liệu cọc (tấn), tính từ diện tích mặt cắt vành khuyên nhân với tổng chiều dài chế tạo thực tế của từng nhóm cọc và khối lượng riêng vật liệu (γ_bê tông = 2,5 T/m³, γ_thép = 7,85 T/m³ — đã đối chiếu khớp với dữ liệu trọng lượng danh định của catalogue AMACCAO); f₂ là chuyển vị ngang lớn nhất của cầu tàu trên tổ hợp bao, không xét thành phần đứng.'),
  pBody('Bốn nhóm ràng buộc được áp dụng: (i) tương tác lực dọc trục – mô men cọc BTCT theo đúng công thức do nhà sản xuất khuyến nghị cho cọc ly tâm dự ứng lực [2]:'),
  pEquation('N/Pvl + M/Mu − 1 ≤ 0', '4'),
  pBody('(ii) ứng suất cọc thép σ = N/A + M/W ≤ Fy/γM, với Fy = 3.150 kG/cm² theo bản vẽ thiết kế (TCVN 9245:2012); (iii) chuyển vị ngang U_max/U_allow − 1 ≤ 0, với U_allow = 71,7 mm theo TCVN 11820-5:2021, Điều 8.9, Bảng 12 (1/300 chiều cao bến, H = 21,5 m, không vượt quá 100 mm); (iv) sức chịu tải địa kỹ thuật theo TCVN 10304:2025 — hiện được ghi nhận trong khung bài toán nhưng chưa triển khai tính toán đầy đủ do thiếu số liệu chỉ tiêu cơ lý đất nền chi tiết (mục 4.4).'),
  pBody('Vi phạm ràng buộc được chuẩn hóa và tổng hợp thành hàm phạt nhân đồng thời lên cả hai mục tiêu:'),
  pEquation('Fk(x) = fk(x) × [1 + C×P(x)],  k = 1,2', '5'),
  pBody('với P(x) là tổng các vi phạm dương chuẩn hóa và C = 10 là hệ số khuếch đại phạt. Cách phạt nhân tránh vấn đề khác thứ nguyên giữa khối lượng và chuyển vị, không làm sai lệch mặt Pareto khả thi.'),

  pSubTitle('3.2. Thuật toán MOFDA'),
  pBody('MOFDA mô phỏng chuyển động của một "dòng chảy" hướng về vùng có giá trị hàm mục tiêu tốt hơn, kết hợp cơ chế lựa chọn thủ lĩnh lai để tăng khả năng hội tụ và duy trì đa dạng nghiệm Pareto, lưu trữ các nghiệm không bị trội trong một kho lưu trữ có cơ chế lưới để kiểm soát mật độ nghiệm [1]. Bài báo sử dụng nguyên bản cơ chế thuật toán đã công bố, không điều chỉnh công thức cập nhật vị trí.'),

  pSubTitle('3.3. Khung kết nối MOFDA–SAP2000 và tính toán song song'),
  pBody('Mỗi lần đánh giá một cá thể bao gồm: (i) ghi giá trị tiết diện cọc vào SAP2000 qua OAPI; (ii) chạy phân tích kết cấu; (iii) trích xuất chuyển vị và nội lực trên tổ hợp bao; (iv) tính hai hàm mục tiêu và mức vi phạm ràng buộc. Toàn bộ quá trình được song song hóa trên 8 tiến trình SAP2000 độc lập, mỗi tiến trình lưu một bản sao mô hình riêng để tránh xung đột ghi file. Số lượng tiến trình song song được xác định thực nghiệm trên máy tính sử dụng (14 lõi/28 luồng): tăng từ 8 lên 10 tiến trình chỉ cải thiện thông lượng 8,6% do tranh chấp tài nguyên, không tương xứng với mức tăng 25% số tiến trình, nên 8 tiến trình được lựa chọn.'),

  pSubTitle('3.4. Liệt kê toàn bộ không gian tìm kiếm'),
  pBody('Vì không gian tìm kiếm chỉ gồm 243 tổ hợp rời rạc, toàn bộ 243 tổ hợp được đánh giá trực tiếp qua cùng mô hình FEM để xác định chính xác mặt Pareto thật, dùng làm cơ sở đối chiếu khách quan cho kết quả MOFDA — một bước kiểm chứng bổ sung tận dụng đặc điểm không gian rời rạc nhỏ của bài toán này, không thay thế cho việc ứng dụng MOFDA.'),

  pSectionTitle('4. Kết quả và thảo luận'),
  pSubTitle('4.1. Mặt Pareto thật (liệt kê toàn bộ)'),
  pBody('Toàn bộ 243 tổ hợp được đánh giá thành công qua SAP2000, trong thời gian 70,9 phút với 8 tiến trình song song. Kết quả xác định được 16 nghiệm không bị trội, trình bày trong Bảng 2.'),
];

// ---- Doan 1 cot: Bang 2 (5 cot, 16 hang) ----
const table2Block = [
  pTableTitle('Bảng 2. Mặt Pareto thật của bài toán (16 nghiệm, liệt kê toàn bộ 243 tổ hợp)'),
  buildTable(
    ['CatIdx', 'D_thép (m)', 't_thép (m)', 'f₁ (tấn)', 'f₂ (mm)'],
    [
      ['1', '1,100', '0,0180', '3.030,6', '13,88'],
      ['1', '1,075', '0,0190', '3.056,8', '13,76'],
      ['1', '1,100', '0,0190', '3.078,0', '13,53'],
      ['1', '1,075', '0,0200', '3.103,0', '13,44'],
      ['1', '1,100', '0,0200', '3.125,3', '13,22'],
      ['2', '1,100', '0,0180', '3.587,1', '13,15'],
      ['2', '1,075', '0,0190', '3.613,3', '13,05'],
      ['2', '1,100', '0,0190', '3.634,5', '12,86'],
      ['2', '1,075', '0,0200', '3.659,5', '12,78'],
      ['2', '1,100', '0,0200', '3.681,8', '12,60'],
      ['3', '1,075', '0,0180', '4.183,6', '12,52'],
      ['3', '1,100', '0,0180', '4.203,7', '12,37'],
      ['3', '1,075', '0,0190', '4.229,9', '12,29'],
      ['3', '1,100', '0,0190', '4.251,0', '12,13'],
      ['3', '1,075', '0,0200', '4.276,0', '12,07'],
      ['3', '1,100', '0,0200', '4.298,3', '11,92'],
    ],
    [900, 1100, 1100, 1000, 1000]
  ),
];

// ---- Doan 2 cot C: 4.1 thao luan .. het bai (Ket luan, Tai lieu tham khao) ----
const bodyC = [
  pBody('Cả ba lựa chọn catalogue cọc BTCT (D700, D800, D900) đều xuất hiện trên mặt Pareto. Toàn bộ 16 nghiệm đều sử dụng cọc thép có kích thước lớn nhất trong miền nghiên cứu — phản ánh đúng bản chất vật lý: cọc thép càng lớn thì độ cứng hệ càng tăng, giảm chuyển vị ngang, đánh đổi bằng khối lượng vật liệu tăng thêm. Khối lượng vật liệu dao động 3.030,6–4.298,3 tấn ứng với chuyển vị ngang 11,92–13,88 mm — đều thấp hơn nhiều giới hạn cho phép 71,7 mm.'),
  pFigPlaceholder('[CHÈN HÌNH 2 TẠI ĐÂY: Biểu đồ phân tán 16 nghiệm Pareto thật (trục hoành f₁ - tấn, trục tung f₂ - mm), phân biệt theo CatIdx bằng màu/ký hiệu]'),
  pFigTitle('Hình 2. Mặt Pareto thật của bài toán (16 nghiệm, liệt kê toàn bộ)'),

  pSubTitle('4.2. Đối chiếu kết quả MOFDA với mặt Pareto thật'),
  pBody('MOFDA được chạy với quần thể 15 cá thể, 15 vòng lặp (1.140 lần đánh giá FEM), thời gian thực hiện 5,35 giờ với 8 tiến trình song song, tìm được 14 nghiệm không bị trội. Đối chiếu trực tiếp với 16 nghiệm Pareto thật: 8/16 nghiệm (50%) trùng khớp chính xác cả về biến thiết kế và giá trị hàm mục tiêu. Sáu nghiệm còn lại, tuy không bị trội lẫn nhau trong tập nghiệm mà thuật toán đã khảo sát, bị trội bởi từ 1 đến 7 nghiệm khác trong tập 243 tổ hợp đầy đủ — tức là các nghiệm gần-tối-ưu nhưng chưa phải tối ưu toàn cục.'),
  pFigPlaceholder('[CHÈN HÌNH 3 TẠI ĐÂY: Chồng lớp 2 mặt Pareto — 16 nghiệm thật (một màu/ký hiệu) và 14 nghiệm MOFDA (màu/ký hiệu khác), đánh dấu rõ 8 điểm trùng khớp]'),
  pFigTitle('Hình 3. Đối chiếu mặt Pareto MOFDA (14 nghiệm) với mặt Pareto thật (16 nghiệm)'),
  pBody('Kết quả này khẳng định hai điểm: (i) MOFDA hội tụ đúng hướng, các nghiệm tìm được đều nằm gần mặt Pareto thật cả về giá trị hàm mục tiêu lẫn cấu trúc biến thiết kế; (ii) đối với bài toán có không gian tìm kiếm rời rạc nhỏ như trường hợp này, phương pháp liệt kê toàn bộ hiệu quả hơn về mặt tính toán (243 so với 1.140 lần đánh giá) và đảm bảo chắc chắn tìm được lời giải tối ưu toàn cục.'),

  pSubTitle('4.3. Đề xuất kỹ thuật'),
  pBody('Với dải nghiệm Pareto thu được, một nghiệm đại diện cân bằng giữa hai mục tiêu (CatIdx=2, D_thép=1,100 m, t_thép=0,019 m: f₁≈3.634,5 tấn, f₂≈12,86 mm) có thể được xem xét làm phương án tham khảo cho giai đoạn thiết kế sơ bộ, tùy theo mức độ ưu tiên giữa tiết kiệm vật liệu và kiểm soát chuyển vị của dự án cụ thể.'),

  pSubTitle('4.4. Giới hạn của nghiên cứu'),
  pBody('Nghiên cứu còn một số giới hạn: (i) ràng buộc sức chịu tải địa kỹ thuật theo TCVN 10304:2025 chưa được triển khai tính toán đầy đủ do thiếu số liệu chỉ tiêu cơ lý đất nền chi tiết; (ii) tổ hợp tải trọng bão chưa được đưa vào phạm vi đánh giá của campaign tối ưu; (iii) catalogue cọc ống thép chưa có sẵn nên biến thiết kế tương ứng được rời rạc hóa theo lưới giả định; (iv) mô hình chỉ xét phân tích tuyến tính tĩnh, chưa xét ứng xử phi tuyến hay tương tác đất–cọc chi tiết kiểu p–y. Các giới hạn này không làm thay đổi kết luận về khả năng ứng dụng của MOFDA nhưng cần được bổ sung trước khi sử dụng kết quả số cho thiết kế thi công.'),

  pSectionTitle('5. Kết luận'),
  pBody('Bài báo đã ứng dụng thành công thuật toán MOFDA để giải bài toán tối ưu đa mục tiêu tiết diện hệ cọc của một cầu tàu container 100.000 DWT thực tế, kết hợp trực tiếp với mô hình phần tử hữu hạn SAP2000 qua OAPI, chạy song song trên nhiều tiến trình. Các kết luận chính gồm:'),
  pBody('(1) Bài toán tối ưu ba biến thiết kế với ràng buộc theo tiêu chuẩn Việt Nam hiện hành (TCVN 7888:2014, TCVN 11820-5:2021, TCVN 9245:2012) đã được hình thành và giải thành công.'),
  pBody('(2) Không gian tìm kiếm rời rạc của bài toán chỉ gồm 243 tổ hợp, cho phép liệt kê toàn bộ để xác định chính xác mặt Pareto thật gồm 16 nghiệm, làm cơ sở đối chiếu khách quan cho kết quả MOFDA.'),
  pBody('(3) MOFDA tìm được 14 nghiệm không bị trội, trong đó 8/16 nghiệm trùng khớp chính xác với mặt Pareto thật, xác nhận thuật toán hội tụ đúng hướng trong bài toán kỹ thuật thực tế này.'),
  pBody('(4) Khối lượng vật liệu cọc tối ưu dao động 3.030,6–4.298,3 tấn, tương ứng chuyển vị ngang 11,9–13,9 mm — đều thấp hơn nhiều giới hạn cho phép 71,7 mm.'),
  pBody('(5) Đối với các bài toán có không gian thiết kế rời rạc nhỏ, phương pháp liệt kê toàn bộ nên được cân nhắc song song với thuật toán metaheuristic để vừa đảm bảo tìm được lời giải tối ưu toàn cục, vừa có cơ sở kiểm chứng độ tin cậy của thuật toán áp dụng.'),

  pAbstractLabel('Lời cảm ơn'),
  pBody('(nếu có)'),

  pRefTitle('TÀI LIỆU THAM KHẢO'),
  pRef('[1] Truong V.H., Khatir S., Cuong-Le T. (2026), Real-World Steel Frame Optimization Using a Hybrid Leader Selection-Based Multi-Objective Flow Direction Algorithm, Trường Đại học Mở Thành phố Hồ Chí Minh.'),
  pRef('[2] AMACCAO PILE (2014), Catalog và thông số kỹ thuật cọc bê tông ly tâm AMACCAO D300-D1200, theo TCVN 7888:2014 và JIS A 5373:2016.'),
  pRef('[3] Bộ Khoa học và Công nghệ (2021), TCVN 11820-5:2021 — Công trình cảng biển – Yêu cầu thiết kế – Phần 5: Công trình bến.'),
  pRef('[4] Bộ Khoa học và Công nghệ (2020), TCVN 11820-4-1:2020 — Công trình cảng biển – Yêu cầu thiết kế – Phần 4-1: Nền móng.'),
  pRef('[5] Bộ Khoa học và Công nghệ, TCVN 10304:2025 — Thiết kế móng cọc.'),
  pRef('[6] Bộ Khoa học và Công nghệ, TCVN 9245:2012 — Cọc ống thép.'),

  new Paragraph({ spacing: { before: 300 }, children: [new TextRun({ text: 'Ngày nhận bài: xx/xx/2026', size: 18, font: FONT, italics: true })] }),
  new Paragraph({ children: [new TextRun({ text: 'Ngày nhận bản sửa: xx/xx/2026', size: 18, font: FONT, italics: true })] }),
  new Paragraph({ children: [new TextRun({ text: 'Ngày duyệt đăng: xx/xx/2026', size: 18, font: FONT, italics: true })] }),
];

const PAGE = { size: { width: 11906, height: 16838 }, margin: { top: 1701, right: 1418, bottom: 1418, left: 1588 } };
function twoColSection(children) {
  return { properties: { type: SectionType.CONTINUOUS, page: PAGE, column: { count: 2, space: 340 } }, children };
}
function oneColSection(children) {
  return { properties: { type: SectionType.CONTINUOUS, page: PAGE, column: { count: 1 } }, children };
}

const doc = new Document({
  styles: { default: { document: { run: { font: FONT, size: 20 } } } },
  sections: [
    { properties: { type: SectionType.CONTINUOUS, page: PAGE }, children: section1Children },
    // bat dau 2 cot tu day, chen 2 doan 1-cot rieng cho Bang 1 va Bang 2 (7 va 5 cot,
    // qua rong cho 1 cot bao) roi quay lai 2 cot -- theo dung quy uoc bao khoa hoc
    // 2 cot khi co bang rong.
    { properties: { type: SectionType.NEXT_PAGE, page: PAGE, column: { count: 2, space: 340 } }, children: bodyA },
    oneColSection(table1Block),
    twoColSection(bodyB),
    oneColSection(table2Block),
    twoColSection(bodyC),
  ],
});

Packer.toBuffer(doc).then((buffer) => {
  fs.writeFileSync('BAI_BAO_MOFDA_CAU_TAU_100000DWT.docx', buffer);
  console.log('OK - da tao file docx');
});
