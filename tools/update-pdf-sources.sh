#!/bin/sh
set -eu

# Regenerate the "# Minerals (alphabetical)" section in tools/pdf-sources.txt
# using a simple find + sort. Everything after the marker is replaced.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MANIFEST="${SCRIPT_DIR}/pdf-sources.txt"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

[ -f "${MANIFEST}" ] || { echo "Manifest not found: ${MANIFEST}" >&2; exit 1; }

MARKER="# Minerals (alphabetical)"
grep -q "^${MARKER}$" "${MANIFEST}" || { echo "Marker not found in manifest: ${MARKER}" >&2; exit 1; }

TMP_FILE="${MANIFEST}.tmp"

# 1) Write everything up to and including the marker line
awk -v marker="${MARKER}" '1; $0==marker{exit}' "${MANIFEST}" > "${TMP_FILE}"
echo >> "${TMP_FILE}"

# 2) Append minerals list (alphabetical, exclude template)
# No pagebreak.md between minerals — the Lua filter inserts a pagebreak before each mineral.
cd "${REPO_ROOT}"
LC_ALL=C find minerals -maxdepth 1 -type f -name '*.md' ! -name '_template.md' -print | sort >> "${TMP_FILE}"

mv "${TMP_FILE}" "${MANIFEST}"
echo "Updated ${MANIFEST}"
