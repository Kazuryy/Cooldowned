# Guide du Repository Custom Jellyfin

Ce document explique comment mettre en place et maintenir le repository custom Jellyfin pour le plugin Next Episode Delay.

## 📦 Architecture du Repository

Pour permettre l'installation via repository custom dans Jellyfin, nous utilisons deux repositories GitHub séparés :

```
1. Cooldowned/                          # Repository principal (code source)
   └── Code du plugin + releases

2. jellyfin-plugin-repo/                # Repository de manifest (optionnel)
   └── manifest.json                    # Métadonnées pour Jellyfin
```

## 🎯 Option 1 : Repository Séparé (Recommandé)

### Créer le repository jellyfin-plugin-repo

```bash
# Créer un nouveau repository GitHub nommé "jellyfin-plugin-repo"
mkdir jellyfin-plugin-repo
cd jellyfin-plugin-repo
git init

# Créer la structure
mkdir -p 10.11
```

### Créer le manifest.json

```json
[
  {
    "guid": "a8b9c0d1-e2f3-4a5b-6c7d-8e9f0a1b2c3d",
    "name": "Next Episode Delay",
    "description": "Add a configurable delay before auto-playing the next episode, similar to Plex behavior. Features a visual countdown overlay with Play Now and Cancel options.",
    "overview": "Configurable delay with countdown overlay before next episode autoplay",
    "owner": "kazury",
    "category": "General",
    "imageUrl": "https://raw.githubusercontent.com/kazury/Cooldowned/main/logo.png",
    "versions": [
      {
        "version": "1.0.0",
        "changelog": "Initial release:\n- Configurable delay (0-300s)\n- Visual countdown overlay\n- Per-user settings\n- Admin dashboard configuration\n- Play Now and Cancel buttons\n- Responsive design\n- Compatible with Jellyfin 10.11+",
        "targetAbi": "10.11.0.0",
        "sourceUrl": "https://github.com/kazury/Cooldowned/releases/download/v1.0.0/NextEpisodeDelay-v1.0.0.zip",
        "checksum": "GENERATED_ON_RELEASE",
        "timestamp": "2026-02-08T00:00:00Z"
      }
    ]
  }
]
```

### Publier le repository

```bash
git add .
git commit -m "Add Next Episode Delay plugin manifest"
git push origin main
```

**URL du repository :**
```
https://raw.githubusercontent.com/kazury/jellyfin-plugin-repo/main/manifest.json
```

## 🎯 Option 2 : Manifest dans le Repository Principal

Si vous préférez tout garder dans un seul repository :

```bash
cd Cooldowned

# Le manifest.json existe déjà à la racine
# Il sera accessible via :
# https://raw.githubusercontent.com/kazury/Cooldowned/main/manifest.json
```

**Avantage :** Tout est au même endroit
**Inconvénient :** Le manifest mélange code et métadonnées

## 🚀 Processus de Release

### 1. Préparer la release

```bash
# Mettre à jour le changelog
vim CHANGELOG.md

# Mettre à jour la version dans le .csproj si nécessaire
vim Jellyfin.Plugin.NextEpisodeDelay/Jellyfin.Plugin.NextEpisodeDelay.csproj

# Commit les changements
git add .
git commit -m "Prepare release v1.0.0"
git push origin main
```

### 2. Créer le tag

```bash
# Créer et pousser le tag
git tag v1.0.0
git push origin v1.0.0
```

### 3. GitHub Actions automatique

Le workflow `.github/workflows/release.yml` va automatiquement :
- ✅ Compiler le plugin
- ✅ Créer le package ZIP
- ✅ Générer le checksum MD5
- ✅ Créer la release GitHub
- ✅ Upload le fichier ZIP
- ✅ Afficher le checksum dans les logs

### 4. Mettre à jour le manifest

Après la release, récupérez le checksum MD5 depuis :
- GitHub Actions logs
- Ou manuellement : `md5sum NextEpisodeDelay-v1.0.0.zip`

Mettez à jour le `manifest.json` :

```json
{
  "version": "1.0.0",
  "checksum": "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6",  // ← Nouveau checksum
  "sourceUrl": "https://github.com/kazury/Cooldowned/releases/download/v1.0.0/NextEpisodeDelay-v1.0.0.zip",
  "timestamp": "2026-02-08T12:00:00Z"  // ← Date actuelle
}
```

### 5. Publier le manifest

```bash
cd jellyfin-plugin-repo  # ou Cooldowned si Option 2
git add manifest.json
git commit -m "Update manifest for v1.0.0"
git push origin main
```

## 📥 Installation pour les Utilisateurs

### Via Repository Custom (Recommandé)

1. Ouvrir Jellyfin → **Dashboard** → **Plugins** → **Repositories**
2. Cliquer sur **Add Repository** (+)
3. Remplir :
   - **Repository Name:** Next Episode Delay
   - **Repository URL:** `https://raw.githubusercontent.com/kazury/jellyfin-plugin-repo/main/manifest.json`
4. Cliquer **Save**
5. Aller dans **Dashboard** → **Plugins** → **Catalog**
6. Chercher "Next Episode Delay"
7. Cliquer **Install**
8. Redémarrer Jellyfin

### Via Installation Manuelle

