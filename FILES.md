# Index des fichiers du projet

Ce document liste tous les fichiers du projet Next Episode Delay avec leur description et leur rôle.

## 📁 Structure du projet

```
Cooldowned/
├── .github/                            # Configuration GitHub
│   ├── ISSUE_TEMPLATE/                 # Templates pour les issues
│   │   ├── bug_report.md               # Template de rapport de bug
│   │   └── feature_request.md          # Template de demande de fonctionnalité
│   ├── workflows/                      # GitHub Actions workflows
│   │   └── build.yml                   # Workflow CI/CD automatique
│   └── pull_request_template.md        # Template de Pull Request
│
├── Jellyfin.Plugin.NextEpisodeDelay/   # Plugin serveur (C#)
│   ├── Api/                            # Controllers API REST
│   │   └── NextEpisodeDelayController.cs  # Endpoints API
│   ├── Configuration/                  # Configuration du plugin
│   │   ├── configPage.html             # Page de configuration admin
│   │   └── PluginConfiguration.cs      # Modèle de configuration
│   ├── build.yaml                      # Configuration de build Jellyfin
│   ├── Jellyfin.Plugin.NextEpisodeDelay.csproj  # Fichier projet .NET
│   └── Plugin.cs                       # Classe principale du plugin
│
├── web/                                # Fichiers client (JavaScript/CSS)
│   ├── nextEpisodeDelay.css            # Styles de l'overlay
│   └── nextEpisodeDelay.js             # Logique client
│
├── ARCHITECTURE.md                     # Documentation d'architecture
├── CHANGELOG.md                        # Historique des changements
├── CONTRIBUTING.md                     # Guide de contribution
├── dev-tools.sh                        # Script d'aide au développement
├── .editorconfig                       # Configuration de style de code
├── .gitignore                          # Fichiers ignorés par Git
├── INSTALL.md                          # Guide d'installation détaillé
├── Jellyfin.Plugin.NextEpisodeDelay.sln  # Solution Visual Studio
├── LICENSE                             # Licence MIT
├── manifest.json                       # Manifest pour repository Jellyfin
├── QUICKSTART.md                       # Guide de démarrage rapide
├── README.md                           # Documentation principale
└── FILES.md                            # Ce fichier
```

---

## 📄 Description détaillée des fichiers

### Racine du projet

| Fichier | Type | Description |
|---------|------|-------------|
| [README.md](README.md) | Documentation | Documentation principale du projet avec présentation, fonctionnalités, installation et configuration |
| [QUICKSTART.md](QUICKSTART.md) | Documentation | Guide rapide pour démarrer en 5 minutes |
| [INSTALL.md](INSTALL.md) | Documentation | Guide d'installation détaillé pour toutes les plateformes (Linux, Docker, Windows, Proxmox) |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Documentation | Documentation technique de l'architecture, flux de données et composants |
| [CONTRIBUTING.md](CONTRIBUTING.md) | Documentation | Guide de contribution avec standards de code et process de PR |
| [CHANGELOG.md](CHANGELOG.md) | Documentation | Historique des versions et changements |
| [FILES.md](FILES.md) | Documentation | Ce fichier - Index de tous les fichiers du projet |
| [LICENSE](LICENSE) | Légal | Licence MIT du projet |
| [manifest.json](manifest.json) | Configuration | Manifest pour le repository de plugins Jellyfin |
| [.gitignore](.gitignore) | Configuration | Fichiers et dossiers ignorés par Git |
| [.editorconfig](.editorconfig) | Configuration | Configuration de style de code pour les éditeurs |
| [dev-tools.sh](dev-tools.sh) | Script | Script bash pour faciliter le développement (build, install, logs, etc.) |
| [Jellyfin.Plugin.NextEpisodeDelay.sln](Jellyfin.Plugin.NextEpisodeDelay.sln) | Solution | Fichier solution Visual Studio pour ouvrir le projet |

### Plugin serveur (C#)

#### Jellyfin.Plugin.NextEpisodeDelay/

| Fichier | Lignes | Description |
|---------|--------|-------------|
| [Plugin.cs](Jellyfin.Plugin.NextEpisodeDelay/Plugin.cs) | ~50 | Classe principale du plugin héritant de BasePlugin. Point d'entrée, singleton, et pages de configuration |
| [Jellyfin.Plugin.NextEpisodeDelay.csproj](Jellyfin.Plugin.NextEpisodeDelay/Jellyfin.Plugin.NextEpisodeDelay.csproj) | ~30 | Fichier projet .NET définissant les dépendances, le framework cible et les ressources embarquées |
| [build.yaml](Jellyfin.Plugin.NextEpisodeDelay/build.yaml) | ~20 | Configuration de build pour le système de plugins Jellyfin |

#### Jellyfin.Plugin.NextEpisodeDelay/Api/

| Fichier | Lignes | Description |
|---------|--------|-------------|
| [NextEpisodeDelayController.cs](Jellyfin.Plugin.NextEpisodeDelay/Api/NextEpisodeDelayController.cs) | ~180 | Controller API REST avec 4 endpoints pour gérer les paramètres utilisateur et par défaut. Inclut validation et autorisation |

