#!/usr/bin/env python3
import argparse
import json

parser = argparse.ArgumentParser(
    description="Set allowed_origins in a native messaging host manifest"
)
parser.add_argument("extension_id", help="Chrome extension ID")
parser.add_argument("input", help="Path to the input JSON manifest")
parser.add_argument("output", help="Path to write the patched JSON manifest")
args = parser.parse_args()

with open(args.input) as f:
    manifest = json.load(f)

origin = f"chrome-extension://{args.extension_id}/"
manifest["allowed_origins"] = [origin]

with open(args.output, "w") as f:
    json.dump(manifest, f, indent=2)
    f.write("\n")
