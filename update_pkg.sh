#!/bin/bash
# Met à jour un .pkg du dépôt mosyle-packages et le pousse sur GitHub (LFS).
# Usage : ./update_pkg.sh /chemin/vers/nouveau.pkg "Nom Exact Dans Le Depot.pkg"
# Le 2e argument est optionnel : sans lui, le nom du fichier source est conservé.
set -euo pipefail
cd "$(dirname "$0")"

SRC="${1:?Usage : ./update_pkg.sh /chemin/nouveau.pkg \"Nom Dans Le Depot.pkg\"}"
DEST="${2:-$(basename "$SRC")}"

[ -f "$SRC" ] || { echo "❌ Fichier introuvable : $SRC"; exit 1; }

echo "— Signature du paquet :"
pkgutil --check-signature "$SRC" | head -3 || echo "  (non signé — OK seulement si le profil Mosyle a « This app is Signed » décoché)"

cp "$SRC" "$DEST"
MD5=$(md5 -q "$DEST")

git add "$DEST"
git commit -m "Update $DEST ($(date +%d/%m/%Y))"
echo "— Push vers GitHub (LFS, patiente si gros fichier)…"
git push origin main

URLNAME=$(echo "$DEST" | sed 's/ /%20/g')
echo ""
echo "✅ Poussé. Il reste 3 gestes dans Mosyle (Edit PKG) :"
echo "   1. App Version → nouvelle version"
echo "   2. MD5 → $MD5"
echo "   3. Cocher « Resend profiles that contains this app » puis Save"
echo "URL (inchangée) : https://github.com/Pyhot/mosyle-packages/raw/main/$URLNAME"
