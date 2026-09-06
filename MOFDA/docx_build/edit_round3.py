import io, sys

path = "unpacked_v1/word/document.xml"
with io.open(path, encoding="utf-8") as f:
    data = f.read()

changes = []

# 1. Remove "theo ban ve thiet ke"
old1 = 'với Fy = 3.150 kG/cm² theo bản vẽ thiết kế (TCVN 9245:2012);'
new1 = 'với Fy = 3.150 kG/cm² (TCVN 9245:2012);'
changes.append(("remove 'theo ban ve thiet ke'", old1, new1, 1))

# 2a. "Pareto tham chieu doc lap" in sec 3.4
old2a = 'để xây dựng mặt Pareto tham chiếu độc lập cho kết quả MOFDA.'
new2a = 'để xây dựng mặt Pareto tham chiếu cho kết quả MOFDA.'
changes.append(("Pareto doc lap (3.4)", old2a, new2a, 1))

# 2b. "Pareto tham chieu doc lap" in conclusion (2)
old2b = 'để xây dựng mặt Pareto tham chiếu độc lập gồm 16 nghiệm.'
new2b = 'để xây dựng mặt Pareto tham chiếu gồm 16 nghiệm.'
changes.append(("Pareto doc lap (conclusion 2)", old2b, new2b, 1))

# 3. Soften the strong claim in 4.4
old3 = (
    'Các giới hạn này không làm thay đổi kết luận về khả năng ứng dụng của MOFDA nhưng cần được bổ sung '
    'trước khi sử dụng kết quả số cho thiết kế thi công.'
)
new3 = (
    'Các giới hạn này cần được xem xét khi đánh giá phạm vi áp dụng của kết quả tối ưu, và cần được bổ '
    'sung trước khi sử dụng kết quả số cho thiết kế thi công.'
)
changes.append(("soften 4.4 claim", old3, new3, 1))

# 4. "thay the ho so thiet ke thi cong" -> "thay the cac buoc kiem tra va thiet ke chinh thuc"
old4 = 'Kết quả tối ưu không được sử dụng trực tiếp để thay thế hồ sơ thiết kế thi công.'
new4 = 'Kết quả tối ưu không được sử dụng trực tiếp để thay thế các bước kiểm tra và thiết kế chính thức.'
changes.append(("thay the ho so -> cac buoc kiem tra", old4, new4, 1))

for label, old, new, expected in changes:
    count = data.count(old)
    sys.stdout.write("%-32s occurrences: %d\n" % (label, count))
    if count != expected:
        raise SystemExit("MISMATCH on '%s': expected %d, found %d" % (label, expected, count))
    data = data.replace(old, new, expected)

with io.open(path, "w", encoding="utf-8") as f:
    f.write(data)

sys.stdout.write("ALL DONE, new length: %d\n" % len(data))
