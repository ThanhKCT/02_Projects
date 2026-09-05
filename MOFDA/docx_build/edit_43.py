import io, sys

path = "unpacked_v1/word/document.xml"
with io.open(path, encoding="utf-8") as f:
    data = f.read()

FONT = '<w:rFonts w:ascii="Times New Roman" w:cs="Times New Roman" w:eastAsia="Times New Roman" w:hAnsi="Times New Roman"/>'

def heading_run(text):
    return ('<w:r><w:rPr>' + FONT +
            '<w:b/><w:bCs/><w:i/><w:iCs/><w:color w:val="990033"/><w:sz w:val="22"/><w:szCs w:val="22"/></w:rPr>'
            '<w:t xml:space="preserve">' + text + '</w:t></w:r>')

def heading_para(text):
    return ('<w:p><w:pPr><w:keepNext/><w:spacing w:after="80" w:before="120"/></w:pPr>' +
            heading_run(text) + '</w:p>')

def body_run(text):
    return ('<w:r><w:rPr>' + FONT + '<w:sz w:val="20"/><w:szCs w:val="20"/></w:rPr>'
            '<w:t xml:space="preserve">' + text + '</w:t></w:r>')

def body_para(text):
    return ('<w:p><w:pPr><w:spacing w:after="40" w:before="40"/><w:ind w:firstLine="284"/><w:jc w:val="both"/></w:pPr>' +
            body_run(text) + '</w:p>')

def caption_para(text):
    return ('<w:p><w:pPr><w:spacing w:after="60" w:before="60"/><w:jc w:val="center"/></w:pPr>'
            '<w:r><w:rPr>' + FONT + '<w:b/><w:bCs/><w:i/><w:iCs/><w:sz w:val="18"/><w:szCs w:val="18"/></w:rPr>'
            '<w:t xml:space="preserve">' + text + '</w:t></w:r></w:p>')

SECTPR_2COL = ('<w:p><w:pPr><w:sectPr><w:type w:val="continuous"/>'
               '<w:pgSz w:w="11906" w:h="16838" w:orient="portrait"/>'
               '<w:pgMar w:top="1701" w:right="1418" w:bottom="1418" w:left="1588" w:header="708" w:footer="708" w:gutter="0"/>'
               '<w:pgNumType/><w:cols w:space="340" w:num="2"/><w:docGrid w:linePitch="360"/></w:sectPr></w:pPr></w:p>')

SECTPR_1COL = ('<w:p><w:pPr><w:sectPr><w:type w:val="continuous"/>'
               '<w:pgSz w:w="11906" w:h="16838" w:orient="portrait"/>'
               '<w:pgMar w:top="1701" w:right="1418" w:bottom="1418" w:left="1588" w:header="708" w:footer="708" w:gutter="0"/>'
               '<w:pgNumType/><w:cols w:num="1"/><w:docGrid w:linePitch="360"/></w:sectPr></w:pPr></w:p>')

def header_cell(width, text):
    return ('<w:tc><w:tcPr><w:tcW w:type="dxa" w:w="%d"/><w:shd w:fill="DEEAF6" w:val="clear"/>'
            '<w:tcMar><w:top w:type="dxa" w:w="40"/><w:left w:type="dxa" w:w="60"/><w:bottom w:type="dxa" w:w="40"/><w:right w:type="dxa" w:w="60"/></w:tcMar>'
            '<w:vAlign w:val="center"/></w:tcPr>'
            '<w:p><w:pPr><w:jc w:val="center"/></w:pPr>'
            '<w:r><w:rPr>' + FONT + '<w:b/><w:bCs/><w:i w:val="false"/><w:iCs w:val="false"/><w:sz w:val="18"/><w:szCs w:val="18"/></w:rPr>'
            '<w:t xml:space="preserve">' + text + '</w:t></w:r></w:p></w:tc>') % width

def data_cell(width, text):
    return ('<w:tc><w:tcPr><w:tcW w:type="dxa" w:w="%d"/>'
            '<w:tcMar><w:top w:type="dxa" w:w="40"/><w:left w:type="dxa" w:w="60"/><w:bottom w:type="dxa" w:w="40"/><w:right w:type="dxa" w:w="60"/></w:tcMar>'
            '<w:vAlign w:val="center"/></w:tcPr>'
            '<w:p><w:pPr><w:jc w:val="center"/></w:pPr>'
            '<w:r><w:rPr>' + FONT + '<w:b w:val="false"/><w:bCs w:val="false"/><w:i w:val="false"/><w:iCs w:val="false"/><w:sz w:val="18"/><w:szCs w:val="18"/></w:rPr>'
            '<w:t xml:space="preserve">' + text + '</w:t></w:r></w:p></w:tc>') % width

