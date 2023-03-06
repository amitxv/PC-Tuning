# PC-Tuning

Configure Windows based systems for real-time tasks

## Rationale

Windows is notorious for its ever-growing bloatware and third party telemetry which makes it difficult to execute real-time tasks efficiently due to excessive context switching, interrupts and I/O which ultimately leads to a poor user experience. This repository was created in hope of standardizing systems for latency sensitive tasks and minimizing unwanted outgoing traffic.

This repository may contain information similar to those of the projects listed in the [Further Reading](#further-reading) section, however it is not my intention to directly copy from them.

The guidance is currently updated and has been tested on client and server editions of Windows 7 through to Windows 11 (x64). See a full list of [issues](https://github.com/amitxv/PC-Tuning/issues).

## Requirements

- USB Storage Device (8 GB minimum)
- [Ventoy](https://github.com/ventoy/Ventoy/releases)
- Any live Linux distribution
- Familiarity with navigating directories in CLI

## Physical Setup

- See [docs/physical-setup.md](/docs/physical-setup.md)

## Pre-Install Instructions

- See [docs/pre-install.md](/docs/pre-install.md)

## Post-Install Instructions

- See [docs/post-install.md](/docs/post-install.md)

## Research

- See [docs/research.md](/docs/research.md)

## Further Reading

- [BoringBoredom/PC-Optimization-Hub](https://github.com/BoringBoredom/PC-Optimization-Hub)

- [Calypto's Latency Guide](https://docs.google.com/document/d/1c2-lUJq74wuYK1WrA_bIvgb89dUN0sj8-hO3vqmrau4)

- [djdallmann/GamingPCSetup](https://github.com/djdallmann/GamingPCSetup)

- [Windows Internals Sixth Edition Part 1](https://repo.zenk-security.com/Linux%20et%20systemes%20d.exploitations/Windows%20Internals%20Part%201_6th%20Edition.pdf)
