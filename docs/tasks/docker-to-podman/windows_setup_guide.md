# Bologna-Tramp Windows Setup Guide

This guide provides step-by-step instructions for setting up Podman Desktop on the Windows host (Wet-Ham) and configuring the Bologna-Tramp machine.

## Prerequisites
- Windows 11
- Administrator access
- Internet connection

## Installation Steps

### 1. Install Podman Desktop
1. Download Podman Desktop from https://podman-desktop.io/
2. Run the installer with administrator privileges
3. Complete the installation wizard
4. Launch Podman Desktop

### 2. Configure Bologna-Tramp Machine
1. Open Podman Desktop
2. Click on "Create machine" or equivalent option
3. Configure the machine with these specifications:
   - Name: bologna-tramp
   - CPUs: 2
   - Memory: 2048 MB
   - Disk Size: 20 GB
4. Start the machine
5. Verify the machine is running:
   ```powershell
   podman machine ls
   ```

### 3. Network Configuration
1. Ensure required ports are available:
   - 80 (HTTP)
   - 443 (HTTPS)
   - 8080 (Traefik Dashboard)
2. Configure Windows Defender Firewall:
   - Allow inbound connections for Podman
   - Allow required ports

### 4. Environment Variables
1. Set up required environment variables:
   ```powershell
   # Open PowerShell as Administrator
   [Environment]::SetEnvironmentVariable("NAMECHEAP_API_USER", "your-value", "User")
   [Environment]::SetEnvironmentVariable("NAMECHEAP_API_KEY", "your-value", "User")
   [Environment]::SetEnvironmentVariable("TRAEFIK_AUTH", "your-value", "User")
   ```

### 5. Verify Installation
1. Test Podman functionality:
   ```powershell
   podman run hello-world
   ```
2. Check machine status:
   ```powershell
   podman machine inspect bologna-tramp
   ```

## Network Communication Setup

### 1. WSL2 Integration
1. Ensure WSL2 network integration is working:
   ```powershell
   # Test connection to Tonnys-Butt
   ping tonnys-butt
   ```

### 2. Port Forwarding
1. Configure port forwarding in Windows:
   ```powershell
   # Example for port 80
   netsh interface portproxy add v4tov4 listenport=80 listenaddress=0.0.0.0 connectport=80 connectaddress=(bologna-tramp-ip)
   ```

## Troubleshooting

### Common Issues
1. Port conflicts
   - Check for services using required ports:
     ```powershell
     netstat -ano | findstr "80"
     netstat -ano | findstr "443"
     netstat -ano | findstr "8080"
     ```
   - Stop conflicting services or change ports

2. Network connectivity
   - Verify WSL2 network adapter
   - Check Windows Defender Firewall rules
   - Verify Podman machine network settings

### Verification Steps
1. Check Podman machine status
2. Verify environment variables
3. Test network connectivity
4. Validate port forwarding

## Next Steps
After completing this setup:
1. Verify connection between Bologna-Tramp and Tonnys-Butt
2. Test container deployment
3. Configure Traefik
4. Set up SSL certificates
