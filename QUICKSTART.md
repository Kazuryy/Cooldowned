# Quick Start Guide - Next Episode Delay

Guide rapide pour démarrer avec le plugin Next Episode Delay en 5 minutes.

## 🚀 Installation rapide

### Linux (systemd)

```bash
# 1. Cloner et compiler
git clone https://github.com/kazury/Cooldowned.git
cd Cooldowned/Jellyfin.Plugin.NextEpisodeDelay
dotnet publish -c Release -o ./publish

# 2. Installer
sudo mkdir -p /var/lib/jellyfin/plugins/NextEpisodeDelay
sudo cp -r ./publish/* /var/lib/jellyfin/plugins/NextEpisodeDelay/
sudo chown -R jellyfin:jellyfin /var/lib/jellyfin/plugins/NextEpisodeDelay

# 3. Redémarrer
sudo systemctl restart jellyfin
```

### Docker

```bash
# 1. Cloner et compiler
git clone https://github.com/kazury/Cooldowned.git
cd Cooldowned/Jellyfin.Plugin.NextEpisodeDelay
dotnet publish -c Release -o ./publish

# 2. Monter le volume dans docker-compose.yml
# volumes:
#   - ./publish:/config/plugins/NextEpisodeDelay:ro

# 3. Redémarrer
docker-compose restart jellyfin
```

## ⚙️ Configuration rapide

### Configuration par défaut (Admin)

1. Ouvrez Jellyfin → `Dashboard` → `Plugins` → `Next Episode Delay`
2. Définissez le délai par défaut : **30 secondes** (recommandé)
3. Cochez "Enable by default"
4. Sauvegardez

### Configuration utilisateur

Les utilisateurs peuvent personnaliser depuis leur profil :
1. `Settings` → `Playback` → `Next Episode Delay`
2. Activez/désactivez selon les préférences
3. Ajustez le délai (10s, 30s, 60s, 120s, ou désactivé)

## 🎬 Utilisation

### Comment ça marche ?

1. **Lancez une série** : Regardez un épisode de votre série préférée
2. **Fin de l'épisode** : L'overlay de countdown s'affiche automatiquement
3. **Choisissez** :
   - Attendez le countdown → L'épisode suivant démarre automatiquement
   - Cliquez "Play Now" → Lance immédiatement l'épisode suivant
   - Cliquez "Cancel" → Arrête l'autoplay et ferme l'overlay

### Exemple visuel

```
┌────────────────────────────────────┐
│        Next Episode                │
│                                    │
│         ⭕ 30                      │
│    (countdown circulaire)          │
│                                    │
│   Playing in 30 seconds...         │
│                                    │
│  [▶ Play Now]  [✕ Cancel]         │
└────────────────────────────────────┘
```

## 🔧 Paramètres disponibles

| Paramètre | Valeurs | Par défaut | Description |
|-----------|---------|------------|-------------|
| Enabled | true/false | true | Activer/désactiver le délai |
| Delay | 0-300s | 30s | Durée du délai en secondes |
| Presets | 10s, 30s, 60s, 120s | 30s | Valeurs prédéfinies rapides |

## 🎨 Personnalisation

### Modifier les presets

Éditez [configPage.html](Jellyfin.Plugin.NextEpisodeDelay/Configuration/configPage.html) :

```html
<option value="10">10 secondes</option>
<option value="20">20 secondes</option>
<option value="30" selected>30 secondes (Recommended)</option>
<option value="45">45 secondes</option>
<option value="60">60 secondes</option>
<option value="90">90 secondes</option>
<option value="120">120 secondes</option>
```

### Modifier le style de l'overlay

Éditez [nextEpisodeDelay.css](web/nextEpisodeDelay.css) :

```css
/* Changer la couleur du countdown */
.nextEpisodeDelay-countdown-progress {
    stroke: #00a4dc; /* Couleur Jellyfin */
    /* stroke: #ff6b6b; Rouge */
    /* stroke: #4ecdc4; Turquoise */
}

/* Changer l'opacité du fond */
.nextEpisodeDelay-overlay {
    background: rgba(0, 0, 0, 0.85); /* 85% opaque */
}
```

## 🐛 Dépannage rapide

### Le plugin n'apparaît pas

```bash
# Vérifier les logs
sudo tail -f /var/log/jellyfin/jellyfin.log | grep -i nextepisode

# Vérifier les fichiers
ls -la /var/lib/jellyfin/plugins/NextEpisodeDelay

# Vérifier les permissions
sudo chown -R jellyfin:jellyfin /var/lib/jellyfin/plugins/NextEpisodeDelay
```

