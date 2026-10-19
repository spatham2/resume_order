#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
config="$root/yaml/promote_draft.yaml"

cfg() {
  python3 -c 'import os, sys, yaml
c = yaml.safe_load(open(sys.argv[1]))
print(os.path.join(sys.argv[2], os.path.expanduser(c[sys.argv[3]])))' "$config" "$root" "$1"
}

draft="${1:-$(cfg draft)}"
current="$(cfg current)"
previous_dir="$(cfg previous_dir)"

[[ -f "$draft" ]] || { echo "Draft not found: $draft" >&2; exit 1; }

if [[ -f "$current" ]]; then
  name="$(basename "$current" .tex)"
  archived="$previous_dir/${name}_$(date +%m_%d_%Y).tex"
  [[ -e "$archived" ]] && { echo "Already exists: $archived" >&2; exit 1; }
  mkdir -p "$previous_dir"
  mv "$current" "$archived"
  echo "Archived: $archived"
fi

mkdir -p "$(dirname "$current")"
mv "$draft" "$current"
echo "Promoted: $current"
