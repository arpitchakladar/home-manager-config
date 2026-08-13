#!/usr/bin/env python3
import json
import re
import sys

manifest_path = sys.argv[1]
ext_key = sys.argv[2]

with open(manifest_path, "r", encoding="utf-8", errors="ignore") as f:
    content = f.read()

pattern = r"(\"[^\"]*?\")|//.*?$|/\*.*?\*/"
clean = re.sub(
    pattern,
    lambda m: m.group(1) if m.group(1) else "",
    content,
    flags=re.DOTALL | re.MULTILINE,
)

clean = re.sub(r",\s*([\]}])", r"\1", clean)

data = json.loads(clean)
data["key"] = ext_key

with open(manifest_path, "w", encoding="utf-8") as f:
    json.dump(data, f, indent=2)
