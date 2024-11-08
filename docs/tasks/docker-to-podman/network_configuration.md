# Network Configuration

## Current Network Setup

### Tonnys-Butt (WSL2)

#### Container Network
- Hello World service running on Podman network
- Container IP: 10.89.1.2
- Service accessible within Podman network

### Required Network Configuration

#### 1. WSL2 to Windows Communication
- WSL2 needs to communicate with Bologna-Tramp on Windows
- Default WSL2 network interface provides Windows host access
- Need to ensure proper DNS resolution between systems

#### 2. Container Network Access
- Traefik on Bologna-Tramp needs to reach hello-world service
- Requires proper routing between:
  - Bologna-Tramp → Tonnys-Butt WSL2 → Podman network
  - External traffic → Bologna-Tramp → Tonnys-Butt services

## Network Testing Plan

### 1. Internal Connectivity Tests
```bash
# From Tonnys-Butt
# Test hello-world service
curl http://10.89.1.2

# Test WSL2 to Windows connectivity
ping bologna-tramp
```

### 2. Container Network Tests
```bash
# From hello-world container
podman exec hello-world ping bologna-tramp

# From Traefik container (once deployed)
podman exec traefik curl http://10.89.1.2
```

### 3. External Access Tests
```powershell
# From Windows (Wet-Ham)
curl http://hai.delo.sh
curl https://traefik.delorenzo.family
```

## Network Configuration Steps

### 1. Tonnys-Butt Configuration
- [x] Basic Podman network setup
- [x] Container network functional
- [ ] Configure container DNS resolution
- [ ] Set up routing to Bologna-Tramp

### 2. Bologna-Tramp Configuration
- [ ] Configure Podman network
- [ ] Set up port forwarding (80, 443, 8080)
- [ ] Configure Traefik network access
- [ ] Set up SSL termination

### 3. Integration Steps
1. Document Bologna-Tramp IP address
2. Configure Traefik to route to hello-world service
3. Set up DNS resolution between hosts
4. Configure external domain routing

## Port Mapping

| Service | Internal Port | External Port | Host |
|---------|--------------|---------------|------|
| Traefik HTTP | 80 | 80 | Bologna-Tramp |
| Traefik HTTPS | 443 | 443 | Bologna-Tramp |
| Traefik Dashboard | 8080 | 8080 | Bologna-Tramp |
| Hello World | 80 | N/A | Tonnys-Butt |

## DNS Configuration

### Required DNS Records
1. traefik.delorenzo.family
   - Points to Bologna-Tramp external IP
   - Managed by Namecheap
   - Used for Traefik dashboard

2. hai.delo.sh
   - Points to Bologna-Tramp external IP
   - Managed by Namecheap
   - Routed internally to hello-world service

## Testing Checklist

- [ ] WSL2 to Windows connectivity
- [ ] Container to container communication
- [ ] External domain resolution
- [ ] SSL certificate generation
- [ ] End-to-end request routing

## Troubleshooting Guide

### Common Issues

1. Container Network Access
```bash
# Check container network
podman network inspect podman_default

# Verify container IP
podman inspect hello-world -f '{{.NetworkSettings.IPAddress}}'
```

2. WSL2 Network Issues
```bash
# Check WSL2 network
ip route
ip addr show

# Test Windows connectivity
ping bologna-tramp
```

3. DNS Resolution
```bash
# Test domain resolution
nslookup hai.delo.sh
nslookup traefik.delorenzo.family
```

### Recovery Steps

1. Network Connectivity Issues
```bash
# Restart WSL2 networking
wsl --shutdown  # From Windows
# Then restart WSL2

# Recreate Podman network
podman network rm podman_default
podman network create podman_default
```

2. Container Networking
```bash
# Recreate container with network
podman-compose down
podman-compose up -d
```

## Next Steps
1. Complete Bologna-Tramp setup
2. Configure Traefik networking
3. Test connectivity between hosts
4. Set up external domain routing
