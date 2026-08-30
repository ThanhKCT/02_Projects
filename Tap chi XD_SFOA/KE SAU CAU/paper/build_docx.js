// build_docx.js — Generate BAI_BAO_KE_SAU_CAU_SFOA_TCXD.docx per Tạp chí Xây dựng format
// Font/size/margins read directly from "Quy cach bai bao khoa hoc-TCXD.docx"'s own
// styles.xml (Times New Roman, 13pt body) and page margins (T1.75/B2/R2/L3 cm).
const {
  Document, Packer, Paragraph, TextRun, AlignmentType,
  Table, TableRow, TableCell, WidthType, VerticalAlign, ShadingType,
  ImageRun,
} = require("docx");
const fs = require("fs");
const path = require("path");

const CM = (n) => Math.round(n * 566.929); // cm -> twips
const FONT = "Times New Roman";
const SZ = 26; // 13pt body (half-points), matches the template's dominant run size
const SZ_TITLE = 30; // 15pt for main title
const SZ_SUB = 26;

function run(text, o = {}) {
  return new TextRun({
    text, font: FONT, size: o.size || SZ, bold: o.bold, italics: o.italics,
    superScript: o.sup, subScript: o.sub,
  });
}
function P(children, opts = {}) {
  return new Paragraph({
    alignment: opts.align || AlignmentType.JUSTIFIED,
    spacing: { after: 160, line: 300 },
    children: Array.isArray(children) ? children : [run(children, opts)],
  });
}
function center(children, opts = {}) {
  return new Paragraph({
    alignment: AlignmentType.CENTER,
    spacing: { after: opts.after ?? 120 },
    children: Array.isArray(children) ? children : [run(children, opts)],
  });
}
// Main headings 1,2,3,4: UPPERCASE, bold (rule: "viết hoa, đậm, đánh số 1,2,3")
function mainHeading(text) {
  return new Paragraph({
    spacing: { before: 280, after: 160 },
    children: [run(text.toUpperCase(), { bold: true })],
  });
}
// Level-1 subheadings 2.1, 2.2...: regular case, bold, NOT italic
function subHeading(text) {
  return new Paragraph({
    spacing: { before: 200, after: 120 },
    children: [run(text, { bold: true })],
  });
}
// Table/figure captions: plain regular text, left-aligned, no bold/italic
function caption(text) {
  return new Paragraph({
    alignment: AlignmentType.LEFT,
    spacing: { before: 80, after: 160 },
    children: [run(text)],
  });
}
// Equation paragraph: centered content + right-aligned number via tab stop
function eq(children, num) {
  return new Paragraph({
    alignment: AlignmentType.CENTER,
    spacing: { before: 140, after: 140 },
    tabStops: [{ type: "right", position: CM(16.5) }],
    children: [...children, run("\t(" + num + ")")],
  });
}

function mkCell(children, opts = {}) {
  const kids = Array.isArray(children)
    ? children
    : [run(String(children), { bold: opts.bold })];
  return new TableCell({
    verticalAlign: VerticalAlign.CENTER,
    shading: opts.shaded ? { type: ShadingType.CLEAR, fill: "E8E8E8" } : undefined,
    margins: { top: 60, bottom: 60, left: 100, right: 100 },
    children: [new Paragraph({
      alignment: opts.align || AlignmentType.CENTER,
      children: kids,
    })],
  });
}
function makeTable(header, rows, colCmWidths) {
  const colWidths = colCmWidths.map((c) => CM(c));
  const totalWidth = colWidths.reduce((a, b) => a + b, 0);
  const headerRow = new TableRow({
    children: header.map((h, i) => {
      const c = mkCell(h, { bold: true, shaded: true });
      c.width = { size: colWidths[i], type: WidthType.DXA };
      return c;
    }),
  });
  const bodyRows = rows.map((r) => new TableRow({
    children: r.map((v, i) => {
      const c = mkCell(v.children || v, { align: v.align, bold: v.bold });
      c.width = { size: colWidths[i], type: WidthType.DXA };
      return c;
    }),
  }));
  return new Table({
    width: { size: totalWidth, type: WidthType.DXA },
    columnWidths: colWidths,
    rows: [headerRow, ...bodyRows],
  });
}

