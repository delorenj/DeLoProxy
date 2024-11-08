# DeLoProxy

A Podman-based reverse proxy setup using Traefik v2.10 for the DeLorenzo family network. This stack handles SSL termination, automatic certificate management, and routing for all web services running on the Wet-Ham server.

## 🏗 Prerequisites

- WSL2 enabled
- Podman installed in WSL2
- Git for version control
- Port 80 and 443 forwarded to the server
- DNS configured for `delorenzo.family` domains

## 🚀 Quick Start

1. Clone this repository into `${HOME}/podman/traefik`
2. Copy `.env.example` to `.env` and fill in your credentials
3. Deploy using `podman-compose up -d`
4. Verify the dashboard is accessible at `https://traefik.delorenzo.family`

## 📁 Directory Structure

```
.
├── docker-compose.yml          # Main compose file for Traefik
├── config/
│   ├── certs.yaml             # Certificate configuration
│   ├── dynamic_conf.yaml      # Dynamic middleware configuration
│   └── machines/
│       └── emma.yaml          # Machine-specific routing
├── acme/                      # Certificate storage (auto-created)
└── README.md                  # This file
```

## ⚙️ Configuration

### Local Setup

```bash
# Create required directories
mkdir -p ${HOME}/podman/traefik/acme

# Set proper permissions for acme directory
chmod 600 ${HOME}/podman/traefik/acme
```

## 🌍 Environment

- Server: Wet-Ham (WSL2 with Podman)
- Network: Host networking
- Domain: `delorenzo.family`
- Base Path: `${HOME}/podman/traefik`

## 🛠 Troubleshooting

1. **Certificate Issues**
   - Check `acme` directory permissions
   - Verify DNS configuration
   - Ensure ports 80/443 are accessible

2. **Service Not Accessible**
   - Check service is running in Podman
   - Verify router rules in dashboard
   - Confirm service labels are correct

3. **Dashboard Not Loading**
   - Check WSL2 network configuration
   - Verify Podman socket access
   - Confirm basic auth credentials

### Logs
```bash
# View Traefik logs
podman logs traefik

# Follow logs
podman logs -f traefik
```
