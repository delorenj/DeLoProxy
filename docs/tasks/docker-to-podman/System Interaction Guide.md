# System Interaction Guide

How to access and interact with the various machines and containers.

## The Traefik Stack's Current State

- It is a git repository named `DeLoProxy`
- It is cloned and located in the windows filesystem of Wet-Ham at     `C:\Users\jarad\code\DeLoProxy`
- It currently consists of a single Traefik container, but I call the repo "DeLoProxy" because I plan on adding more services to it in the future.
- The deploy location is on `bologna-tramp` which is a podman machine on Wet-Ham Windows.

## Wet-Ham:Local Host Machine

- OS: Windows 11 with WSL2 Ubuntu
- Working Directory: This project (and you!) is mounted in the windows filesystem of Wet-Ham
- Primary Shell: PowerShell
- Default PowerShell Prompt: `PS C:\Users\jarad\code\DeLoProxy>`
- Optional Shell: Windows Terminal

## Tonnys-Butt:WSL2 Ubuntu

- OS: Ubuntu WSL2 on Windows 11
- Primary Shell: Zsh
- Default Shell Prompt: `delorenj@tonnys-butt:/home/delorenj>`
- Podman Root Directory: `/home/delorenj/podman`
- SSH Command: `ssh delorenj@tonnys-butt`