### L'overlay ne s'affiche pas

1. Ouvrez la console du navigateur (F12)
2. Cherchez les erreurs JavaScript
3. Vérifiez que le délai est activé dans vos paramètres
4. Testez avec : `NextEpisodeDelay.showOverlay(30)`

### Les paramètres ne se sauvegardent pas

```bash
# Vérifier l'API
curl http://localhost:8096/NextEpisodeDelay/DefaultSettings

# Vérifier le fichier de configuration
cat /var/lib/jellyfin/config/plugins/Next\ Episode\ Delay.xml
```

## 📊 Tester l'API

### Récupérer les paramètres par défaut

```bash
curl -X GET "http://localhost:8096/NextEpisodeDelay/DefaultSettings" \
  -H "X-Emby-Authorization: YOUR_TOKEN"
```

### Mettre à jour les paramètres utilisateur

```bash
curl -X POST "http://localhost:8096/NextEpisodeDelay/Settings/USER_ID" \
  -H "Content-Type: application/json" \
  -H "X-Emby-Authorization: YOUR_TOKEN" \
  -d '{"enabled": true, "delaySeconds": 30}'
```

## 🔗 Ressources utiles

- 📚 [README complet](README.md) - Documentation complète
- 🛠️ [Guide d'installation détaillé](INSTALL.md) - Instructions pas à pas
- 🤝 [Guide de contribution](CONTRIBUTING.md) - Contribuer au projet
- 📝 [Changelog](CHANGELOG.md) - Historique des versions
- 🐛 [Signaler un bug](https://github.com/kazury/Cooldowned/issues/new?template=bug_report.md)
- ✨ [Proposer une feature](https://github.com/kazury/Cooldowned/issues/new?template=feature_request.md)

## 💡 Astuces

### Désactiver temporairement le plugin

Sans désinstaller :

```bash
# Renommer le dossier
sudo mv /var/lib/jellyfin/plugins/NextEpisodeDelay \
        /var/lib/jellyfin/plugins/NextEpisodeDelay.disabled

# Redémarrer
sudo systemctl restart jellyfin

# Pour réactiver
sudo mv /var/lib/jellyfin/plugins/NextEpisodeDelay.disabled \
        /var/lib/jellyfin/plugins/NextEpisodeDelay
```

### Mode développement

Compiler automatiquement à chaque modification :

```bash
# Avec dotnet watch
cd Jellyfin.Plugin.NextEpisodeDelay
dotnet watch build

# Ou avec un script
while inotifywait -e modify *.cs; do
    dotnet build
    sudo cp bin/Debug/net9.0/* /var/lib/jellyfin/plugins/NextEpisodeDelay/
    sudo systemctl restart jellyfin
done
```

### Logs en temps réel

```bash
# Logs Jellyfin + plugin
sudo journalctl -u jellyfin -f | grep -i "nextepisode\|plugin"

# Avec couleurs
sudo journalctl -u jellyfin -f | grep --color -i "nextepisode\|plugin\|error"
```

## 🎯 Cas d'usage courants

### Scenario 1 : Regarder une série en binge-watching

**Besoin** : Délai court pour continuer rapidement

**Configuration** :
- Délai : 10-15 secondes
- Enabled : Oui

### Scenario 2 : Regarder avant de dormir

**Besoin** : Délai long pour pouvoir arrêter facilement

**Configuration** :
- Délai : 60-120 secondes
- Enabled : Oui

### Scenario 3 : Contrôle total

**Besoin** : Pas d'autoplay automatique

**Configuration** :
- Enabled : Non
- Ou Délai : 0 secondes

## 📱 Support multi-appareil

| Appareil | Support | Notes |
|----------|---------|-------|
| Desktop | ✅ Full | Toutes fonctionnalités |
| Mobile | ✅ Full | Design responsive |
| Tablet | ✅ Full | Interface adaptée |
| Smart TV | ⚠️ Partiel | Dépend du navigateur |
| Apps mobiles | ❌ Non | Client web uniquement |

## 🚦 Prochaines étapes

1. ✅ Installez le plugin
2. ✅ Configurez les paramètres par défaut
3. ✅ Testez avec une série
4. 📊 Donnez votre feedback
5. ⭐ Mettez une étoile sur GitHub !

---

**Besoin d'aide ?** Consultez le [README complet](README.md) ou ouvrez une [issue](https://github.com/kazury/Cooldowned/issues).

**Vous aimez le plugin ?** Partagez-le avec la communauté Jellyfin ! 🎉
