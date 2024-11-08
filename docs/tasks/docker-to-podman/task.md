# Task

Guide me through the setup and configuration of the DeLoProxy stack on my network.

## Device Inventory

- Wet-Ham (Windows)
- Tonnys-Butt (Ubuntu WSL2 on Wet-Ham)
- Bologna-Tramp (podman-machine on Wet-Ham Windows)
- Emma (Synology NAS)
- Netgear Nighthawk (WiFi 6 Router)

## Acceptance Criteria

- Tonnys-Butt (Wet-Ham's WSL2 Ubuntu) is running podman where most containers will be deployed
- Bologna-Tramp (podman-machine on Wet-Ham Windows) is running podman desktop where Traefik will be deployed and where the delorenzo.family and the delo.sh domains will be routed
- Traefik is deployed and running on Bologna-Tramp
- Both the delorenzo.family and delo.sh domains are correctly configured for namecheap dnschallenge
- From Wet-Ham (Windows), I can curl `hai.delo.sh` and a hello-world container at that address that is deployed on Tonnys-Butt (WSL2 on Wet-Ham) should respond with a 200 status code and a message of "Hello World"
- From Wet-Ham (Windows), I can curl the traefik dashboard at `traefik.delorenzo.family` and see the dashboard






