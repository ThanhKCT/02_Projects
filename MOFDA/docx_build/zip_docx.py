import sys, os, zipfile

src_dir = sys.argv[1]
out_path = sys.argv[2]

if os.path.exists(out_path):
    os.remove(out_path)

with zipfile.ZipFile(out_path, "w", zipfile.ZIP_DEFLATED) as zf:
    for root, dirs, files in os.walk(src_dir):
        for name in files:
            full = os.path.join(root, name)
            rel = os.path.relpath(full, src_dir).replace(os.sep, "/")
            zf.write(full, rel)

print("wrote", out_path)
