#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
config="$root/yaml/promote_draft.yaml"

cfg() {
  python3 -c 'import os, sys, yaml
c = yaml.safe_load(open(sys.argv[1]))
print(os.path.join(sys.argv[2], os.path.expanduser(c[sys.argv[3]])))' "$config" "$root" "$1"
}

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <resume-name>" >&2
  exit 1
fi

name="${1%.tex}"
if [[ -z "$name" || "$name" == "." || "$name" == ".." || "$name" == */* ]]; then
  echo "Invalid resume name: $1" >&2
  exit 1
fi

draft="$(cfg draft)"
current="$(dirname "$(cfg current)")/$name.tex"
previous_dir="$(cfg previous_dir)"

[[ -f "$draft" ]] || { echo "Draft not found: $draft" >&2; exit 1; }
[[ "$draft" != "$current" ]] || { echo "Draft and current resume must be different files" >&2; exit 1; }

if [[ -f "$current" ]]; then
  archived="$previous_dir/${name}_$(date +%m_%d_%Y).tex"
  [[ -e "$archived" ]] && { echo "Already exists: $archived" >&2; exit 1; }
  mkdir -p "$previous_dir"
  mv "$current" "$archived"
  echo "Archived: $archived"
fi

mkdir -p "$(dirname "$current")"
mv "$draft" "$current"
echo "Promoted: $current"