widths = [700, 1800, 700, 900, 900, 1000, 1000]
headers = ["Phương án", "Tiêu chí lựa chọn", "CatIdx", "D_thép (m)", "t_thép (m)", "f₁ (tấn)", "f₂ (mm)"]
rows = [
    ["PA1", "Khối lượng nhỏ nhất", "1", "1,100", "0,018", "3.030,6", "13,88"],
    ["PA2", "Cân bằng tương đối", "2", "1,100", "0,019", "3.634,5", "12,86"],
    ["PA3", "Chuyển vị nhỏ nhất", "3", "1,100", "0,020", "4.298,3", "11,92"],
]

tbl_grid = ''.join('<w:gridCol w:w="%d"/>' % w for w in widths)
header_row = '<w:tr>' + ''.join(header_cell(w, t) for w, t in zip(widths, headers)) + '</w:tr>'
data_rows = ''.join('<w:tr>' + ''.join(data_cell(w, t) for w, t in zip(widths, row)) + '</w:tr>' for row in rows)

table_width = sum(widths)
table3 = ('<w:tbl><w:tblPr><w:tblW w:type="dxa" w:w="%d"/>'
          '<w:tblBorders><w:top w:val="single" w:sz="4"/><w:left w:val="single" w:sz="4"/><w:bottom w:val="single" w:sz="4"/><w:right w:val="single" w:sz="4"/>'
          '<w:insideH w:val="single" w:sz="2"/><w:insideV w:val="single" w:sz="2"/></w:tblBorders></w:tblPr>'
          '<w:tblGrid>%s</w:tblGrid>%s%s</w:tbl>') % (table_width, tbl_grid, header_row, data_rows)

# ---- Assemble new 4.3 block ----
p1 = ("Mặt Pareto không xác định một nghiệm tối ưu duy nhất mà cung cấp các phương án thiết kế "
      "tương ứng với những mức độ đánh đổi khác nhau giữa khối lượng vật liệu cọc và chuyển vị ngang. "
      "Trong nghiên cứu này, ba phương án đại diện được lựa chọn theo ba xu hướng: ưu tiên giảm khối "
      "lượng, cân bằng giữa hai mục tiêu và ưu tiên kiểm soát chuyển vị. Việc lựa chọn này nhằm minh "
      "họa khả năng khai thác kết quả Pareto trong giai đoạn thiết kế sơ bộ, thay vì xác định một "
      "phương án tối ưu duy nhất cho công trình.")

p2 = ("Phương án 1 là phương án có khối lượng vật liệu nhỏ nhất trên mặt Pareto, với CatIdx = 1, "
      "đường kính cọc thép D_thép = 1,100 m và chiều dày t_thép = 0,018 m; khối lượng vật liệu đạt "
      "3.030,6 tấn và chuyển vị ngang lớn nhất là 13,88 mm. Phương án này phù hợp khi ưu tiên giảm "
      "khối lượng vật liệu trong khi vẫn bảo đảm yêu cầu chuyển vị của bài toán.")

p3 = ("Phương án 2 là phương án có mức cân bằng tương đối giữa hai mục tiêu, với CatIdx = 2, "
      "D_thép = 1,100 m và t_thép = 0,019 m; khối lượng vật liệu là 3.634,5 tấn và chuyển vị ngang lớn "
      "nhất là 12,86 mm. Đây là phương án trung gian được lựa chọn để minh họa sự đánh đổi giữa hai "
      "mục tiêu.")

p4 = ("Phương án 3 là phương án có chuyển vị ngang nhỏ nhất trên mặt Pareto, với CatIdx = 3, "
      "D_thép = 1,100 m và t_thép = 0,020 m; khối lượng vật liệu là 4.298,3 tấn và chuyển vị ngang lớn "
      "nhất là 11,92 mm. Phương án này thể hiện xu hướng ưu tiên tăng độ cứng và kiểm soát chuyển vị "
      "ngang.")

p5 = ("Ba phương án trên không được xem là ba phương án tối ưu độc lập mà là các điểm đại diện cho ba "
      "mức độ ưu tiên khác nhau trên cùng một mặt Pareto. Việc lựa chọn phương án cụ thể trong thực tế "
      "cần căn cứ vào yêu cầu kỹ thuật, mức độ ưu tiên về vật liệu và các điều kiện thiết kế bổ sung "
      "của dự án.")

