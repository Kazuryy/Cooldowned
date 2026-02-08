# Guide de Déploiement - Next Episode Delay

Guide complet pour déployer et distribuer le plugin Next Episode Delay via repository custom Jellyfin.

## 📋 Vue d'ensemble

Le plugin peut être distribué de **deux manières** :

1. **Via Repository Custom Jellyfin** (Recommandé) - Installation en 1 clic
2. **Installation Manuelle** - Téléchargement et installation manuelle

## 🎯 Architecture de Distribution

```
┌────────────────────────────────────────────────────────────┐
│                     GitHub                                  │
│                                                            │
│  ┌──────────────────────┐  ┌──────────────────────────┐  │
│  │   Cooldowned         │  │ jellyfin-plugin-repo     │  │
│  │   (Code source)      │  │ (Manifest uniquement)    │  │
│  │                      │  │                          │  │
│  │  • Code C#/JS/CSS    │  │  • manifest.json         │  │
│  │  • Releases (ZIP)    │  │    (métadonnées)         │  │
│  │  • manifest.json     │  │                          │  │
│  └──────────┬───────────┘  └──────────┬───────────────┘  │
│             │                          │                  │
└─────────────┼──────────────────────────┼──────────────────┘
              │                          │
              │ Releases API             │ Raw Content API
              │                          │
         ┌────▼──────────────────────────▼────┐
         │     Utilisateurs Jellyfin           │
         │                                     │
         │  Option 1: Repository Custom        │
         │  Option 2: Download + Install       │
         └─────────────────────────────────────┘
```

## 🚀 Étape 1 : Préparer le Repository Principal

### 1.1 Créer le repository GitHub

```bash
# Si pas encore fait
cd /home/kazury/dev/Cooldowned
git init
git add .
git commit -m "Initial commit: Next Episode Delay plugin"

# Créer le repository sur GitHub (via interface web)
# Repository name: Cooldowned

# Pousser le code
git remote add origin git@github.com:kazury/Cooldowned.git
git branch -M main
git push -u origin main
```

### 1.2 Vérifier les fichiers essentiels

```bash
# Vérifier que ces fichiers existent
ls -l manifest.json                               # ✓ Manifest
ls -l .github/workflows/release.yml               # ✓ Release workflow
ls -l .github/workflows/build.yml                 # ✓ Build workflow
ls -l scripts/generate-checksum.sh                # ✓ Checksum script
ls -l scripts/update-manifest.sh                  # ✓ Manifest updater
```

## 🏗️ Étape 2 : Créer le Repository de Manifest (Optionnel)

> **Note :** Cette étape est optionnelle. Vous pouvez utiliser le manifest dans le repository principal.

### Option A : Repository séparé (Recommandé pour production)

```bash
# Créer un nouveau repository
mkdir jellyfin-plugin-repo
cd jellyfin-plugin-repo

# Initialiser
git init

# Créer la structure
mkdir -p 10.11

# Copier le manifest
cp ../Cooldowned/manifest.json ./10.11/manifest.json

# Créer un manifest racine qui pointe vers la dernière version
ln -s 10.11/manifest.json manifest.json

# Commit et push
git add .
git commit -m "Initial manifest for Next Episode Delay"
git remote add origin git@github.com:kazury/jellyfin-plugin-repo.git
git push -u origin main
```

**URL du repository :**
```
https://raw.githubusercontent.com/kazury/jellyfin-plugin-repo/main/manifest.json
```

### Option B : Utiliser le manifest dans Cooldowned

Le manifest est déjà à la racine de [Cooldowned](.).

**URL du repository :**
```
https://raw.githubusercontent.com/kazury/Cooldowned/main/manifest.json
```

## 📦 Étape 3 : Créer votre première Release

### 3.1 Préparer la version

```bash
cd /home/kazury/dev/Cooldowned

# Mettre à jour le changelog
vim CHANGELOG.md
# Ajouter les changements pour v1.0.0

# Commit les changements
git add CHANGELOG.md
git commit -m "Prepare release v1.0.0"
git push origin main
```

### 3.2 Créer et pousser le tag

```bash
# Créer le tag
git tag -a v1.0.0 -m "Release v1.0.0 - Initial release"

# Pousser le tag
git push origin v1.0.0
```

### 3.3 GitHub Actions automatique

Le workflow [.github/workflows/release.yml](.github/workflows/release.yml) va automatiquement :

1. ✅ Compiler le plugin en Release
2. ✅ Créer `NextEpisodeDelay-v1.0.0.zip`
3. ✅ Calculer le checksum MD5
4. ✅ Créer la release GitHub
5. ✅ Uploader le ZIP
6. ✅ Afficher le checksum dans les logs

