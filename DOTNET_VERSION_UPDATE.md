# Mise à jour .NET 8.0 → 9.0

## ⚠️ Changement Important

Jellyfin 10.11+ utilise **.NET 9.0**, pas .NET 8.0 !

## ✅ Fichiers mis à jour

### Code source
- [x] `Jellyfin.Plugin.NextEpisodeDelay.csproj` - `net8.0` → `net9.0`
- [x] `build.yaml` - `framework: net9.0`

### GitHub Actions
- [x] `.github/workflows/build.yml` - `dotnet-version: 9.0.x`
- [x] `.github/workflows/release.yml` - `dotnet-version: 9.0.x`

### Documentation
- [x] `README.md` - Toutes les références à .NET 8.0
- [x] `INSTALL.md` - SDK et runtime 9.0
- [x] `CONTRIBUTING.md` - Version SDK
- [x] `QUICKSTART.md` - Chemins net9.0
- [x] `CHANGELOG.md` - Description technique
- [x] `ARCHITECTURE.md` - Liens documentation

## 📝 Pourquoi ce changement ?

Jellyfin 10.11.x utilise .NET 9.0 :
```
Package Jellyfin.Controller 10.11.6 supports: net9.0
Package Jellyfin.Model 10.11.6 supports: net9.0
```

## 🚀 Pour compiler maintenant

### Installation du SDK

**Linux :**
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install dotnet-sdk-9.0
```

**Docker :**
```dockerfile
FROM mcr.microsoft.com/dotnet/sdk:9.0
```

**Verification :**
```bash
dotnet --version  # Devrait afficher 9.0.x
```

### Compilation

```bash
cd Jellyfin.Plugin.NextEpisodeDelay
dotnet restore  # Devrait maintenant fonctionner !
dotnet build -c Release
```

## 🔍 Vérification

```bash
# Vérifier que tous les fichiers sont à jour
grep -r "net8\|8\.0" --include="*.cs" --include="*.csproj" --include="*.yml" --include="*.yaml"
# Ne devrait rien retourner
```

## ✅ GitHub Actions

Le prochain push va maintenant :
1. Utiliser .NET 9.0 SDK
2. Compiler sans erreur
3. Créer les releases correctement

---

**Date de mise à jour :** 2026-02-08
**Raison :** Compatibilité Jellyfin 10.11+