p6_discussion = ("Bảng 3 cho thấy khi chuyển từ PA1 sang PA3, khối lượng vật liệu tăng từ 3.030,6 lên "
                  "4.298,3 tấn, trong khi chuyển vị ngang giảm từ 13,88 xuống 11,92 mm. PA2 nằm giữa "
                  "hai xu hướng này và thể hiện một mức đánh đổi trung gian. Như vậy, kết quả tối ưu đa "
                  "mục tiêu không chỉ cung cấp một giá trị đơn lẻ mà còn cho phép người thiết kế xem xét "
                  "nhiều phương án theo mức độ ưu tiên khác nhau.")

new_block = (
    heading_para("4.3. Lựa chọn các phương án đại diện trên mặt Pareto") +
    body_para(p1) + body_para(p2) + body_para(p3) + body_para(p4) + body_para(p5) +
    SECTPR_2COL +
    caption_para("Bảng 3. Ba phương án đại diện trên mặt Pareto") +
    table3 +
    SECTPR_1COL +
    body_para(p6_discussion)
)

old_block = (
    '<w:p><w:pPr><w:keepNext/><w:spacing w:after="80" w:before="120"/></w:pPr><w:r><w:rPr>' + FONT +
    '<w:b/><w:bCs/><w:i/><w:iCs/><w:color w:val="990033"/><w:sz w:val="22"/><w:szCs w:val="22"/></w:rPr>'
    '<w:t xml:space="preserve">4.3. Phương án đại diện trên mặt Pareto</w:t></w:r></w:p>'
    '<w:p><w:pPr><w:spacing w:after="40" w:before="40"/><w:ind w:firstLine="284"/><w:jc w:val="both"/></w:pPr>'
    '<w:r><w:rPr>' + FONT + '<w:sz w:val="20"/><w:szCs w:val="20"/></w:rPr>'
    '<w:t xml:space="preserve">Với dải nghiệm Pareto thu được, một phương án đại diện có sự cân bằng '
    'tương đối giữa hai mục tiêu (CatIdx=2, D_thép=1,100 m, t_thép=0,019 m: f₁≈3.634,5 tấn, '
    'f₂≈12,86 mm) được nêu làm ví dụ minh họa cho giai đoạn thiết kế sơ bộ. Việc lựa chọn '
    'phương án này nhằm minh họa một điểm trung gian trên mặt Pareto, không hàm ý đây là nghiệm tối ưu '
    'duy nhất; phương án cuối cùng cần được lựa chọn tùy theo mức độ ưu tiên giữa tiết kiệm vật liệu và '
    'kiểm soát chuyển vị của dự án cụ thể.</w:t></w:r></w:p>'
)

count = data.count(old_block)
sys.stdout.write("old_block occurrences: %d\n" % count)
assert count == 1, "old_block not found exactly once"

data2 = data.replace(old_block, new_block, 1)

# ---- Replace conclusion point (5) ----
old_p5_concl = (
    '<w:p><w:pPr><w:spacing w:after="40" w:before="40"/><w:ind w:firstLine="284"/><w:jc w:val="both"/></w:pPr>'
    '<w:r><w:rPr>' + FONT + '<w:sz w:val="20"/><w:szCs w:val="20"/></w:rPr>'
    '<w:t xml:space="preserve">(5) Kết quả được sử dụng làm cơ sở tham khảo cho lựa chọn phương án sơ '
    'bộ; cần bổ sung các kiểm tra còn thiếu — đặc biệt là sức chịu tải địa kỹ thuật — trước khi '
    'áp dụng cho thiết kế chính thức.</w:t></w:r></w:p>'
)

count2 = data2.count(old_p5_concl)
sys.stdout.write("old_p5_concl occurrences: %d\n" % count2)
assert count2 == 1, "old_p5_concl not found exactly once"

new_p5_concl_text = ("(5) Mặt Pareto cung cấp cơ sở để lựa chọn phương án sơ bộ theo các mức độ ưu tiên "
                      "khác nhau. Ba phương án đại diện được lựa chọn tương ứng với xu hướng giảm khối "
                      "lượng, cân bằng hai mục tiêu và kiểm soát chuyển vị, qua đó minh họa khả năng sử "
                      "dụng kết quả tối ưu đa mục tiêu trong hỗ trợ quyết định ở giai đoạn thiết kế sơ bộ. "
                      "Trước khi áp dụng cho thiết kế chính thức, cần bổ sung các kiểm tra còn thiếu, đặc "
                      "biệt là kiểm tra sức chịu tải địa kỹ thuật.")

data3 = data2.replace(old_p5_concl, body_para(new_p5_concl_text), 1)

with io.open(path, "w", encoding="utf-8") as f:
    f.write(data3)

sys.stdout.write("done, new length: %d (old %d)\n" % (len(data3), len(data)))
