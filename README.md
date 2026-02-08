# Jellyfin Plugin: Next Episode Delay

Un plugin Jellyfin qui ajoute un délai configurable avant le lancement automatique de l'épisode suivant, similaire au comportement de Plex.

## ✨ Fonctionnalités

- **Délai personnalisable** : Configurez le délai entre 0 et 300 secondes
- **Overlay visuel élégant** : Countdown animé avec progression circulaire
- **Contrôles utilisateur** :
  - Bouton "Lire maintenant" pour ignorer le délai
  - Bouton "Annuler" pour arrêter l'autoplay
- **Configuration par utilisateur** : Chaque utilisateur peut définir ses préférences
- **Compatible Jellyfin 10.11+** : Utilise EF Core et les dernières API
- **Design non-intrusif** : Interface fluide et compatible avec le thème Jellyfin

## 📋 Prérequis

- **Jellyfin 10.11.0 ou supérieur**
- **.NET 8.0 SDK** (pour la compilation)
- Navigateur web moderne avec support JavaScript

## 🚀 Installation

### Méthode 1 : Installation depuis le dépôt (Recommandé)

1. **Ouvrez Jellyfin Dashboard**
   - Connectez-vous à votre serveur Jellyfin
   - Allez dans `Dashboard` → `Plugins` → `Repositories`

2. **Ajoutez le dépôt du plugin**
   - Cliquez sur le bouton `+` pour ajouter un nouveau dépôt
   - **Repository Name:** `Next Episode Delay`
   - **Repository URL:** `https://raw.githubusercontent.com/kazury/jellyfin-plugin-repo/main/manifest.json`

3. **Installez le plugin**
   - Allez dans `Dashboard` → `Plugins` → `Catalog`
   - Recherchez "Next Episode Delay"
   - Cliquez sur `Install`

4. **Redémarrez Jellyfin**

> **Note :** Le repository peut aussi être accessible via l'URL principale du projet :
> `https://raw.githubusercontent.com/kazury/Cooldowned/main/manifest.json`

### Méthode 2 : Installation manuelle

#### Étape 1 : Compiler le plugin

```bash
# Clonez le dépôt
git clone https://github.com/votre-username/Cooldowned.git
cd Cooldowned/Jellyfin.Plugin.NextEpisodeDelay

# Compilez le projet
dotnet build -c Release

# Ou créez un package
dotnet publish -c Release -o bin/Release/net8.0/publish
```

#### Étape 2 : Copier les fichiers

```bash
# Trouvez le dossier plugins de Jellyfin
# Linux: /var/lib/jellyfin/plugins
# Windows: C:\ProgramData\Jellyfin\Server\plugins
# Docker: /config/plugins

# Créez le dossier du plugin
mkdir -p /var/lib/jellyfin/plugins/NextEpisodeDelay

# Copiez les fichiers compilés
cp -r bin/Release/net8.0/publish/* /var/lib/jellyfin/plugins/NextEpisodeDelay/
```

#### Étape 3 : Installer les fichiers client

Les fichiers client (JavaScript et CSS) sont embarqués dans la DLL, mais pour le développement :

```bash
# Copiez les fichiers web dans le répertoire web de Jellyfin
cp ../web/nextEpisodeDelay.js /var/lib/jellyfin/jellyfin-web/
cp ../web/nextEpisodeDelay.css /var/lib/jellyfin/jellyfin-web/
```

#### Étape 4 : Redémarrer Jellyfin

```bash
# Systemd
sudo systemctl restart jellyfin

# Docker
docker restart jellyfin

# LXC
lxc restart jellyfin
```

## ⚙️ Configuration

### Configuration par défaut (Administrateur)

1. Allez dans `Dashboard` → `Plugins` → `Next Episode Delay`
2. Configurez les paramètres par défaut :
   - **Enable by default** : Activer le délai pour tous les nouveaux utilisateurs
   - **Default delay** : Délai par défaut en secondes (recommandé : 30s)
3. Utilisez les presets rapides : 10s, 30s, 60s, 120s, ou désactivé
4. Cliquez sur `Save`

### Configuration par utilisateur

Les utilisateurs peuvent personnaliser leurs préférences depuis leur profil :