### 3.4 Récupérer le checksum

Allez sur GitHub :
1. **Actions** → Workflow "Create Release" → Dernier run
2. Dans les logs, cherchez : `MD5 Checksum: ...`
3. Copiez le checksum

Ou utilisez le script :

```bash
# Télécharger la release
wget https://github.com/kazury/Cooldowned/releases/download/v1.0.0/NextEpisodeDelay-v1.0.0.zip

# Générer le checksum
./scripts/generate-checksum.sh NextEpisodeDelay-v1.0.0.zip
```

### 3.5 Mettre à jour le manifest

**Méthode automatique :**

```bash
# Avec le script
./scripts/update-manifest.sh 1.0.0 NextEpisodeDelay-v1.0.0.zip

# Vérifier les changements
git diff manifest.json

# Commit et push
git add manifest.json
git commit -m "Update manifest for v1.0.0"
git push origin main
```

**Méthode manuelle :**

Éditez [manifest.json](manifest.json) :

```json
{
  "versions": [
    {
      "version": "1.0.0",
      "changelog": "Initial release:\n- Configurable delay (0-300s)\n- Visual countdown overlay\n- Per-user settings",
      "targetAbi": "10.11.0.0",
      "sourceUrl": "https://github.com/kazury/Cooldowned/releases/download/v1.0.0/NextEpisodeDelay-v1.0.0.zip",
      "checksum": "PASTE_MD5_HERE",
      "timestamp": "2026-02-08T12:00:00Z"
    }
  ]
}
```

## 🧪 Étape 4 : Tester l'Installation

### Test via Repository Custom

1. Ouvrir Jellyfin → **Dashboard** → **Plugins** → **Repositories**
2. Cliquer **Add Repository** (+)
3. Remplir :
   - **Repository Name:** Next Episode Delay Test
   - **Repository URL:** `https://raw.githubusercontent.com/kazury/Cooldowned/main/manifest.json`
4. **Save** et **Refresh**
5. Aller dans **Catalog** → Chercher "Next Episode Delay"
6. Cliquer **Install**
7. Redémarrer Jellyfin
8. Vérifier dans **Dashboard** → **Plugins** que le plugin est installé

### Test manuel

```bash
# Télécharger
wget https://github.com/kazury/Cooldowned/releases/download/v1.0.0/NextEpisodeDelay-v1.0.0.zip

# Vérifier le checksum
md5sum NextEpisodeDelay-v1.0.0.zip

# Installer
sudo mkdir -p /var/lib/jellyfin/plugins/NextEpisodeDelay
sudo unzip NextEpisodeDelay-v1.0.0.zip -d /var/lib/jellyfin/plugins/NextEpisodeDelay
sudo chown -R jellyfin:jellyfin /var/lib/jellyfin/plugins/NextEpisodeDelay
sudo systemctl restart jellyfin

# Vérifier les logs
sudo journalctl -u jellyfin -f | grep -i nextepisode
```

## 📢 Étape 5 : Annoncer le Plugin

### 5.1 Forum Jellyfin

