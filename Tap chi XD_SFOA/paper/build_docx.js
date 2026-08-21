// build_docx.js — Generate 02_Draft_SOO_SFOA_Marine_Jetty_TCXD.docx per Tạp chí Xây dựng format
// (A4, Myriad Pro 9pt, margins T3/B2/R1.8/L1.3 cm, headings per spec)
const {
  Document, Packer, Paragraph, TextRun, HeadingLevel, AlignmentType,
  Table, TableRow, TableCell, WidthType, BorderStyle, ShadingType,
  ImageRun, PageBreak, VerticalAlign
} = require("docx");
const fs = require("fs");

const CM = (n) => Math.round(n * 566.929); // cm -> twips
const FONT = "Myriad Pro";
const SZ = 18; // 9pt in half-points
const SZ_TITLE = 26; // 13pt for title-ish text (visually distinct, still modest)

function P(text, opts = {}) {
  return new Paragraph({
    alignment: opts.align || AlignmentType.JUSTIFIED,
    spacing: { after: 160, line: 276 },
    children: Array.isArray(text) ? text : [new TextRun({ text, font: FONT, size: opts.size || SZ, bold: opts.bold, italics: opts.italics })],
  });
}

function run(text, o = {}) {
  return new TextRun({ text, font: FONT, size: o.size || SZ, bold: o.bold, italics: o.italics, superScript: o.sup, subScript: o.sub });
}

function mainHeading(text) {
  return new Paragraph({
    spacing: { before: 240, after: 160 },
    children: [new TextRun({ text: text.toUpperCase(), font: FONT, size: SZ, bold: true })],
  });
}
function subHeading(text) {
  return new Paragraph({
    spacing: { before: 200, after: 120 },
    children: [new TextRun({ text, font: FONT, size: SZ, bold: true })],
  });
}
function caption(text) {
  return new Paragraph({
    alignment: AlignmentType.LEFT,
    spacing: { before: 80, after: 160 },
    children: [new TextRun({ text, font: FONT, size: SZ })],
  });
}
function eq(children, num) {
  return new Paragraph({
    spacing: { before: 120, after: 120 },
    tabStops: [{ type: "right", position: CM(16.9) }],
    children: [...children, new TextRun({ text: "\t" + num, font: FONT, size: SZ })],
  });
}

function makeTable(header, rows, colCmWidths) {
  const totalCm = colCmWidths.reduce((a, b) => a + b, 0);
  const colWidths = colCmWidths.map((c) => CM(c));
  const mkCell = (text, bold, shaded) =>
    new TableCell({
      width: { size: colWidths[0], type: WidthType.DXA },
      verticalAlign: VerticalAlign.CENTER,
      shading: shaded ? { type: ShadingType.CLEAR, fill: "E8E8E8" } : undefined,
      margins: { top: 60, bottom: 60, left: 80, right: 80 },
      children: [new Paragraph({
        alignment: AlignmentType.CENTER,
        children: [new TextRun({ text: String(text), font: FONT, size: SZ, bold })],
      })],
    });
  const headerRow = new TableRow({
    children: header.map((h, i) => {
      const c = mkCell(h, true, true);
      c.width = { size: colWidths[i], type: WidthType.DXA };
      return c;
    }),
  });
  const bodyRows = rows.map((r) => new TableRow({
    children: r.map((v, i) => {
      const c = mkCell(v, false, false);
      c.width = { size: colWidths[i], type: WidthType.DXA };
      return c;
    }),
  }));
  return new Table({
    width: { size: CM(totalCm), type: WidthType.DXA },
    columnWidths: colWidths,
    rows: [headerRow, ...bodyRows],
  });
}

function img(path, wCm, hCm) {
  return new Paragraph({
    alignment: AlignmentType.CENTER,
    spacing: { before: 160, after: 60 },
    children: [new ImageRun({ data: fs.readFileSync(path), transformation: { width: CM(wCm) / 20, height: CM(hCm) / 20 }, type: "png" })],
  });
}

