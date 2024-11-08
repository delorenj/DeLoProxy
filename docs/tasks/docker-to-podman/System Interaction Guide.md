# System Interaction Guide

How to access and interact with the various machines and containers.

## The Traefik Stack's (DeLoProxy) Current State

- It is a git repository named `DeLoProxy`
- It is cloned and located in the WSL2 Ubuntu filesystem of Wet-Ham at     `/home/delorenj/code/DeLoProxy`
- It will be deployed to `bologna-tramp` which is a podman machine on Wet-Ham Windows.
- It's only purpose is to be a reverse proxy for the other services hosted on the other machines in the network.

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
