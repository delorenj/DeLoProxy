# Container Deployment Guide

This guide outlines the steps to deploy the Traefik reverse proxy on Bologna-Tramp and the Hello World service on Tonnys-Butt.

## Prerequisites

### Bologna-Tramp (Windows)
- Podman Desktop installed and configured
- Environment variables set:
  - NAMECHEAP_API_USER
  - NAMECHEAP_API_KEY
  - TRAEFIK_AUTH

### Tonnys-Butt (WSL2)
- Podman installed and configured
- Network connectivity with Bologna-Tramp verified

## Deployment Steps

### 1. Deploy Traefik on Bologna-Tramp

1. Copy configuration files:
   ```powershell
   # Create necessary directories
   mkdir config acme
   cp traefik-compose.yaml podman-compose.yaml
   ```

2. Start Traefik:
   ```powershell
   podman-compose up -d
   ```

3. Verify Traefik is running:
   ```powershell
   podman ps
   podman logs traefik
   ```

4. Test dashboard access:
   - Navigate to https://traefik.delorenzo.family
   - Login with configured credentials

### 2. Deploy Hello World Service on Tonnys-Butt

1. Copy configuration files:
   ```bash
   # Create necessary directories
   mkdir -p hello-world/html
   cp hello-world-compose.yaml podman-compose.yaml
   cp hello-world/html/index.html hello-world/html/
   ```

2. Start Hello World service:
   ```bash
   podman-compose up -d
   ```

3. Verify service is running:
   ```bash
   podman ps
   podman logs hello-world
   ```

4. Test service access:
   - Navigate to https://hai.delo.sh
   - Verify "Hello World" message is displayed

## Verification Steps

### 1. Network Connectivity
- Verify Traefik can reach Hello World service
- Check Traefik logs for routing information
- Verify SSL certificate generation

### 2. Service Health
- Monitor container logs
- Check resource usage
- Verify automatic restarts

### 3. SSL Certificates
- Verify certificate generation
- Check certificate validity
- Monitor renewal process

## Troubleshooting

### Common Issues

1. Certificate Generation
   ```bash
   # Check Traefik logs
   podman logs traefik | grep -i "certificate"
   ```

2. Network Connectivity
   ```bash
   # Test network from Traefik to Hello World
   podman exec traefik wget -q -O- http://hello-world
   ```

3. Service Discovery
   ```bash
   # Check Traefik provider status
   podman exec traefik traefik status
   ```

### Recovery Steps

1. Service Failure
   ```bash
   # Restart service
   podman-compose restart
   ```

2. Network Issues
   ```bash
   # Recreate network
   podman network rm podman_default
   podman-compose up -d
   ```

## Maintenance

### Regular Tasks
1. Monitor logs
2. Check certificate renewals
3. Verify service health
4. Update images when needed

### Updates
1. Pull new images:
   ```bash
   podman-compose pull
   ```

2. Apply updates:
   ```bash
   podman-compose up -d
   ```

## Rollback Procedure

If issues occur:

1. Stop new containers:
   ```bash
   podman-compose down
   ```

2. Revert to previous version:
   ```bash
   podman tag <image>:latest <image>:backup
   podman-compose up -d
   ```

## Next Steps
- Monitor service performance
- Set up logging aggregation
- Configure monitoring alerts
- Plan backup strategy
