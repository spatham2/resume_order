#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
config="$root/yaml/convert_to_pdf.yaml"

cfg() {
  python3 -c 'import os, sys, yaml
c = yaml.safe_load(open(sys.argv[1]))
print(os.path.join(sys.argv[2], os.path.expanduser(c[sys.argv[3]])))' "$config" "$root" "$1"
}

tex="${1:-$(cfg tex)}"
pdf="$(cfg pdf)"
job="$(basename "$pdf" .pdf)"

[[ -f "$tex" ]] || { echo "LaTeX file not found: $tex" >&2; exit 1; }

build_dir="$(mktemp -d)"
trap 'rm -rf "$build_dir"' EXIT

(cd "$(dirname "$tex")" && pdflatex -interaction=nonstopmode -halt-on-error \
  -output-directory="$build_dir" -jobname="$job" "$(basename "$tex")" >/dev/null) \
  || { echo "pdflatex failed; see $build_dir/$job.log" >&2; trap - EXIT; exit 1; }

mkdir -p "$(dirname "$pdf")"
mv -f "$build_dir/$job.pdf" "$pdf"
echo "Wrote: $pdf"