**Endpoints fournis :**
- `GET /NextEpisodeDelay/Settings/{userId}` - Récupérer paramètres utilisateur
- `POST /NextEpisodeDelay/Settings/{userId}` - Mettre à jour paramètres utilisateur
- `GET /NextEpisodeDelay/DefaultSettings` - Récupérer paramètres par défaut (admin)
- `POST /NextEpisodeDelay/DefaultSettings` - Mettre à jour paramètres par défaut (admin)

#### Jellyfin.Plugin.NextEpisodeDelay/Configuration/

| Fichier | Lignes | Description |
|---------|--------|-------------|
| [PluginConfiguration.cs](Jellyfin.Plugin.NextEpisodeDelay/Configuration/PluginConfiguration.cs) | ~50 | Modèle de données pour la configuration avec paramètres par défaut et paramètres par utilisateur. Sérialisé en XML par Jellyfin |
| [configPage.html](Jellyfin.Plugin.NextEpisodeDelay/Configuration/configPage.html) | ~120 | Page HTML de configuration dans le dashboard admin. Interface pour modifier les paramètres par défaut avec presets rapides |

### Client web (JavaScript/CSS)

#### web/

| Fichier | Lignes | Description |
|---------|--------|-------------|
| [nextEpisodeDelay.js](web/nextEpisodeDelay.js) | ~250 | Script JavaScript principal qui gère l'overlay, le countdown, les événements de lecture et la communication avec l'API |
| [nextEpisodeDelay.css](web/nextEpisodeDelay.css) | ~250 | Feuille de styles pour l'overlay avec animations, countdown SVG et design responsive. Compatible avec le thème Jellyfin |

**Fonctionnalités JavaScript :**
- Hook dans les événements Jellyfin (`playbackstop`)
- Gestion du countdown circulaire avec SVG
- API calls pour charger les paramètres utilisateur
- Boutons Play Now et Cancel
- Mode debug avec `window.NextEpisodeDelay`

**Fonctionnalités CSS :**
- Overlay avec backdrop blur
- Countdown circulaire animé (SVG)
- Animations fluides (transitions, pulse)
- Design responsive (mobile/desktop)
- Thème compatible (dark mode)

### Configuration GitHub

#### .github/

| Fichier | Description |
|---------|-------------|
| [ISSUE_TEMPLATE/bug_report.md](.github/ISSUE_TEMPLATE/bug_report.md) | Template structuré pour les rapports de bugs avec checklist |
| [ISSUE_TEMPLATE/feature_request.md](.github/ISSUE_TEMPLATE/feature_request.md) | Template pour les demandes de fonctionnalités |
| [pull_request_template.md](.github/pull_request_template.md) | Template pour les Pull Requests avec checklist de validation |
| [workflows/build.yml](.github/workflows/build.yml) | GitHub Actions workflow pour CI/CD automatique (build, test, release) |

**Workflow CI/CD :**
- Build automatique sur push/PR
- Tests (quand disponibles)
- Création de packages pour les releases
- Upload automatique vers GitHub Releases

---

## 🔧 Fichiers de configuration

### .editorconfig

Configuration pour maintenir un style de code cohérent :
- **C#** : indent_size=4, spaces
- **JavaScript/CSS** : indent_size=4, spaces
- **XML** : indent_size=2, spaces
- **YAML** : indent_size=2, spaces
- Trim trailing whitespace
- Insert final newline

### .gitignore

Fichiers et dossiers exclus du contrôle de version :
- Build artifacts (bin/, obj/, publish/)
- IDE files (.vs/, .vscode/, *.suo)
- NuGet packages
- OS files (.DS_Store, Thumbs.db)
- Compiled files (*.dll, *.exe, *.pdb)

### manifest.json

Manifest pour le repository de plugins Jellyfin :
- GUID du plugin
- Informations de version
- Changelog
- Liens de téléchargement
- Compatible Jellyfin 10.11+

---

## 📊 Statistiques du projet

### Lignes de code

| Langage | Fichiers | Lignes (approx.) |
|---------|----------|------------------|
| C# | 3 | ~280 |
| JavaScript | 1 | ~250 |
| CSS | 1 | ~250 |
| HTML | 1 | ~120 |
| **Total code** | **6** | **~900** |

### Documentation

| Type | Fichiers | Lignes (approx.) |
|------|----------|------------------|
| Markdown | 9 | ~3000 |
| YAML | 2 | ~50 |
| Shell | 1 | ~350 |
| **Total docs** | **12** | **~3400** |

### Total général

- **24 fichiers**
- **~4300 lignes**
- **8 répertoires**

---

## 🎯 Fichiers par fonctionnalité

### Configuration et paramètres

```
Jellyfin.Plugin.NextEpisodeDelay/Configuration/
├── PluginConfiguration.cs      # Modèle de données
└── configPage.html             # Interface admin
```

### API REST

