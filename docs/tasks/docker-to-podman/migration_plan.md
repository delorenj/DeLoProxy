# Migration Plan: Docker to Podman

This document outlines the detailed plan for migrating from Docker to Podman, based on the initial system assessment and acceptance criteria.

## Phase 1: Environment Setup

### 1.1 Bologna-Tramp (Windows Host) Setup
- [ ] Verify Podman Desktop installation
- [ ] Configure Podman machine settings
  - Memory allocation
  - CPU allocation
  - Disk size
- [ ] Verify network connectivity
- [ ] Test Podman socket accessibility

### 1.2 Tonnys-Butt (WSL2) Setup
- [ ] Install Podman
- [ ] Configure Podman rootless mode
- [ ] Set up Podman socket
- [ ] Configure network for container communication

## Phase 2: Container Migration

### 2.1 Traefik Migration (Bologna-Tramp)
- [ ] Convert docker-compose.yml to Podman format
  - Update socket path to Podman socket
  - Verify volume mount compatibility
  - Adjust network settings
- [ ] Create environment file
  - NAMECHEAP_API_USER
  - NAMECHEAP_API_KEY
  - TRAEFIK_AUTH
- [ ] Test Traefik container launch
- [ ] Verify Traefik logs and startup

### 2.2 Hello World Service (Tonnys-Butt)
- [ ] Create hello-world container configuration
  - Container image selection
  - Network configuration
  - Port mapping
- [ ] Deploy hello-world service
- [ ] Configure Traefik routing rules

## Phase 3: Network Configuration

### 3.1 Internal Network Setup
- [ ] Configure network between Bologna-Tramp and Tonnys-Butt
- [ ] Set up port forwarding rules
- [ ] Test internal communication

### 3.2 External Access Configuration
- [ ] Configure DNS for delorenzo.family
- [ ] Configure DNS for delo.sh
- [ ] Set up Namecheap DNS challenge
- [ ] Test SSL certificate generation

## Phase 4: Testing & Verification

### 4.1 Component Testing
- [ ] Verify Traefik dashboard access
  - Test https://traefik.delorenzo.family
  - Verify authentication
  - Check SSL certificate
- [ ] Test hello-world service
  - Verify https://hai.delo.sh
  - Check response code (200)
  - Validate response message

### 4.2 Integration Testing
- [ ] Test end-to-end routing
- [ ] Verify SSL/TLS functionality
- [ ] Check logging and monitoring
- [ ] Performance testing

## Phase 5: Documentation & Cleanup

### 5.1 Documentation Updates
- [ ] Update system architecture diagrams
- [ ] Document configuration changes
- [ ] Create troubleshooting guide
- [ ] Update deployment procedures

### 5.2 Cleanup
- [ ] Remove Docker artifacts
- [ ] Archive old configuration files
- [ ] Update environment variables
- [ ] Clean up unused volumes

## Success Criteria

1. Traefik Dashboard
   - Accessible at traefik.delorenzo.family
   - Protected by authentication
   - Shows proper SSL certificate
   - Displays running services

2. Hello World Service
   - Accessible at hai.delo.sh
   - Returns 200 status code
   - Returns "Hello World" message
   - Properly routed through Traefik

3. System Health
   - All services running on correct hosts
   - Proper logging in place
   - Monitoring functional
   - Network communication established

## Rollback Plan

In case of critical issues:

1. Stop Podman services
2. Restore Docker configuration
3. Update DNS settings
4. Test original setup
5. Document issues encountered

## Timeline Estimate

- Phase 1: 1-2 hours
- Phase 2: 2-3 hours
- Phase 3: 1-2 hours
- Phase 4: 2-3 hours
- Phase 5: 1-2 hours

Total estimated time: 7-12 hours
