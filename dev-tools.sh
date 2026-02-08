#!/bin/bash

# Next Episode Delay - Development Tools
# Helper script for building, testing, and deploying the plugin

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$PROJECT_DIR/Jellyfin.Plugin.NextEpisodeDelay"
PLUGIN_NAME="NextEpisodeDelay"
JELLYFIN_PLUGIN_DIR="/var/lib/jellyfin/plugins/$PLUGIN_NAME"
JELLYFIN_WEB_DIR="/usr/share/jellyfin/web"

# Functions
print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        print_error "This operation requires root privileges"
        echo "Please run with sudo: sudo $0 $@"
        exit 1
    fi
}

# Build the plugin
build() {
    print_header "Building Plugin"

    cd "$PLUGIN_DIR"

    if [ "$1" == "release" ]; then
        print_info "Building in Release mode..."
        dotnet build -c Release
        print_success "Release build completed"
    else
        print_info "Building in Debug mode..."
        dotnet build -c Debug
        print_success "Debug build completed"
    fi
}

# Clean build artifacts
clean() {
    print_header "Cleaning Build Artifacts"

    cd "$PLUGIN_DIR"
    dotnet clean
    rm -rf bin/ obj/

    print_success "Clean completed"
}

# Publish the plugin
publish() {
    print_header "Publishing Plugin"

    cd "$PLUGIN_DIR"
    dotnet publish -c Release -o ./publish

    print_success "Plugin published to ./publish/"
}

