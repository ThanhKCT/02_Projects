import io, sys

path = "unpacked_v1/word/document.xml"
with io.open(path, encoding="utf-8") as f:
    data = f.read()

FONT = '<w:rFonts w:ascii="Times New Roman" w:cs="Times New Roman" w:eastAsia="Times New Roman" w:hAnsi="Times New Roman"/>'

def body_run(text):
    return ('<w:r><w:rPr>' + FONT + '<w:sz w:val="20"/><w:szCs w:val="20"/></w:rPr>'
            '<w:t xml:space="preserve">' + text + '</w:t></w:r>')

def italic_body_run(text):
    return ('<w:r><w:rPr>' + FONT + '<w:i/><w:iCs/><w:sz w:val="20"/><w:szCs w:val="20"/></w:rPr>'
            '<w:t xml:space="preserve">' + text + '</w:t></w:r>')

changes = []  # (label, old, new, expected_count)

# 1. Remove the whole "Can nhan manh pham vi bai bao" paragraph
old1 = (
    '<w:p><w:pPr><w:spacing w:after="40" w:before="40"/><w:ind w:firstLine="284"/><w:jc w:val="both"/></w:pPr>'
    '<w:r><w:rPr>' + FONT + '<w:sz w:val="20"/><w:szCs w:val="20"/></w:rPr>'
    '<w:t xml:space="preserve">Cần nhấn mạnh phạm vi bài báo: (1) MOFDA được sử dụng như công cụ đã kiểm chứng, '
    'không phải đối tượng phát triển mới, do đó bài báo không so sánh MOFDA với các thuật toán tối ưu đa '
    'mục tiêu khác; (2) hồ sơ thiết kế kỹ thuật của công trình chỉ được sử dụng để dựng mô hình FEM đầu vào, '
    'không nhằm mục đích đánh giá hay phê bình hồ sơ thiết kế gốc.</w:t></w:r></w:p>'
)
changes.append(("remove scope paragraph", old1, "", 1))

# 2. Section 2.2 ending clause
old2 = 'vị trí, độ xiên và chiều dài cọc giữ nguyên theo hồ sơ.'
new2 = 'vị trí, độ xiên và chiều dài cọc được giữ cố định trong tất cả các phương án khảo sát.'
changes.append(("sec2.2 wording", old2, new2, 1))

# 3. Section 2.3 "trong mo hinh goc"
old3 = 'trong mô hình gốc, được sử dụng trực tiếp cho việc trích xuất chuyển vị và nội lực.'
new3 = 'trong mô hình tính toán, được sử dụng trực tiếp cho việc trích xuất chuyển vị và nội lực.'
changes.append(("sec2.3 wording", old3, new3, 1))

# 4. Standard-scope phrase in Mo dau
old4 = 'theo đúng hệ tiêu chuẩn thiết kế công trình cảng biển Việt Nam hiện hành'
new4 = 'theo các tiêu chuẩn thiết kế công trình cảng biển Việt Nam được áp dụng trong phạm vi nghiên cứu'
changes.append(("standard scope phrase", old4, new4, 1))

# 5a. Constraints intro sentence: "Bon nhom" -> "Ba nhom ... truc tiep..."
old5a = 'Bốn nhóm ràng buộc được áp dụng: (i) tương tác lực dọc trục'
new5a = 'Ba nhóm ràng buộc được áp dụng trực tiếp trong quá trình đánh giá phương án, gồm: (i) tương tác lực dọc trục'
changes.append(("constraints intro", old5a, new5a, 1))

