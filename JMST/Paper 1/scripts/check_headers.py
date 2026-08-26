import re
text = open('Paper1_JMST_Draft_v1.md', encoding='utf-8').read()
text_no_comment = re.sub(r'<!--.*?-->', '', text, flags=re.S)
heads = re.findall(r'^#{2,3} .*', text_no_comment, re.M)
for h in heads:
    print(h)
print('---refs to sections in body (grep-like)---')
for m in re.finditer(r'§\d+(\.\d+)?', text_no_comment):
    pass
sec_refs = sorted(set(re.findall(r'§\d+(?:\.\d+)?', text_no_comment)))
print(sec_refs)
