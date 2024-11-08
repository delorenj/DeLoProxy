# port-forward.ps1

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet('add','remove')]
    [string]$Action
)

# Must run as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script must be run as Administrator. Right-click PowerShell and select 'Run as Administrator'."
    exit 1
}

# Get the IP address of the Podman machine
$podmanIP = podman machine inspect bologna-tramp --format '{{.NetworkSettings.IPAddress}}'
if (-not $podmanIP) {
    Write-Error "Could not get Podman machine IP. Is the machine running?"
    exit 1
}

# Port forward rules
$rules = @(
    @{
        ListenPort = 80
        ConnectPort = 8080
    },
    @{
        ListenPort = 443
        ConnectPort = 8443
    }
)

function Add-PortForwards {
    foreach ($rule in $rules) {
        Write-Host "Adding port forward from localhost:$($rule.ListenPort) to ${podmanIP}:$($rule.ConnectPort)"
        netsh interface portproxy add v4tov4 listenport=$($rule.ListenPort) listenaddress=0.0.0.0 connectport=$($rule.ConnectPort) connectaddress=$podmanIP
        
        # Add firewall rules if they don't exist
        $fwRuleName = "Podman-Forward-$($rule.ListenPort)"
        if (-not (Get-NetFirewallRule -Name $fwRuleName -ErrorAction SilentlyContinue)) {
            New-NetFirewallRule -Name $fwRuleName -DisplayName $fwRuleName -Direction Inbound -Action Allow -Protocol TCP -LocalPort $rule.ListenPort
        }
    }
}

function Remove-PortForwards {
    foreach ($rule in $rules) {
        Write-Host "Removing port forward for port $($rule.ListenPort)"
        netsh interface portproxy delete v4tov4 listenport=$($rule.ListenPort) listenaddress=0.0.0.0
        
        # Remove firewall rules
        $fwRuleName = "Podman-Forward-$($rule.ListenPort)"
        Remove-NetFirewallRule -Name $fwRuleName -ErrorAction SilentlyContinue
    }
}

# Execute requested action
switch ($Action) {
    'add' { Add-PortForwards }
    'remove' { Remove-PortForwards }
}

# Show current port forwards
Write-Host "`nCurrent port forwards:"
netsh interface portproxy show all