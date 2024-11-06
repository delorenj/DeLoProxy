# DeLoProxy

A Docker-based reverse proxy setup using Traefik v2.10 for the DeLorenzo family network. This stack handles SSL termination, automatic certificate management, and routing for all web services running on the Wet-Ham server.

## 🏗 Prerequisites

- Windows Server with Docker Desktop installed
- WSL2 enabled
- Git for version control
- Portainer for stack deployment
- Port 80 and 443 forwarded to the server
- DNS configured for `delorenzo.family` domains

## 🚀 Quick Start

1. In Portainer, create a new stack named `deloproxy`
2. Use Git repository deployment and point to this repository
3. Deploy the stack
4. Verify the dashboard is accessible at `https://delorenzo.family`

## 📁 Directory Structure

```
.
├── docker-compose.yml          # Main compose file for Traefik
├── config/
│   ├── traefik.yml            # Static Traefik configuration
│   └── dynamic.yml            # Dynamic middleware configuration
├── lego/                      # Certificate storage (auto-created)
│   └── acme.json              # Let's Encrypt certificates
└── README.md                  # This file
```

## ⚙️ Configuration

### Local Setup

```powershell
# Create required directories
New-Item -Path "C:\DockerData\core\traefik\lego" -ItemType Directory -Force

# Create and set permissions for acme.json
New-Item -Path "C:\DockerData\core\traefik\lego\acme.json" -ItemType File -Force
icacls "C:\DockerData\core\traefik\lego\acme.json" /inheritance:r
icacls "C:\DockerData\core\traefik\lego\acme.json" /grant:r "$env:USERNAME:(R,W)"
```

### Adding New Services

To add a new service behind the proxy, use these labels in your Docker Compose:

```yaml
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.myservice.rule=Host(`myservice.delorenzo.family`)"
  - "traefik.http.routers.myservice.entrypoints=websecure"
  - "traefik.http.routers.myservice.tls.certresolver=letsencrypt"
  - "traefik.http.services.myservice.loadbalancer.server.port=8080"
```

## 🔐 Security

- All HTTP traffic is automatically redirected to HTTPS
- SSL certificates are automatically managed via Let's Encrypt
- Admin dashboard is protected with basic authentication
- Services are not exposed by default (`exposedByDefault=false`)

## 🌍 Environment

- Server: Wet-Ham (Windows with Docker Desktop)
- Network: `proxy` (external Docker network)
- Domain: `delorenzo.family`
- Base Path: `C:\DockerData\core\traefik`

## 🔍 Monitoring

Access the Traefik dashboard at `https://delorenzo.family` to monitor:
- Service health
- Router status
- Certificate information
- Middleware chains

## 🛠 Troubleshooting

1. **Certificate Issues**
   - Check `acme.json` permissions
   - Verify DNS configuration
   - Ensure ports 80/443 are accessible

2. **Service Not Accessible**
   - Verify service is in the `proxy` network
   - Check router rules in dashboard
   - Confirm service labels are correct

3. **Dashboard Not Loading**
   - Verify Windows firewall settings
   - Check Docker socket access
   - Confirm basic auth credentials

## 📝 Maintenance

### Regular Tasks
- Monitor certificate renewals (auto-renewed 30 days before expiry)
- Check Traefik logs for routing issues
- Review dashboard for service health
- Keep Traefik image updated

### Logs
```bash
# View Traefik logs
docker logs traefik

# Follow logs
docker logs -f traefik
```

## 🔄 Updates

To update Traefik:
1. Update the image tag in `docker-compose.yml`
2. Redeploy the stack in Portainer
3. Verify all services are routing correctly

## 📚 Further Reading

- [Traefik v2 Documentation](https://doc.traefik.io/traefik/)
- [Let's Encrypt Documentation](https://letsencrypt.org/docs/)
- [Docker Networking Guide](https://docs.docker.com/network/)


## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.