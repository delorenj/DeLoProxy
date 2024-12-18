# start-traefik.ps1
[CmdletBinding()]
param (
    [string]$ConfigPath = ".\config\traefik.toml",
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
    $absoluteConfigPath = Join-Path $scriptDir $ConfigPath
    
    Write-StatusMessage "Testing Traefik configuration..." "Info"
    Write-StatusMessage "Traefik path: $traefikPath" "Info"
    Write-StatusMessage "Config path: $absoluteConfigPath" "Info"
    
    try {
        # Start Traefik process
        $process = Start-Process -FilePath $traefikPath -ArgumentList "--configFile=`"$absoluteConfigPath`"" -NoNewWindow -PassThru -RedirectStandardError ".\traefik-test.log"
        
        # Wait a few seconds to see if it starts successfully
        Start-Sleep -Seconds 3
        
        if (-not $process.HasExited) {
            # If process is still running, configuration is valid
            Write-StatusMessage "Configuration test successful" "Success"
            $process.Kill()
            return $true
        } else {
            # If process exited, read the error log
            $errorLog = Get-Content ".\traefik-test.log" -ErrorAction SilentlyContinue
            Write-StatusMessage "Configuration test failed" "Error"
            if ($errorLog) {
                Write-StatusMessage "Error details: $errorLog" "Error"
            }
            return $false
        }
    } catch {
        Write-StatusMessage "Error testing configuration: $_" "Error"
        return $false
    } finally {
        # Cleanup
        Remove-Item ".\traefik-test.log" -ErrorAction SilentlyContinue
    }
}

function Import-DotEnv {
    param (
        [string]$Path = ".env"
    )
    if (Test-Path $Path) {
        Get-Content $Path | ForEach-Object {
            if ($_ -match "^\s*([^#][^=]*)\s*=\s*(.*)\s*$") {
                [System.Environment]::SetEnvironmentVariable($matches[1], $matches[2], [System.EnvironmentVariableTarget]::Process)
            }
        }
    } else {
        Write-Host "No .env file found at path: $Path"
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
    $absoluteConfigPath = Join-Path $scriptDir $ConfigPath
    
    # Create the service with full paths
    $binaryPath = "`"$traefikPath`" --configFile=`"$absoluteConfigPath`""
    
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
    # Verify config file exists
    $absoluteConfigPath = Join-Path $scriptDir $ConfigPath
    if (-not (Test-Path $absoluteConfigPath)) {
        throw "Config file not found at: $absoluteConfigPath"
    }

    Write-StatusMessage "Starting Traefik with configuration from: $absoluteConfigPath"
    Write-StatusMessage "Press Ctrl+C to stop Traefik..." "Warning"
    
    # Start Traefik with configuration file
    traefik --configFile="$absoluteConfigPath"
        
} catch {
    Write-StatusMessage "Error: $_" "Error"
    exit 1
}
