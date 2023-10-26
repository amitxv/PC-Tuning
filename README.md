# PC-Tuning
<a href="https://discord.com/invite/yrAnChXXZw">
  <img src="https://discordapp.com/api/guilds/994887453599076422/widget.png?style=shield" alt="Discord" width="120"/></a>
<a href="https://www.buymeacoffee.com/amitxv">
  <img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy me a coffee" width="95"/>
</a>

## Rationale

Windows is notorious for its ever-growing bloatware, third-party telemetry, excessive context switching, interrupts and I/O. This repository was created in hope of standardizing systems for latency-sensitive tasks and minimizing unwanted outgoing traffic. Note that the OS-related sections aren't indented to be followed on existing Windows installations. On the contrary, the mentioned sections will guide you to customize an ISO using DISM then reinstall Windows properly.

This repository may contain information similar to those of the projects listed in the [Further Reading](#further-reading) section, however, it isn't my intention to directly copy from them.

The guidance is currently updated and has been tested on client and server editions of Windows 7 through to Windows 11 (x64). See a full list of [issues](https://github.com/amitxv/PC-Tuning/issues). Users are expected to follow the guidance in the order listed below starting with [Physical Setup](#1-physical-setup) through to [Post-Install Instructions](#3-post-install-instructions).

## Staying Informed

The contents and information included in this repository will inevitably change over time. To stay up to date, I would recommend reviewing what has changed once in a while. At the time of reviewing, take a note of the 7 digit SHA code in the [latest commit](https://github.com/amitxv/PC-Tuning/commit/main) (e.g. ``2428150``) then use the URL below as an example to compare what has changed since the noted commit.

<https://github.com/amitxv/PC-Tuning/compare/2428150..main>

## Benchmarking

Before diving into the main content, is important to learn and understand how to benchmark properly and what the appropriate tools for a given task are as you will need to carry out your own experiments throughout the guide to assist in decision-making (e.g. settings to use, verify performance scaling) rather than blindly applying settings. A non-exhaustive list of factors to consider are noted below.

- **Controlled Environment** - Create a controlled and consistent testing environment to minimize the influence of external factors affecting the results. (e.g. close background programs)
- **Variables** - Identify and control both independent (manipulated) and dependent (measured) variables in your experiment (e.g. don't change more than one variable at once)
- **Sample Size** - Determine an appropriate sample size to achieve statistical significance based on the benchmark. A low sample size may be misleading due to benchmark variance
- **Reproducibility** - Ensure that your results can be replicated by yourself and others following the same procedures (e.g. after multiple system reboots in case of variance)

### Tools

- **[FrameView](https://www.nvidia.com/en-gb/geforce/technologies/frameview)** - [PC Latency](https://images.nvidia.com/content/images/article/system-latency-optimization-guide/nvidia-latency-optimization-guide-pc-latency.png) in games that support [PC Latency Stats](https://www.nvidia.com/en-gb/geforce/technologies/reflex/supported-products) and frame pacing. Uses a proprietary version of [PresentMon](https://github.com/GameTechDev/PresentMon) for underlying data collection
- **[PresentMon](https://github.com/GameTechDev/PresentMon)** - Various metrics such as frame pacing and [GPU Busy](https://www.intel.com/content/www/us/en/docs/gpa/user-guide/2022-4/gpu-metrics.html). See a full list [here](https://github.com/GameTechDev/PresentMon/blob/main/README-CaptureApplication.md#metric-definitions)
- **[Windows Performance Toolkit](https://learn.microsoft.com/en-us/windows-hardware/test/wpt)** - Advanced performance analysis library for Windows. Measure ISR/DPC execution times with [xperf](/bin/scripts/xperf-dpcisr.bat)
- **[Mouse Tester](https://github.com/amitxv/MouseTester)** - Polling interval, X/Y counts and more plots against time
- **[NVIDIA Reflex Analyzer](https://www.nvidia.com/en-gb/geforce/news/reflex-latency-analyzer-360hz-g-sync-monitors)** - End-to-end latency
- **[Frame-Time-Analysis](https://github.com/BoringBoredom/Frame-Time-Analysis)** - Analyze CSV data logged by the programs mentioned above including 1%, 0.1% lows metrics
- **[Reflex Latency Analyzer Grapher](https://boringboredom.github.io/tools/#/RLA)** - Analyze latency results from RLA and FrameView

## Requirements

- USB Storage Device (8 GB minimum)
- [Ventoy](https://github.com/ventoy/Ventoy/releases)
- Any live Linux distribution
- Familiarity with navigating directories in CLI

## 1. Physical Setup

- See [docs/physical-setup.md](/docs/physical-setup.md)

## 2. Pre-Install Instructions

- See [docs/pre-install.md](/docs/pre-install.md)

## 3. Post-Install Instructions

- See [docs/post-install.md](/docs/post-install.md)

## 4. Research

- See [docs/research.md](/docs/research.md)

## Further Reading

- [BoringBoredom/PC-Optimization-Hub](https://github.com/BoringBoredom/PC-Optimization-Hub)

- [Calypto's Latency Guide](https://docs.google.com/document/d/1c2-lUJq74wuYK1WrA_bIvgb89dUN0sj8-hO3vqmrau4)

- [djdallmann/GamingPCSetup](https://github.com/djdallmann/GamingPCSetup)

- [klasbo/GamePerfTesting](https://github.com/klasbo/GamePerfTesting)

- [sieger/handbook](https://github.com/sieger/handbook)

- Windows Internals, Part 1: System Architecture, Processes, Threads, Memory Management, and More

- Windows Internals, Part 2
