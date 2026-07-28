# Contexte projet mosyle-packages

## Description
Dépôt GitHub pour héberger les PKG à déployer via Mosyle MDM.
- Repo : https://github.com/Pyhot/mosyle-packages
- Git LFS activé pour les fichiers .pkg (> 100 MB)

## Packages disponibles

| Package | Version | Taille | MD5 | URL Mosyle |
|---------|---------|--------|-----|------------|
| Install Synology Drive Client.pkg | 8.0.3-17892 (28/07/2026) | 157 MB | `6d4290588345cc958c0ea6f2371ddd23` | `https://github.com/Pyhot/mosyle-packages/raw/main/Install%20Synology%20Drive%20Client.pkg` |
| AlDente.pkg | — | 11 MB | — | `https://github.com/Pyhot/mosyle-packages/raw/main/AlDente.pkg` |
| OnyX.pkg | — | 6.9 MB | — | `https://github.com/Pyhot/mosyle-packages/raw/main/OnyX.pkg` |
| Pearcleaner.pkg | — | 6.3 MB | — | `https://github.com/Pyhot/mosyle-packages/raw/main/Pearcleaner.pkg` |

## Procédure de mise à jour d'un PKG (méthode validée 28/07/2026)
1. Télécharger le .dmg Synology → monter → extraire le `.pkg` signé
2. Vérifier signature : `pkgutil --check-signature` (Developer ID Synology Inc. + notarisation)
3. Remplacer le fichier dans ce dépôt **SOUS LE MÊME NOM** (l'URL Mosyle ne change alors pas)
4. `git add` + commit + push (Git LFS gère les >100 MB)
5. Dans Mosyle (Edit PKG) : App Version → nouvelle version, MD5 → `md5 -q fichier.pkg`, cocher « Resend profiles that contains this app », Save
6. App Bundle (ne change pas) : `com.synology.CloudStation`

## Historique
- 28/07/2026 : Drive Client 8.0.1-17885 → **8.0.3-17892**
- ~11/01/2026 : setup initial LFS + 4 pkg

## Notes importantes
- Limite GitHub web : 25 MB (contournée avec Git LFS)
- Limite Git sans LFS : 100 MB (contournée avec Git LFS)
- Synology DriveClient doit être installé APRÈS l'enrollment (pas pendant)
- ⚠️ Le dépôt est PRIVÉ (constaté 28/07/2026) → l'URL raw GitHub exige une authentification. Deux options : (a) passer le dépôt en public (contenu = logiciels publics, rien de sensible), ou (b) cocher « Needs authentication » dans Mosyle avec username GitHub + Personal Access Token (fine-grained, read-only sur ce dépôt). À trancher AVANT le Resend.
- ⚠️ Les tâches « Configurer l'URL dans Mosyle » et « Tester le déploiement sur un Mac » n'ont jamais été cochées à l'époque → le téléchargement Mosyle→GitHub n'est peut-être JAMAIS passé en réel. Tester sur 1 Mac avant le parc.
- JAMAIS d'upload de .pkg via l'interface web GitHub (limite 25 MB) → toujours `git push` en CLI, Git LFS gère
- Dépôt passé PUBLIC le 28/07/2026 (audit confidentialité OK : 0 secret, emails noreply, config propre)
- ⚠️ AlDente.pkg, OnyX.pkg, Pearcleaner.pkg = NON SIGNÉS (constaté 28/07/2026) → échoueront probablement via MDM ; re-générer depuis les installeurs officiels signés avant tout déploiement. Seul Drive Client est signé + notarié
- Sécurité chaîne de déploiement : compte GitHub Pyhot = maillon root du parc → 2FA obligatoire ; garder « Validate file integrity » (MD5) coché dans Mosyle
