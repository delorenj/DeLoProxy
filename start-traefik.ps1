# start-traefik.ps1
[CmdletBinding()]
param (
    [string]$ConfigPath = ".\config",
    [switch]$NoColor,
    [switch]$InstallService,
    [switch]$UninstallService
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

# Get the absolute path of the script
$scriptPath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path -Parent $scriptPath
$serviceName = "TraefikService"
$serviceDisplayName = "Traefik Proxy Service"
$serviceDescription = "Runs Traefik reverse proxy with configuration from config directory"

function Install-TraefikService {
    if (Get-Service $serviceName -ErrorAction SilentlyContinue) {
        Write-StatusMessage "Service already exists" "Warning"
        return
    }

    $absoluteConfigPath = Join-Path $scriptDir "config"
    
    # Create the service
    $params = @{
        Name = $serviceName
        BinaryPathName = "traefik --configDir `"$absoluteConfigPath`""
        DisplayName = $serviceDisplayName
        Description = $serviceDescription
        StartupType = "Automatic"
    }

    New-Service @params
    Write-StatusMessage "Service installed successfully" "Success"
    Write-StatusMessage "Starting service..." "Info"
    Start-Service -Name $serviceName
    Write-StatusMessage "Service started" "Success"
}

function Uninstall-TraefikService {
    if (-not (Get-Service $serviceName -ErrorAction SilentlyContinue)) {
        Write-StatusMessage "Service does not exist" "Warning"
        return
    }

    Stop-Service -Name $serviceName -Force
    Remove-Service -Name $serviceName
    Write-StatusMessage "Service uninstalled successfully" "Success"
}

try {
    # Handle service installation/uninstallation
    if ($InstallService) {
        Install-TraefikService
        exit 0
    }
    if ($UninstallService) {
        Uninstall-TraefikService
        exit 0
    }

    # Normal execution mode
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
    traefik --configDir="$ConfigPath"
        
} catch {
    Write-StatusMessage "Error: $_" "Error"
    exit 1
}
