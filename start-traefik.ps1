# start-traefik.ps1
[CmdletBinding()]
param (
    [string]$ConfigPath = ".\config",
    [switch]$NoColor,
    [switch]$InstallService,
    [switch]$UninstallService,
    [switch]$TestConfig
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

# Get the absolute path of the script and traefik
$scriptPath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path -Parent $scriptPath
$serviceName = "TraefikService"
$serviceDisplayName = "Traefik Proxy Service"
$serviceDescription = "Runs Traefik reverse proxy with configuration from config directory"

function Get-TraefikPath {
    $traefikPath = Get-Command traefik -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source
    if (-not $traefikPath) {
        throw "Traefik executable not found in PATH"
    }
    return $traefikPath
}

function Test-TraefikConfig {
    $traefikPath = Get-TraefikPath
    $absoluteConfigPath = Join-Path $scriptDir "config"
    
    Write-StatusMessage "Testing Traefik configuration..." "Info"
    Write-StatusMessage "Traefik path: $traefikPath" "Info"
    Write-StatusMessage "Config path: $absoluteConfigPath" "Info"
    
    try {
        # Test the configuration
        & $traefikPath "$absoluteConfigPath" --checkconfiguration
        if ($LASTEXITCODE -eq 0) {
            Write-StatusMessage "Configuration test successful" "Success"
            return $true
        } else {
            Write-StatusMessage "Configuration test failed" "Error"
            return $false
        }
    } catch {
        Write-StatusMessage "Error testing configuration: $_" "Error"
        return $false
    }
}

function Get-ServiceError {
    param($ServiceName)
    
    $events = Get-WinEvent -FilterHashtable @{
        LogName = 'System'
        Level = 2  # Error
        ProviderName = 'Service Control Manager'
    } -MaxEvents 10 -ErrorAction SilentlyContinue
    
    $relevantEvents = $events | Where-Object { $_.Message -like "*$ServiceName*" }
    if ($relevantEvents) {
        return $relevantEvents[0].Message
    }
    return $null
}

function Install-TraefikService {
    if (Get-Service $serviceName -ErrorAction SilentlyContinue) {
        Write-StatusMessage "Service already exists. Uninstall it first using -UninstallService" "Warning"
        return
    }

    # Test configuration first
    if (-not (Test-TraefikConfig)) {
        throw "Configuration test failed. Please check your Traefik configuration."
    }

    $traefikPath = Get-TraefikPath
    $absoluteConfigPath = Join-Path $scriptDir "config"
    
    # Create the service with full paths, using cmd.exe to handle the command
    $binaryPath = "cmd.exe /C `"$traefikPath`" `"$absoluteConfigPath`""
    
    Write-StatusMessage "Installing service with path: $binaryPath" "Info"
    
    $params = @{
        Name = $serviceName
        BinaryPathName = $binaryPath
        DisplayName = $serviceDisplayName
        Description = $serviceDescription
        StartupType = "Automatic"
    }

    New-Service @params
    Write-StatusMessage "Service installed successfully" "Success"
    Write-StatusMessage "Starting service..." "Info"
    
    try {
        Start-Service -Name $serviceName
        Write-StatusMessage "Service started successfully" "Success"
    } catch {
        $errorDetails = Get-ServiceError $serviceName
        Write-StatusMessage "Failed to start service" "Error"
        Write-StatusMessage "Error details: $errorDetails" "Error"
        throw "Service installation failed: $_"
    }
}

function Uninstall-TraefikService {
    if (-not (Get-Service $serviceName -ErrorAction SilentlyContinue)) {
        Write-StatusMessage "Service does not exist" "Warning"
        return
    }

    Write-StatusMessage "Stopping service..." "Info"
    Stop-Service -Name $serviceName -Force -ErrorAction SilentlyContinue
    
    Write-StatusMessage "Removing service..." "Info"
    $result = sc.exe delete $serviceName
    if ($LASTEXITCODE -eq 0) {
        Write-StatusMessage "Service uninstalled successfully" "Success"
    } else {
        throw "Failed to remove service: $result"
    }
}

try {
    # Handle service installation/uninstallation
    if ($TestConfig) {
        Test-TraefikConfig
        exit 0
    }
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
    traefik "$ConfigPath"
        
} catch {
    Write-StatusMessage "Error: $_" "Error"
    exit 1
}
