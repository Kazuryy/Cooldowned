using System;
using System.ComponentModel.DataAnnotations;
using System.Net.Mime;
using Jellyfin.Plugin.NextEpisodeDelay.Configuration;
using MediaBrowser.Common.Extensions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Jellyfin.Plugin.NextEpisodeDelay.Api;

/// <summary>
/// Next Episode Delay API controller.
/// </summary>
[ApiController]
[Route("NextEpisodeDelay")]
[Produces(MediaTypeNames.Application.Json)]
public class NextEpisodeDelayController : ControllerBase
{
    /// <summary>
    /// Gets the delay settings for the current user.
    /// </summary>
    /// <param name="userId">The user ID.</param>
    /// <returns>The user's delay settings.</returns>
    [HttpGet("Settings/{userId}")]
    [Authorize(Policy = "DefaultAuthorization")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public ActionResult<UserDelaySettingsResponse> GetUserSettings([FromRoute, Required] Guid userId)
    {
        if (Plugin.Instance == null)
        {
            return NotFound();
        }

        var config = Plugin.Instance.Configuration;
        var userIdString = userId.ToString();

        if (config.UserSettings.TryGetValue(userIdString, out var settings))
        {
            return new UserDelaySettingsResponse
            {
                Enabled = settings.Enabled,
                DelaySeconds = settings.DelaySeconds
            };
        }

        // Return default settings if user doesn't have custom settings
        return new UserDelaySettingsResponse
        {
            Enabled = config.EnabledByDefault,
            DelaySeconds = config.DefaultDelaySeconds
        };
    }

    /// <summary>
    /// Updates the delay settings for the current user.
    /// </summary>
    /// <param name="userId">The user ID.</param>
    /// <param name="settings">The new settings.</param>
    /// <returns>No content.</returns>
    [HttpPost("Settings/{userId}")]
    [Authorize(Policy = "DefaultAuthorization")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public ActionResult UpdateUserSettings([FromRoute, Required] Guid userId, [FromBody, Required] UserDelaySettingsRequest settings)
    {
        if (Plugin.Instance == null)
        {
            return NotFound();
        }

        var config = Plugin.Instance.Configuration;
        var userIdString = userId.ToString();

        config.UserSettings[userIdString] = new UserDelaySettings
        {
            Enabled = settings.Enabled,
            DelaySeconds = settings.DelaySeconds
        };

        Plugin.Instance.SaveConfiguration();

        return NoContent();
    }

    /// <summary>
    /// Gets the default plugin configuration.
    /// </summary>
    /// <returns>The default configuration.</returns>
    [HttpGet("DefaultSettings")]
    [Authorize(Policy = "RequiresElevation")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public ActionResult<DefaultSettingsResponse> GetDefaultSettings()
    {
        if (Plugin.Instance == null)
        {
            return NotFound();
        }

        var config = Plugin.Instance.Configuration;

        return new DefaultSettingsResponse
        {
            DefaultDelaySeconds = config.DefaultDelaySeconds,
            EnabledByDefault = config.EnabledByDefault
        };
    }

    /// <summary>
    /// Updates the default plugin configuration.
    /// </summary>
    /// <param name="settings">The new default settings.</param>
    /// <returns>No content.</returns>
    [HttpPost("DefaultSettings")]
    [Authorize(Policy = "RequiresElevation")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public ActionResult UpdateDefaultSettings([FromBody, Required] DefaultSettingsRequest settings)
    {
        if (Plugin.Instance == null)
        {
            return NotFound();
        }

        var config = Plugin.Instance.Configuration;
        config.DefaultDelaySeconds = settings.DefaultDelaySeconds;
        config.EnabledByDefault = settings.EnabledByDefault;

        Plugin.Instance.SaveConfiguration();

        return NoContent();
    }
}

/// <summary>
/// User delay settings response.
/// </summary>
public class UserDelaySettingsResponse
{
    /// <summary>
    /// Gets or sets a value indicating whether the delay is enabled.
    /// </summary>
    public bool Enabled { get; set; }

    /// <summary>
    /// Gets or sets the delay in seconds.
    /// </summary>
    public int DelaySeconds { get; set; }
}

/// <summary>
/// User delay settings request.
/// </summary>
public class UserDelaySettingsRequest
{
    /// <summary>
    /// Gets or sets a value indicating whether the delay is enabled.
    /// </summary>
    [Required]
    public bool Enabled { get; set; }

    /// <summary>
    /// Gets or sets the delay in seconds.
    /// </summary>
    [Required]
    [Range(0, 300)]
    public int DelaySeconds { get; set; }
}

/// <summary>
/// Default settings response.
/// </summary>
public class DefaultSettingsResponse
{
    /// <summary>
    /// Gets or sets the default delay in seconds.
    /// </summary>
    public int DefaultDelaySeconds { get; set; }

    /// <summary>
    /// Gets or sets a value indicating whether the delay is enabled by default.
    /// </summary>
    public bool EnabledByDefault { get; set; }
}

/// <summary>
/// Default settings request.
/// </summary>
public class DefaultSettingsRequest
{
    /// <summary>
    /// Gets or sets the default delay in seconds.
    /// </summary>
    [Required]
    [Range(0, 300)]
    public int DefaultDelaySeconds { get; set; }

    /// <summary>
    /// Gets or sets a value indicating whether the delay is enabled by default.
    /// </summary>
    [Required]
    public bool EnabledByDefault { get; set; }
}
