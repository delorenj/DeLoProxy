# Initial System Assessment

## Current System Architecture

### Infrastructure Overview
- **Wet-Ham** (Windows 11)
  - Primary host machine
  - Running Windows Terminal and PowerShell
  - Hosts WSL2 Ubuntu instance
  - Project location: `C:\Users\jarad\code\DeLoProxy`

- **Tonnys-Butt** (WSL2 Ubuntu on Wet-Ham)
  - Target for main container deployments
  - Podman root directory: `/home/delorenj/podman`
  - Running Zsh shell

- **Bologna-Tramp** (Podman machine on Wet-Ham Windows)
  - Designated for Traefik deployment
  - Will handle routing for delorenzo.family and delo.sh domains

- **Emma** (Synology NAS)
  - Network attached storage system
  - Current role in architecture to be determined

- **Netgear Nighthawk** (WiFi 6 Router)
  - Network infrastructure

### Current Traefik Configuration Analysis

#### Container Configuration
- Using Traefik v2.10
- Running with essential security configurations:
  - No new privileges
  - NET_BIND_SERVICE capability
- Port mappings:
  - 8080:80 (HTTP)
  - 8443:443 (HTTPS)
  - 9000:8080 (Dashboard)

#### Key Features
1. **SSL/TLS**
   - Configured for two separate certificate resolvers:
     - delorenzo.family domain
     - delo.sh domain
   - Using Namecheap DNS challenge for certificate validation
   - TLS minimum version set to 1.2

2. **Security**
   - Basic authentication enabled for dashboard
   - Secure headers middleware configured with:
     - SSL redirect
     - HSTS with preload
     - Subdomains included in HSTS
   - API security enabled (insecure mode disabled)

3. **Provider Configuration**
   - Docker provider enabled
   - File provider with dynamic configuration
   - Containers not exposed by default (explicit opt-in required)

4. **Monitoring & Logging**
   - Dashboard enabled at traefik.delorenzo.family
   - Access logs enabled
   - Log level set to INFO

## Migration Challenges & Considerations

1. **Socket Access**
   - Current setup uses Docker socket
   - Need to transition to Podman socket
   - Path adjustment required: `/run/user/1000/podman/podman.sock`

2. **Network Architecture**
   - Complex routing between Windows host and WSL2
   - Need to ensure proper communication between:
     - Bologna-Tramp (Traefik) → Tonnys-Butt (Services)
     - External traffic → Bologna-Tramp → Tonnys-Butt

3. **Volume Mounts**
   - Current Docker volume mounts need verification for Podman compatibility
   - SELinux context (`:Z`) already in place, which is good for Podman

4. **Environment Variables**
   - Need to ensure proper transfer of:
     - NAMECHEAP_API_USER
     - NAMECHEAP_API_KEY
     - TRAEFIK_AUTH

## Next Steps

1. **Podman Setup**
   - Verify Podman installation on both Tonnys-Butt and Bologna-Tramp
   - Configure Podman socket accessibility

2. **Container Migration**
   - Convert docker-compose.yml to Podman compatible format
   - Test Traefik container on Bologna-Tramp
   - Verify socket connectivity

3. **Network Configuration**
   - Set up routing between Bologna-Tramp and Tonnys-Butt
   - Configure port forwarding as needed
   - Verify DNS resolution

4. **Testing Plan**
   - Verify SSL certificate generation
   - Test dashboard accessibility
   - Validate routing between systems
   - Deploy test container for hai.delo.sh endpoint