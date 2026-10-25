#!/usr/bin/env bash
# Kontrola před nasazením: syntaxe + hlídání, kam smí stránka posílat data.
set -euo pipefail
cd "$(dirname "$0")/.."
fail=0
js=$(ls *.js)

for f in $js; do node --check "$f" || fail=1; done

# Povolené adresy: GitHub (API, avatary, odkazy) a Google Fonts.
allowed='^https://(api\.github\.com|github\.com|avatars\.githubusercontent\.com|fonts\.googleapis\.com|fonts\.gstatic\.com|zaviscuchna\.github\.io)'
bad=$(grep -ohE "https?://[a-zA-Z0-9.-]+" index.html style.css $js | sort -u | grep -vE "$allowed" | grep -v "www.w3.org" || true)
if [ -n "$bad" ]; then echo "❌ Nepovolené adresy (klíč smí jít jen na GitHub):"; echo "$bad"; fail=1; fi

if grep -nE "\.innerHTML\s*=|outerHTML\s*=|insertAdjacentHTML|document\.write|\beval\(|new Function\(" $js; then
  echo "❌ innerHTML / insertAdjacentHTML / document.write / eval: uživatelský text jen přes h() a textContent"; fail=1
fi

if grep -nE "<script[^>]+src=\"https?://" index.html; then echo "❌ Skript z cizího serveru"; fail=1; fi

# Data patří do soukromého repa; tady smí být jen kód stránky.
if git ls-files 2>/dev/null | grep -vE '^(index\.html|style\.css|[a-z0-9-]+\.js|README\.md|CLAUDE\.md|\.gitignore|scripts/check\.sh|\.github/workflows/check\.yml)$'; then
  echo "❌ Nečekané soubory v repu (veřejné repo má jen kód stránky)"; fail=1
fi

[ $fail = 0 ] && echo "✅ Kontrola prošla"
exit $fail