1. Allez dans `Settings` → `Playback`
2. Trouvez la section "Next Episode Delay"
3. Activez/désactivez le délai
4. Ajustez le délai en secondes
5. Sauvegardez

> **Note** : Les paramètres utilisateur remplacent les paramètres par défaut.

## 🎨 Interface utilisateur

Lorsqu'un épisode se termine, l'overlay s'affiche avec :

- **Countdown visuel** : Cercle animé avec temps restant
- **Bouton "Lire maintenant"** : Ignore le délai et lance l'épisode immédiatement
- **Bouton "Annuler"** : Arrête l'autoplay et ferme l'overlay

L'interface est responsive et s'adapte aux écrans mobiles.

## 🏗️ Architecture technique

### Structure du projet

```
Cooldowned/
├── Jellyfin.Plugin.NextEpisodeDelay/    # Plugin serveur C#
│   ├── Api/                              # Endpoints API REST
│   │   └── NextEpisodeDelayController.cs
│   ├── Configuration/                    # Configuration du plugin
│   │   ├── PluginConfiguration.cs
│   │   └── configPage.html
│   ├── Plugin.cs                         # Classe principale du plugin
│   ├── Jellyfin.Plugin.NextEpisodeDelay.csproj
│   └── build.yaml
├── web/                                  # Fichiers client
│   ├── nextEpisodeDelay.js              # Logique overlay/countdown
│   └── nextEpisodeDelay.css             # Styles de l'interface
└── README.md
```

### Composants

#### 1. Plugin serveur (C#)

- **Plugin.cs** : Classe principale héritant de `BasePlugin<PluginConfiguration>`
- **PluginConfiguration.cs** : Modèle de configuration avec support EF Core
- **NextEpisodeDelayController.cs** : API REST pour gérer les préférences
  - `GET /NextEpisodeDelay/Settings/{userId}` : Récupérer les paramètres utilisateur
  - `POST /NextEpisodeDelay/Settings/{userId}` : Mettre à jour les paramètres utilisateur
  - `GET /NextEpisodeDelay/DefaultSettings` : Récupérer les paramètres par défaut (admin)
  - `POST /NextEpisodeDelay/DefaultSettings` : Mettre à jour les paramètres par défaut (admin)

#### 2. Client web (JavaScript/CSS)

- **nextEpisodeDelay.js** :
  - Hook dans les événements de lecture Jellyfin (`playbackstop`)
  - Gestion du countdown et de l'overlay
  - Communication avec l'API pour charger les préférences utilisateur

- **nextEpisodeDelay.css** :
  - Styles de l'overlay avec backdrop blur
  - Animation du countdown circulaire avec SVG
  - Design responsive et accessible

### Flux de fonctionnement

```
1. Episode se termine
   ↓
2. Plugin intercepte l'événement 'playbackstop'
   ↓
3. Vérifie si c'est une série avec épisode suivant
   ↓
4. Charge les préférences utilisateur depuis l'API
   ↓
5. Si délai activé: affiche l'overlay avec countdown
   ↓
6. Utilisateur peut:
   - Attendre la fin du countdown → autoplay
   - Cliquer "Lire maintenant" → lance immédiatement
   - Cliquer "Annuler" → arrête l'autoplay
```

## 🔌 API Endpoints

### GET `/NextEpisodeDelay/Settings/{userId}`

Récupère les paramètres de délai pour un utilisateur spécifique.

**Réponse :**
```json
{
  "enabled": true,
  "delaySeconds": 30
}
```

### POST `/NextEpisodeDelay/Settings/{userId}`

Met à jour les paramètres de délai pour un utilisateur.

**Corps de la requête :**
```json
{
  "enabled": true,
  "delaySeconds": 30
}
```

### GET `/NextEpisodeDelay/DefaultSettings`

Récupère les paramètres par défaut (admin uniquement).

**Réponse :**
```json
{
  "defaultDelaySeconds": 30,
  "enabledByDefault": true
}
```

### POST `/NextEpisodeDelay/DefaultSettings`

Met à jour les paramètres par défaut (admin uniquement).

**Corps de la requête :**
```json
{
  "defaultDelaySeconds": 30,
  "enabledByDefault": true
}
```

## 🛠️ Développement

### Prérequis de développement

