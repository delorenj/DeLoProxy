# Task

Guide me through the setup and configuration of traefik binary amd64 installed via choco on my network.

## Device Inventory

- Wet-Ham (Windows)
- Tonnys-Butt (Ubuntu WSL2 on Wet-Ham)

## Acceptance Criteria

- Tonnys-Butt has a `hello-world` container running on podman
- Traefik is deployed and running on Wet-Ham
- Both the `delorenzo.family` and `delo.sh` domains are correctly configured for namecheap dnschallenge
- From Wet-Ham (Windows), I can curl `hai.delo.sh` and a hello-world container at that address that is deployed on Tonnys-Butt (WSL2 on Wet-Ham) should respond with a 200 status code and a message of "Hello World"
- From Wet-Ham (Windows), I can curl the traefik dashboard at `traefik.delorenzo.family` and see the dashboard
