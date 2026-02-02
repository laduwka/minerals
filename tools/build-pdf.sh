#!/bin/sh
set -eu

cd "${1:-/work}" 2>/dev/null || true

MANIFEST="tools/pdf-sources.txt"
PDF_OUT="${OUTPUT:-mineral-catalog-local.pdf}"

[ -f "$MANIFEST" ] || { echo "Manifest not found: $MANIFEST" >&2; exit 1; }

# Build a positional list of files from the manifest (skip comments/blank)
set --
while IFS= read -r line; do
  # strip CR if file has Windows line endings
  line=$(printf '%s' "$line" | tr -d '\r')
  case "$line" in
    ''|'#'*) continue ;;
    *) set -- "$@" "$line" ;;
  esac
done < "$MANIFEST"

[ "$#" -gt 0 ] || { echo "No sources resolved from $MANIFEST" >&2; exit 1; }

echo "Inputs ($#):" >&2
printf '%s\n' "$@" >&2

# Validate each source exists before invoking pandoc
for f in "$@"; do
  [ -f "$f" ] || { echo "Missing source: $f" >&2; exit 1; }
done

# ── Pre-process mineral files ─────────────────────────────────────
# Pandoc's --file-scope does NOT run Lua filters per-file; the filter
# sees only the merged document whose metadata comes from the last file.
# Work around this by processing each mineral file individually through
# the Lua filter (which reads its YAML front matter), then feeding the
# rendered markdown into the final pandoc pass.
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

# Save original file list, then rebuild with processed minerals
ARGFILE="$TMPDIR/args.txt"
for f in "$@"; do
  printf '%s\n' "$f" >> "$ARGFILE"
done

echo "[1/2] Pre-processing mineral files..." >&2
set --
i=0
while IFS= read -r f; do
  i=$((i + 1))
  case "$f" in
    minerals/*.md)
      outf="$TMPDIR/$(printf '%04d' "$i").md"
      pandoc -L tools/filters/mineral.lua \
        --from markdown+yaml_metadata_block+pipe_tables+raw_attribute \
        -t markdown+raw_attribute \
        -o "$outf" "$f"
      set -- "$@" "$outf"
      ;;
    *)
      set -- "$@" "$f"
      ;;
  esac
done < "$ARGFILE"

echo "[2/2] Building PDF with Typst..." >&2
pandoc --defaults tools/pdf-metadata.yml \
  -V date="$(date -I)" \
  --pdf-engine=typst \
  --pdf-engine-opt=--root=. \
  -o "$PDF_OUT" \
  "$@"

echo "Done: $PDF_OUT" >&2
