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
        children: [run("Nghiên cứu đánh giá khả năng ứng dụng thuật toán tối ưu sao biển trong bài toán tối ưu đơn mục tiêu kết cấu công trình biển", { bold: true, size: 22 })] }),
      new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 200 },
        children: [run("Study on the applicability of the starfish optimization algorithm to single-objective optimization of marine structures", { size: 20 })] }),
      new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 40 },
        children: [run("ABC", { bold: true }), run("1,*", { bold: true, sup: true })] }),
      new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 40 },
        children: [run("1", { sup: true }), run("[Đơn vị công tác — cần cập nhật]")] }),
      new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 240 },
        children: [run("*", { sup: true }), run("Email: abc@gmail.com")] }),

      // TÓM TẮT
      subHeading("TÓM TẮT"),
      P("Nghiên cứu đánh giá khả năng ứng dụng thuật toán tối ưu sao biển nguyên bản (Original Starfish Optimization Algorithm – SFOA) trong bài toán tối ưu đơn mục tiêu (Single-Objective Optimization – SOO) cho kết cấu cầu cảng chính (Main Jetty Platform – MJP). Hai bài toán SOO được khảo sát độc lập với mục tiêu tối thiểu chi phí vật liệu và tối thiểu chuyển vị lớn nhất của kết cấu. Mô hình phần tử hữu hạn SAP2000 được liên kết trực tiếp với MATLAB thông qua giao diện COM, cho phép SFOA cập nhật biến thiết kế và đánh giá phản ứng kết cấu bằng FEM trong vòng lặp tối ưu. Mỗi bài toán được thực hiện 30 lần độc lập với quần thể 30 cá thể và 150 vòng lặp; kết quả được đánh giá thông qua giá trị Best, Mean, Max, STD, CV và đặc điểm hội tụ. Kết quả cho thấy giá trị Best của bài toán chuyển vị giống nhau tuyệt đối giữa 30 lần chạy (CV = 0%), trong khi bài toán chi phí có CV = 17,98%. Hai nghiệm tốt nhất theo hai mục tiêu khác biệt rõ rệt về cấu hình cọc, nhịp và kích thước dầm, đồng thời thể hiện sự đánh đổi đáng kể giữa chi phí và chuyển vị: chi phí của nghiệm chuyển vị cao hơn 2.542,2% (tương đương khoảng 26,4 lần), trong khi chuyển vị của nghiệm chi phí cao hơn 96,2%. Hai nghiệm được báo cáo đều đạt các ràng buộc cọc được triển khai trong quá trình tối ưu và được hậu kiểm thiết kế dầm. Kết quả cho thấy SOO bằng SFOA có khả năng tìm kiếm các cấu hình kết cấu phù hợp theo từng tiêu chí riêng lẻ, nhưng chỉ cung cấp các nghiệm cực trị thay vì một tập phương án cân bằng giữa nhiều tiêu chí. Đây là cơ sở thực nghiệm cho nghiên cứu phát triển SFOA đa mục tiêu (MOSFOA) trong các bài toán thiết kế kết cấu công trình biển."),
      P([run("Từ khóa: ", { bold: true }), run("Thuật toán tối ưu sao biển; tối ưu đơn mục tiêu; kết cấu cầu cảng chính; SAP2000–MATLAB; tối ưu kết cấu; đánh đổi chi phí–chuyển vị.")]),

      subHeading("ABSTRACT"),
      P("This study evaluates the applicability of the original Starfish Optimization Algorithm (SFOA) to single-objective optimization (SOO) problems for the Main Jetty Platform (MJP) structure. Two SOO problems are investigated independently, with the objectives of minimizing material cost and minimizing the maximum structural displacement. A SAP2000 finite-element model is coupled directly with MATLAB through a COM interface, allowing SFOA to update design variables and evaluate structural response at every evaluation. Each problem is performed over 30 independent runs with a population of 30 individuals and 150 iterations; results are assessed through Best, Mean, Max, STD, CV values and convergence behavior. Results show that the Best value of the displacement problem has absolute repeatability across 30 runs (CV=0%), while the cost problem has CV=17.98%. The two best solutions found for the two objectives differ markedly in pile configuration, span, and beam dimensions, and exhibit a significant trade-off between cost and displacement: the cost of the displacement-best solution is 2,542.2% higher (equivalent to approximately 26.4 times), while the displacement of the cost-best solution is 96.2% higher. Both reported solutions satisfy the pile constraints implemented during optimization and were post-hoc verified for beam design. The results show that SOO using SFOA can search for structural configurations suited to each individual criterion, but only provides extreme solutions rather than a balanced set of trade-off solutions across multiple criteria. This provides an experimental basis for developing a multi-objective SFOA (MOSFOA) for marine structural design problems."),
      P([run("Keywords: ", { bold: true }), run("Starfish Optimization Algorithm; single-objective optimization; main jetty platform; SAP2000–MATLAB; structural optimization; cost–displacement trade-off.")]),

      // ĐẶT VẤN ĐỀ
      mainHeading("1. Đặt vấn đề"),
      P("Cầu cảng chính (Main Jetty Platform - MJP) là hệ kết cấu công trình biển có nhiều biến thiết kế (đường kính cọc, chiều dày thành cọc, chiều dài cọc, nhịp dầm, kích thước dầm...) và chịu đồng thời tổ hợp tải trọng bản thân và tải trọng khai thác. Thiết kế thực tế phải đồng thời bảo đảm an toàn kết cấu, chuyển vị trong giới hạn cho phép và hiệu quả kinh tế. Mô hình phần tử hữu hạn (FEM) cho phép đánh giá trực tiếp phản ứng kết cấu dưới các tổ hợp tải này, còn các thuật toán tối ưu metaheuristic phù hợp với bài toán tối ưu phi tuyến, biến rời rạc và nhiều ràng buộc kỹ thuật mà các phương pháp giải tích khó xử lý."),
      P("Thuật toán tối ưu sao biển (Starfish Optimization Algorithm - SFOA) là một thuật toán metaheuristic lấy cảm hứng từ hành vi săn mồi và tái sinh của sao biển, gồm hai pha chính là khám phá (exploration) và khai thác (exploitation) [1]. Bài báo gốc của SFOA đã đánh giá thuật toán trên nhiều hàm benchmark và một số bài toán kỹ thuật [1], tuy nhiên nghiên cứu này không khảo sát SFOA ở mức benchmark mà tập trung vào khả năng ứng dụng của SFOA nguyên bản cho các bài toán tối ưu kết cấu công trình biển thực tế, có tính phi tuyến cao, biến rời rạc và kết hợp trực tiếp với phân tích FEM — đặc điểm chung của lớp bài toán mà các thuật toán metaheuristic thường được áp dụng [4]. Đây là vấn đề cần khảo sát, không nhằm khẳng định SFOA là thuật toán yếu."),
      P([run("Trong thiết kế kết cấu công trình biển, hai tiêu chí quan trọng nhất thường là chi phí vật liệu C(x) và chuyển vị lớn nhất D(x), với x là vector biến thiết kế. Khi áp dụng SFOA nguyên bản theo cách tiếp cận đơn mục tiêu (SOO), hai bài toán min C(x) và min D(x) được giải độc lập trong cùng một không gian thiết kế, mỗi bài toán chỉ trả về một nghiệm tối ưu duy nhất theo tiêu chí được chọn.")]),
      P("Mục tiêu tổng quát của nghiên cứu là đánh giá khả năng của SFOA nguyên bản trong tối ưu đơn mục tiêu cho hệ kết cấu MJP, đồng thời phân tích sự khác biệt giữa nghiệm tốt nhất tìm được theo mục tiêu chi phí và nghiệm tốt nhất tìm được theo mục tiêu chuyển vị để làm rõ giới hạn của cách tiếp cận SOO khi bài toán thiết kế thực tế đòi hỏi xem xét đồng thời nhiều tiêu chí. Nghiên cứu đặt ra ba câu hỏi: (i) SFOA nguyên bản có giải ổn định các bài toán tối ưu chi phí và chuyển vị của MJP hay không; (ii) hai nghiệm này khác nhau như thế nào về biến thiết kế và mức đánh đổi chi phí-chuyển vị thể hiện ra sao; (iii) vì sao SOO không đủ để cung cấp tập phương án cho bài toán thiết kế thực tế."),
      P("Đóng góp của nghiên cứu gồm ba điểm: (1) xây dựng và đánh giá framework liên kết SAP2000-MATLAB-SFOA cho tối ưu đơn mục tiêu kết cấu công trình biển, trình bày đầy đủ và tự đứng vững (self-contained) từ mô hình hình học, ràng buộc kỹ thuật đến hàm mục tiêu; (2) đánh giá SFOA nguyên bản trên hệ kết cấu cầu cảng chính (MJP) — hạng mục kết cấu chịu tải khai thác trực tiếp và có không gian biến thiết kế phong phú (bao gồm cả cấu hình cọc và kích thước dầm) — với biến thiết kế rời rạc và ràng buộc kỹ thuật theo tiêu chuẩn Việt Nam; (3) định lượng sự khác biệt giữa nghiệm cost-optimal và displacement-optimal, từ đó xác lập cơ sở kỹ thuật cho nhu cầu tối ưu đa mục tiêu (MOO) và bước phát triển tiếp theo là MOSFOA."),

      // 2. MÔ HÌNH
      mainHeading("2. Mô hình bài toán và phương pháp nghiên cứu"),
      subHeading("2.1. Hệ kết cấu nghiên cứu"),
      P("Cầu cảng chính (Main Jetty Platform - MJP) là hạng mục kết cấu chịu tải khai thác trực tiếp (xe cộ, cần trục, đường ống công nghệ...) trong công trình bến cảng dạng cầu cảng cọc, với không gian biến thiết kế phong phú, bao gồm cả cấu hình cọc (đường kính, chiều dày thành, chiều dài) và kích thước dầm (nhịp dọc/ngang, bề rộng, chiều cao). Đây là lý do nghiên cứu này chọn MJP làm đối tượng khảo sát cho bài toán tối ưu đơn mục tiêu kết hợp SFOA-SAP2000-MATLAB, phù hợp với đặc thù bài toán tối ưu có FEM lồng trong vòng lặp (FEM-in-the-loop) với chi phí đánh giá mỗi cá thể cao."),
      P("MJP là hệ khung cọc-dầm-bản mặt cầu bê tông cốt thép: cọc đứng bố trí dạng lưới, dầm dọc/ngang đỡ bản mặt cầu, chịu tổ hợp tải trọng bản thân (DL) và tải trọng khai thác (LL). Thiết kế hiện tại (baseline, dùng làm mốc so sánh ở mục 4.2) của MJP dùng cọc loại 500-B (D=500 mm, t=80 mm, cấp thép ứng suất trước loại B theo TCVN 7888:2014 [2]), chiều dài cọc 38 m, nhịp dọc/ngang 4,2×4,5 m, dầm 0,7×1,0 m. Toàn bộ hình học, vật liệu, tải trọng, ràng buộc và hàm mục tiêu của MJP được thiết lập và trình bày đầy đủ ngay trong các mục 2.2–2.5 dưới đây, không phụ thuộc vào tài liệu bên ngoài."),

      subHeading("2.2. Khung liên kết SAP2000-MATLAB-SFOA"),
      P("Mô hình phần tử hữu hạn (FEM) của MJP được xây dựng trong SAP2000 theo mô tả tại mục 2.1. Với mỗi vector thiết kế x do SFOA đề xuất, MATLAB cập nhật các thông số hình học (đường kính, chiều dày, chiều dài cọc, kích thước dầm...) trực tiếp vào mô hình SAP2000 đang mở thông qua giao diện lập trình COM (SAP2000 OAPI), sau đó ra lệnh chạy phân tích FEM. Kết quả chuyển vị, nội lực (N, M, V) và phản lực gối được truy xuất ngược lại MATLAB để kiểm tra ràng buộc và tính giá trị hàm mục tiêu có phạt (objective + penalty), làm đầu vào cho vòng lặp tiếp theo của SFOA. Cơ chế liên kết hai chiều này cho phép SFOA tối ưu trực tiếp trên đáp ứng kết cấu thật, không cần xây dựng hàm surrogate."),

      subHeading("2.3. Tải trọng và tổ hợp tải"),
      P("Hệ tải trọng của MJP trong nghiên cứu này gồm tải trọng bản thân (DL, tự tính trong SAP2000 từ khối lượng riêng vật liệu và hình học mô hình, không cần trích dẫn tiêu chuẩn tải trọng riêng) và tải trọng khai thác phân bố đều trên bản mặt cầu (LL=9,81 kN/m², tương đương khoảng 1,0 T/m²). Giá trị LL này là một giả định tải trọng khai thác của mô hình tính toán, không trích dẫn từ một tiêu chuẩn tải trọng cụ thể nào; đây là một giới hạn về nguồn gốc tải trọng cần nêu rõ, và việc đối chiếu/thay thế bằng giá trị LL theo tiêu chuẩn tải trọng công trình bến cảng hiện hành là hướng hoàn thiện cho các nghiên cứu tiếp theo. Hai tải trọng này được tổ hợp thành COMB2=DL+LL, được sử dụng làm tổ hợp khai thác chính trong mô hình nghiên cứu; toàn bộ chi tiết về tổ hợp bao BAO dùng để trích xuất chuyển vị và nội lực cọc được trình bày cụ thể ở mục 2.4."),

      subHeading("2.4. Tiêu chuẩn và ràng buộc kỹ thuật"),
      P("Ràng buộc kỹ thuật áp dụng theo TCVN 7888:2014 về kích thước và cấp cọc bê tông ly tâm dự ứng lực [2], TCVN 10304:2014 về thiết kế móng cọc và sức chịu tải [3]. Cần lưu ý về tính cập nhật của tiêu chuẩn: TCVN 10304:2014 đã được Bộ Xây dựng công bố tiêu chuẩn thay thế là TCVN 10304:2025 [6] (tháng 7/2025), chuyển từ phương pháp hệ số an toàn sang phương pháp trạng thái giới hạn. Mô hình tính sức chịu tải cọc trong nghiên cứu được xây dựng theo TCVN 10304:2014; do đó các kết quả cần được hiểu trong phạm vi bộ tiêu chuẩn này. Việc cập nhật mô hình theo TCVN 10304:2025 được xác định là hướng hoàn thiện trong các nghiên cứu tiếp theo. Ràng buộc được kiểm tra qua hai bước: (i) một bộ điều kiện khả thi hình học/địa chất được kiểm tra trước khi chạy FEM — nếu vi phạm, cá thể bị loại trực tiếp bằng một giá trị phạt cứng (hard penalty) mà không cần giải FEM; (ii) các ràng buộc về nội lực/phản lực cọc được kiểm tra sau khi chạy FEM và xử lý bằng hàm phạt liên tục (soft penalty) theo cách tiếp cận phổ biến trong tối ưu ràng buộc bằng thuật toán tiến hóa/metaheuristic [5], với tổng T ràng buộc:"),
      eq([run("P(x) = "), run("Σ", {}), run("T", { sup: true }), run("j=1", { sub: true }), run(" λ"), run("j", { sub: true }), run(" [max(0, g"), run("j", { sub: true }), run("(x))]"), run("p", { sup: true })], "(1)"),
      P("Bảng 1 liệt kê toàn bộ ràng buộc được áp dụng cho MJP."),
      caption("Bảng 1. Ràng buộc kỹ thuật áp dụng cho MJP"),
      makeTable(["STT", "Ràng buộc", "Đại lượng kiểm tra gj(x)", "Điều kiện thỏa mãn", "Cách xử lý"],
        [["1", "Chiều dài cọc theo sức chịu tải nền", "L so với chiều dài yêu cầu tối thiểu Lu", "L ≥ Lu", "Hard gate"],
         ["2", "Điều kiện đất tại mũi cọc", "Chỉ số sệt IL tại cao độ mũi cọc", "IL < 0,4", "Hard gate"],
         ["3", "Chiều dày lớp đất chịu lực dưới mũi cọc", "Chiều dày lớp đất dưới mũi cọc htip", "htip ≥ 2 m", "Hard gate"],
         ["4", "Khe hở cọc-dầm", "Đường kính cọc D so với bề rộng dầm b", "D+0,2 ≤ b (m)", "Hard gate"],
         ["5", "Mô men uốn cọc (trục 2)", "g1 = max|M2| − Mcr", "g1 ≤ 0", "Soft penalty"],
         ["6", "Mô men uốn cọc (trục 3)", "g1' = max|M3| − Mcr", "g1' ≤ 0", "Soft penalty"],
         ["7", "Sức chịu tải dọc trục cọc (nén và nhổ)", "g2 = Σi max(|F3,i| − Np,adm, 0)", "g2 = 0", "Soft penalty"]],
        [1.2, 3.3, 6, 2.6, 2.6]),
      P("trong đó Mcr là mô men uốn giới hạn và Np,adm là sức chịu tải dọc trục cho phép của cọc, cả hai được xác định theo TCVN 10304:2014 [3] tương ứng với từng loại cọc trong danh mục tham chiếu (Bảng 2); F3,i là phản lực dọc trục tại đầu cọc thứ i. Nếu ràng buộc (1)-(4) vi phạm, cá thể nhận giá trị phạt cứng 10^9 và không được đánh giá FEM (tiết kiệm thời gian tính toán); nếu (5)-(7) vi phạm sau khi chạy FEM, tổng mức vi phạm g1+g1'+g2 được nhân với hệ số phạt λ=10^6 (giống nhau cho mọi ràng buộc, p=1 — phạt tuyến tính) rồi cộng vào hàm mục tiêu theo công thức (1). Một nghiệm được ghi nhận AllConstraintsSatisfied=1 khi tổng mức vi phạm (5)-(7) nhỏ hơn 10^-9 (dung sai số học)."),
      P("Ba điểm cần lưu ý về phạm vi của bộ ràng buộc trên, phục vụ khả năng tái lập và minh bạch của nghiên cứu: (i) Toàn bộ đại lượng Dmax, M2, M3, F3,i dùng để tính ràng buộc và hàm mục tiêu chuyển vị đều được trích xuất từ cùng một tổ hợp tải trọng đặt tên BAO trong SAP2000 — đây là tổ hợp bao (Envelope) giữa COMB1 (chỉ có DL, hệ số 1,0) và COMB2 (DL+LL, hệ số 1,0), cả hai đều ở mức tải trọng chưa nhân hệ số (chưa factor hóa); vì mô hình chỉ có tải trọng cùng chiều tác dụng (không có tải trọng gây đảo dấu nội lực), COMB2 (DL+LL) trong thực tế luôn chi phối giá trị bao BAO. Tổ hợp có hệ số vượt tải riêng (1,4DL; 1,25DL+1,5LL) chỉ được dùng nội bộ cho thiết kế cấu kiện bê tông cốt thép (mục 2.5), không dùng để tính Dmax hay kiểm tra ràng buộc cọc. (ii) Do giới hạn của việc lấy giá trị tuyệt đối |F3,i| trong ràng buộc (7), cả chiều nén và chiều nhổ (kéo) của phản lực dọc trục cọc đều được so sánh với cùng một giá trị Np,adm (sức chịu tải nén cho phép). Đây là một đơn giản hóa của mô hình ràng buộc trong nghiên cứu này: theo TCVN 10304:2014, sức chịu tải chịu nhổ của cọc (chỉ do ma sát thân cọc, không có thành phần chịu mũi) thường nhỏ hơn sức chịu tải chịu nén cho phép cùng loại cọc, nên việc dùng chung Np,adm cho cả hai chiều có thể đánh giá chưa đủ chặt chẽ ràng buộc chống nhổ; giới hạn này cần được nêu rõ trong phần Hạn chế và khắc phục ở các nghiên cứu tiếp theo bằng cách tách riêng hai giá trị sức chịu tải nén/nhổ. (iii) Việc thiết kế cấu kiện bê tông cốt thép của dầm (module DesignConcrete của SAP2000, mục 2.5) được thực hiện lại ở mỗi lần đánh giá cá thể để xác định khối lượng cốt thép yêu cầu Ws phục vụ tính chi phí; kết quả kiểm tra đạt/không đạt của bản thân thiết kế dầm (VerifyPassed, VerifySections, cùng ErrorSummary/WarningSummary của từng dầm) không được ghi lại trong 60 lần chạy của campaign và không được đưa vào làm ràng buộc của bài toán tối ưu — chỉ các ràng buộc về cọc (STT 1-7 ở trên) mới trực tiếp ảnh hưởng đến quá trình tìm kiếm của SFOA. Để làm rõ điểm này, nhóm tác giả đã đánh giá lại hậu kiểm (post-hoc) đúng hai vector thiết kế của nghiệm MJP-C và MJP-D (Bảng 5) qua cùng mô hình SAP2000-MATLAB: cả hai đều cho VerifyPassed/VerifySections không có phần tử nào không đạt, và toàn bộ dầm được kiểm tra (29 dầm ở MJP-C, 80 dầm ở MJP-D) đều có ErrorSummary/WarningSummary rỗng. Kết quả hậu kiểm này chỉ áp dụng cho hai nghiệm được báo cáo, không đại diện cho toàn bộ 60 lần chạy của campaign, và không thay đổi cách xử lý ràng buộc đã mô tả ở trên."),

      subHeading("2.5. Biến thiết kế và hàm mục tiêu"),
      P([run("Vector biến thiết kế của MJP là x=[D,t,L,L"), run("L", { sub: true }), run(",L"), run("T", { sub: true }), run(",b,h], trong đó D là đường kính cọc, t là chiều dày thành cọc, L là chiều dài cọc, L"), run("L", { sub: true }), run(" là nhịp dọc, L"), run("T", { sub: true }), run(" là nhịp ngang, b là bề rộng dầm và h là chiều cao dầm. D, t được chọn đồng thời (ghép cặp thành một \"loại cọc\", ví dụ 300-A, 500-B, 1200-C) theo danh mục cọc bê tông ly tâm dự ứng lực chuẩn theo TCVN 7888:2014 [2], còn L, L"), run("L", { sub: true }), run(", L"), run("T", { sub: true }), run(", b, h là các biến rời rạc theo bước lưới thi công khả thi của mô hình SAP2000-MATLAB dùng cho nghiên cứu này.")]),
      P("Ký hiệu loại cọc gồm một số chỉ đường kính danh nghĩa (mm) và một chữ cái chỉ cấp cọc (A/AB/B/C, ứng với chiều dày thành và cấp thép ứng suất trước tăng dần theo TCVN 7888:2014), mỗi cấp có đơn giá vật liệu riêng Pp (USD/m). Bảng 2 trích một phần danh mục đơn giá cọc tham chiếu dùng trong nghiên cứu (ba loại cọc xuất hiện trong kết quả ở mục 4.2)."),
      caption("Bảng 2. Danh mục loại cọc và đơn giá vật liệu tham chiếu sử dụng trong nghiên cứu"),
      makeTable(["Loại cọc", "D (mm)", "t (mm)", "Đơn giá Pp (USD/m)"],
        [["300-A", "300", "60", "8,46"],
         ["500-B", "500", "80", "20,30"],
         ["1200-C", "1.200", "150", "127,66"]],
        [4, 4, 4, 5]),
      caption("Thông số hình học và cấp cọc (D, t) được lựa chọn theo TCVN 7888:2014 [2]; đơn giá Pp là dữ liệu kinh tế quy ước sử dụng trong mô hình nghiên cứu, không phải số liệu do TCVN 7888:2014 quy định. Đơn giá cọc trong danh mục gốc được lập bằng VNĐ và quy đổi sang USD theo tỷ giá 23.500 VNĐ/USD. Đơn giá bê tông (Pc=46,25 USD/m³) và cốt thép (Ps=0,57 USD/kg) ở mục dưới đây được cho trực tiếp bằng USD trong mô hình tính toán; cơ sở quy đổi VNĐ (nếu có) của hai đơn giá này không xác định được từ mã nguồn hiện tại của nghiên cứu."),
      P([run("Hàm mục tiêu chi phí là C(x)=N"), run("p", { sub: true }), run("L"), run("p", { sub: true }), run("P"), run("p", { sub: true }), run("+V"), run("b", { sub: true }), run("P"), run("c", { sub: true }), run("+W"), run("s", { sub: true }), run("P"), run("s", { sub: true }), run(", trong đó N"), run("p", { sub: true }), run(" là tổng số cọc, L"), run("p", { sub: true }), run("=L là chiều dài cọc, P"), run("p", { sub: true }), run(" là đơn giá cọc, lấy trực tiếp từ danh mục cọc dùng trong mô hình tính toán (Bảng 2); V"), run("b", { sub: true }), run(" là thể tích bê tông dầm và W"), run("s", { sub: true }), run(" là khối lượng cốt thép dầm dọc/ngang/biên, lấy trực tiếp từ kết quả thiết kế cấu kiện bê tông cốt thép của SAP2000 (module DesignConcrete) ứng với mỗi cấu hình x; tiêu chuẩn thiết kế bê tông cốt thép được gán trong mô hình SAP2000 của nghiên cứu này là CSA A23.3-14 (tiêu chuẩn Canada), không phải TCVN 5574 — đây là thiết lập kế thừa nguyên trạng từ mô hình FEM gốc và cần được nêu rõ như một giới hạn về tính nhất quán tiêu chuẩn giữa phần thiết kế cọc (theo TCVN) và phần thiết kế dầm (theo CSA); P"), run("c", { sub: true }), run("=46,25 USD/m³ là đơn giá bê tông và P"), run("s", { sub: true }), run("=0,57 USD/kg là đơn giá cốt thép (khối lượng thép quy đổi từ thể tích cốt thép thiết kế với khối lượng riêng 7.849 kg/m³). C(x) do đó là "), run("hàm chi phí vật liệu quy ước"), run(" của cọc và dầm — không bao gồm khối lượng bê tông bản mặt cầu (kích thước bản được giữ cố định trong toàn bộ không gian thiết kế, không phải biến thiết kế, nên không ảnh hưởng đến so sánh tương đối giữa các phương án) và không bao gồm chi phí nhân công, thi công, đóng cọc, vận chuyển hay các chi phí gián tiếp khác. Việc gọi C(x) là \"chi phí vật liệu\" thay vì \"chi phí xây dựng\" đầy đủ nhằm phản ánh đúng phạm vi của hàm mục tiêu.")]),
      P([run("Hàm mục tiêu chuyển vị là D(x)=D"), run("max", { sub: true }), run("(x): giá trị lớn nhất của chuyển vị nút tổng hợp (resultant) D"), run("i", { sub: true }), run("=√(U"), run("1,i", { sub: true }), run("²+U"), run("2,i", { sub: true }), run("²+U"), run("3,i", { sub: true }), run("²), tính trên toàn bộ các nút của mô hình MJP, dưới tổ hợp bao BAO (Envelope của COMB1=DL và COMB2=DL+LL, cả hai ở mức chưa nhân hệ số — chi tiết ở mục 2.4), truy xuất trực tiếp từ SAP2000 qua hàm JointDisplAbs của OAPI. Vì lấy theo chuyển vị tổng hợp ba phương thay vì chỉ chuyển vị đứng, D"), run("max", { sub: true }), run(" phản ánh đồng thời ứng xử theo phương ngang và phương đứng của hệ khung cọc-dầm. Hàm fitness cuối cùng cho hai bài toán tối ưu chi phí (SOO-C) và tối ưu chuyển vị (SOO-D) là:")]),
      eq([run("F"), run("C", { sub: true }), run("(x)=C(x)+P(x);   F"), run("D", { sub: true }), run("(x)=D(x)+P(x)")], "(2)"),
      P("Cần lưu ý về thứ nguyên của P(x) trong công thức (1)-(2): g1, g1' (vi phạm mô men, đơn vị kN·m) và g2 (vi phạm sức chịu tải dọc trục, đơn vị kN) được cộng trực tiếp thành tổng vi phạm, nhân với một hệ số phạt λ=10^6 duy nhất, rồi cộng y hệt vào cả FC (USD) và FD (m). Đây là cách xây dựng theo kiểu \"hệ số phạt cố định lớn\" (large fixed-coefficient penalty) thường gặp trong các phương pháp phạt cho bài toán tối ưu ràng buộc, không phải một công thức đã chuẩn hóa thứ nguyên (ví dụ chia g1 cho Mcr, g2 cho Np,adm để đưa các vi phạm về đại lượng không thứ nguyên trước khi cộng). Về mặt thực dụng, λ=10^6 có vẻ đủ lớn so với hai khoảng giá trị khả thi của Cost (bậc 10^3-10^5 USD) và Displacement (bậc 10^-5-10^-3 m): toàn bộ 60 nghiệm tốt nhất được báo cáo (30/case, Bảng 4) đều đạt AllConstraintsSatisfied=1, cho thấy cơ chế phạt này trên thực tế đã dẫn dắt SFOA hội tụ về nghiệm khả thi (không vi phạm) ở cả hai bài toán trong phạm vi đã khảo sát. Tuy nhiên, nghiên cứu không lưu lại lịch sử vi phạm của toàn bộ quần thể qua các vòng lặp (chỉ lưu nghiệm tốt nhất mỗi lần chạy), nên không thể xác nhận độc lập biên độ áp đảo của λ tại các cấu hình gần biên khả thi trong suốt quá trình tìm kiếm. Việc chuẩn hóa P(x) theo từng ràng buộc riêng là một cải tiến phương pháp luận cần thiết ở bước phát triển tiếp theo (MOSFOA), đặc biệt quan trọng khi mở rộng sang bài toán đa mục tiêu nơi các mục tiêu cần được so sánh trên cùng thang đo chuẩn hóa."),

      subHeading("2.6. Thuật toán SFOA nguyên bản"),
      P("Nghiên cứu sử dụng đúng SFOA nguyên bản [1], không bổ sung archive Pareto, non-dominated sorting, leader selection hay các cơ chế đa mục tiêu khác — đây là điểm phân biệt cốt yếu giữa bài toán SOO trong nghiên cứu này với một phiên bản đa mục tiêu của SFOA (tạm gọi là MOSFOA) mà kết quả của nghiên cứu này tạo cơ sở khoa học để đề xuất phát triển trong tương lai, hiện chưa được xây dựng. Trong pha khám phá, mỗi cá thể cập nhật vị trí theo một trong hai chiến lược phụ thuộc số chiều bài toán, có tham chiếu đến nghiệm tốt nhất hiện tại; trong pha khai thác, cá thể cập nhật theo cơ chế \"săn mồi\" dựa trên năm cá thể tham chiếu (năm cánh sao biển) và cơ chế \"tái sinh\" cho cá thể cuối cùng của quần thể. Sau mỗi lần cập nhật liên tục, nghiệm được kiểm soát biên rồi ánh xạ về tập giá trị thiết kế rời rạc hợp lệ (theo danh mục cọc, bước lưới dầm) trước khi gửi sang SAP2000 đánh giá."),
      P("Điều kiện dừng được khóa thống nhất cho cả hai bài toán: quần thể 30 cá thể và 150 vòng lặp — số vòng lặp được xác định từ một khảo sát hội tụ thực nghiệm riêng ở đúng quy mô quần thể 30 (không suy diễn từ quy mô quần thể khác): bài toán tối ưu chi phí có giá trị Best-so-far ổn định trong vùng quan sát được từ khoảng vòng lặp thứ 125-130 và giữ nguyên tới vòng 250 trong khảo sát mở rộng, nên 150 vòng cho biên an toàn khoảng 20 vòng sau vùng ổn định quan sát được; bài toán tối ưu chuyển vị ổn định sớm hơn (từ vòng 50-100). Quần thể Npop=30 được lựa chọn trên cơ sở cân bằng giữa số lượng mẫu tìm kiếm và chi phí tính toán FEM, do mỗi lần đánh giá một cá thể yêu cầu một lần giải FEM đầy đủ trong SAP2000 (mục 4.4). Cả 30 lần chạy độc lập của mỗi bài toán không đặt seed ngẫu nhiên cố định; mỗi lần chạy sử dụng trạng thái kế tiếp của bộ sinh số ngẫu nhiên mặc định của MATLAB, bảo đảm khởi tạo quần thể độc lập giữa các lần chạy trong cùng một phiên tính toán."),

      // 3. THIẾT LẬP
      mainHeading("3. Thiết lập thực nghiệm số"),
      P("Hai bài toán SOO được thiết lập từ hệ kết cấu MJP và hai mục tiêu độc lập, như trong Bảng 3."),
      caption("Bảng 3. Ma trận hai bài toán tối ưu đơn mục tiêu"),
      makeTable(["Case", "Kết cấu", "Mục tiêu", "Thuật toán"],
        [["C1", "MJP", "Min Cost", "Original SFOA"], ["C2", "MJP", "Min Displacement", "Original SFOA"]],
        [2.5, 3, 4.5, 5.5]),
      P([run("Mỗi case được chạy 30 lần độc lập với cùng mô hình FEM, cùng tải trọng, cùng ràng buộc, cùng hàm phạt và cùng miền biến, tổng cộng 2×30=60 lượt chạy độc lập. Kết quả được đánh giá theo ba nhóm chỉ tiêu: (i) chỉ tiêu thuật toán — giá trị tốt nhất trong 30 lần chạy độc lập (Best), trung bình (Mean), xấu nhất (Max), độ lệch chuẩn (STD) và đường hội tụ Best-so-far; (ii) chỉ tiêu kết cấu — chi phí, chuyển vị lớn nhất, biến thiết kế và trạng thái ràng buộc; (iii) chỉ tiêu đánh đổi — chi phí của nghiệm tốt nhất theo mục tiêu chuyển vị, chuyển vị của nghiệm tốt nhất theo mục tiêu chi phí, và phần trăm chênh lệch giữa hai nghiệm cực trị.")]),

      // 4. KẾT QUẢ
      mainHeading("4. Kết quả và thảo luận"),
      subHeading("4.1. Khả năng hội tụ và độ ổn định của SFOA"),
      P("Đường hội tụ Best-so-far của SFOA cho hai bài toán (Hình 1) và kết quả thống kê 30 lần chạy (Bảng 4) được dùng để đánh giá đồng thời chất lượng nghiệm và độ ổn định — không kết luận SFOA tốt hay yếu chỉ dựa trên một đường hội tụ đơn lẻ. Trong Hình 1, đường liền là giá trị Best-so-far của lần chạy tốt nhất (Best run) trong 30 lần chạy, còn dải bóng mờ (Min-Max band) thể hiện khoảng dao động giữa giá trị tốt nhất và xấu nhất trong 30 lần chạy tại mỗi vòng lặp; trục tung dùng thang logarithmic vì chênh lệch giữa giá trị khởi tạo (còn nhiều cá thể chưa hội tụ) và giá trị hội tụ lên tới nhiều bậc độ lớn."),
      caption("Bảng 4. Kết quả thống kê 30 lần chạy của SFOA cho MJP-Cost và MJP-Displacement"),
      makeTable(["Case", "Best", "Mean", "Max", "STD", "CV (%)"],
        [["MJP-C", "5.291,8573", "8.012,5085", "10.073,9390", "1.440,4557", "17,98"],
         ["MJP-D", "0,0000388", "0,0000388", "0,0000388", "0,0000000", "0,00"]],
        [2.5, 3, 3, 3, 3, 2.5]),
      caption("Best là giá trị mục tiêu tốt nhất của mỗi lần chạy độc lập (Best-of-run); Mean/Max/STD/CV được tính trên tập 30 giá trị Best này."),
      P("30 lần chạy độc lập của MJP-Displacement đều đạt cùng giá trị tốt nhất của hàm mục tiêu chuyển vị — cả 30 giá trị Best đều bằng 0,0000388 (STD=0, CV=0%), thể hiện qua dải Min-Max gần như không nhìn thấy ở Hình 1(b). Kiểm tra trực tiếp 30 vector thiết kế tốt nhất (không chỉ giá trị hàm mục tiêu) cho thấy: 25/30 lần chạy hội tụ về đúng cấu hình cọc 1200-C đã báo cáo ở Bảng 5, còn 4/30 và 1/30 lần chạy hội tụ về hai loại cọc liền kề trong danh mục (cùng D=1200mm, cấp thép thấp hơn một bậc) — nhưng cả ba nhóm đều có cùng nhịp dầm nhỏ nhất khả thi (3,0×3,0 m) và cùng kích thước dầm lớn nhất khả thi (1,4×2,0 m), và cho giá trị Dmax giống hệt nhau đến toàn bộ chữ số có nghĩa đã ghi nhận. Điều này cho thấy CV=0% không phải do 30 lần chạy luôn hội tụ về đúng một vector thiết kế duy nhất, mà do hàm mục tiêu chuyển vị bị bão hòa (plateau): một khi nhịp dầm và kích thước dầm đã đạt cấu hình cứng nhất khả thi, việc tăng thêm cấp thép cọc không còn làm giảm đáng kể Dmax trong phạm vi đo được — một đặc điểm hợp lý của bài toán tối ưu biến rời rạc có miền giá trị hữu hạn. MJP-Cost có mức phân tán giữa các lần chạy với CV=17,98%, trong khi MJP-Displacement có CV=0% về giá trị mục tiêu tốt nhất — không có nghiệm tốt nhất nào của các run được ghi nhận vi phạm ràng buộc (tất cả 30 nghiệm tốt nhất đều thỏa AllConstraintsSatisfied=1). Kết quả này cho thấy độ ổn định của SFOA phụ thuộc vào bản chất của objective và không đồng nhất giữa hai bài toán SOO đã khảo sát."),

      img("D:/ResearchLab/02_Projects/Tap chi XD_SFOA/paper_figures/Hinh1_convergence.png", 16.5, 6.8),
      caption("Hình 1. Đường hội tụ Best-so-far của SFOA cho (a) MJP-Cost và (b) MJP-Displacement (30 lần chạy độc lập, thang log)"),

      subHeading("4.2. Kết quả tối ưu của MJP"),
      P("Hai nghiệm tốt nhất tìm được (cost-optimal và displacement-optimal) được so sánh về biến thiết kế, chi phí và chuyển vị (Bảng 5), đồng thời đối chiếu với thiết kế hiện tại để xác định mức tiết kiệm chi phí hoặc cải thiện chuyển vị đạt được (Bảng 6)."),
      caption("Bảng 5. Hai nghiệm tối ưu đơn mục tiêu của MJP"),
      makeTable(["Nghiệm", "Mục tiêu", "Cọc", "D(mm)", "t(mm)", "L(m)", "LL(m)", "LT(m)", "b(m)", "h(m)", "Cost(USD)", "Disp.(m)"],
        [["MJP-C", "Cost", "300-A", "300", "60", "37,8", "5,3", "5,6", "0,5", "0,5", "5.291,86 (min)", "0,00102"],
         ["MJP-D", "Displ.", "1200-C", "1.200", "150", "16,8", "3,0", "3,0", "1,4", "2,0", "139.831,48", "0,0000388 (min)"]],
        [1.6, 1.5, 1.5, 1.3, 1.2, 1.2, 1.2, 1.2, 1.1, 1.1, 1.9, 1.9]),
      P("Nghiệm cost-optimal chọn cọc nhỏ nhất trong danh mục (D300, cấp thép thấp nhất) và nhịp dầm lớn nhất có thể (5,3×5,6 m, ít cọc/nhịp hơn), cùng kích thước dầm tối thiểu — toàn bộ biến đều dịch về hướng \"rẻ nhất khả thi\". Nghiệm displacement-optimal chọn cọc lớn nhất trong danh mục (D1200, cấp thép cao nhất), nhịp dầm nhỏ nhất có thể (3,0×3,0 m, nhiều cọc/nhịp hơn) và dầm lớn nhất có thể — toàn bộ biến dịch về hướng làm giảm chuyển vị nhiều nhất có thể (\"cứng nhất khả thi\"). Về mặt định tính, cọc tiết diện ống có mô men quán tính I=π(Do^4-Di^4)/64 nên độ cứng uốn của cọc tăng mạnh khi đường kính ngoài tăng (dù chiều dày thành t cũng là biến thiết kế, không chỉ riêng D); đồng thời việc giảm nhịp dầm làm tăng đáng kể độ cứng tổng thể của hệ khung cọc-dầm. Hai xu hướng này cùng góp phần giải thích vì sao cấu hình cọc lớn nhất/nhịp nhỏ nhất cho chuyển vị nhỏ nhất — tương ứng với độ cứng tổng thể lớn nhất — trong không gian thiết kế khả thi được khảo sát, với Dmax=0,0000388 m — nhỏ hơn khoảng 26 lần so với nghiệm cost-optimal (0,00102 m) và nhỏ hơn khoảng 6 lần so với thiết kế hiện tại (0,00022445 m); nghiên cứu này không thực hiện một phân tích độ cứng/độ nhạy định lượng riêng để tách bạch chính xác mức đóng góp của từng biến. Cả hai nghiệm đều thỏa các ràng buộc kỹ thuật đã triển khai trong nghiên cứu này (Bảng 1: mô men, sức chịu tải dọc trục, khoảng cách cọc-dầm, điều kiện đất nền — xem thêm giới hạn về cách xử lý ràng buộc nhổ ở mục 2.4); nghiên cứu không đưa một giới hạn chuyển vị phục vụ (serviceability) cụ thể theo tiêu chuẩn vào hệ ràng buộc."),

      caption("Bảng 6. So sánh thiết kế hiện tại và nghiệm SOO của MJP"),
      makeTable(["Thiết kế", "Cọc", "Cost (USD)", "ΔCost (%)", "Displacement (m)", "ΔD (%)"],
        [["Current (L=38m, 4,2×4,5m, 0,7×1,0m)", "500-B", "25.708,9425", "--", "0,00022445", "--"],
         ["SFOA-C", "300-A", "5.291,8573", "-79,4", "0,00102", "+353,7"],
         ["SFOA-D", "1200-C", "139.831,4792", "+443,9", "0,0000388", "-82,7"]],
        [5.5, 1.8, 2.8, 2.2, 3, 2.2]),
      caption("Thiết kế hiện tại (baseline) được tính trực tiếp bằng mô hình SAP2000-MATLAB dùng cho nghiên cứu này tại cấu hình cố định (không tối ưu) nêu ở mục 2.1, dùng làm mốc so sánh cho hai nghiệm SFOA."),
      P("So với thiết kế hiện tại, nghiệm cost-optimal giảm chi phí 79,4% nhưng chuyển vị tăng ~3,5 lần (vẫn ở mức milimét, thỏa các ràng buộc được triển khai trong quá trình tối ưu); nghiệm displacement-optimal giảm chuyển vị 82,7% nhưng chi phí tăng gần 4,4 lần. Thiết kế hiện tại nằm ở vị trí trung gian giữa hai nghiệm cực trị. Kết quả cho thấy lựa chọn thiết kế phụ thuộc đáng kể vào tiêu chí ưu tiên khi đồng thời xem xét chi phí và chuyển vị."),

      subHeading("4.3. Phân tích đánh đổi chi phí-chuyển vị"),
      P([run("Đây là phần phân tích cốt lõi của nghiên cứu. Chuyển vị tại nghiệm cost-optimal (D"), run("C", { sub: true }), run(") và chi phí tại nghiệm displacement-optimal (C"), run("D", { sub: true }), run(") được so sánh chéo với hai nghiệm cực trị C"), run("C", { sub: true }), run("*"), run(" và D"), run("D", { sub: true }), run("*"), run(" (Bảng 7, Hình 2), từ đó tính:")]),
      eq([run("ΔC = (C"), run("D", { sub: true }), run("-C"), run("C", { sub: true }), run("*"), run(")/C"), run("C", { sub: true }), run("*"), run(" × 100%;   ΔD = (D"), run("C", { sub: true }), run("-D"), run("D", { sub: true }), run("*"), run(")/D"), run("C", { sub: true }), run(" × 100%")], "(3)"),
      caption("Bảng 7. So sánh chéo hai nghiệm cực trị của MJP"),
      makeTable(["Kết cấu", "C_C* (USD)", "D_C (m)", "D_D* (m)", "C_D (USD)", "ΔC (%)", "ΔD (%)"],
        [["MJP", "5.291,8573", "0,00102", "0,0000388", "139.831,4792", "2.542,2", "96,2"]],
        [2.2, 2.6, 2, 2, 2.6, 2, 2]),
      P("Kết quả tính toán số cho thấy đồng thời C(x_C*)=5.291,86 < C(x_D*)=139.831,48 và D(x_D*)=0,0000388 < D(x_C*)=0,00102 trên hệ kết cấu MJP. Hai bất đẳng thức này xảy ra đồng thời và cho thấy chi phí và chuyển vị có quan hệ đánh đổi rõ rệt tại hai nghiệm cực trị của bài toán MJP; đây chưa phải bằng chứng bao trùm toàn bộ không gian thiết kế hay tương đương một Pareto front, vốn đòi hỏi khảo sát đa mục tiêu (ngoài phạm vi bài báo này). Nếu ưu tiên chuyển vị thay vì chi phí, chi phí tăng 2.542,2% (tương đương khoảng 26,4 lần); nếu ưu tiên chi phí thay vì chuyển vị, chuyển vị \"chỉ\" tăng tương đối 96,2% nhưng giá trị tuyệt đối vẫn rất nhỏ (1,02 mm). Kết quả cho thấy mức tăng chi phí giữa hai nghiệm cực trị lớn hơn đáng kể so với mức tăng tương đối của chuyển vị; đây là một quan sát số liệu tại hai điểm cực trị đã khảo sát, chưa phải kết luận từ một phân tích độ nhạy (sensitivity analysis) hình thức trên nhiều điểm thiết kế."),
      P("Xét dưới góc độ kỹ thuật công trình biển, 1,02 mm (nghiệm cost-optimal) vẫn là một giá trị rất nhỏ so với quy mô kết cấu MJP. Tuy nhiên, nghiên cứu này không đưa một giới hạn chuyển vị phục vụ (serviceability) cụ thể theo TCVN vào hệ ràng buộc (Bảng 1), nên không có cơ sở để khẳng định giá trị này \"nằm trong giới hạn an toàn cho phép của TCVN\" — nhận xét ở đây chỉ dừng ở mức định tính rằng đây là một chuyển vị nhỏ. Với nhận xét thận trọng đó, việc đầu tư thêm 2.542,2% chi phí (tương đương khoảng 26,4 lần) để giảm chuyển vị từ 1,02 mm xuống mức cực hạn 0,0000388 m là một đánh đổi cần được chủ đầu tư/kỹ sư thiết kế cân nhắc dựa trên yêu cầu cụ thể của từng dự án, hơn là một kết luận phổ quát về hiệu quả kinh tế-kỹ thuật. Quan sát này càng củng cố lý do cần một phương pháp tối ưu đa mục tiêu: thay vì buộc phải chọn một trong hai nghiệm cực trị, một tập nghiệm Pareto sẽ cho phép chọn phương án cân bằng phù hợp hơn với yêu cầu cụ thể của từng dự án."),
      P("Kết luận đúng cần được phát biểu là: SFOA nguyên bản cho nghiệm khả thi ở cả hai bài toán đơn mục tiêu khảo sát, với mức độ ổn định giữa các lần chạy phụ thuộc vào bản chất của từng mục tiêu — ổn định tuyệt đối về giá trị Best-of-run ở bài toán chuyển vị (CV=0%), phân tán vừa phải ở bài toán chi phí (CV=17,98%) — (nghiên cứu không so sánh với PSO/GA/DE/GWO hay các metaheuristic khác nên không có cơ sở xếp hạng SFOA), nhưng bản chất đơn mục tiêu chỉ cho phép một tiêu chí chi phối quá trình chọn nghiệm, không tạo ra tập nghiệm không trội tương đương Pareto front do không có cơ chế lưu trữ archive, bảo toàn đa dạng hay chọn leader trong không gian mục tiêu. Do đó, bài toán thiết kế thực tế — vốn cần đồng thời cân bằng chi phí và độ cứng — khó có thể được giải quyết đầy đủ chỉ bằng cách tiếp cận SOO, và kết quả này cung cấp cơ sở thực nghiệm cho việc xem xét bài toán đa mục tiêu trong nghiên cứu tiếp theo (MOSFOA). Vì nghiên cứu này chỉ khảo sát một hệ kết cấu (MJP), kết luận về quan hệ đánh đổi được phát biểu ở mức hệ kết cấu đơn lẻ và cần nêu rõ giới hạn này trong phần Hạn chế."),

      img("D:/ResearchLab/02_Projects/Tap chi XD_SFOA/paper_figures/Hinh2_tradeoff.png", 13, 8.7),
      caption("Hình 2. Quan hệ đánh đổi chi phí-chuyển vị giữa thiết kế hiện tại và hai nghiệm tối ưu đơn mục tiêu của MJP. Đường nét đứt chỉ nối hình học ba điểm thiết kế, không phải Pareto front."),

      subHeading("4.4. Hiệu quả tính toán"),
      P([run("Mỗi bài toán SOO gồm 30 lần chạy độc lập với N"), run("pop", { sub: true }), run("=30 và N"), run("it", { sub: true }), run("=150; số lần gọi SAP2000 cho mỗi lần chạy là:")]),
      eq([run("N"), run("eval", { sub: true }), run(" = N"), run("pop", { sub: true }), run("×(N"), run("it", { sub: true }), run("+1) = 30×151 = 4.530")], "(4)"),
      P("(151 = 150 vòng lặp cộng 1 lần đánh giá khởi tạo quần thể ban đầu). Trung bình mỗi lần chạy MJP-Cost tốn 3.945,5s (~65,8 phút) và MJP-Displacement tốn 4.125,6s (~68,8 phút). Tổng thời gian tính toán thực tế cho 60 run là 242.133,2s (~67,3 giờ). Một quan sát đáng chú ý trong quá trình khảo sát hội tụ (pilot) là thời gian mỗi vòng lặp không cố định mà tăng dần khi quần thể hội tụ — quần thể ngẫu nhiên ban đầu có nhiều cá thể không khả thi bị loại nhanh bằng phạt cứng (không cần chạy FEM, xem Bảng 1), trong khi quần thể đã hội tụ có phần lớn cá thể khả thi, phải giải FEM và kiểm tra ràng buộc đầy đủ, làm tăng thời gian mỗi vòng lặp 2-4 lần so với lúc khởi động. Đây là đặc điểm riêng của các bài toán SOO kết hợp trực tiếp với FEM lặp, khác với benchmark toán học thuần túy, và là dữ liệu tham khảo hữu ích cho các nghiên cứu tối ưu kết cấu-FEM chi phí cao khác."),
      P("Bảng 8 tóm tắt môi trường phần mềm/phần cứng và cấu hình thuật toán dùng cho toàn bộ 60 lần chạy, phục vụ khả năng tái lập. MATLAB Parallel Computing Toolbox được dùng để đánh giá song song các cá thể trong quần thể (mỗi cá thể ứng với một tiến trình SAP2000 riêng) trong phạm vi một lần chạy; 60 lần chạy độc lập của campaign được thực hiện tuần tự — tổng thời gian tính toán 242.133,2s ở trên bằng đúng tổng cộng dồn thời gian của 60 lần chạy riêng lẻ (30×3.945,5s+30×4.125,6s), không có hiện tượng chồng lấp giữa các lần chạy."),
      caption("Bảng 8. Môi trường tính toán và cấu hình thuật toán"),
      makeTable(["Thông số", "Giá trị"],
        [["MATLAB", "R2023b + Parallel Computing Toolbox"],
         ["SAP2000", "Phiên bản 24"],
         ["CPU", "Intel Xeon E5-2680 v4 @ 2,40GHz (14 lõi thật/28 luồng)"],
         ["RAM", "49 GB"],
         ["Hệ điều hành", "Windows 10 Pro"],
         ["Npop", "30"],
         ["Số vòng lặp tối đa", "150"],
         ["Số lần chạy độc lập", "30/case"],
         ["Random seed", "Không cố định (trạng thái kế tiếp của bộ sinh số ngẫu nhiên mặc định MATLAB)"]],
        [6, 11]),

      // KẾT LUẬN
      mainHeading("5. Kết luận"),
      P("Nghiên cứu đã xây dựng và đánh giá framework liên kết SAP2000-MATLAB-SFOA để giải hai bài toán tối ưu đơn mục tiêu (tối thiểu chi phí vật liệu và tối thiểu chuyển vị) trên hệ kết cấu cầu cảng chính (MJP), qua 60 lượt chạy độc lập (30 run/mục tiêu). Kết quả cho thấy: (1) SFOA nguyên bản cho các nghiệm tốt nhất thỏa các ràng buộc cọc được triển khai trong quá trình tối ưu ở cả hai bài toán — toàn bộ 30 lần chạy của MJP-Displacement đều đạt cùng giá trị tốt nhất của hàm mục tiêu (CV=0%), MJP-Cost có mức phân tán giữa các lần chạy với CV=17,98%, không nghiệm tốt nhất của các run được ghi nhận vi phạm ràng buộc; hai nghiệm tốt nhất được báo cáo đều đạt hậu kiểm thiết kế dầm; (2) nghiệm tốt nhất tìm được theo mục tiêu chi phí (Cost=5.291,86 USD) và nghiệm tốt nhất tìm được theo mục tiêu chuyển vị (Displacement=0,0000388 m) khác biệt hoàn toàn về biến thiết kế — cost-optimal chọn cọc nhỏ nhất và nhịp lớn nhất, displacement-optimal chọn cọc lớn nhất và nhịp nhỏ nhất — và tạo ra quan hệ đánh đổi rõ rệt tại hai nghiệm cực trị: ưu tiên chuyển vị làm chi phí tăng 2.542,2% (tương đương khoảng 26,4 lần) so với ưu tiên chi phí, ngược lại ưu tiên chi phí làm chuyển vị tăng 96,2% (nhưng vẫn ở bậc milimét, nhỏ so với quy mô kết cấu, dù nghiên cứu không kiểm tra giá trị này so với một giới hạn chuyển vị phục vụ cụ thể theo TCVN); (3) vì SOO chỉ cung cấp nghiệm tốt nhất theo từng mục tiêu riêng lẻ và không duy trì tập nghiệm không trội, cách tiếp cận này chưa đủ để hỗ trợ bài toán thiết kế đồng thời nhiều mục tiêu. Kết quả nghiên cứu không phủ nhận hiệu quả của SFOA trong tối ưu đơn mục tiêu; thay vào đó, nghiên cứu chỉ ra rằng giới hạn nằm ở bản chất đơn mục tiêu của mô hình tối ưu, từ đó tạo động lực khoa học và kỹ thuật cho việc mở rộng SFOA sang một phiên bản đa mục tiêu (MOSFOA) ở bước nghiên cứu tiếp theo. Do ràng buộc thời gian tính toán thực tế, nghiên cứu chỉ khảo sát một hệ kết cấu duy nhất (MJP); đây là giới hạn cần nêu rõ, và việc mở rộng khảo sát sang các hệ kết cấu công trình biển khác bằng cùng framework là hướng phát triển khả thi cho các nghiên cứu tiếp theo."),

      // TÀI LIỆU THAM KHẢO
      subHeading("TÀI LIỆU THAM KHẢO"),
      P("[1] Zhong, C., Li, G., Meng, Z., Li, H., Yildiz, A.R., Mirjalili, S. Starfish optimization algorithm (SFOA): a bio-inspired metaheuristic algorithm for global optimization compared with 100 optimizers. Neural Computing and Applications, vol. 37, pp. 3641-3683, 2025, doi: 10.1007/s00521-024-10694-1."),
      P("[2] TCVN 7888:2014. Cọc bê tông ly tâm ứng lực trước. Bộ Khoa học và Công nghệ, Việt Nam, 2014."),
      P("[3] TCVN 10304:2014. Móng cọc - Tiêu chuẩn thiết kế. Bộ Khoa học và Công nghệ, Việt Nam, 2014."),
      P("[4] Turgut, O.E., Turgut, M.S., Kırtepe, E. A systematic review of the emerging metaheuristic algorithms on solving complex optimization problems. Neural Computing and Applications, vol. 35, pp. 14275-14378, 2023, doi: 10.1007/s00521-023-08481-5."),
      P("[5] Deb, K. An efficient constraint handling method for genetic algorithms. Computer Methods in Applied Mechanics and Engineering, vol. 186, no. 2-4, pp. 311-338, 2000, doi: 10.1016/S0045-7825(99)00389-8."),
      P("[6] TCVN 10304:2025. Thiết kế móng cọc. Bộ Xây dựng, Việt Nam, 2025."),
    ],
  }],
});

Packer.toBuffer(doc).then((buf) => {
  fs.writeFileSync("02_Draft_SOO_SFOA_Marine_Jetty_TCXD.docx", buf);
  console.log("DONE");
});
