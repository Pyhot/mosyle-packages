# Contexte projet mosyle-packages

## Description
Dépôt GitHub pour héberger les PKG à déployer via Mosyle MDM.
- Repo : https://github.com/Pyhot/mosyle-packages
- Git LFS activé pour les fichiers .pkg (> 100 MB)

## Packages disponibles

| Package | Version | Bundle ID | MD5 | Cible | URL Mosyle |
|---------|---------|-----------|-----|-------|------------|
| Install Synology Drive Client.pkg | 8.0.3-17892 (28/07/2026) | `com.synology.CloudStation` | `6d4290588345cc958c0ea6f2371ddd23` | Tout le parc | `https://github.com/Pyhot/mosyle-packages/raw/main/Install%20Synology%20Drive%20Client.pkg` |
| AlDente.pkg | 1.36.3 (pkg non signé, app signée AppHouseKitchen) | `com.apphousekitchen.aldente-pro` | `9360fd1b40d17ee0ff8e979658a5afb9` | MacBooks UNIQUEMENT (batterie) | `https://github.com/Pyhot/mosyle-packages/raw/main/AlDente.pkg` |
| ~~OnyX.pkg~~ | **SUPPRIMÉ** du dépôt + fiche Mosyle à Delete (28/07/2026) | — | — | Au besoin : télécharger la version courante sur le site Titanium, adaptée au macOS de la machine (1 version OnyX = 1 version macOS) | — |
| Pearcleaner.pkg | 5.4.3 (pkg non signé, app signée M. Lupascu) | `com.alienator88.Pearcleaner` | `66fc8cbc6fa892d2709cdd4f64521414` | Tout le parc | `https://github.com/Pyhot/mosyle-packages/raw/main/Pearcleaner.pkg` |

## Déploiement des pkg NON SIGNÉS (AlDente, Pearcleaner) — plan 28/07/2026
- Les .app à l'intérieur SONT signées Developer ID par leurs éditeurs ; seule l'enveloppe .pkg (fabriquée maison via `pkgbuild`, les éditeurs ne fournissent pas de pkg) est non signée.
- **Étape 1 (gratuit)** : profil Mosyle avec « This app is Signed » DÉCOCHÉ → test sur 1 Mac. Si l'agent Mosyle installe les pkg non signés → terminé.
- **Étape 2 (si échec)** : Apple Developer Program (~99 €/an, décision PYD) → certificat « Developer ID Installer » → `productsign --sign "Developer ID Installer: ..." brut.pkg signé.pkg` → re-push.
- OnyX : écarté du déploiement MDM — build spécifique à chaque version de macOS + Full Disk Access à accorder manuellement + outil d'usage ponctuel.

## Réglages Mosyle (actés 28/07/2026 — DÉCISION PYD : tout auto, tout le parc)
- ⚠️ CONSTAT console : le bloc « Configure App Auto Install and Update » est au niveau du PROFIL InstallApps, COMMUN à toutes les apps (pas séparable par app). La granularité = appartenance au profil. Décision PYD : UN SEUL profil, toutes les apps, tous les Macs.
- **Bloc commun** : Auto-Install « Install all apps after saving the profile » · pop-up OFF · Self-Service « Show the apps » (bouton de réinstall manuelle) · **Reinstall ON** · **Update « automatically without alerting end users »**
- Conséquence Update auto : une maj = remplacer le pkg (update_pkg.sh) + monter App Version sur la fiche → le parc se met à jour SEUL (plus besoin de Resend)
- Conséquence acceptée : AlDente s'installe aussi sur les Mac sans batterie (inoffensif) ; si gênant un jour → 2e profil restreint au groupe MacBooks
- Par FICHE (champ « This app is Signed ») : Drive Client = coché (signé+notarié) ; AlDente/Pearcleaner = DÉCOCHÉ (enveloppes non signées → voie agent Mosyle)
- Parc en Device Enrollment (ABM) — la contrainte « User Enrollment → Apple Protocol obligatoire » ne s'applique pas
- **Mosyle Embark = OFF** pour Drive Client (règle historique : à installer APRÈS l'enrollment, pas pendant)
- **Règle de tri pour toute NOUVELLE app** : dispo sur le Mac App Store → canal VPP/Apps and Books via ABM (zéro pkg, zéro URL, maj auto par Apple) ; sinon → ce dépôt + fiche PKG dans le profil InstallApps

## Procédure de mise à jour d'un PKG (méthode validée 28/07/2026)
**Raccourci : `./update_pkg.sh /chemin/nouveau.pkg "Nom Dans Le Depot.pkg"`** — fait les étapes 2 à 5 tout seul et affiche le MD5 à coller dans Mosyle. Détail manuel :
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

- ⚠️ Double numérotation Drive Client : version PUBLIQUE affichée (ex. 4.0.3-17892, site + fenêtre À propos) ≠ version INTERNE du bundle (ex. 8.0.3, Info.plist) — MOSYLE compare la version INTERNE → App Version = toujours celle lue via `defaults read .../Info.plist CFBundleShortVersionString`. Le build (17892) est commun aux deux.
- « Configure Apps and Books (VPP) licenses » : OFF — ne concerne que les apps App Store (canal VPP), pas les PKG ; à revoir seulement si canal VPP ouvert ET apps pré-installées manuellement par les utilisateurs (elles resteraient non gérées)
- 28/07/2026 : profil InstallApps v6 VALIDÉ et poussé — Apple Protocol décoché (confirmé PYD), tout auto, assignation « All current and future Devices » ; OnyX retiré ; en observation : statuts installed + verdict Pearcleaner (voie non signée)
- 28/07/2026 soir : ✅ VALIDÉ EN RÉEL — 4/4 Macs vérifiés en 4.0.3-17892 (chaîne GitHub raw → Mosyle → MD5 → install + comparaison de version : tout fonctionne)