- .NET 8.0 SDK
- Visual Studio 2022, VS Code ou Rider
- Node.js (pour les outils de développement web)

### Compiler le projet

```bash
# Mode Debug
dotnet build

# Mode Release
dotnet build -c Release

# Avec tests
dotnet test

# Créer un package NuGet
dotnet pack -c Release
```

### Tester localement

1. Configurez le chemin de sortie vers votre répertoire de plugins Jellyfin
2. Modifiez le `.csproj` pour copier automatiquement :

```xml
<PropertyGroup>
  <JellyfinPluginDir>/var/lib/jellyfin/plugins/NextEpisodeDelay</JellyfinPluginDir>
</PropertyGroup>

<Target Name="CopyToPluginDir" AfterTargets="Build">
  <Copy SourceFiles="$(TargetPath)" DestinationFolder="$(JellyfinPluginDir)" />
</Target>
```

### Debugging JavaScript

Le fichier `nextEpisodeDelay.js` expose un objet `window.NextEpisodeDelay` pour le debugging :

```javascript
// Dans la console du navigateur
NextEpisodeDelay.showOverlay(30);  // Tester l'overlay
NextEpisodeDelay.userSettings();    // Voir les paramètres utilisateur
NextEpisodeDelay.loadUserSettings(); // Recharger les paramètres
```

## 🐛 Dépannage

### Le plugin n'apparaît pas dans la liste

1. Vérifiez que tous les fichiers sont dans le bon répertoire
2. Assurez-vous que Jellyfin a été redémarré
3. Consultez les logs : `/var/log/jellyfin/jellyfin.log`

### L'overlay ne s'affiche pas

1. Ouvrez la console du navigateur (F12)
2. Cherchez les erreurs JavaScript
3. Vérifiez que les fichiers CSS/JS sont chargés
4. Assurez-vous que l'utilisateur a activé le délai dans ses paramètres

### Les paramètres ne se sauvegardent pas

1. Vérifiez les permissions du fichier de configuration
2. Consultez les logs du serveur pour les erreurs API
3. Testez les endpoints API avec curl :

```bash
curl -H "X-Emby-Authorization: YOUR_TOKEN" \
  http://localhost:8096/NextEpisodeDelay/Settings/USER_ID
```

### Le délai ne fonctionne qu'une fois

Cela peut être un conflit avec d'autres plugins (Intro Skipper, etc.). Vérifiez l'ordre de chargement des plugins.

## 🤝 Contribution

Les contributions sont les bienvenues ! Voici comment contribuer :

1. Forkez le projet
2. Créez une branche feature (`git checkout -b feature/AmazingFeature`)
3. Committez vos changements (`git commit -m 'Add some AmazingFeature'`)
4. Pushez vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une Pull Request

### Guidelines

- Suivez les conventions de code C# (.NET)
- Ajoutez des tests unitaires si possible
- Documentez les nouvelles fonctionnalités
- Testez avec Jellyfin 10.11.x

## 📝 Changelog

### Version 1.0.0 (Initial Release)

- ✨ Délai configurable entre 0 et 300 secondes
- 🎨 Overlay avec countdown visuel animé
- 👤 Configuration par utilisateur
- 🔧 Interface d'administration dans le Dashboard
- 📱 Design responsive et accessible
- 🔌 API REST pour gérer les préférences

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 🙏 Remerciements

- L'équipe Jellyfin pour leur excellent serveur média
- La communauté des contributeurs de plugins Jellyfin
- Plex pour l'inspiration du délai avant lecture automatique

## 📞 Support

- **Issues** : [GitHub Issues](https://github.com/votre-username/Cooldowned/issues)
- **Forum Jellyfin** : [Jellyfin Community](https://forum.jellyfin.org/)
- **Documentation Jellyfin** : [Jellyfin Plugin Documentation](https://jellyfin.org/docs/general/server/plugins/)

## 🔗 Liens utiles

- [Documentation Jellyfin Plugin Development](https://jellyfin.org/docs/general/server/plugins/)
- [API Jellyfin](https://api.jellyfin.org/)
- [Repository template officiel](https://github.com/jellyfin/jellyfin-plugin-template)

---

**Fait avec ❤️ pour la communauté Jellyfin**