function img(filePath, wCm) {
  const dims = { width: 700, height: 450 }; // native px of the exported PNG (approx 200dpi 700x450)
  const hCm = wCm * (dims.height / dims.width);
  return new Paragraph({
    alignment: AlignmentType.CENTER,
    spacing: { before: 160, after: 40 },
    children: [new ImageRun({
      data: fs.readFileSync(filePath),
      transformation: { width: CM(wCm) / 20, height: CM(hCm) / 20 },
      type: "png",
    })],
  });
}

// Helper to build "x_i" style subscripted variable runs quickly
const v = (base, sub, opt = {}) => [
  run(base, { italics: true, ...opt }),
  ...(sub ? [run(sub, { italics: true, sub: true, ...opt })] : []),
];

const imgPath = path.join(__dirname, "Hinh1_hoi_tu_SFOA.png");

const doc = new Document({
  styles: { default: { document: { run: { font: FONT, size: SZ } } } },
  sections: [{
    properties: {
      page: {
        size: { width: CM(21), height: CM(29.7) },
        margin: { top: CM(1.75), bottom: CM(2), right: CM(2), left: CM(3) },
      },
    },
    children: [
      // ---- Title block ----
      center(run("Tối ưu hóa khối lượng bê tông tường chắn và bản đáy kè sau cầu bằng thuật toán tối ưu sao biển kết hợp SAP2000–MATLAB", { bold: true, size: SZ_TITLE }), { after: 120 }),
      center(run("Concrete-volume optimization of the retaining wall and base slab of a bridge-abutment revetment using the starfish optimization algorithm coupled with SAP2000–MATLAB", { size: SZ }), { after: 200 }),
      center([run("[HỌ VÀ TÊN TÁC GIẢ]", { bold: true }), run("1,*", { bold: true, sup: true })], { after: 40 }),
      center([run("1", { sup: true }), run("[Đơn vị công tác]")], { after: 40 }),
      center([run("*", { sup: true }), run("Email liên hệ: dangvanhai@hanyang.ac.kr")], { after: 240 }),

      // ---- TÓM TẮT ----
      new Paragraph({ spacing: { before: 200, after: 120 }, children: [run("TÓM TẮT", { bold: true })] }),
      P("Nghiên cứu áp dụng thuật toán tối ưu sao biển nguyên bản (Original Starfish Optimization Algorithm – SFOA) để tối thiểu hóa khối lượng bê tông kết cấu tường chắn và bản đáy của một công trình kè sau cầu thực tế, chịu đồng thời năm ràng buộc kỹ thuật theo tiêu chuẩn Việt Nam hiện hành. Mô hình phần tử hữu hạn SAP2000 được liên kết trực tiếp với MATLAB qua giao diện COM, cho phép SFOA cập nhật sáu biến chiều dày độc lập (bốn vùng tường, hai vùng bản đáy) và đánh giá phản hồi kết cấu bằng phân tích FEM trong từng bước lặp. Các ràng buộc gồm sức chịu tải cọc (TCVN 10304:2025), chuyển vị ngang đỉnh tường (TCVN 11820-5:2021), khả năng chịu cắt và bề rộng vết nứt (TCVN 4116:2023), và chọc thủng bản đáy theo từng cọc (TCVN 5574:2018). Kết quả tối ưu với quần thể 50 cá thể, 50 vòng lặp cho khối lượng bê tông 232,48 m³, giảm 51,66 m³ (18,18%) so với thiết kế hiện trạng (284,14 m³), đồng thời thỏa mãn toàn bộ năm ràng buộc kỹ thuật với biên an toàn dương. Đường cong hội tụ ổn định từ khoảng vòng lặp thứ 47. Kết quả cho thấy SFOA nguyên bản, kết hợp trực tiếp với FEM, có khả năng khai thác dư thừa khả năng chịu lực giữa các vùng kết cấu có nội lực khác nhau mà thiết kế theo kinh nghiệm khó nhận diện đầy đủ."),
      P([run("Từ khóa: ", { bold: true }), run("Thuật toán tối ưu sao biển; tối ưu kết cấu; kè sau cầu; SAP2000–MATLAB; TCVN 10304:2025; TCVN 4116:2023.")]),

      new Paragraph({ spacing: { before: 200, after: 120 }, children: [run("ABSTRACT", { bold: true })] }),
      P("This study applies the original Starfish Optimization Algorithm (SFOA) to minimize the concrete volume of the retaining wall and base slab of an actual bridge-abutment revetment structure, subject to five simultaneous technical constraints under current Vietnamese standards. A SAP2000 finite-element model is directly coupled with MATLAB through a COM interface, allowing SFOA to update six independent thickness variables (four wall zones, two base-slab zones) and evaluate the structural response through FEM analysis at every iteration. The constraints comprise pile bearing capacity (TCVN 10304:2025), lateral displacement at the wall top (TCVN 11820-5:2021), shear capacity and crack width (TCVN 4116:2023), and per-pile punching shear of the base slab (TCVN 5574:2018). With a population of 50 individuals over 50 iterations, the optimal solution reaches a concrete volume of 232.48 m³, a reduction of 51.66 m³ (18.18%) compared with the as-built design (284.14 m³), while satisfying all five constraints with a positive safety margin. The convergence curve stabilizes from around iteration 47. The results show that the original SFOA, directly coupled with FEM, can exploit the structural capacity reserve across zones with different internal-force demand that experience-based design often cannot fully identify."),
      P([run("Keywords: ", { bold: true }), run("Starfish Optimization Algorithm; structural optimization; bridge-abutment revetment; SAP2000–MATLAB; TCVN 10304:2025; TCVN 4116:2023.")]),

      // ---- 1. ĐẶT VẤN ĐỀ ----
      mainHeading("1. Đặt vấn đề"),
      P("Kè sau cầu là kết cấu chắn đất bố trí phía sau mố cầu, có chức năng giữ ổn định khối đất đắp và bảo vệ nền đường dẫn, thường gồm hệ tường chắn thẳng đứng liên kết với bản đáy đặt trên hệ cọc. Do tường và bản đáy thường được chia thành nhiều vùng có chiều dày khác nhau theo cao trình và vị trí để phù hợp với sự phân bố nội lực thực tế, khối lượng bê tông của toàn bộ kết cấu phụ thuộc đồng thời vào nhiều biến thiết kế độc lập. Thiết kế theo kinh nghiệm, dựa trên kiểm tra tuần tự từng tiết diện, khó xác định đồng thời tổ hợp chiều dày tối thiểu cho tất cả các vùng sao cho vẫn thỏa mãn mọi ràng buộc kỹ thuật, dẫn đến dư thừa khả năng chịu lực cục bộ và tăng chi phí vật liệu không cần thiết."),
      P("Các thuật toán tối ưu metaheuristic, kết hợp trực tiếp với mô hình phần tử hữu hạn (FEM) để đánh giá phản hồi kết cấu trong vòng lặp tối ưu, là hướng tiếp cận phù hợp cho lớp bài toán tối ưu kết cấu có tính phi tuyến cao, biến thiết kế rời rạc và nhiều ràng buộc kỹ thuật đồng thời mà phương pháp giải tích truyền thống khó xử lý [1]. Thuật toán tối ưu sao biển (Starfish Optimization Algorithm – SFOA) là một thuật toán metaheuristic được đề xuất gần đây, lấy cảm hứng từ hành vi săn mồi và tái sinh của sao biển, đã được đánh giá hiệu quả trên nhiều hàm benchmark và một số bài toán kỹ thuật [1]. Nghiên cứu này không khảo sát SFOA ở mức benchmark thuật toán mà tập trung vào khả năng ứng dụng của SFOA nguyên bản cho một bài toán tối ưu kết cấu công trình thực tế, kết hợp trực tiếp với phân tích FEM và chịu đồng thời nhiều ràng buộc theo tiêu chuẩn thiết kế hiện hành của Việt Nam."),
      P("Việc kết hợp SFOA với SAP2000 cho bài toán tối ưu khối lượng bê tông kết cấu kè chắn đất có nhiều vùng chiều dày độc lập, chịu ràng buộc đồng thời về sức chịu tải cọc, chuyển vị, khả năng chịu cắt, bề rộng vết nứt và chọc thủng theo các tiêu chuẩn thiết kế hiện hành — bao gồm hai tiêu chuẩn mới ban hành gần đây là TCVN 10304:2025 (thay thế TCVN 10304:2014) và TCVN 4116:2023 — chưa được khảo sát trong các nghiên cứu trước. Mục tiêu của nghiên cứu là: (1) xây dựng khung tính toán SAP2000–MATLAB–SFOA cho bài toán tối ưu đơn mục tiêu khối lượng bê tông của sáu vùng chiều dày kè sau cầu, chịu đồng thời năm ràng buộc kỹ thuật theo TCVN hiện hành; (2) áp dụng khung tính toán này cho một công trình kè sau cầu thực tế và đánh giá định lượng hiệu quả giảm khối lượng bê tông so với phương án thiết kế hiện trạng. Đóng góp chính của nghiên cứu là minh chứng thực nghiệm về khả năng ứng dụng SFOA nguyên bản, không cần điều chỉnh hay lai ghép thêm cơ chế nào, cho một bài toán tối ưu kết cấu chắn đất thực tế có nhiều ràng buộc TCVN đồng thời — trong đó phần lớn cấu hình khả dĩ (khoảng 1,7 tỷ tổ hợp rời rạc) vượt xa khả năng liệt kê toàn bộ (brute-force), buộc phải dùng công cụ tìm kiếm metaheuristic."),

      // ---- 2. MÔ HÌNH ----
      mainHeading("2. Mô hình bài toán và phương pháp"),
      subHeading("2.1. Hệ kết cấu"),
      P("Đối tượng nghiên cứu là kè sau cầu với tường chắn đất cao 4,5m, được chia thành bốn vùng chiều dày độc lập theo cao trình và vị trí dọc tuyến (TUONGC30, TUONGM30, TUONGM43, TUONGM78), liên kết với bản đáy đặt trên hệ 142 cọc bê tông ly tâm ứng suất trước (đường kính D400 và D500), bản đáy được chia thành hai vùng chiều dày độc lập (DAY130, DAY60). Kết cấu tường và bản đáy được mô hình hóa bằng phần tử vỏ (shell) trong SAP2000, vật liệu bê tông mác M350; cọc được mô hình bằng phần tử thanh (frame), giữ nguyên kích thước và bố trí trong toàn bộ quá trình tối ưu (không phải biến thiết kế)."),

      subHeading("2.2. Tải trọng và tổ hợp tải"),
      P("Mô hình chịu bốn trường hợp tải cơ bản: tĩnh tải bản thân (DEAD), trọng lượng khối đất đắp sau tường (Gdat), áp lực đất chủ động dạng lực tập trung và dạng phân bố (Pdat, ALD). Hai tổ hợp tải được xét: TH1 = DEAD + Gdat + Pdat + ALD (không có hoạt tải khai thác) và TH2 = TH1 + HH (có bổ sung hoạt tải chất xếp/khai thác trên mặt bãi). Tổ hợp bao BAO, lấy giá trị bao trùm (envelope) của TH1 và TH2, được dùng để trích xuất nội lực và chuyển vị cho toàn bộ quá trình kiểm tra ràng buộc."),

      subHeading("2.3. Biến thiết kế và hàm mục tiêu"),
      P([run("Sáu biến thiết kế liên tục "), ...v("x", null), run(" = ["), ...v("x", "1"), run(", "), ...v("x", "2"), run(", ..., "), ...v("x", "6"), run("] tương ứng chiều dày sáu vùng shell (TUONGC30, TUONGM30, TUONGM43, TUONGM78, DAY130, DAY60), được rời rạc hóa về bội số 0,01m trước khi ghi vào mô hình SAP2000 và trước khi tính hàm mục tiêu. Hàm mục tiêu là tổng khối lượng bê tông của sáu vùng, tính trực tiếp từ diện tích mặt bằng/mặt đứng đã xác định trước của từng vùng (không đọc từ SAP2000, vì diện tích hình học không đổi theo chiều dày):")]),
      eq([
        ...v("V", null), run("("), ...v("x", null), run(") = "),
        run("∑", { italics: false }), run("i=1", { sub: true }), run("6", { sup: true }),
        run(" "), ...v("A", "i"), run(" · "), ...v("x", "i"),
      ], 1),
      P([run("trong đó "), ...v("A", "i"), run(" là diện tích vùng "), run("i", { italics: true }), run(" (m²) và "), ...v("x", "i"), run(" là chiều dày vùng "), run("i", { italics: true }), run(" (m). Hàm thích nghi (fitness) dùng cho SFOA kết hợp hàm mục tiêu với hàm phạt tuyến tính theo tổng mức vi phạm ràng buộc "), ...v("g", null), run("("), ...v("x", null), run(") (mục 2.4), theo cách tiếp cận phạt tĩnh hệ số lớn thường dùng cho bài toán tối ưu ràng buộc [2]:")]),
      eq([
        ...v("f", null), run("("), ...v("x", null), run(") = "), ...v("V", null), run("("), ...v("x", null),
        run(") + "), run("C", { italics: true }), run(" · "), ...v("g", null), run("("), ...v("x", null),
        run("),  "), ...v("g", null), run("("), ...v("x", null), run(") = "),
        run("∑"), run("j=1", { sub: true }), run("5", { sup: true }),
        run(" max(0, "), ...v("v", "j"), run("("), ...v("x", null), run("))"),
      ], 2),
      P([run("với "), ...v("v", "j"), run("("), ...v("x", null), run(") là mức vi phạm của ràng buộc thứ "), run("j", { italics: true }), run(" (bằng 0 nếu thỏa mãn) và "), run("C", { italics: true }), run(" = 10"), run("6", { sup: true }), run(" là hệ số phạt.")]),

      subHeading("2.4. Ràng buộc kỹ thuật"),
      P("Bảng 1 tổng hợp năm ràng buộc kỹ thuật được kiểm tra tại mỗi lần đánh giá, cùng nguồn tiêu chuẩn và cách xử lý trong vòng lặp tối ưu."),
      caption("Bảng 1. Ràng buộc kỹ thuật của bài toán tối ưu"),
      makeTable(
        ["STT", "Ràng buộc", "Đại lượng kiểm tra", "Điều kiện thỏa mãn", "Nguồn/Ghi chú"],
        [
          ["1", "Sức chịu tải cọc", "Nd từng cọc (từ phản lực đầu cọc)", "Nd ≤ [Nd] (78,76T với cọc D400; 112,44T với cọc D500)", "TCVN 10304:2025"],
          ["2", "Chuyển vị ngang đỉnh tường", "max|U1| tại các nút thuộc nhóm đỉnh tường", "≤ min(H/300, 100mm) = 15mm", "TCVN 11820-5:2021, Bảng 12"],
          ["3", "Khả năng chịu cắt", "Lực cắt Q tại tiết diện cách mặt gối tựa một đoạn h0", "γlc·γn·Q ≤ γc·γb7·Qb", "TCVN 4116:2023, Điều 8.2.12"],
          ["4", "Bề rộng vết nứt", "acr tính từ ứng suất cốt thép σs", "acr ≤ γc · 0,2mm", "TCVN 4116:2023, Điều 9.2/9.1.1"],
          ["5", "Chọc thủng bản đáy", "Phản lực đầu cọc so với khả năng chống chọc thủng theo chu vi tháp chọc thủng", "|Nd| ≤ γc·Rbt·u·h0", "TCVN 5574:2018"],
        ],
        [1.2, 3.0, 4.5, 4.5, 3.0]
      ),
      P("Ràng buộc 3 và 4 được kiểm tra riêng cho từng vùng trong số sáu vùng chiều dày, sử dụng nội lực bao (M, V) trích xuất từ SAP2000 tại các điểm cách mặt gối tựa (chân tường hoặc mép cọc) một khoảng lớn hơn hoặc bằng chiều cao làm việc h0 của tiết diện, nhằm loại trừ các đỉnh nội lực cắt giả do hiệu ứng tập trung ứng suất cục bộ tại các nút biên cứng của phần tử vỏ — một hiện tượng đặc trưng của lưới phần tử hữu hạn, không phản ánh tiết diện nguy hiểm thực tế. Mô men uốn không áp dụng bộ lọc này vì giá trị lớn nhất tại chân công-xôn là cơ học thực. Ràng buộc 5 được kiểm tra riêng cho từng cọc trong số 142 cọc, sử dụng chiều cao làm việc h0 của đúng vùng bản đáy mà cọc đó thuộc về."),

      subHeading("2.5. Khung tính toán SAP2000–MATLAB–SFOA"),
      P("Mỗi lần đánh giá một cá thể trong quần thể SFOA được thực hiện qua chuỗi bước: (i) MATLAB rời rạc hóa vector thiết kế về bội số 0,01m; (ii) ghi chiều dày của sáu vùng vào phiên SAP2000 đang mở thông qua hàm OAPI SetShell_1; (iii) chạy phân tích kết cấu (RunAnalysis); (iv) đọc phản lực đầu cọc, chuyển vị nút và nội lực vỏ theo tổ hợp bao BAO; (v) tính hàm mục tiêu, mức vi phạm từng ràng buộc và hàm thích nghi; (vi) trả giá trị thích nghi về cho SFOA để cập nhật quần thể. Toàn bộ quá trình tối ưu sử dụng một phiên SAP2000 duy nhất được giữ mở xuyên suốt, chỉ cập nhật thuộc tính tiết diện giữa các lần đánh giá, nhằm tránh chi phí mở/đóng file lặp lại."),

      subHeading("2.6. Thuật toán SFOA nguyên bản và thiết lập tính toán"),
      P([run("Nghiên cứu sử dụng đúng SFOA nguyên bản [1], gồm hai pha khám phá và khai thác dựa trên hành vi tìm mồi và tái sinh của sao biển, không bổ sung cơ chế nào khác. Do đây là nghiên cứu ứng dụng SFOA làm công cụ tối ưu thiết kế cho một công trình cụ thể — không nhằm so sánh hay phát triển thuật toán — quá trình tối ưu chỉ thực hiện một lần chạy độc lập duy nhất ("), ...v("N", "run"), run("=1), không yêu cầu thống kê Best/Mean/STD qua nhiều lần chạy như các nghiên cứu đánh giá thuật toán. Quy mô quần thể "), ...v("N", "pop"), run("=50 và số vòng lặp "), ...v("Max", "it"), run("=50 (tổng 2.550 lần đánh giá) được xác định dựa trên một khảo sát hội tụ thực nghiệm riêng ở quy mô quần thể nhỏ hơn ("), ...v("N", "pop"), run("=15, 40 vòng lặp): đường cong hội tụ ổn định rõ rệt từ khoảng vòng lặp thứ 26-30, chỉ cải thiện thêm 0,16% trong 14 vòng lặp cuối. Quy mô chính thức được chọn lớn hơn đáng kể so với ngưỡng hội tụ quan sát được để tạo biên an toàn.")]),

      // ---- 3. KẾT QUẢ VÀ THẢO LUẬN ----
      mainHeading("3. Kết quả và thảo luận"),
      subHeading("3.1. Sự hội tụ của thuật toán"),
      P("Hình 1 thể hiện đường cong hội tụ (giá trị tốt nhất tích lũy theo vòng lặp) của lần chạy chính thức. Giá trị hàm mục tiêu giảm nhanh trong giai đoạn đầu, từ 261,97 m³ ở vòng lặp thứ nhất xuống 233,37 m³ ở vòng lặp thứ 13, sau đó tiếp tục cải thiện chậm dần và ổn định hoàn toàn từ vòng lặp thứ 47 đến vòng lặp thứ 50 (232,48 m³ không đổi trong bốn vòng lặp cuối). Đặc điểm hội tụ này khớp với xu hướng quan sát được ở khảo sát sơ bộ tại mục 2.6, cho thấy 50 vòng lặp là đủ để thuật toán đạt trạng thái ổn định với biên an toàn."),
      img(imgPath, 13),
      caption("Hình 1. Đường cong hội tụ của SFOA (giá trị tốt nhất tích lũy theo vòng lặp)"),

      subHeading("3.2. Nghiệm tối ưu"),
      P("Bảng 2 trình bày nghiệm tốt nhất tìm được so với phương án thiết kế hiện trạng (as-built) của công trình."),
      caption("Bảng 2. So sánh nghiệm tối ưu với thiết kế hiện trạng"),
      makeTable(
        ["Biến thiết kế", "Thiết kế hiện trạng (m)", "Nghiệm tốt nhất tìm được (m)"],
        [
          ["x1 – TUONGC30", "0,30", "0,20"],
          ["x2 – TUONGM30", "0,30", "0,22"],
          ["x3 – TUONGM43", "0,43", "0,25"],
          ["x4 – TUONGM78", "0,78", "0,40"],
          ["x5 – DAY130", "1,30", "0,71"],
          ["x6 – DAY60", "0,60", "0,58"],
          [{ children: [run("Khối lượng bê tông V (m³)", { bold: true })] }, { children: [run("284,14", { bold: true })] }, { children: [run("232,48 (min)", { bold: true })] }],
          [{ children: [run("Chênh lệch ΔV", { bold: true })] }, "--", { children: [run("-51,66 m³ (-18,18%)", { bold: true })] }],
        ],
        [5.5, 4, 5]
      ),
      P("Nghiệm tối ưu giảm chiều dày ở cả sáu vùng so với hiện trạng, trong đó mức giảm lớn nhất tương đối rơi vào vùng bản đáy DAY130 (giảm từ 1,30m xuống 0,71m, tương ứng 45,4%) — vùng có diện tích nhỏ nhất (33,97 m²) nhưng chiều dày hiện trạng lớn nhất, cho thấy dư thừa khả năng chịu lực đáng kể ở vùng này trong thiết kế ban đầu. Ngược lại, vùng DAY60 (diện tích lớn nhất, 290,27 m²) chỉ giảm nhẹ từ 0,60m xuống 0,58m, phù hợp với việc vùng có diện tích lớn đóng góp tỷ trọng lớn vào hàm mục tiêu nên thuật toán thận trọng hơn khi giảm chiều dày ở đây."),

      subHeading("3.3. Kiểm tra ràng buộc kỹ thuật của nghiệm tối ưu"),
      P("Bảng 3 tổng hợp giá trị các đại lượng kiểm tra của nghiệm tối ưu so với giới hạn cho phép."),
      caption("Bảng 3. Kiểm tra ràng buộc của nghiệm tối ưu"),
      makeTable(
        ["Ràng buộc", "Giá trị/tỷ số", "Giới hạn", "Kết luận"],
        [
          ["Sức chịu tải cọc (tỷ số Nd/[Nd] lớn nhất)", "0,375", "≤ 1,0", "Thỏa mãn"],
          ["Chuyển vị ngang đỉnh tường", "4,06 mm", "≤ 15 mm", "Thỏa mãn"],
          ["Khả năng chịu cắt", "Không vi phạm", "--", "Thỏa mãn"],
          ["Bề rộng vết nứt", "Không vi phạm", "≤ 0,2 mm", "Thỏa mãn"],
          ["Chọc thủng bản đáy", "Không vi phạm", "--", "Thỏa mãn"],
        ],
        [6, 3, 2.5, 2.5]
      ),
      P("Toàn bộ năm ràng buộc đều thỏa mãn với biên an toàn dương (hàm phạt bằng 0), trong đó ràng buộc sức chịu tải cọc có biên an toàn lớn nhất (tỷ số sử dụng chỉ 37,5%) và ràng buộc chuyển vị ngang có biên an toàn tương đối (4,06mm so với giới hạn 15mm, đạt 27,1% giới hạn) — hai ràng buộc này không phải là ràng buộc chi phối (binding constraint) đối với nghiệm tối ưu tìm được, cho thấy dư địa giảm khối lượng bê tông trong bài toán này chủ yếu bị giới hạn bởi ràng buộc chịu cắt và bề rộng vết nứt tại các vùng chiều dày mỏng nhất."),

      subHeading("3.4. Hiệu quả tính toán"),
      P([run("Toàn bộ quá trình tối ưu thực hiện 2.550 lần đánh giá (bằng "), ...v("N", "pop"), run(" × ("), ...v("Max", "it"), run("+1) = 50 × 51), mỗi lần đánh giá bao gồm một lần cập nhật thuộc tính tiết diện và một lần giải FEM đầy đủ trong SAP2000. Thời gian tính toán thực đo trung bình khoảng 15,4 giây cho mỗi lần đánh giá, với kiến trúc tuần tự sử dụng một phiên SAP2000 duy nhất (không song song hóa). Tổng thời gian tính toán của toàn bộ quá trình tối ưu xấp xỉ 10 giờ 55 phút.")]),

      subHeading("3.5. Hạn chế"),
      P([run("Nghiên cứu chỉ thực hiện một lần chạy độc lập ("), ...v("N", "run"), run("=1), phù hợp với mục tiêu ứng dụng SFOA làm công cụ thiết kế cho một công trình cụ thể thay vì đánh giá độ ổn định thống kê của thuật toán; đường cong hội tụ ổn định rõ rệt (mục 3.1) được dùng làm minh chứng thay thế cho thống kê đa lần chạy. Các ràng buộc chịu cắt và bề rộng vết nứt trong vòng lặp tối ưu dựa trên tỷ lệ cốt thép ước tính từ mô men yêu cầu ("), ...v("A", "s,req"), run("), chưa hậu kiểm theo bản vẽ bố trí cốt thép cấu tạo cụ thể; nghiệm được đề xuất cần được hậu kiểm chi tiết trước khi triển khai thi công.")]),

      // ---- 4. KẾT LUẬN ----
      mainHeading("4. Kết luận"),
      P("Nghiên cứu đã xây dựng và áp dụng thành công một khung tính toán kết hợp SAP2000, MATLAB và thuật toán tối ưu sao biển nguyên bản (SFOA) cho bài toán tối ưu khối lượng bê tông kết cấu tường chắn và bản đáy của một công trình kè sau cầu thực tế, với sáu biến thiết kế và năm ràng buộc kỹ thuật theo tiêu chuẩn Việt Nam hiện hành được kiểm tra đồng thời trong vòng lặp tối ưu, bao gồm hai tiêu chuẩn mới ban hành gần đây (TCVN 10304:2025 và TCVN 4116:2023). Kết quả tối ưu đạt khối lượng bê tông 232,48 m³, giảm 51,66 m³ (18,18%) so với thiết kế hiện trạng, đồng thời thỏa mãn toàn bộ năm ràng buộc kỹ thuật với biên an toàn dương; đường cong hội tụ ổn định từ vòng lặp thứ 47 trên tổng số 50 vòng lặp, cho thấy quy mô tính toán đã chọn là phù hợp."),
      P("Kết quả cho thấy SFOA nguyên bản, không cần điều chỉnh hay bổ sung cơ chế đặc thù, có khả năng khai thác hiệu quả dư thừa khả năng chịu lực phân bố không đồng đều giữa các vùng kết cấu có nội lực khác nhau — điều mà thiết kế theo kinh nghiệm, kiểm tra tuần tự từng tiết diện, khó nhận diện đầy đủ trong một không gian thiết kế có quy mô tổ hợp rời rạc vượt xa khả năng liệt kê toàn bộ. Hướng phát triển tiếp theo bao gồm hậu kiểm chi tiết cấu tạo cốt thép cho nghiệm được đề xuất trước khi áp dụng vào thiết kế thi công, cũng như mở rộng bài toán sang hướng tối ưu đa mục tiêu (kết hợp thêm tiêu chí chi phí thi công hoặc độ nhạy ràng buộc) và xem xét kiến trúc tính toán song song để tăng quy mô khảo sát trong các nghiên cứu tiếp theo."),

      // ---- TÀI LIỆU THAM KHẢO ----
      mainHeading("Tài liệu tham khảo"),
      P("[1] Zhong, C., Li, G., Meng, Z., Li, H., Yildiz, A.R., Mirjalili, S. Starfish optimization algorithm (SFOA): a bio-inspired metaheuristic algorithm for global optimization compared with 100 optimizers. Neural Computing and Applications, vol. 37, pp. 3641-3683, 2025, doi: 10.1007/s00521-024-10694-1.", { align: AlignmentType.LEFT }),
      P("[2] Deb, K. An efficient constraint handling method for genetic algorithms. Computer Methods in Applied Mechanics and Engineering, vol. 186, no. 2-4, pp. 311-338, 2000, doi: 10.1016/S0045-7825(99)00389-8.", { align: AlignmentType.LEFT }),
      P("[3] TCVN 10304:2025. Thiết kế móng cọc. Bộ Xây dựng, Việt Nam, 2025.", { align: AlignmentType.LEFT }),
      P("[4] TCVN 11820-5:2021. Công trình cảng biển - Yêu cầu thiết kế - Phần 5: Công trình bến. Bộ Khoa học và Công nghệ, Việt Nam, 2021.", { align: AlignmentType.LEFT }),
      P("[5] TCVN 4116:2023. Công trình thủy lợi - Kết cấu bê tông và bê tông cốt thép thủy công - Yêu cầu thiết kế. Bộ Khoa học và Công nghệ, Việt Nam, 2023.", { align: AlignmentType.LEFT }),
      P("[6] TCVN 5574:2018. Thiết kế kết cấu bê tông và bê tông cốt thép. Bộ Khoa học và Công nghệ, Việt Nam, 2018.", { align: AlignmentType.LEFT }),
    ].filter(Boolean),
  }],
});

const outPath = path.join(__dirname, "BAI_BAO_KE_SAU_CAU_SFOA_TCXD.docx");
Packer.toBuffer(doc).then((buf) => {
  fs.writeFileSync(outPath, buf);
  console.log("Wrote " + outPath);
});
