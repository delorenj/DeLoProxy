# start-traefik.ps1
[CmdletBinding()]
param (
    [string]$ConfigPath = ".\config",
    [switch]$NoColor
)

# Enable error handling
$ErrorActionPreference = "Stop"

# Colors for status messages (unless -NoColor is specified)
function Write-StatusMessage {
    param($Message, $Type = "Info")
    
    if ($NoColor) {
        Write-Output $Message
        return
    }

    $color = switch ($Type) {
        "Info"    { "Cyan" }
        "Success" { "Green" }
        "Error"   { "Red" }
        "Warning" { "Yellow" }
        default   { "White" }
    }
    
    Write-Host $Message -ForegroundColor $color
}

try {
    # Verify config directory exists
    if (-not (Test-Path $ConfigPath)) {
        throw "Config directory not found at: $ConfigPath"
    }

    # Verify traefik.yaml exists
    $configFile = Join-Path $ConfigPath "traefik.yaml"
    if (-not (Test-Path $configFile)) {
        throw "traefik.yaml not found at: $configFile"
    }

    Write-StatusMessage "Starting Traefik with configuration from: $ConfigPath"
    Write-StatusMessage "Press Ctrl+C to stop Traefik..." "Warning"
    
    # Start Traefik with standard configuration
    traefik `
        --configFile="$configFile" `
        --log.level=INFO
        
} catch {
    Write-StatusMessage "Error: $_" "Error"
    exit 1
}