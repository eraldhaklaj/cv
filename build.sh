#!/usr/bin/env bash
# Builds both CV PDFs from index.html, the single source.
#
#   Erald-Haklaj-CV.pdf             no phone number. This is what the site links to.
#   "Erald-Haklaj CV.pdf"           same CV plus the phone number, for job applications.
#
# The phone lives in a <span class="tel"> that index.html hides by default. This flips
# that one CSS rule for the second build so the two can never drift apart.

set -euo pipefail
cd "$(dirname "$0")"

CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
[ -x "$CHROME" ] || { echo "Chrome not found at $CHROME"; exit 1; }

render() {  # render <source.html> <output.pdf>
  "$CHROME" --headless --disable-gpu --no-pdf-header-footer \
            --print-to-pdf="$PWD/$2" "file://$PWD/$1" 2>/dev/null
  echo "  $2"
}

echo "Building:"
render index.html Erald-Haklaj-CV.pdf

TMP=".with-phone.html"
trap 'rm -f "$TMP"' EXIT
sed 's/\.tel{ display:none; }/.tel{ display:inline; }/' index.html > "$TMP"
grep -q 'display:inline' "$TMP" || { echo "phone toggle did not apply"; exit 1; }
render "$TMP" "Erald-Haklaj CV.pdf"

echo "Done."