# 5b. Constraints tail paragraph (ii)-(iv) rewritten to (ii)-(iii) + geotechnical caveat
old5b = (
    '(ii) ứng suất cọc thép σ = N/A + M/W ≤ Fy/γM, với Fy = 3.150 kG/cm² theo bản vẽ thiết kế '
    '(TCVN 9245:2012); (iii) chuyển vị ngang U_max/U_allow − 1 ≤ 0, với U_allow = 71,7 mm theo '
    'TCVN 11820-5:2021, Điều 8.9, Bảng 12 (1/300 chiều cao bến, H = 21,5 m, không vượt quá 100 mm); '
    '(iv) sức chịu tải địa kỹ thuật theo TCVN 10304:2025 — hiện được ghi nhận trong khung bài toán '
    'nhưng chưa triển khai tính toán đầy đủ do thiếu số liệu chỉ tiêu cơ lý đất nền chi tiết (mục 4.4). '
    'Các ràng buộc kết cấu và chuyển vị (i)-(iii) được áp dụng đầy đủ trong phạm vi dữ liệu hiện có; '
    'kiểm tra sức chịu tải địa kỹ thuật (iv) chưa được đưa vào đánh giá định lượng trong đợt tính toán '
    'tối ưu do thiếu đầy đủ thông số đất nền chi tiết. Do đó, kết quả tối ưu chỉ có giá trị trong phạm vi '
    'các ràng buộc đã được triển khai và chưa được sử dụng để thay thế kiểm tra địa kỹ thuật trong thiết '
    'kế chính thức.'
)
new5b = (
    '(ii) ứng suất cọc thép σ = N/A + M/W ≤ Fy/γM, với Fy = 3.150 kG/cm² theo bản vẽ thiết kế '
    '(TCVN 9245:2012); và (iii) chuyển vị ngang U_max/U_allow − 1 ≤ 0, với U_allow = 71,7 mm theo '
    'TCVN 11820-5:2021, Điều 8.9, Bảng 12 (1/300 chiều cao bến, H = 21,5 m, không vượt quá 100 mm). '
    'Sức chịu tải địa kỹ thuật theo TCVN 10304:2025 được xác định là một yêu cầu kiểm tra cần thiết '
    'nhưng chưa được triển khai định lượng trong nghiên cứu do thiếu đầy đủ số liệu chỉ tiêu cơ lý đất '
    'nền (mục 4.4). Do đó, kết quả tối ưu chỉ có giá trị trong phạm vi ba nhóm ràng buộc đã được triển '
    'khai và chưa được sử dụng để thay thế kiểm tra địa kỹ thuật trong thiết kế chính thức.'
)
changes.append(("constraints tail", old5b, new5b, 1))

# 6. Penalty function clarifying sentence, inserted after "...he so khuech dai phat."
old6 = 'và C = 10 là hệ số khuếch đại phạt. Cách phạt nhân cho phép duy trì'
new6 = (
    'và C = 10 là hệ số khuếch đại phạt. Mỗi mức vi phạm được chuẩn hóa theo dạng v_i = max(0, g_i), '
    'với g_i là hàm ràng buộc đã được đưa về dạng không thứ nguyên g_i ≤ 0; khi đó P(x) = Σv_i. '
    'Cách phạt nhân cho phép duy trì'
)
changes.append(("penalty clarify sentence", old6, new6, 1))

# 7. C=10 calibration sentence
old7 = 'Giá trị C = 10 được hiệu chỉnh qua các lần chạy thử của nghiên cứu này và giữ cố định trong toàn bộ đợt tính toán chính thức.'
new7 = 'Giá trị C = 10 được lựa chọn qua các lần chạy thử và giữ cố định trong toàn bộ đợt tính toán chính thức.'
changes.append(("C10 wording", old7, new7, 1))

# 8. Section 3.3 parallelization sentences
old8 = (
    'Toàn bộ quá trình được song song hóa trên 8 tiến trình SAP2000 độc lập, mỗi tiến trình lưu một bản '
    'sao mô hình riêng để tránh xung đột khi ghi tệp. Số lượng tiến trình song song (8) được lựa chọn '
    'dựa trên khảo sát thực nghiệm sơ bộ trên máy tính sử dụng (14 lõi/28 luồng), do việc tăng thêm số '
    'tiến trình không mang lại hiệu quả tương xứng vì tranh chấp tài nguyên tính toán giữa các tiến trình '
    'SAP2000.'
)
new8 = (
    'Toàn bộ quá trình được song song hóa trên 8 tiến trình SAP2000 độc lập, mỗi tiến trình sử dụng một '
    'bản sao mô hình riêng để tránh xung đột khi ghi tệp. Số lượng 8 tiến trình được lựa chọn qua các lần '
    'thử nghiệm trên máy tính sử dụng 14 lõi/28 luồng, trong đó việc tăng thêm số tiến trình không cho '
    'thấy hiệu quả tính toán tương xứng do tranh chấp tài nguyên.'
)
changes.append(("sec3.3 wording", old8, new8, 1))

# 9. Six-solutions paragraph (4.2)
old9 = (
    'Sáu nghiệm còn lại là các nghiệm không bị trội trong tập nghiệm do thuật toán tìm được, nhưng bị '
    'trội bởi từ 1 đến 7 nghiệm khác khi xét toàn bộ không gian thiết kế — tức là các nghiệm gần vùng '
    'tối ưu nhưng chưa thuộc mặt Pareto tham chiếu.'
)
new9 = (
    'Sáu nghiệm còn lại không bị trội trong tập nghiệm của MOFDA nhưng bị trội khi xét toàn bộ 243 tổ '
    'hợp, cho thấy đây là các nghiệm gần vùng Pareto nhưng chưa thuộc mặt Pareto tham chiếu.'
)
changes.append(("six solutions wording", old9, new9, 1))

