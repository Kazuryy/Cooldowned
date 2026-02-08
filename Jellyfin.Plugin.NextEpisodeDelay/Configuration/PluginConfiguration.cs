using System.Collections.Generic;
using MediaBrowser.Model.Plugins;

namespace Jellyfin.Plugin.NextEpisodeDelay.Configuration;

/// <summary>
/// Plugin configuration class.
/// </summary>
public class PluginConfiguration : BasePluginConfiguration
{
    /// <summary>
    /// Initializes a new instance of the <see cref="PluginConfiguration"/> class.
    /// </summary>
    public PluginConfiguration()
    {
        DefaultDelaySeconds = 30;
        EnabledByDefault = true;
        UserSettings = new Dictionary<string, UserDelaySettings>();
    }

    /// <summary>
    /// Gets or sets the default delay in seconds.
    /// </summary>
    public int DefaultDelaySeconds { get; set; }

    /// <summary>
    /// Gets or sets a value indicating whether the delay is enabled by default for new users.
    /// </summary>
    public bool EnabledByDefault { get; set; }

    /// <summary>
    /// Gets or sets the per-user delay settings.
    /// Key: UserId (Guid as string)
    /// Value: UserDelaySettings
    /// </summary>
    public Dictionary<string, UserDelaySettings> UserSettings { get; set; }
}

/// <summary>
/// Per-user delay settings.
/// </summary>
public class UserDelaySettings
{
    /// <summary>
    /// Gets or sets a value indicating whether the delay is enabled for this user.
    /// </summary>
    public bool Enabled { get; set; }

    /// <summary>
    /// Gets or sets the delay in seconds for this user.
    /// </summary>
    public int DelaySeconds { get; set; }
}