```
Jellyfin.Plugin.NextEpisodeDelay/Api/
└── NextEpisodeDelayController.cs  # Tous les endpoints
```

### Interface utilisateur

```
web/
├── nextEpisodeDelay.js         # Logique overlay/countdown
└── nextEpisodeDelay.css        # Styles
```

### Documentation

```
./
├── README.md                   # Doc principale
├── QUICKSTART.md               # Démarrage rapide
├── INSTALL.md                  # Installation détaillée
├── ARCHITECTURE.md             # Architecture technique
├── CONTRIBUTING.md             # Contribution
├── CHANGELOG.md                # Versions
└── FILES.md                    # Index des fichiers
```

### Développement

```
./
├── dev-tools.sh                # Script d'aide
├── .editorconfig               # Style de code
├── .gitignore                  # Git exclusions
└── Jellyfin.Plugin.NextEpisodeDelay.sln  # Solution VS
```

### CI/CD

```
.github/
├── workflows/build.yml         # GitHub Actions
├── pull_request_template.md    # Template PR
└── ISSUE_TEMPLATE/             # Templates issues
```

---

## 🔍 Fichiers par rôle

### Administrateur Jellyfin

Fichiers importants :
1. [README.md](README.md) - Vue d'ensemble
2. [INSTALL.md](INSTALL.md) - Installation
3. [QUICKSTART.md](QUICKSTART.md) - Démarrage rapide
4. [configPage.html](Jellyfin.Plugin.NextEpisodeDelay/Configuration/configPage.html) - Configuration

### Développeur

Fichiers importants :
1. [ARCHITECTURE.md](ARCHITECTURE.md) - Architecture technique
2. [CONTRIBUTING.md](CONTRIBUTING.md) - Guide de contribution
3. [dev-tools.sh](dev-tools.sh) - Outils de développement
4. [Plugin.cs](Jellyfin.Plugin.NextEpisodeDelay/Plugin.cs) - Point d'entrée
5. [NextEpisodeDelayController.cs](Jellyfin.Plugin.NextEpisodeDelay/Api/NextEpisodeDelayController.cs) - API
6. [nextEpisodeDelay.js](web/nextEpisodeDelay.js) - Client

### Utilisateur final

Fichiers visibles :
1. Page de configuration dans Dashboard
2. Overlay pendant la lecture
3. (Aucune interaction directe avec les fichiers du projet)

---

## 📝 Notes de maintenance

### Fichiers à mettre à jour lors d'une nouvelle version

1. [CHANGELOG.md](CHANGELOG.md) - Ajouter l'entrée de version
2. [manifest.json](manifest.json) - Mettre à jour la version et le changelog
3. [Plugin.cs](Jellyfin.Plugin.NextEpisodeDelay/Plugin.cs) - Incrémenter AssemblyVersion (dans .csproj)
4. [README.md](README.md) - Mettre à jour les badges et notes de version
5. [build.yaml](Jellyfin.Plugin.NextEpisodeDelay/build.yaml) - Mettre à jour la version

### Fichiers à vérifier lors d'un changement de dépendances

1. [Jellyfin.Plugin.NextEpisodeDelay.csproj](Jellyfin.Plugin.NextEpisodeDelay/Jellyfin.Plugin.NextEpisodeDelay.csproj) - PackageReference
2. [build.yaml](Jellyfin.Plugin.NextEpisodeDelay/build.yaml) - targetAbi
3. [manifest.json](manifest.json) - targetAbi

### Fichiers de test (à ajouter)

Fichiers manquants pour une couverture complète :
- [ ] Tests unitaires (xUnit)
- [ ] Tests d'intégration
- [ ] Tests E2E
- [ ] Benchmarks de performance

---

## 🔗 Liens entre fichiers

### Dépendances principales

```
Plugin.cs
  ├─→ PluginConfiguration.cs (modèle)
  ├─→ configPage.html (page admin)
  └─→ NextEpisodeDelayController.cs (API)

NextEpisodeDelayController.cs
  └─→ PluginConfiguration.cs (lecture/écriture config)

configPage.html
  └─→ NextEpisodeDelayController.cs (via API)
      (ou via ApiClient.updatePluginConfiguration)

nextEpisodeDelay.js
  └─→ NextEpisodeDelayController.cs (fetch API)
```

### Ressources embarquées

```
Jellyfin.Plugin.NextEpisodeDelay.csproj
  ├─→ web/nextEpisodeDelay.js (EmbeddedResource)
  └─→ web/nextEpisodeDelay.css (EmbeddedResource)
```

---

## ✅ Checklist de complétion

- [x] Plugin serveur C# complet
- [x] Configuration et API REST
- [x] Client JavaScript avec overlay
- [x] Styles CSS responsive
- [x] Documentation complète
- [x] Guides d'installation
- [x] Guide de contribution
- [x] Templates GitHub
- [x] CI/CD workflow
- [x] Script d'outils de développement
- [x] Licence
- [x] Manifest pour repository

---

**Dernière mise à jour :** 2026-02-08
**Version du projet :** 1.0.0
**Total de fichiers :** 24