const doc = new Document({
  styles: { default: { document: { run: { font: FONT, size: SZ } } } },
  sections: [{
    properties: {
      page: {
        size: { width: CM(21), height: CM(29.7) },
        margin: { top: CM(3), bottom: CM(2), right: CM(1.8), left: CM(1.3) },
      },
    },
    children: [
      // Title
      new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 120 },
        children: [run("Ứng dụng thuật toán tối ưu sao biển cho tối ưu đơn mục tiêu kết cấu công trình biển", { bold: true, size: 22 })] }),
      new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 200 },
        children: [run("Application of the Starfish Optimization Algorithm to Single-Objective Optimization of Marine Jetty Structures", { italics: true, size: 20 })] }),
      new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 40 },
        children: [run("abc", { bold: true }), run("1,*", { bold: true, sup: true })] }),
      new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 40 },
        children: [run("1", { sup: true }), run("[Đơn vị công tác — cần cập nhật]")] }),
      new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 240 },
        children: [run("*", { sup: true }), run("Email: abc@gmail.com")] }),

      // TÓM TẮT
      subHeading("TÓM TẮT"),
      P("Kết cấu cầu cảng chính (Main Jetty Platform - MJP) trong công trình biển chịu đồng thời tải trọng bản thân và tải trọng khai thác, trong khi vẫn phải bảo đảm chi phí xây dựng hợp lý và độ cứng phù hợp. Nghiên cứu áp dụng thuật toán tối ưu sao biển nguyên bản (Original Starfish Optimization Algorithm - SFOA) để giải hai bài toán tối ưu đơn mục tiêu (SOO) trên hệ kết cấu MJP, với hai mục tiêu độc lập là tối thiểu chi phí xây dựng và tối thiểu chuyển vị lớn nhất. Mô hình phần tử hữu hạn SAP2000 được liên kết trực tiếp với MATLAB qua giao diện COM để đánh giá phản ứng kết cấu trong từng lần lặp của SFOA. Mỗi bài toán được chạy độc lập 30 lần với quần thể 30 cá thể và 150 vòng lặp, xác định qua khảo sát hội tụ thực nghiệm, để đánh giá độ ổn định thuật toán. Kết quả cho thấy SFOA hội tụ ổn định khi tối ưu từng mục tiêu riêng lẻ — MJP-Displacement hội tụ tuyệt đối trên cả 30 lần chạy (CV=0%), MJP-Cost có độ biến động vừa phải (CV=17,98%) — và không có nghiệm nào vi phạm ràng buộc kỹ thuật. Nghiệm tối ưu chi phí và nghiệm tối ưu chuyển vị khác biệt hoàn toàn về biến thiết kế (cọc nhỏ nhất/nhịp lớn nhất so với cọc lớn nhất/nhịp nhỏ nhất) và thể hiện xung đột rõ rệt: ưu tiên chuyển vị làm chi phí tăng 2.542% so với ưu tiên chi phí, trong khi ưu tiên chi phí làm chuyển vị tăng 96,2% so với ưu tiên chuyển vị. Vì cách tiếp cận đơn mục tiêu chỉ tạo ra nghiệm cực trị mà không duy trì tập nghiệm không trội, nghiên cứu chỉ ra sự cần thiết phát triển một phiên bản đa mục tiêu của SFOA (MOSFOA) để cung cấp tập phương án cân bằng chi phí và độ cứng cho bài toán thiết kế thực tế."),
      P([run("Từ khóa: ", { bold: true }), run("Thuật toán tối ưu sao biển; tối ưu đơn mục tiêu; cầu cảng; SAP2000-MATLAB; đánh đổi chi phí-chuyển vị; kết cấu công trình biển.")]),

      subHeading("ABSTRACT"),
      P("The Main Jetty Platform (MJP), a key marine jetty structure, simultaneously resists dead and operational loads while having to satisfy both cost-effectiveness and stiffness requirements. This study applies the original Starfish Optimization Algorithm (SFOA) to two single-objective optimization (SOO) problems on the MJP structural system, using two independent objectives: minimum construction cost and minimum maximum displacement. A SAP2000 finite-element model is coupled directly with MATLAB through a COM interface to evaluate structural response at every SFOA iteration. Each problem is solved over 30 independent runs with a population of 30 individuals and 150 iterations, determined from empirical convergence testing, to assess algorithmic stability. SFOA converges stably when each objective is optimized independently — the displacement problem converges absolutely across all 30 runs (CV=0%), while the cost problem shows moderate variability (CV=17.98%) — with no constraint violations in any run. The cost-optimal and displacement-optimal designs differ entirely in design variables (smallest pile/largest span versus largest pile/smallest span) and reveal a clear conflict: prioritizing displacement increases cost by 2,542% relative to the cost-optimal design, while prioritizing cost increases displacement by 96.2% relative to the displacement-optimal design. Because a single-objective approach only yields extreme solutions and cannot maintain a non-dominated solution set, the study motivates the development of a multi-objective SFOA (MOSFOA) capable of providing a trade-off design set for practical decision-making."),
      P([run("Keywords: ", { bold: true }), run("Starfish Optimization Algorithm; single-objective optimization; main jetty platform; SAP2000-MATLAB coupling; cost-displacement trade-off; marine structures.")]),

      // ĐẶT VẤN ĐỀ
      subHeading("ĐẶT VẤN ĐỀ"),
      P("Cầu cảng chính (Main Jetty Platform - MJP) là hệ kết cấu công trình biển có nhiều biến thiết kế (đường kính cọc, chiều dày thành cọc, chiều dài cọc, nhịp dầm, kích thước dầm...) và chịu đồng thời tổ hợp tải trọng bản thân và tải trọng khai thác. Thiết kế thực tế phải đồng thời bảo đảm an toàn kết cấu, độ cứng/chuyển vị trong giới hạn cho phép và hiệu quả kinh tế. Mô hình phần tử hữu hạn (FEM) cho phép đánh giá trực tiếp phản ứng kết cấu dưới các tổ hợp tải này, còn các thuật toán tối ưu metaheuristic phù hợp với bài toán tối ưu phi tuyến, biến rời rạc và nhiều ràng buộc kỹ thuật mà các phương pháp giải tích khó xử lý."),
      P("Thuật toán tối ưu sao biển (Starfish Optimization Algorithm - SFOA) là một thuật toán metaheuristic lấy cảm hứng từ hành vi săn mồi và tái sinh của sao biển, gồm hai pha chính là khám phá (exploration) và khai thác (exploitation) [1]. SFOA đã được kiểm chứng tốt trên nhiều hàm benchmark và một số bài toán kỹ thuật, tuy nhiên nghiên cứu này không khảo sát SFOA ở mức benchmark mà tập trung vào khả năng ứng dụng của SFOA nguyên bản cho các bài toán tối ưu kết cấu công trình biển thực tế, có tính phi tuyến cao, biến rời rạc và kết hợp trực tiếp với phân tích FEM. Đây là khoảng trống nghiên cứu cần khảo sát, không nhằm khẳng định SFOA là thuật toán yếu."),
      P([run("Trong thiết kế kết cấu công trình biển, hai tiêu chí quan trọng nhất thường là chi phí xây dựng C(x) và chuyển vị lớn nhất D(x), với x là vector biến thiết kế. Khi áp dụng SFOA nguyên bản theo cách tiếp cận đơn mục tiêu (SOO), hai bài toán min C(x) và min D(x) được giải độc lập trong cùng một không gian thiết kế, mỗi bài toán chỉ trả về một nghiệm tối ưu duy nhất theo tiêu chí được chọn.")]),
      P("Mục tiêu tổng quát của nghiên cứu là đánh giá khả năng của SFOA nguyên bản trong tối ưu đơn mục tiêu cho hệ kết cấu MJP, đồng thời phân tích sự khác biệt giữa nghiệm tối ưu chi phí và nghiệm tối ưu chuyển vị để làm rõ giới hạn của cách tiếp cận SOO khi bài toán thiết kế thực tế đòi hỏi xem xét đồng thời nhiều tiêu chí. Nghiên cứu đặt ra ba câu hỏi: (i) SFOA nguyên bản có giải ổn định các bài toán tối ưu chi phí và chuyển vị của MJP hay không; (ii) hai nghiệm tối ưu này khác nhau như thế nào về biến thiết kế và mức đánh đổi chi phí-chuyển vị thể hiện ra sao; (iii) vì sao SOO không đủ để cung cấp tập phương án cho bài toán thiết kế thực tế."),
      P("Đóng góp của nghiên cứu gồm ba điểm: (1) xây dựng và kiểm chứng framework liên kết SAP2000-MATLAB-SFOA cho tối ưu đơn mục tiêu kết cấu công trình biển; (2) đánh giá SFOA nguyên bản trên hệ kết cấu cầu cảng chính (MJP) — hệ kết cấu chính trong ba hệ đã khảo sát ở bài MOO/MOSFOA nền [2] — với biến thiết kế rời rạc và ràng buộc kỹ thuật theo tiêu chuẩn Việt Nam và quốc tế; (3) định lượng sự khác biệt giữa nghiệm cost-optimal và displacement-optimal, từ đó xác lập cơ sở kỹ thuật cho nhu cầu tối ưu đa mục tiêu (MOO) và bước phát triển tiếp theo là MOSFOA."),

      // 1. MÔ HÌNH
      mainHeading("1. Mô hình bài toán và phương pháp nghiên cứu"),
      subHeading("1.1. Hệ kết cấu nghiên cứu"),
      P("Nghiên cứu tối ưu đa mục tiêu (MOO/MOSFOA) nền [2] đã khảo sát ba hệ kết cấu công trình biển: Berthing Dolphin (BD), Mooring Dolphin (MD) và Main Jetty Platform (MJP). Nghiên cứu SOO này tập trung vào MJP — hệ kết cấu chính trong ba hệ trên, do đây là kết cấu chịu tải khai thác trực tiếp và có không gian biến thiết kế phong phú nhất (bao gồm cả cấu hình cọc và kích thước dầm); việc thu hẹp phạm vi khảo sát từ ba hệ xuống một hệ là lựa chọn có chủ đích nhằm tập trung tài nguyên tính toán thực tế cho một hệ kết cấu đại diện, thay vì dàn trải trên cả ba hệ (xem thêm phần Hạn chế). MJP là hệ khung cọc-dầm-bản mặt cầu bê tông cốt thép, cọc đứng bố trí dạng lưới, dầm dọc/ngang và bản mặt cầu, chịu tổ hợp tải trọng bản thân (DL) và tải trọng khai thác (LL). Cấu hình cọc, kích thước dầm và số lượng cọc được lấy đúng theo mô hình SAP2000 nền đã dùng trong [2]. Thiết kế hiện tại (baseline) của MJP dùng cọc loại 500-B (D=500 mm, t=80 mm), chiều dài 38 m, nhịp dọc/ngang 4,2×4,5 m, dầm 0,7×1,0 m — số liệu này đã được đối chiếu trực tiếp với Bảng 12 của [2] và kiểm chứng lại bằng cách chạy chính mô hình SAP2000-MATLAB của nghiên cứu này cho đúng cấu hình đó, thu được kết quả khớp hoàn toàn với [2] (mục 3.2)."),

      subHeading("1.2. Khung liên kết SAP2000-MATLAB-SFOA"),
      P("Mô hình FEM được giữ nguyên như trong nghiên cứu MOO nền. Với mỗi vector thiết kế x do SFOA đề xuất, MATLAB cập nhật các thông số hình học (đường kính, chiều dày, chiều dài cọc, kích thước dầm...) trực tiếp vào mô hình SAP2000 đang mở thông qua giao diện lập trình COM (SAP2000 OAPI, gọi tắt là công cụ SM), sau đó ra lệnh chạy phân tích FEM. Kết quả chuyển vị, nội lực (N, M, V) và phản lực gối được truy xuất ngược lại MATLAB để kiểm tra ràng buộc và tính giá trị hàm mục tiêu có phạt (objective + penalty), làm đầu vào cho vòng lặp tiếp theo của SFOA. Cơ chế liên kết hai chiều này cho phép SFOA tối ưu trực tiếp trên đáp ứng kết cấu thật, không cần xây dựng hàm surrogate."),

      subHeading("1.3. Tải trọng và tổ hợp tải"),
      P("Hệ tải trọng của MJP gồm DL (tự tính trong SAP2000) và LL (tải trọng khai thác), giữ nguyên tổ hợp DL+LL theo mô hình MOO nền [2]. (Hai hệ BD và MD của bài MOO nền chịu thêm tải trọng cập tàu BL và tải trọng neo ML theo PIANC [5]/OCDI [6], nhưng nằm ngoài phạm vi khảo sát của bài SOO này — xem mục 1.1.)"),

      subHeading("1.4. Tiêu chuẩn và ràng buộc kỹ thuật"),
      P("Ràng buộc kỹ thuật áp dụng theo TCVN 7888:2014 về kích thước cọc bê tông dự ứng lực [3], TCVN 10304:2014 về thiết kế móng cọc và sức chịu tải [4], cùng các yêu cầu về sức chịu tải dọc trục, sức chịu nhổ và mô men uốn giới hạn của cọc đã tích hợp trong SAP2000. Ràng buộc được xử lý bằng hàm phạt (penalty), với tổng T ràng buộc:"),
      eq([run("P(x) = "), run("Σ", {}), run("T", { sup: true }), run("j=1", { sub: true }), run(" λ"), run("j", { sub: true }), run(" [max(0, g"), run("j", { sub: true }), run("(x))]"), run("p", { sup: true })], "(1)"),

      subHeading("1.5. Biến thiết kế và hàm mục tiêu"),
      P([run("Vector biến thiết kế của MJP là x=[D,t,L,L"), run("L", { sub: true }), run(",L"), run("T", { sub: true }), run(",b,h], trong đó D là đường kính cọc, t là chiều dày thành cọc, L là chiều dài cọc, L"), run("L", { sub: true }), run(" là nhịp dọc, L"), run("T", { sub: true }), run(" là nhịp ngang, b là bề rộng dầm và h là chiều cao dầm; D, t, L được chọn rời rạc theo danh mục cọc tham chiếu, còn L"), run("L", { sub: true }), run(", L"), run("T", { sub: true }), run(", b, h theo miền rời rạc đã khóa trong mô hình MOO nền.")]),
      P([run("Hàm mục tiêu chi phí là C(x)=N"), run("p", { sub: true }), run("L"), run("p", { sub: true }), run("P"), run("p", { sub: true }), run("+V"), run("b", { sub: true }), run("P"), run("c", { sub: true }), run("+W"), run("s", { sub: true }), run("P"), run("s", { sub: true }), run(" (chi phí cọc theo số lượng, chiều dài, đơn giá, cộng chi phí bê tông và cốt thép dầm). Hàm mục tiêu chuyển vị là D(x)=D"), run("max", { sub: true }), run("(x), lấy trực tiếp từ kết quả phân tích SAP2000. Hàm fitness cuối cùng cho hai bài toán tối ưu chi phí (SOO-C) và tối ưu chuyển vị (SOO-D) là:")]),
      eq([run("F"), run("C", { sub: true }), run("(x)=C(x)+P(x);   F"), run("D", { sub: true }), run("(x)=D(x)+P(x)")], "(2)"),

      subHeading("1.6. Thuật toán SFOA nguyên bản"),
      P("Nghiên cứu sử dụng đúng SFOA nguyên bản [1], không bổ sung archive Pareto, non-dominated sorting, leader selection hay các cơ chế đa mục tiêu khác — đây là điểm phân biệt cốt yếu giữa bài toán SOO trong nghiên cứu này và MOSFOA ở bước phát triển tiếp theo. Trong pha khám phá, mỗi cá thể cập nhật vị trí theo một trong hai chiến lược phụ thuộc số chiều bài toán, có tham chiếu đến nghiệm tốt nhất hiện tại; trong pha khai thác, cá thể cập nhật theo cơ chế \"săn mồi\" dựa trên năm cá thể tham chiếu (năm cánh sao biển) và cơ chế \"tái sinh\" cho cá thể cuối cùng của quần thể. Sau mỗi lần cập nhật liên tục, nghiệm được kiểm soát biên rồi ánh xạ về tập giá trị thiết kế rời rạc hợp lệ (theo danh mục cọc, bước lưới dầm) trước khi gửi sang SAP2000 đánh giá."),
      P("Điều kiện dừng được khóa thống nhất cho cả hai bài toán: quần thể 30 cá thể và 150 vòng lặp — số vòng lặp được xác định từ một khảo sát hội tụ thực nghiệm riêng ở đúng quy mô quần thể 30 (không suy diễn từ quy mô quần thể khác): nghiệm tối ưu chi phí hội tụ tuyệt đối từ vòng lặp thứ 125-130 và giữ nguyên tới vòng 250 trong khảo sát mở rộng, nên 150 vòng cho biên an toàn khoảng 20 vòng sau điểm hội tụ thật; nghiệm tối ưu chuyển vị hội tụ còn sớm hơn (từ vòng 50-100) — với 30 lần chạy độc lập mỗi bài toán. Quần thể 30 cá thể (thay vì mức 100 thường dùng trong khảo sát benchmark) là giá trị mặc định phổ biến trong các nghiên cứu SFOA/metaheuristic và được lựa chọn để bài toán khả thi về thời gian tính toán trên hạ tầng SAP2000-MATLAB thực tế của nghiên cứu, do mỗi lần đánh giá cá thể đòi hỏi một lần giải FEM đầy đủ."),

      // 2. THIẾT LẬP
      mainHeading("2. Thiết lập thực nghiệm số"),
      P("Hai bài toán SOO được thiết lập từ hệ kết cấu MJP và hai mục tiêu độc lập, như trong Bảng 1."),
      caption("Bảng 1. Ma trận hai bài toán tối ưu đơn mục tiêu"),
      makeTable(["Case", "Kết cấu", "Mục tiêu", "Thuật toán"],
        [["C1", "MJP", "Min Cost", "Original SFOA"], ["C2", "MJP", "Min Displacement", "Original SFOA"]],
        [2.5, 3, 4.5, 5.5]),
      P([run("Mỗi case được chạy 30 lần độc lập với cùng mô hình FEM, cùng tải trọng, cùng ràng buộc, cùng hàm phạt và cùng miền biến, tổng cộng 2×30=60 lượt chạy độc lập. Kết quả được đánh giá theo ba nhóm chỉ tiêu: (i) chỉ tiêu thuật toán — giá trị tốt nhất (Best), trung bình (Mean), xấu nhất (Max), độ lệch chuẩn (STD) và đường hội tụ; (ii) chỉ tiêu kết cấu — chi phí, chuyển vị lớn nhất, biến thiết kế và trạng thái ràng buộc; (iii) chỉ tiêu đánh đổi — chi phí của nghiệm tối ưu chuyển vị, chuyển vị của nghiệm tối ưu chi phí, và phần trăm chênh lệch giữa hai nghiệm cực trị.")]),

      // 3. KẾT QUẢ
      mainHeading("3. Kết quả và thảo luận"),
      subHeading("3.1. Khả năng hội tụ và độ ổn định của SFOA"),
      P("Đường hội tụ Best-so-far của SFOA cho hai bài toán (Hình 1) và kết quả thống kê 30 lần chạy (Bảng 2) được dùng để đánh giá đồng thời chất lượng nghiệm và độ ổn định — không kết luận SFOA tốt hay yếu chỉ dựa trên một đường hội tụ đơn lẻ."),
      caption("Bảng 2. Kết quả thống kê 30 lần chạy của SFOA cho MJP-Cost và MJP-Displacement"),
      makeTable(["Case", "Best", "Mean", "Max", "STD", "CV (%)"],
        [["MJP-C", "5.291,8573", "8.012,5085", "10.073,9390", "1.440,4557", "17,98"],
         ["MJP-D", "0,0000388", "0,0000388", "0,0000388", "0,0000000", "0,00"]],
        [2.5, 3, 3, 3, 3, 2.5]),
      P("MJP-Displacement hội tụ tuyệt đối trên cả 30 lần chạy độc lập — cả 30 giá trị Best đều bằng 0,0000388 (STD=0, CV=0%), cho thấy độ ổn định gần như hoàn hảo của SFOA với bài toán này. MJP-Cost có CV=17,98%, mức biến động vừa phải, thường gặp ở các bài toán tối ưu kết cấu rời rạc nhiều ràng buộc — không có run nào vi phạm ràng buộc (tất cả 30 nghiệm tốt nhất đều thỏa AllConstraintsSatisfied=1)."),

      img("D:/ResearchLab/02_Projects/02_Projects/Tap chi XD_SFOA/paper_figures/Hinh1_convergence.png", 16.5, 6.8),
      caption("Hình 1. Đường hội tụ Best-so-far của SFOA cho (a) MJP-Cost và (b) MJP-Displacement (30 lần chạy độc lập, thang log)"),

      subHeading("3.2. Kết quả tối ưu của MJP"),
      P("Hai nghiệm tối ưu (cost-optimal và displacement-optimal) được so sánh về biến thiết kế, chi phí và chuyển vị (Bảng 3), đồng thời đối chiếu với thiết kế hiện tại để xác định mức tiết kiệm chi phí hoặc cải thiện độ cứng đạt được (Bảng 4)."),
      caption("Bảng 3. Hai nghiệm tối ưu đơn mục tiêu của MJP"),
      makeTable(["Nghiệm", "Mục tiêu", "Cọc", "D(mm)", "t(mm)", "L(m)", "LL(m)", "LT(m)", "b(m)", "h(m)", "Cost(USD)", "Disp.(m)"],
        [["MJP-C", "Cost", "300-A", "300", "60", "37,8", "5,3", "5,6", "0,5", "0,5", "5.291,86 (min)", "0,00102"],
         ["MJP-D", "Displ.", "1200-C", "1.200", "150", "16,8", "3,0", "3,0", "1,4", "2,0", "139.831,48", "0,0000388 (min)"]],
        [1.6, 1.5, 1.5, 1.3, 1.2, 1.2, 1.2, 1.2, 1.1, 1.1, 1.9, 1.9]),
      caption("Ký hiệu loại cọc (300-A, 1200-C...) đối chiếu trực tiếp với Bảng 12 của bài MOO nền [2] theo đơn giá cọc (USD/m) — nghiệm MJP-D khớp tuyệt đối (Cost và Displacement giống đến từng chữ số) với thiết kế \"III\" (cọc 1200-C) trong [2], một kiểm chứng độc lập cho mô hình SAP2000-MATLAB dùng trong nghiên cứu này."),
      P("Nghiệm cost-optimal chọn cọc nhỏ nhất trong danh mục (D300, cấp thép thấp nhất) và nhịp dầm lớn nhất có thể (5,3×5,6 m, ít cọc/nhịp hơn), cùng kích thước dầm tối thiểu — toàn bộ biến đều dịch về hướng \"rẻ nhất khả thi\". Nghiệm displacement-optimal chọn cọc lớn nhất trong danh mục (D1200, cấp thép cao nhất), nhịp dầm nhỏ nhất có thể (3,0×3,0 m, nhiều cọc/nhịp hơn) và dầm lớn nhất có thể — toàn bộ biến dịch về hướng \"cứng nhất khả thi\". Cả hai nghiệm đều thỏa mọi ràng buộc kỹ thuật (bearing, moment, uplift, khoảng cách cọc-dầm)."),

      caption("Bảng 4. So sánh thiết kế hiện tại và nghiệm SOO của MJP"),
      makeTable(["Thiết kế", "Cọc", "Cost (USD)", "ΔCost (%)", "Displacement (m)", "ΔD (%)"],
        [["Current (L=38m, 4,2×4,5m, 0,7×1,0m) [2]", "500-B", "25.708,9425", "--", "0,00022445", "--"],
         ["SFOA-C", "300-A", "5.291,8573", "-79,4", "0,00102", "+353,7"],
         ["SFOA-D", "1200-C", "139.831,4792", "+443,9", "0,0000388", "-82,7"]],
        [5.5, 1.8, 2.8, 2.2, 3, 2.2]),
      caption("Thiết kế hiện tại lấy nguyên từ Bảng 12 của bài MOO nền [2]; nghiên cứu này đã tái tạo độc lập qua cùng mô hình SAP2000-MATLAB và thu được kết quả khớp hoàn toàn (25.708,9425 USD và 0,00022445 m), xác nhận tính nhất quán của mô hình FEM."),
      P("So với thiết kế hiện tại, nghiệm cost-optimal giảm chi phí 79,4% nhưng chuyển vị tăng ~3,5 lần (vẫn ở mức milimét, thỏa mọi ràng buộc); nghiệm displacement-optimal giảm chuyển vị 82,7% nhưng chi phí tăng gần 4,4 lần. Thiết kế hiện tại nằm ở vị trí trung gian giữa hai nghiệm cực trị — bản thân đây đã là một minh chứng trực quan cho việc không có \"một thiết kế tốt nhất\" duy nhất khi xét đồng thời hai tiêu chí."),

      subHeading("3.3. Phân tích đánh đổi chi phí-chuyển vị"),
      P([run("Đây là phần phân tích cốt lõi của nghiên cứu. Chuyển vị tại nghiệm cost-optimal (D"), run("C", { sub: true }), run(") và chi phí tại nghiệm displacement-optimal (C"), run("D", { sub: true }), run(") được so sánh chéo với hai nghiệm cực trị C"), run("C", { sub: true }), run("*"), run(" và D"), run("D", { sub: true }), run("*"), run(" (Bảng 5, Hình 2), từ đó tính:")]),
      eq([run("ΔC = (C"), run("D", { sub: true }), run("-C"), run("C", { sub: true }), run("*"), run(")/C"), run("C", { sub: true }), run("*"), run(" × 100%;   ΔD = (D"), run("C", { sub: true }), run("-D"), run("D", { sub: true }), run("*"), run(")/D"), run("C", { sub: true }), run(" × 100%")], "(3)"),
      caption("Bảng 5. So sánh chéo hai nghiệm cực trị của MJP"),
      makeTable(["Kết cấu", "C_C* (USD)", "D_C (m)", "D_D* (m)", "C_D (USD)", "ΔC (%)", "ΔD (%)"],
        [["MJP", "5.291,8573", "0,00102", "0,0000388", "139.831,4792", "2.542,2", "96,2"]],
        [2.2, 2.6, 2, 2, 2.6, 2, 2]),
      P("Dữ liệu thực nghiệm xác nhận đồng thời C(x_C*)=5.291,86 < C(x_D*)=139.831,48 và D(x_D*)=0,0000388 < D(x_C*)=0,00102 trên hệ kết cấu MJP — hai bất đẳng thức xảy ra đồng thời, đúng điều kiện cần để khẳng định chi phí và chuyển vị là hai mục tiêu xung đột. Nếu ưu tiên chuyển vị thay vì chi phí, chi phí tăng 2.542% (~25,4 lần); nếu ưu tiên chi phí thay vì chuyển vị, chuyển vị \"chỉ\" tăng tương đối 96,2% nhưng giá trị tuyệt đối vẫn rất nhỏ (1,02 mm) — bất đối xứng này cho thấy độ nhạy của chi phí với yêu cầu độ cứng lớn hơn nhiều so với độ nhạy của chuyển vị với yêu cầu tiết kiệm, một quan sát kỹ thuật có giá trị riêng. Kết luận đúng cần được phát biểu là: SFOA giải tốt từng bài toán đơn mục tiêu, nhưng bản chất đơn mục tiêu chỉ cho phép một tiêu chí chi phối quá trình chọn nghiệm, không tạo ra tập nghiệm không trội tương đương Pareto front do không có cơ chế lưu trữ archive, bảo toàn đa dạng hay chọn leader trong không gian mục tiêu. Do đó, bài toán thiết kế thực tế — vốn cần đồng thời cân bằng chi phí và độ cứng — không thể được giải quyết đầy đủ chỉ bằng cách tiếp cận SOO, và đây là cơ sở kỹ thuật trực tiếp cho việc phát triển MOSFOA ở bài báo tiếp theo. Vì nghiên cứu này chỉ khảo sát MJP (không lặp lại trên BD, MD như bài MOO nền [2]), kết luận về xung đột mục tiêu được phát biểu ở mức hệ kết cấu đơn lẻ; tính tổng quát trên nhiều hệ kết cấu đã được minh chứng độc lập trong [2] và cần nêu rõ giới hạn này trong phần Hạn chế."),

      img("D:/ResearchLab/02_Projects/02_Projects/Tap chi XD_SFOA/paper_figures/Hinh2_tradeoff.png", 13, 8.7),
      caption("Hình 2. Quan hệ đánh đổi chi phí-chuyển vị giữa thiết kế hiện tại và hai nghiệm tối ưu đơn mục tiêu của MJP"),

      subHeading("3.4. Hiệu quả tính toán"),
      P("Trung bình mỗi lần chạy MJP-Cost tốn 3.945,5s (~65,8 phút) và MJP-Displacement tốn 4.125,6s (~68,8 phút) với Npop=30, Max_it=150 (4.530 lần gọi SAP2000/run). Tổng thời gian tính toán thực tế cho 60 run là 242.133,2s (~67,3 giờ). Một quan sát đáng chú ý trong quá trình khảo sát hội tụ (pilot) là thời gian mỗi vòng lặp không cố định mà tăng dần khi quần thể hội tụ — quần thể ngẫu nhiên ban đầu có nhiều cá thể không khả thi bị loại nhanh bằng phạt cứng, trong khi quần thể đã hội tụ có phần lớn cá thể khả thi, phải giải FEM và kiểm tra ràng buộc đầy đủ, làm tăng thời gian mỗi vòng lặp 2-4 lần so với lúc khởi động. Đây là đặc điểm riêng của các bài toán SOO kết hợp trực tiếp với FEM lặp, khác với benchmark toán học thuần túy, và là dữ liệu tham khảo hữu ích cho các nghiên cứu tối ưu kết cấu-FEM chi phí cao khác."),

      // KẾT LUẬN
      subHeading("KẾT LUẬN"),
      P("Nghiên cứu đã triển khai và kiểm chứng framework liên kết SAP2000-MATLAB-SFOA để giải hai bài toán tối ưu đơn mục tiêu (tối thiểu chi phí và tối thiểu chuyển vị) trên hệ kết cấu cầu cảng chính (MJP) — hệ kết cấu chính trong ba hệ đã khảo sát ở bài MOO/MOSFOA nền [2], qua 60 lượt chạy độc lập (30 run/mục tiêu). Kết quả cho thấy: (1) SFOA nguyên bản hội tụ ổn định và cho nghiệm khả thi kỹ thuật trên cả hai bài toán — MJP-Displacement hội tụ tuyệt đối trên toàn bộ 30 lần chạy (CV=0%), MJP-Cost có độ biến động vừa phải (CV=17,98%), không run nào vi phạm ràng buộc; (2) nghiệm tối ưu chi phí (Cost=5.291,86) và nghiệm tối ưu chuyển vị (Displacement=0,0000388 m) khác biệt hoàn toàn về biến thiết kế — cost-optimal chọn cọc nhỏ nhất và nhịp lớn nhất, displacement-optimal chọn cọc lớn nhất và nhịp nhỏ nhất — và tạo ra đánh đổi rõ rệt: ưu tiên chuyển vị làm chi phí tăng 2.542% so với ưu tiên chi phí, ngược lại ưu tiên chi phí làm chuyển vị tăng 96,2% (nhưng vẫn ở bậc milimét); (3) vì SOO chỉ cung cấp nghiệm tối ưu theo từng mục tiêu riêng lẻ và không duy trì tập nghiệm không trội, cách tiếp cận này chưa đủ để hỗ trợ bài toán thiết kế đồng thời nhiều mục tiêu. Kết quả nghiên cứu không phủ nhận hiệu quả của SFOA trong tối ưu đơn mục tiêu; thay vào đó, nghiên cứu chỉ ra rằng giới hạn nằm ở bản chất đơn mục tiêu của mô hình tối ưu, từ đó tạo động lực khoa học và kỹ thuật cho việc mở rộng SFOA sang một phiên bản đa mục tiêu (MOSFOA) ở bước nghiên cứu tiếp theo. Do ràng buộc thời gian tính toán thực tế, nghiên cứu chỉ khảo sát MJP thay vì cả ba hệ kết cấu của bài MOO nền; đây là giới hạn cần nêu rõ, và việc mở rộng khảo sát sang BD, MD bằng cùng framework là hướng phát triển khả thi cho các nghiên cứu tiếp theo."),

      // TÀI LIỆU THAM KHẢO
      subHeading("TÀI LIỆU THAM KHẢO"),
      P("[1] Zhong, C., Li, G., Meng, Z., Li, H., Yildiz, A.R., Mirjalili, S. Starfish optimization algorithm (SFOA): a bio-inspired metaheuristic algorithm for global optimization compared with 100 optimizers. Neural Computing and Applications, vol. 37, pp. 3641-3683, 2025."),
      P("[2] Do-Quang, T., Vu-Huu, T., Cuong-Le, T. Multi-objective optimization design of marine structures based on an enhanced starfish algorithm. Bản thảo đang chuẩn bị nộp / in preparation."),
      P("[3] TCVN 7888:2014. Cọc bê tông ly tâm ứng lực trước. Bộ Khoa học và Công nghệ, Việt Nam, 2014."),
      P("[4] TCVN 10304:2014. Móng cọc - Tiêu chuẩn thiết kế. Bộ Khoa học và Công nghệ, Việt Nam, 2014."),
      P("[5] PIANC. Guidelines for the Design of Fender Systems: 2002. Permanent International Association of Navigation Congresses, Brussels, 2002."),
      P("[6] OCDI. Technical Standards and Commentaries for Port and Harbour Facilities in Japan. The Overseas Coastal Area Development Institute of Japan, Tokyo, 2002."),
    ],
  }],
});

Packer.toBuffer(doc).then((buf) => {
  fs.writeFileSync("02_Draft_SOO_SFOA_Marine_Jetty_TCXD.docx", buf);
  console.log("DONE");
});