1. Télécharger `NextEpisodeDelay-v1.0.0.zip` depuis [Releases](https://github.com/kazury/Cooldowned/releases)
2. Extraire dans `/var/lib/jellyfin/plugins/NextEpisodeDelay/`
3. Redémarrer Jellyfin

## 🔄 Gestion des Versions

### Structure du manifest avec plusieurs versions

```json
{
  "versions": [
    {
      "version": "1.1.0",  // Dernière version (en haut)
      "changelog": "Bug fixes and improvements",
      "targetAbi": "10.11.0.0",
      "sourceUrl": "...",
      "checksum": "...",
      "timestamp": "2026-03-01T00:00:00Z"
    },
    {
      "version": "1.0.0",  // Version précédente
      "changelog": "Initial release",
      "targetAbi": "10.11.0.0",
      "sourceUrl": "...",
      "checksum": "...",
      "timestamp": "2026-02-08T00:00:00Z"
    }
  ]
}
```

**Important :** Toujours placer la **dernière version en premier** dans le tableau.

### Compatibilité avec différentes versions de Jellyfin

Si vous supportez plusieurs versions de Jellyfin :

```
jellyfin-plugin-repo/
├── 10.10/
│   └── manifest.json    # Pour Jellyfin 10.10.x
├── 10.11/
│   └── manifest.json    # Pour Jellyfin 10.11.x
└── manifest.json        # Pointe vers la dernière (10.11)
```

URLs :
- Jellyfin 10.11: `https://raw.githubusercontent.com/kazury/jellyfin-plugin-repo/main/10.11/manifest.json`
- Jellyfin 10.10: `https://raw.githubusercontent.com/kazury/jellyfin-plugin-repo/main/10.10/manifest.json`

## 🛠️ Scripts Utiles

### Générer le checksum manuellement

```bash
./scripts/generate-checksum.sh NextEpisodeDelay-v1.0.0.zip
```

### Release complète avec le script dev-tools

```bash
# Option 1 : Version par défaut (1.0.0)
./dev-tools.sh package

# Option 2 : Version spécifique
./dev-tools.sh package 1.1.0

# Le ZIP est créé : NextEpisodeDelay-v1.1.0.zip
```

### Automatiser la mise à jour du manifest

```bash
#!/bin/bash
VERSION="1.0.0"
ZIP_FILE="NextEpisodeDelay-v${VERSION}.zip"
CHECKSUM=$(md5sum "$ZIP_FILE" | awk '{print $1}')
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)

# Mettre à jour le manifest avec jq (à installer : sudo apt install jq)
jq --arg version "$VERSION" \
   --arg checksum "$CHECKSUM" \
   --arg timestamp "$TIMESTAMP" \
   --arg url "https://github.com/kazury/Cooldowned/releases/download/v${VERSION}/${ZIP_FILE}" \
   '.[0].versions[0].version = $version |
    .[0].versions[0].checksum = $checksum |
    .[0].versions[0].timestamp = $timestamp |
    .[0].versions[0].sourceUrl = $url' \
   manifest.json > manifest.json.tmp && mv manifest.json.tmp manifest.json
```

## 📊 Exemples de Repositories Existants

Pour inspiration :

| Repository | URL | Plugins |
|------------|-----|---------|
| Jellyfin Enhanced | `https://raw.githubusercontent.com/n00bcodr/jellyfin-plugins/main/10.11/manifest.json` | Enhanced, Tweaks, JSInjector |
| Intro Skipper | `https://raw.githubusercontent.com/intro-skipper/jellyfin-plugin-repo/main/manifest.json` | Intro Skipper |
| LizardByte | `https://raw.githubusercontent.com/LizardByte/jellyfin-plugin-repo/main/manifest.json` | Themerr |
| Shemanaev | `https://raw.githubusercontent.com/shemanaev/jellyfin-plugin-repo/main/manifest.json` | MyShows, Webhooks |

## ✅ Checklist de Release

- [ ] Code testé et fonctionnel
- [ ] CHANGELOG.md mis à jour
- [ ] Version incrémentée dans .csproj (si nécessaire)
- [ ] Commit et push sur main
- [ ] Tag créé et poussé
- [ ] GitHub Actions terminé avec succès
- [ ] Checksum MD5 récupéré
- [ ] manifest.json mis à jour avec le checksum
- [ ] manifest.json poussé sur le repository
- [ ] Installation testée via repository custom
- [ ] Annonce sur le forum Jellyfin (optionnel)

## 🔗 Liens Utiles

- [Documentation Jellyfin - Plugins](https://jellyfin.org/docs/general/server/plugins/)
- [GitHub Actions - Create Release](https://github.com/actions/create-release)
- [Jellyfin Plugin Template](https://github.com/jellyfin/jellyfin-plugin-template)
- [Exemple : Jellyfin Enhanced Repo](https://github.com/n00bcodr/jellyfin-plugins)

## 🆘 Dépannage

### Le plugin n'apparaît pas dans le catalog

1. Vérifiez que l'URL du manifest est accessible :
   ```bash
   curl https://raw.githubusercontent.com/kazury/jellyfin-plugin-repo/main/manifest.json
   ```

2. Vérifiez le format JSON :
   ```bash
   cat manifest.json | jq .
   ```

3. Redémarrez Jellyfin après l'ajout du repository

### Erreur de checksum

Le checksum MD5 ne correspond pas au fichier téléchargé :
```bash
# Régénérez le checksum
md5sum NextEpisodeDelay-v1.0.0.zip

# Mettez à jour le manifest.json
```

### Erreur targetAbi

Si l'utilisateur a une version de Jellyfin incompatible :
- Vérifiez que `targetAbi` correspond à la version Jellyfin de l'utilisateur
- Créez plusieurs manifests pour différentes versions si nécessaire

---

**Prêt à publier ?** Suivez le [processus de release](#-processus-de-release) ci-dessus ! 🚀
