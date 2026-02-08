# Changelog

All notable changes to the Next Episode Delay plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- [ ] Add localization support (i18n)
- [ ] Add keyboard shortcuts (Space to skip, Esc to cancel)
- [ ] Add sound notification option
- [ ] Add "Remember my choice" option
- [ ] Add statistics on how often users skip delays
- [ ] Add mobile app support (iOS/Android)
- [ ] Add option to skip delay for certain series

## [1.0.0] - 2026-02-08

### Added
- ✨ Initial release of Next Episode Delay plugin
- ⚙️ Configurable delay between 0 and 300 seconds
- 🎨 Visual countdown overlay with circular progress indicator
- 👤 Per-user settings stored in database
- 🔧 Admin dashboard configuration page with presets
- 🎮 "Play Now" button to skip delay immediately
- 🚫 "Cancel" button to stop autoplay
- 📱 Responsive design for mobile and desktop
- 🌈 Theme-compatible styling (follows Jellyfin theme)
- 🔌 REST API endpoints for settings management:
  - GET /NextEpisodeDelay/Settings/{userId}
  - POST /NextEpisodeDelay/Settings/{userId}
  - GET /NextEpisodeDelay/DefaultSettings (admin)
  - POST /NextEpisodeDelay/DefaultSettings (admin)
- 📦 Embedded JavaScript and CSS resources
- 🔒 Proper authorization and permissions
- ♿ Accessibility features (focus states, ARIA labels)

### Technical Details
- 🏗️ Built with .NET 9.0 and C# latest
- 🗄️ Uses EF Core for settings persistence
- 🎯 Compatible with Jellyfin 10.11.0+
- 🔄 Hooks into playbackstop events
- 🚀 Non-blocking, lightweight implementation
- 🎭 Smooth animations and transitions

### Documentation
- 📚 Comprehensive README with examples
- 📖 Detailed installation guide (INSTALL.md)
- 🤝 Contributing guidelines (CONTRIBUTING.md)
- 📄 MIT License
- 🐛 GitHub issue templates
- 🔀 Pull request template
- ⚙️ EditorConfig for code consistency
- 🏷️ Manifest for plugin repository

### Known Issues
- ⚠️ May conflict with other autoplay-modifying plugins
- ⚠️ Overlay may not show if JavaScript errors occur
- ⚠️ Material Icons dependency (requires Jellyfin web fonts)

### Notes
- Default delay is set to 30 seconds (recommended)
- Settings are stored per-user in plugin configuration
- Overlay appears only when playing series episodes
- Compatible with all modern browsers

---

## Version History

### Format

```
## [Version] - YYYY-MM-DD

### Added
- New features

### Changed
- Changes in existing functionality

### Deprecated
- Soon-to-be removed features

### Removed
- Removed features

### Fixed
- Bug fixes

### Security
- Security fixes
```

---

## Upgrade Notes

### From Initial Installation
No upgrade notes yet. This is the first release.

---

## Support

For issues, feature requests, or questions:
- [GitHub Issues](https://github.com/kazury/Cooldowned/issues)
- [Jellyfin Forum](https://forum.jellyfin.org/)

---

**Legend:**
- ✨ Feature
- 🐛 Bug fix
- 📚 Documentation
- ⚡ Performance
- 🔒 Security
- 💥 Breaking change
