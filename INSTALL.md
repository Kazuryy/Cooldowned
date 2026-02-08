# Guide d'installation détaillé - Next Episode Delay

Ce guide vous accompagne pas à pas dans l'installation du plugin Next Episode Delay sur différentes configurations Jellyfin.

## Table des matières

1. [Installation standard (Linux/systemd)](#installation-standard-linuxsystemd)
2. [Installation Docker](#installation-docker)
3. [Installation Proxmox LXC](#installation-proxmox-lxc)
4. [Installation Windows](#installation-windows)
5. [Vérification de l'installation](#vérification-de-linstallation)
6. [Injection des fichiers client](#injection-des-fichiers-client)

---

## Installation standard (Linux/systemd)

### Prérequis

- Jellyfin 10.11.0 ou supérieur installé
- Accès root ou sudo
- .NET 8.0 SDK (pour compiler)

### Étapes

#### 1. Compiler le plugin

```bash
# Installer le SDK .NET 8.0 si nécessaire
sudo apt update
sudo apt install dotnet-sdk-8.0

# Cloner le dépôt
cd /tmp
git clone https://github.com/votre-username/Cooldowned.git
cd Cooldowned/Jellyfin.Plugin.NextEpisodeDelay

# Compiler en Release
dotnet publish -c Release -o ./publish
```

#### 2. Créer le répertoire du plugin

```bash
# Créer le dossier si nécessaire
sudo mkdir -p /var/lib/jellyfin/plugins/NextEpisodeDelay

# Définir les permissions
sudo chown jellyfin:jellyfin /var/lib/jellyfin/plugins/NextEpisodeDelay
```

#### 3. Copier les fichiers

```bash
# Copier la DLL et ses dépendances
sudo cp -r ./publish/* /var/lib/jellyfin/plugins/NextEpisodeDelay/

# Vérifier les permissions
sudo chown -R jellyfin:jellyfin /var/lib/jellyfin/plugins/NextEpisodeDelay
sudo chmod 755 /var/lib/jellyfin/plugins/NextEpisodeDelay
sudo chmod 644 /var/lib/jellyfin/plugins/NextEpisodeDelay/*
```

#### 4. Redémarrer Jellyfin

```bash
sudo systemctl restart jellyfin
sudo systemctl status jellyfin
```

#### 5. Vérifier les logs

```bash
sudo journalctl -u jellyfin -f | grep "NextEpisodeDelay"
# Ou
sudo tail -f /var/log/jellyfin/jellyfin.log | grep "NextEpisodeDelay"
```

---

## Installation Docker

### Docker Compose

#### 1. Arrêter le conteneur

```bash
docker-compose down
```

#### 2. Modifier le volume mount

Ajoutez un volume pour le plugin dans votre `docker-compose.yml` :

```yaml
version: "3"
services:
  jellyfin:
    image: jellyfin/jellyfin:latest
    volumes:
      - /path/to/config:/config
      - /path/to/cache:/cache
      - /path/to/media:/media
      # Ajoutez cette ligne pour le plugin
      - /path/to/Cooldowned/publish:/config/plugins/NextEpisodeDelay:ro
    # ... autres configurations
```

#### 3. Compiler le plugin (sur la machine hôte)

```bash
cd /path/to/Cooldowned/Jellyfin.Plugin.NextEpisodeDelay
dotnet publish -c Release -o ./publish
```

#### 4. Redémarrer le conteneur

```bash
docker-compose up -d
docker-compose logs -f jellyfin
```

### Docker run

```bash
# Arrêter le conteneur
docker stop jellyfin

# Compiler le plugin
cd /path/to/Cooldowned/Jellyfin.Plugin.NextEpisodeDelay
dotnet publish -c Release -o ./publish

# Redémarrer avec le nouveau volume
docker run -d \
  --name jellyfin \
  -v /path/to/config:/config \
  -v /path/to/cache:/cache \
  -v /path/to/media:/media \
  -v /path/to/Cooldowned/publish:/config/plugins/NextEpisodeDelay:ro \
  -p 8096:8096 \
  jellyfin/jellyfin:latest
```

---

## Installation Proxmox LXC

### Méthode 1 : Installation dans le conteneur

#### 1. Entrer dans le conteneur

```bash
pct enter <container-id>
```

#### 2. Installer .NET SDK

```bash
apt update
apt install wget apt-transport-https

# Ajouter le dépôt Microsoft
wget https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

apt update
apt install dotnet-sdk-8.0
```

#### 3. Compiler et installer

```bash
cd /tmp
git clone https://github.com/votre-username/Cooldowned.git
cd Cooldowned/Jellyfin.Plugin.NextEpisodeDelay

dotnet publish -c Release -o /var/lib/jellyfin/plugins/NextEpisodeDelay

chown -R jellyfin:jellyfin /var/lib/jellyfin/plugins/NextEpisodeDelay
systemctl restart jellyfin
```

### Méthode 2 : Build sur l'hôte, copie dans le LXC

#### 1. Compiler sur l'hôte Proxmox

```bash
cd /tmp
git clone https://github.com/votre-username/Cooldowned.git
cd Cooldowned/Jellyfin.Plugin.NextEpisodeDelay

dotnet publish -c Release -o ./publish
```

#### 2. Copier dans le conteneur

```bash
# Depuis l'hôte Proxmox
pct push <container-id> ./publish /tmp/plugin -perms 755

# Entrer dans le conteneur
pct enter <container-id>

# Dans le conteneur
mkdir -p /var/lib/jellyfin/plugins/NextEpisodeDelay
cp -r /tmp/plugin/* /var/lib/jellyfin/plugins/NextEpisodeDelay/
chown -R jellyfin:jellyfin /var/lib/jellyfin/plugins/NextEpisodeDelay
systemctl restart jellyfin
```

---

## Installation Windows

### Étapes

#### 1. Installer .NET SDK

Téléchargez et installez le [.NET 8.0 SDK](https://dotnet.microsoft.com/download/dotnet/8.0)

#### 2. Compiler le plugin

Ouvrez PowerShell en tant qu'administrateur :

```powershell
# Cloner le dépôt
cd $env:TEMP
git clone https://github.com/votre-username/Cooldowned.git
cd Cooldowned\Jellyfin.Plugin.NextEpisodeDelay

# Compiler
dotnet publish -c Release -o .\publish
```

#### 3. Copier les fichiers

```powershell
# Créer le dossier du plugin
$pluginDir = "$env:ProgramData\Jellyfin\Server\plugins\NextEpisodeDelay"
New-Item -ItemType Directory -Path $pluginDir -Force

# Copier les fichiers
Copy-Item -Path ".\publish\*" -Destination $pluginDir -Recurse -Force
```

#### 4. Redémarrer le service Jellyfin

```powershell
# Via PowerShell
Restart-Service JellyfinServer

# Ou via l'interface graphique
# Services → Jellyfin Server → Redémarrer
```

---

## Vérification de l'installation

### 1. Vérifier dans le Dashboard

1. Connectez-vous à Jellyfin (http://localhost:8096)
2. Allez dans `Dashboard` → `Plugins`
3. Le plugin "Next Episode Delay" devrait apparaître dans la liste
4. Vérifiez que la version est bien `1.0.0`

### 2. Vérifier les logs

**Linux :**
```bash
sudo tail -f /var/log/jellyfin/jellyfin.log | grep -i "nextepisode"
```

**Docker :**
```bash
docker logs -f jellyfin 2>&1 | grep -i "nextepisode"
```

**Windows :**
```
C:\ProgramData\Jellyfin\Server\log\jellyfin.log
```

Recherchez des lignes comme :
```
[INF] Loaded plugin: Next Episode Delay 1.0.0
[INF] Plugin NextEpisodeDelay initialized successfully
```

### 3. Tester l'API

```bash
# Remplacez USER_ID et AUTH_TOKEN par vos valeurs
curl -H "X-Emby-Authorization: YOUR_AUTH_TOKEN" \
  http://localhost:8096/NextEpisodeDelay/Settings/USER_ID
```

Vous devriez recevoir une réponse JSON :
```json
{
  "enabled": true,
  "delaySeconds": 30
}
```

---

## Injection des fichiers client

### Méthode automatique (Embedded Resources)

Les fichiers JavaScript et CSS sont automatiquement embarqués dans la DLL du plugin. Jellyfin les chargera automatiquement.

Aucune action manuelle n'est nécessaire.

### Méthode manuelle (Développement)

Pour le développement et les tests :

**Linux :**
```bash
# Copier les fichiers web
sudo cp web/nextEpisodeDelay.js /usr/share/jellyfin/web/
sudo cp web/nextEpisodeDelay.css /usr/share/jellyfin/web/

# Ou dans le répertoire utilisateur
sudo cp web/nextEpisodeDelay.js /var/lib/jellyfin/jellyfin-web/
sudo cp web/nextEpisodeDelay.css /var/lib/jellyfin/jellyfin-web/
```

**Docker :**
```bash
docker cp web/nextEpisodeDelay.js jellyfin:/jellyfin/jellyfin-web/
docker cp web/nextEpisodeDelay.css jellyfin:/jellyfin/jellyfin-web/
```

**Windows :**
```powershell
Copy-Item web\nextEpisodeDelay.js "C:\Program Files\Jellyfin\Server\jellyfin-web\"
Copy-Item web\nextEpisodeDelay.css "C:\Program Files\Jellyfin\Server\jellyfin-web\"
```

---

## Problèmes courants

### Plugin non chargé

**Symptôme :** Le plugin n'apparaît pas dans la liste

**Solution :**
```bash
# Vérifier les permissions
ls -la /var/lib/jellyfin/plugins/NextEpisodeDelay

# Devrait être : -rw-r--r-- jellyfin jellyfin

# Corriger si nécessaire
sudo chown -R jellyfin:jellyfin /var/lib/jellyfin/plugins/NextEpisodeDelay
sudo chmod 755 /var/lib/jellyfin/plugins/NextEpisodeDelay
sudo chmod 644 /var/lib/jellyfin/plugins/NextEpisodeDelay/*
```

### Erreur de dépendance .NET

**Symptôme :** Erreur dans les logs à propos de version .NET

**Solution :**
```bash
# Vérifier la version installée
dotnet --list-runtimes

# Devrait inclure : Microsoft.AspNetCore.App 8.0.x

# Installer si manquant
sudo apt install aspnetcore-runtime-8.0
```

### Fichiers JavaScript non chargés

**Symptôme :** L'overlay ne s'affiche pas

**Solution :**
1. Ouvrez la console du navigateur (F12)
2. Vérifiez l'onglet "Réseau"
3. Cherchez les erreurs 404 pour `nextEpisodeDelay.js` ou `.css`
4. Vérifiez que les fichiers sont bien dans le dossier web de Jellyfin

### Port binding error (Docker)

**Symptôme :** Le conteneur ne démarre pas avec erreur de port

**Solution :**
```bash
# Vérifier si le port est utilisé
sudo netstat -tlnp | grep 8096

# Arrêter le processus conflictuel
sudo systemctl stop jellyfin  # Si version native installée

# Ou changer le port dans docker-compose.yml
ports:
  - "8097:8096"  # Utiliser 8097 sur l'hôte
```

---

## Mise à jour du plugin

### Mise à jour manuelle

```bash
# Sauvegarder la configuration actuelle
sudo cp -r /var/lib/jellyfin/plugins/NextEpisodeDelay /tmp/backup-plugin

# Compiler la nouvelle version
cd /path/to/Cooldowned/Jellyfin.Plugin.NextEpisodeDelay
git pull
dotnet publish -c Release -o ./publish

# Remplacer les fichiers
sudo rm -rf /var/lib/jellyfin/plugins/NextEpisodeDelay/*
sudo cp -r ./publish/* /var/lib/jellyfin/plugins/NextEpisodeDelay/
sudo chown -R jellyfin:jellyfin /var/lib/jellyfin/plugins/NextEpisodeDelay

# Redémarrer
sudo systemctl restart jellyfin
```

### Retour à la version précédente

```bash
# Restaurer depuis la sauvegarde
sudo rm -rf /var/lib/jellyfin/plugins/NextEpisodeDelay
sudo cp -r /tmp/backup-plugin /var/lib/jellyfin/plugins/NextEpisodeDelay
sudo systemctl restart jellyfin
```

---

## Désinstallation

### Désinstallation complète

**Linux :**
```bash
# Arrêter Jellyfin
sudo systemctl stop jellyfin

# Supprimer le plugin
sudo rm -rf /var/lib/jellyfin/plugins/NextEpisodeDelay

# Supprimer la configuration (optionnel)
sudo rm -f /var/lib/jellyfin/config/plugins/Next\ Episode\ Delay.xml

# Redémarrer
sudo systemctl start jellyfin
```

**Docker :**
```bash
docker-compose down

# Retirer le volume mount du plugin dans docker-compose.yml
# Puis redémarrer

docker-compose up -d
```

**Windows :**
```powershell
# Arrêter le service
Stop-Service JellyfinServer

# Supprimer le dossier
Remove-Item -Path "$env:ProgramData\Jellyfin\Server\plugins\NextEpisodeDelay" -Recurse -Force

# Redémarrer
Start-Service JellyfinServer
```

---

## Support

Si vous rencontrez des problèmes d'installation :

1. Consultez les logs : `/var/log/jellyfin/jellyfin.log`
2. Vérifiez la configuration : `/var/lib/jellyfin/config/plugins/`
3. Ouvrez une issue sur GitHub avec :
   - Version de Jellyfin
   - Système d'exploitation
   - Logs complets de l'erreur
   - Étapes pour reproduire

---

**Installation réussie ? Passez à la [configuration du plugin](README.md#⚙️-configuration) !**