# 10. PA1 concluding sentence (in 4.3)
old10 = 'Phương án này phù hợp khi ưu tiên giảm khối lượng vật liệu trong khi vẫn bảo đảm yêu cầu chuyển vị của bài toán.'
new10 = 'Phương án này thể hiện xu hướng ưu tiên giảm khối lượng vật liệu, đồng thời vẫn thỏa mãn ràng buộc chuyển vị được xét trong nghiên cứu.'
changes.append(("PA1 wording", old10, new10, 1))

# 11. Abstract (Tom tat) Pareto phrase
old11 = 'toàn bộ 243 tổ hợp cũng được liệt kê để xây dựng mặt Pareto tham chiếu độc lập (16 nghiệm).'
new11 = 'toàn bộ 243 tổ hợp cũng được liệt kê để xây dựng mặt Pareto tham chiếu trong phạm vi các ràng buộc được triển khai (16 nghiệm).'
changes.append(("abstract VN wording", old11, new11, 1))

# 12. English Abstract parallel phrase (consistency)
old12 = 'all 243 combinations were also exhaustively enumerated to build an independent reference Pareto front (16 solutions).'
new12 = 'all 243 combinations were also exhaustively enumerated to build a reference Pareto front within the scope of the constraints implemented (16 solutions).'
changes.append(("abstract EN wording", old12, new12, 1))

# 13. Conclusion (3)
old13 = '(3) Mặt Pareto thu được cho thấy rõ sự đánh đổi giữa khối lượng vật liệu cọc'
new13 = '(3) Mặt Pareto trong phạm vi các ràng buộc được triển khai cho thấy rõ sự đánh đổi giữa khối lượng vật liệu cọc'
changes.append(("conclusion (3) wording", old13, new13, 1))

# Apply text changes
for label, old, new, expected in changes:
    count = data.count(old)
    sys.stdout.write("%-28s occurrences: %d\n" % (label, count))
    if count != expected:
        raise SystemExit("MISMATCH on '%s': expected %d, found %d" % (label, expected, count))
    data = data.replace(old, new, expected)

# 14. References: update [1], remove [4], renumber [5]->[4], [6]->[5]
old_ref1 = (
    '[1] Truong V.H., Khatir S., Cuong-Le T. (2026), Real-World Steel Frame Optimization Using a Hybrid '
    'Leader Selection-Based Multi-Objective Flow Direction Algorithm, Trường Đại học Mở Thành phố Hồ Chí Minh.'
)
new_ref1 = (
    '[1] Truong V.H., Khatir S., Cuong-Le T. (2025), Real-World Steel Frame Optimization Using a Hybrid '
    'Leader Selection-Based Multi-Objective Flow Direction Algorithm, International Journal for Numerical '
    'Methods in Engineering, 126(15), e70098. https://doi.org/10.1002/nme.70098'
)
c = data.count(old_ref1)
sys.stdout.write("ref [1] occurrences: %d\n" % c)
assert c == 1
data = data.replace(old_ref1, new_ref1, 1)

ref4_para = (
    '<w:p><w:pPr><w:spacing w:after="20" w:before="20"/><w:ind w:left="284" w:hanging="284"/><w:jc w:val="both"/></w:pPr>'
    '<w:r><w:rPr>' + FONT + '<w:sz w:val="20"/><w:szCs w:val="20"/></w:rPr>'
    '<w:t xml:space="preserve">[4] Bộ Khoa học và Công nghệ (2020), TCVN 11820-4-1:2020 — Công trình cảng biển – '
    'Yêu cầu thiết kế – Phần 4-1: Nền móng.</w:t></w:r></w:p>'
)
c = data.count(ref4_para)
sys.stdout.write("ref [4] paragraph occurrences: %d\n" % c)
assert c == 1
data = data.replace(ref4_para, "", 1)

c5 = data.count('[5] Bộ Khoa học và Công nghệ, TCVN 10304:2025 — Thiết kế móng cọc.')
sys.stdout.write("ref [5] occurrences: %d\n" % c5)
assert c5 == 1
data = data.replace(
    '[5] Bộ Khoa học và Công nghệ, TCVN 10304:2025 — Thiết kế móng cọc.',
    '[4] Bộ Khoa học và Công nghệ, TCVN 10304:2025 — Thiết kế móng cọc.',
    1,
)

c6 = data.count('[6] Bộ Khoa học và Công nghệ, TCVN 9245:2012 — Cọc ống thép.')
sys.stdout.write("ref [6] occurrences: %d\n" % c6)
assert c6 == 1
data = data.replace(
    '[6] Bộ Khoa học và Công nghệ, TCVN 9245:2012 — Cọc ống thép.',
    '[5] Bộ Khoa học và Công nghệ, TCVN 9245:2012 — Cọc ống thép.',
    1,
)

with io.open(path, "w", encoding="utf-8") as f:
    f.write(data)

sys.stdout.write("ALL DONE, new length: %d\n" % len(data))