# Install the plugin
install() {
    check_root

    print_header "Installing Plugin"

    if [ ! -d "$PLUGIN_DIR/bin/Release/net8.0" ] && [ ! -d "$PLUGIN_DIR/publish" ]; then
        print_error "Plugin not built. Run 'build release' or 'publish' first."
        exit 1
    fi

    # Stop Jellyfin
    print_info "Stopping Jellyfin..."
    systemctl stop jellyfin

    # Create plugin directory
    mkdir -p "$JELLYFIN_PLUGIN_DIR"

    # Copy files
    if [ -d "$PLUGIN_DIR/publish" ]; then
        print_info "Copying from publish directory..."
        cp -r "$PLUGIN_DIR/publish/"* "$JELLYFIN_PLUGIN_DIR/"
    else
        print_info "Copying from build directory..."
        cp -r "$PLUGIN_DIR/bin/Release/net8.0/"* "$JELLYFIN_PLUGIN_DIR/"
    fi

    # Set permissions
    chown -R jellyfin:jellyfin "$JELLYFIN_PLUGIN_DIR"
    chmod 755 "$JELLYFIN_PLUGIN_DIR"
    chmod 644 "$JELLYFIN_PLUGIN_DIR"/*

    # Start Jellyfin
    print_info "Starting Jellyfin..."
    systemctl start jellyfin

    print_success "Plugin installed successfully"
    print_info "Check logs: journalctl -u jellyfin -f"
}

# Uninstall the plugin
uninstall() {
    check_root

    print_header "Uninstalling Plugin"

    print_info "Stopping Jellyfin..."
    systemctl stop jellyfin

    if [ -d "$JELLYFIN_PLUGIN_DIR" ]; then
        rm -rf "$JELLYFIN_PLUGIN_DIR"
        print_success "Plugin directory removed"
    else
        print_warning "Plugin directory not found"
    fi

    print_info "Starting Jellyfin..."
    systemctl start jellyfin

    print_success "Plugin uninstalled successfully"
}

# Watch for changes and rebuild
watch() {
    print_header "Watching for Changes"

    print_info "Watching $PLUGIN_DIR for changes..."
    print_info "Press Ctrl+C to stop"

    cd "$PLUGIN_DIR"

    while true; do
        inotifywait -e modify,create,delete -r . \
            --exclude '(bin|obj|\.git|\.vs)' 2>/dev/null

        echo ""
        print_info "Change detected, rebuilding..."
        dotnet build -c Debug

        if [ $? -eq 0 ]; then
            print_success "Build successful"
        else
            print_error "Build failed"
        fi

        echo ""
    done
}

# View logs
logs() {
    print_header "Jellyfin Logs"

    if [ "$1" == "follow" ] || [ "$1" == "-f" ]; then
        print_info "Following logs (Ctrl+C to stop)..."
        journalctl -u jellyfin -f | grep -i --color "nextepisode\|plugin\|error"
    else
        print_info "Showing recent logs..."
        journalctl -u jellyfin -n 100 | grep -i --color "nextepisode\|plugin\|error"
    fi
}

# Run tests
test() {
    print_header "Running Tests"

    cd "$PLUGIN_DIR"

    if [ -f "*.Tests.csproj" ]; then
        dotnet test --configuration Release --verbosity normal
        print_success "Tests completed"
    else
        print_warning "No test project found"
    fi
}

# Create release package
package() {
    print_header "Creating Release Package"

    VERSION=${1:-"1.0.0"}

    # Build and publish
    build release
    publish

    # Create ZIP
    cd "$PLUGIN_DIR/publish"
    zip -r "../../$PLUGIN_NAME-v$VERSION.zip" *

    cd "$PROJECT_DIR"
    print_success "Package created: $PLUGIN_NAME-v$VERSION.zip"

    # Show file info
    ls -lh "$PLUGIN_NAME-v$VERSION.zip"
}

# Check Jellyfin status
status() {
    print_header "Jellyfin Status"

    systemctl status jellyfin --no-pager

    echo ""
    print_info "Plugin directory:"
    if [ -d "$JELLYFIN_PLUGIN_DIR" ]; then
        ls -lah "$JELLYFIN_PLUGIN_DIR"
    else
        print_warning "Plugin not installed"
    fi
}

# Development environment setup
dev_setup() {
    print_header "Development Environment Setup"

    # Check .NET SDK
    print_info "Checking .NET SDK..."
    if command -v dotnet &> /dev/null; then
        dotnet_version=$(dotnet --version)
        print_success ".NET SDK installed: $dotnet_version"
    else
        print_error ".NET SDK not found"
        print_info "Install with: sudo apt install dotnet-sdk-8.0"
        exit 1
    fi

    # Check inotify-tools (for watch)
    print_info "Checking inotify-tools..."
    if command -v inotifywait &> /dev/null; then
        print_success "inotify-tools installed"
    else
        print_warning "inotify-tools not found (needed for 'watch' command)"
        print_info "Install with: sudo apt install inotify-tools"
    fi

    # Restore dependencies
    print_info "Restoring dependencies..."
    cd "$PLUGIN_DIR"
    dotnet restore
    print_success "Dependencies restored"

    print_success "Development environment ready!"
}

# Show usage
usage() {
    cat << EOF
Next Episode Delay - Development Tools

Usage: $0 <command> [options]

Commands:
    build [release]     Build the plugin (debug by default)
    clean               Clean build artifacts
    publish             Publish plugin for distribution
    install             Install plugin to Jellyfin (requires sudo)
    uninstall           Uninstall plugin from Jellyfin (requires sudo)
    watch               Watch for changes and rebuild automatically
    logs [follow]       View Jellyfin logs (add 'follow' or '-f' to follow)
    test                Run tests
    package [version]   Create release package (default version: 1.0.0)
    status              Check Jellyfin and plugin status
    dev-setup           Setup development environment
    help                Show this help message

Examples:
    $0 build                   # Build in debug mode
    $0 build release           # Build in release mode
    $0 publish                 # Publish plugin
    sudo $0 install            # Install plugin to Jellyfin
    $0 watch                   # Watch for changes
    $0 logs follow             # Follow logs in real-time
    $0 package 1.0.0           # Create release package

EOF
}

# Main script
main() {
    case "${1:-help}" in
        build)
            build "$2"
            ;;
        clean)
            clean
            ;;
        publish)
            publish
            ;;
        install)
            install
            ;;
        uninstall)
            uninstall
            ;;
        watch)
            watch
            ;;
        logs)
            logs "$2"
            ;;
        test)
            test
            ;;
        package)
            package "$2"
            ;;
        status)
            status
            ;;
        dev-setup)
            dev_setup
            ;;
        help|--help|-h)
            usage
            ;;
        *)
            print_error "Unknown command: $1"
            echo ""
            usage
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
