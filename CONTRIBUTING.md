# Guide de contribution - Next Episode Delay

Merci de votre intérêt pour contribuer au plugin Next Episode Delay ! Ce document vous guide pour contribuer efficacement au projet.

## Table des matières

- [Code de conduite](#code-de-conduite)
- [Comment contribuer](#comment-contribuer)
- [Configuration de l'environnement de développement](#configuration-de-lenvironnement-de-développement)
- [Standards de code](#standards-de-code)
- [Process de Pull Request](#process-de-pull-request)
- [Rapporter des bugs](#rapporter-des-bugs)
- [Proposer des fonctionnalités](#proposer-des-fonctionnalités)

## Code de conduite

Ce projet adhère au code de conduite Contributor Covenant. En participant, vous vous engagez à respecter ce code. Veuillez signaler tout comportement inacceptable.

### Nos engagements

- Créer un environnement accueillant et inclusif
- Respecter les points de vue et expériences différents
- Accepter les critiques constructives avec grâce
- Se concentrer sur ce qui est meilleur pour la communauté

## Comment contribuer

### Types de contributions acceptées

- 🐛 **Corrections de bugs**
- ✨ **Nouvelles fonctionnalités**
- 📝 **Améliorations de documentation**
- 🎨 **Améliorations UI/UX**
- ⚡ **Optimisations de performance**
- 🌍 **Traductions**
- ✅ **Tests**

### Avant de commencer

1. **Vérifiez les issues existantes** : Quelqu'un travaille peut-être déjà dessus
2. **Discutez des changements majeurs** : Ouvrez une issue pour en discuter d'abord
3. **Restez dans le scope** : Concentrez-vous sur une chose à la fois

## Configuration de l'environnement de développement

### Prérequis

- .NET 8.0 SDK
- Git
- Jellyfin 10.11+ pour les tests
- Visual Studio 2022, VS Code ou Rider (recommandé)
- Node.js (optionnel, pour les outils de développement)

### Setup initial

```bash
# 1. Forker le projet sur GitHub

# 2. Cloner votre fork
git clone https://github.com/VOTRE-USERNAME/Cooldowned.git
cd Cooldowned

# 3. Ajouter le remote upstream
git remote add upstream https://github.com/kazury/Cooldowned.git

# 4. Créer une branche de développement
git checkout -b feature/ma-fonctionnalite

# 5. Restaurer les dépendances
cd Jellyfin.Plugin.NextEpisodeDelay
dotnet restore

# 6. Compiler
dotnet build
```

### Configuration de l'IDE

#### Visual Studio Code

Installez les extensions recommandées :
- C# Dev Kit
- EditorConfig for VS Code
- GitLens

#### Rider / Visual Studio

Les paramètres du projet sont automatiquement détectés.

### Environnement de test

Pour tester le plugin en développement :

```bash
# Créer un lien symbolique vers votre instance Jellyfin
ln -s $(pwd)/bin/Debug/net8.0 /var/lib/jellyfin/plugins/NextEpisodeDelay-dev

# Configurer le build pour copier automatiquement
# Ajoutez dans Jellyfin.Plugin.NextEpisodeDelay.csproj :
```xml
<Target Name="CopyToJellyfin" AfterTargets="Build">
  <Copy SourceFiles="$(TargetPath)"
        DestinationFolder="/var/lib/jellyfin/plugins/NextEpisodeDelay-dev" />
</Target>
```

## Standards de code

### C# (.NET)

#### Style de code

Nous suivons les [conventions C# de Microsoft](https://docs.microsoft.com/en-us/dotnet/csharp/fundamentals/coding-style/coding-conventions) :

```csharp
// ✅ Bon
public class UserDelaySettings
{
    public bool Enabled { get; set; }
    public int DelaySeconds { get; set; }
}

// ❌ Mauvais
public class userDelaySettings
{
    public bool enabled;
    public int delay_seconds;
}
```

#### Naming conventions

- **Classes** : PascalCase (`UserDelaySettings`)
- **Méthodes** : PascalCase (`GetUserSettings`)
- **Variables locales** : camelCase (`delaySeconds`)
- **Constantes** : PascalCase (`DefaultDelaySeconds`)
- **Interfaces** : I + PascalCase (`IDelayService`)

#### Documentation XML

Documentez les méthodes et classes publiques :

```csharp
/// <summary>
/// Gets the delay settings for the current user.
/// </summary>
/// <param name="userId">The user ID.</param>
/// <returns>The user's delay settings.</returns>
public ActionResult<UserDelaySettings> GetUserSettings(Guid userId)
{
    // ...
}
```

### JavaScript

#### Style de code

Nous utilisons ES6+ avec conventions modernes :

```javascript
// ✅ Bon
const getUserSettings = async () => {
    const response = await fetch(`/${API_BASE}/${userId}`);
    return response.json();
};

// ❌ Mauvais
function getUserSettings(callback) {
    fetch('/' + API_BASE + '/' + userId).then(function(response) {
        response.json().then(function(data) {
            callback(data);
        });
    });
}
```

#### Naming conventions

- **Fonctions** : camelCase (`getUserSettings`)
- **Constantes** : UPPER_SNAKE_CASE (`API_BASE`)
- **Variables** : camelCase (`delaySeconds`)
- **Classes** : PascalCase (`OverlayManager`)

### CSS

Utilisez le préfixe `nextEpisodeDelay-` pour éviter les conflits :

```css
/* ✅ Bon */
.nextEpisodeDelay-overlay {
    position: fixed;
}

/* ❌ Mauvais */
.overlay {
    position: fixed;
}
```

### Formatage

Nous utilisons `.editorconfig` pour la cohérence :

```ini
[*.cs]
indent_style = space
indent_size = 4

[*.{js,css}]
indent_style = space
indent_size = 4
```

## Process de Pull Request

### 1. Créer une branche

```bash
# Depuis main
git checkout main
git pull upstream main

# Créer une branche feature
git checkout -b feature/ma-fonctionnalite

# Ou une branche bugfix
git checkout -b fix/correction-bug
```

### 2. Faire vos modifications

- Commitez régulièrement avec des messages clairs
- Suivez les standards de code
- Ajoutez des tests si applicable

### 3. Messages de commit

Utilisez le format conventionnel :

```
type(scope): description courte

Description détaillée si nécessaire

Fixes #123
```

**Types :**
- `feat`: Nouvelle fonctionnalité
- `fix`: Correction de bug
- `docs`: Documentation
- `style`: Formatage, pas de changement de code
- `refactor`: Refactoring
- `test`: Ajout/modification de tests
- `chore`: Tâches de maintenance

**Exemples :**

```bash
git commit -m "feat(api): add endpoint for batch settings update"
git commit -m "fix(overlay): countdown not resetting correctly"
git commit -m "docs(readme): add Docker installation instructions"
```

### 4. Pousser vos changements

```bash
git push origin feature/ma-fonctionnalite
```

### 5. Créer une Pull Request

1. Allez sur GitHub
2. Cliquez sur "New Pull Request"
3. Sélectionnez votre branche
4. Remplissez le template :

```markdown
## Description
Décrivez vos changements en détail

## Type de changement
- [ ] Bug fix
- [ ] Nouvelle fonctionnalité
- [ ] Breaking change
- [ ] Documentation

## Comment tester
1. Compilez le plugin
2. Installez sur Jellyfin 10.11.6
3. Testez en lisant une série

## Checklist
- [ ] Mon code suit les standards du projet
- [ ] J'ai ajouté des commentaires pour le code complexe
- [ ] J'ai mis à jour la documentation
- [ ] Mes changements ne génèrent pas de warnings
- [ ] J'ai testé sur Jellyfin 10.11.x
```

### 6. Review process

- Un mainteneur reviewera votre PR
- Répondez aux commentaires et ajustez si nécessaire
- Une fois approuvée, votre PR sera mergée

### Critères d'acceptation

- ✅ Les tests passent (si applicables)
- ✅ Le code compile sans warnings
- ✅ La documentation est à jour
- ✅ Le style de code est respecté
- ✅ Pas de régression introduite

## Rapporter des bugs

### Avant de rapporter

1. Vérifiez que c'est bien un bug du plugin (pas de Jellyfin)
2. Cherchez dans les issues existantes
3. Testez avec la dernière version

### Template de bug report

```markdown
**Describe the bug**
Description claire et concise du bug.

**To Reproduce**
1. Allez sur '...'
2. Cliquez sur '....'
3. Faites défiler jusqu'à '....'
4. Le bug apparaît

**Expected behavior**
Ce qui devrait se passer normalement.

**Screenshots**
Si applicable, ajoutez des captures d'écran.

**Environment:**
 - OS: [e.g. Ubuntu 22.04]
 - Jellyfin Version: [e.g. 10.11.6]
 - Plugin Version: [e.g. 1.0.0]
 - Browser: [e.g. Chrome 120]

**Logs**
```
Collez les logs pertinents ici
```

**Additional context**
Tout autre contexte sur le problème.
```

## Proposer des fonctionnalités

### Template de feature request

```markdown
**Is your feature request related to a problem?**
Description claire du problème.

**Describe the solution you'd like**
Ce que vous aimeriez voir implémenté.

**Describe alternatives you've considered**
Solutions alternatives considérées.

**Additional context**
Captures d'écran, mockups, exemples.

**Would you be willing to implement this?**
- [ ] Yes, I can submit a PR
- [ ] No, but I can help test
- [ ] No, just suggesting
```

### Processus de discussion

1. Ouvrez une issue avec le template
2. L'équipe discutera de la faisabilité
3. Si approuvée, l'issue sera labellée `enhancement`
4. Vous pouvez alors commencer à travailler dessus

## Tester

### Tests manuels

Avant de soumettre une PR :

1. **Testez l'installation** sur une instance propre
2. **Testez toutes les configurations** :
   - Délai activé/désactivé
   - Différentes durées (0s, 10s, 30s, 120s)
   - Paramètres par défaut vs utilisateur
3. **Testez l'interface** :
   - Affichage de l'overlay
   - Countdown visuel
   - Boutons Play Now et Cancel
   - Responsive design (mobile/desktop)
4. **Testez les cas limites** :
   - Dernier épisode d'une série
   - Playlists avec différents types de média
   - Changement de paramètres pendant la lecture

### Tests automatisés (futur)

Nous prévoyons d'ajouter :
- Tests unitaires (xUnit)
- Tests d'intégration
- Tests E2E avec Playwright

## Questions ?

- 💬 Ouvrez une [Discussion](https://github.com/kazury/Cooldowned/discussions)
- 🐛 Rapportez un [Bug](https://github.com/kazury/Cooldowned/issues/new?template=bug_report.md)
- ✨ Proposez une [Feature](https://github.com/kazury/Cooldowned/issues/new?template=feature_request.md)

## Remerciements

Merci à tous les contributeurs qui rendent ce projet meilleur ! 🎉

Chaque contribution, qu'elle soit petite ou grande, est appréciée.

---

**Happy coding! 🚀**
