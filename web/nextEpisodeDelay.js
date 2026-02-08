/**
 * Next Episode Delay - Client-side script
 * Adds a configurable delay with countdown overlay before auto-playing next episode
 */

(function() {
    'use strict';

    const PLUGIN_ID = 'a8b9c0d1-e2f3-4a5b-6c7d-8e9f0a1b2c3d';
    const API_BASE = 'NextEpisodeDelay/Settings';

    let userSettings = null;
    let countdownInterval = null;
    let overlayElement = null;
    let isDelayActive = false;

    /**
     * Get current user ID
     */
    function getCurrentUserId() {
        if (window.ApiClient && window.ApiClient.getCurrentUserId) {
            return window.ApiClient.getCurrentUserId();
        }

        // Fallback for different Jellyfin versions
        if (window.Dashboard && window.Dashboard.getCurrentUserId) {
            return window.Dashboard.getCurrentUserId();
        }

        return null;
    }

    /**
     * Load user settings from API
     */
    async function loadUserSettings() {
        const userId = getCurrentUserId();
        if (!userId) {
            console.warn('[NextEpisodeDelay] Could not get current user ID');
            return null;
        }

        try {
            const response = await fetch(`/${API_BASE}/${userId}`, {
                headers: {
                    'X-Emby-Authorization': window.ApiClient.getAuthorizationHeader()
                }
            });

            if (response.ok) {
                userSettings = await response.json();
                console.log('[NextEpisodeDelay] User settings loaded:', userSettings);
                return userSettings;
            }
        } catch (error) {
            console.error('[NextEpisodeDelay] Error loading user settings:', error);
        }

        return null;
    }

    /**
     * Create countdown overlay element
     */
    function createOverlay() {
        const overlay = document.createElement('div');
        overlay.id = 'nextEpisodeDelayOverlay';
        overlay.className = 'nextEpisodeDelay-overlay';

        overlay.innerHTML = `
            <div class="nextEpisodeDelay-content">
                <div class="nextEpisodeDelay-header">
                    <h3 class="nextEpisodeDelay-title">Next Episode</h3>
                </div>
                <div class="nextEpisodeDelay-countdown-container">
                    <svg class="nextEpisodeDelay-countdown-svg" viewBox="0 0 100 100">
                        <circle class="nextEpisodeDelay-countdown-bg" cx="50" cy="50" r="45"></circle>
                        <circle class="nextEpisodeDelay-countdown-progress" cx="50" cy="50" r="45"></circle>
                    </svg>
                    <div class="nextEpisodeDelay-countdown-text">
                        <span class="nextEpisodeDelay-countdown-number">0</span>
                    </div>
                </div>
                <div class="nextEpisodeDelay-message">
                    Playing in <span class="nextEpisodeDelay-seconds">0</span> seconds...
                </div>
                <div class="nextEpisodeDelay-buttons">
                    <button class="nextEpisodeDelay-button nextEpisodeDelay-button-primary" id="nextEpisodePlayNow">
                        <span class="material-icons">play_arrow</span>
                        <span>Play Now</span>
                    </button>
                    <button class="nextEpisodeDelay-button nextEpisodeDelay-button-secondary" id="nextEpisodeCancel">
                        <span class="material-icons">close</span>
                        <span>Cancel</span>
                    </button>
                </div>
            </div>
        `;

        return overlay;
    }

    /**
     * Show countdown overlay
     */
    function showOverlay(delaySeconds) {
        if (isDelayActive) {
            return;
        }

        isDelayActive = true;

        // Create overlay if it doesn't exist
        if (!overlayElement) {
            overlayElement = createOverlay();
            document.body.appendChild(overlayElement);

            // Attach event listeners
            document.getElementById('nextEpisodePlayNow').addEventListener('click', playNow);
            document.getElementById('nextEpisodeCancel').addEventListener('click', cancelAutoplay);
        }

        // Show overlay with animation
        overlayElement.style.display = 'flex';
        setTimeout(() => {
            overlayElement.classList.add('nextEpisodeDelay-visible');
        }, 10);

        // Start countdown
        startCountdown(delaySeconds);
    }

    /**
     * Hide countdown overlay
     */
    function hideOverlay() {
        if (!overlayElement) {
            return;
        }

        overlayElement.classList.remove('nextEpisodeDelay-visible');
        setTimeout(() => {
            overlayElement.style.display = 'none';
            isDelayActive = false;
        }, 300);

        clearCountdown();
    }

    /**
     * Start countdown timer
     */
    function startCountdown(totalSeconds) {
        let remainingSeconds = totalSeconds;
        const circumference = 2 * Math.PI * 45; // radius = 45

        updateCountdownDisplay(remainingSeconds, totalSeconds, circumference);

        countdownInterval = setInterval(() => {
            remainingSeconds--;

            if (remainingSeconds >= 0) {
                updateCountdownDisplay(remainingSeconds, totalSeconds, circumference);
            } else {
                clearCountdown();
                playNow();
            }
        }, 1000);
    }

    /**
     * Update countdown display
     */
    function updateCountdownDisplay(remaining, total, circumference) {
        const countdownNumber = overlayElement.querySelector('.nextEpisodeDelay-countdown-number');
        const secondsText = overlayElement.querySelector('.nextEpisodeDelay-seconds');
        const progressCircle = overlayElement.querySelector('.nextEpisodeDelay-countdown-progress');

        countdownNumber.textContent = remaining;
        secondsText.textContent = remaining;

        // Update circular progress
        const progress = remaining / total;
        const offset = circumference * (1 - progress);
        progressCircle.style.strokeDasharray = `${circumference}`;
        progressCircle.style.strokeDashoffset = `${offset}`;
    }

    /**
     * Clear countdown timer
     */
    function clearCountdown() {
        if (countdownInterval) {
            clearInterval(countdownInterval);
            countdownInterval = null;
        }
    }

    /**
     * Play next episode immediately
     */
    function playNow() {
        console.log('[NextEpisodeDelay] Playing now');
        hideOverlay();

        // Trigger the original autoplay
        if (window.playbackManager && typeof window.playbackManager.nextTrack === 'function') {
            window.playbackManager.nextTrack();
        }
    }

    /**
     * Cancel autoplay
     */
    function cancelAutoplay() {
        console.log('[NextEpisodeDelay] Autoplay cancelled');
        hideOverlay();

        // Stop playback if needed
        if (window.playbackManager && typeof window.playbackManager.stop === 'function') {
            window.playbackManager.stop();
        }
    }

    /**
     * Hook into Jellyfin's playback events
     */
    function initializePlaybackHooks() {
        console.log('[NextEpisodeDelay] Initializing playback hooks');

        // Listen for playback stopped event
        document.addEventListener('playbackstop', async function(event) {
            const state = event.detail?.state;

            if (!state) {
                return;
            }

            // Check if this is the end of an episode and there's a next item
            const playbackManager = window.playbackManager;
            if (!playbackManager) {
                return;
            }

            const player = playbackManager.getCurrentPlayer();
            const playlist = playbackManager.getPlaylist();
            const currentIndex = playbackManager.getCurrentPlaylistIndex();

            if (playlist && currentIndex < playlist.length - 1) {
                const currentItem = playlist[currentIndex];
                const nextItem = playlist[currentIndex + 1];

                // Check if both items are episodes from the same series
                if (currentItem?.Type === 'Episode' && nextItem?.Type === 'Episode' &&
                    currentItem?.SeriesId === nextItem?.SeriesId) {

                    // Load settings if not loaded
                    if (!userSettings) {
                        await loadUserSettings();
                    }

                    // Show delay if enabled
                    if (userSettings && userSettings.Enabled && userSettings.DelaySeconds > 0) {
                        // Prevent default autoplay
                        event.preventDefault();
                        event.stopPropagation();

                        showOverlay(userSettings.DelaySeconds);
                        return false;
                    }
                }
            }
        }, true);
    }

    /**
     * Initialize plugin
     */
    async function initialize() {
        console.log('[NextEpisodeDelay] Plugin initializing...');

        // Wait for Jellyfin Web to be ready
        if (typeof window.ApiClient === 'undefined' || typeof window.playbackManager === 'undefined') {
            console.log('[NextEpisodeDelay] Waiting for Jellyfin Web to be ready...');
            setTimeout(initialize, 1000);
            return;
        }

        // Load user settings
        await loadUserSettings();

        // Initialize playback hooks
        initializePlaybackHooks();

        console.log('[NextEpisodeDelay] Plugin initialized');
    }

    // Start initialization when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initialize);
    } else {
        initialize();
    }

    // Expose for debugging
    window.NextEpisodeDelay = {
        showOverlay,
        hideOverlay,
        loadUserSettings,
        userSettings: () => userSettings
    };

})();