Créez un post sur le [forum Jellyfin](https://forum.jellyfin.org/) dans la catégorie **Plugins** :

```markdown
# [PLUGIN] Next Episode Delay - Plex-style episode autoplay delay

## Description
Add a configurable delay before auto-playing the next episode, similar to Plex behavior.

## Features
- Configurable delay (0-300s)
- Visual countdown overlay
- Per-user settings
- Play Now and Cancel buttons
- Responsive design

## Installation
Add repository: `https://raw.githubusercontent.com/kazury/Cooldowned/main/manifest.json`

## Links
- [GitHub Repository](https://github.com/kazury/Cooldowned)
- [Documentation](https://github.com/kazury/Cooldowned#readme)
- [Issues](https://github.com/kazury/Cooldowned/issues)

## Screenshots
[Add screenshots here]
```

### 5.2 Reddit

Post sur [r/jellyfin](https://www.reddit.com/r/jellyfin/) :

```markdown
[Plugin Release] Next Episode Delay - Add a countdown before autoplay

I've created a plugin that adds a configurable delay before auto-playing
the next episode, similar to Plex's behavior.

Repository: https://raw.githubusercontent.com/kazury/Cooldowned/main/manifest.json

[Add GIF/screenshot]

Feedback welcome!
```

### 5.3 Awesome Jellyfin

Ouvrez une PR sur [awesome-jellyfin](https://github.com/awesome-jellyfin/awesome-jellyfin) :

```markdown
## Next Episode Delay
Add a configurable delay before auto-playing the next episode, similar to Plex.

**Features:** Countdown overlay, Per-user settings, Play Now/Cancel buttons

**Repository:** https://raw.githubusercontent.com/kazury/Cooldowned/main/manifest.json
**Source:** https://github.com/kazury/Cooldowned
```

## 🔄 Étape 6 : Process de Mise à Jour

Pour les versions suivantes (1.1.0, 1.2.0, etc.) :

### 6.1 Développer et tester

```bash
# Créer une branche
git checkout -b feature/nouvelle-fonctionnalite

# Développer...
# Tester...

# Merger dans main
git checkout main
git merge feature/nouvelle-fonctionnalite
git push origin main
```

### 6.2 Préparer la release

```bash
# Mettre à jour le changelog
vim CHANGELOG.md

# Mettre à jour la version dans build.yaml si nécessaire
vim Jellyfin.Plugin.NextEpisodeDelay/build.yaml

# Commit
git add .
git commit -m "Prepare release v1.1.0"
git push origin main
```

### 6.3 Créer la release

```bash
# Tag
git tag -a v1.1.0 -m "Release v1.1.0 - New features"
git push origin v1.1.0

# GitHub Actions va créer la release automatiquement
```

### 6.4 Mettre à jour le manifest

```bash
# Télécharger la release
wget https://github.com/kazury/Cooldowned/releases/download/v1.1.0/NextEpisodeDelay-v1.1.0.zip

# Mettre à jour le manifest
./scripts/update-manifest.sh 1.1.0 NextEpisodeDelay-v1.1.0.zip

# Push
git add manifest.json
git commit -m "Release v1.1.0"
git push origin main
```

### 6.5 Mise à jour automatique pour les utilisateurs

Les utilisateurs Jellyfin avec le repository configuré verront automatiquement la nouvelle version disponible dans **Dashboard** → **Plugins** → **Updates**.

## 📊 Monitoring

### Téléchargements

Voir les statistiques sur GitHub :
- **Releases** → Chaque release affiche le nombre de téléchargements du ZIP

### Issues et Feedback

Surveillez :
- [GitHub Issues](https://github.com/kazury/Cooldowned/issues)
- Forum Jellyfin
- Reddit r/jellyfin

## ✅ Checklist Complète

### Préparation initiale
- [x] Repository GitHub créé
- [x] Code poussé sur main
- [x] manifest.json configuré
- [x] Workflows GitHub Actions configurés
- [x] Scripts de déploiement créés
- [x] Documentation complète

### Première release
- [ ] CHANGELOG.md mis à jour
- [ ] Code testé
- [ ] Tag v1.0.0 créé et poussé
- [ ] Release GitHub créée (automatique)
- [ ] Checksum MD5 récupéré
- [ ] manifest.json mis à jour avec checksum
- [ ] Installation testée via repository
- [ ] Installation testée manuellement

### Publication
- [ ] Post sur forum Jellyfin
- [ ] Post sur Reddit r/jellyfin
- [ ] PR sur awesome-jellyfin
- [ ] README avec badges et liens
- [ ] Screenshots/GIF ajoutés

### Support continu
- [ ] Surveiller les issues GitHub
- [ ] Répondre aux questions sur le forum
- [ ] Publier les mises à jour régulièrement
- [ ] Maintenir la documentation à jour

## 🆘 Dépannage

### Le workflow GitHub Actions échoue

```bash
# Vérifier les logs sur GitHub
# Actions → Workflow failed → View logs

# Problèmes courants :
# - .NET SDK version incorrecte
# - Permissions GitHub
# - Erreur de build
```

### Le plugin n'apparaît pas dans le catalog

```bash
# Vérifier que le manifest est accessible
curl https://raw.githubusercontent.com/kazury/Cooldowned/main/manifest.json

# Vérifier le JSON
cat manifest.json | jq .

# Vérifier que le GUID est unique
grep "a8b9c0d1-e2f3-4a5b-6c7d-8e9f0a1b2c3d" manifest.json
```

### Erreur de checksum lors de l'installation

```bash
# Le checksum dans manifest.json ne correspond pas au fichier
# Régénérer :
md5sum NextEpisodeDelay-v1.0.0.zip

# Mettre à jour manifest.json avec le bon checksum
```

## 📚 Ressources

- [Documentation Jellyfin Plugins](https://jellyfin.org/docs/general/server/plugins/)
- [Jellyfin Plugin Template](https://github.com/jellyfin/jellyfin-plugin-template)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Exemple : Jellyfin Enhanced](https://github.com/n00bcodr/jellyfin-plugins)

---

**Prêt à déployer ?** Suivez les étapes ci-dessus et votre plugin sera disponible pour toute la communauté Jellyfin ! 🚀

**Questions ?** Ouvrez une [issue](https://github.com/kazury/Cooldowned/issues) ou consultez le [README](README.md).
