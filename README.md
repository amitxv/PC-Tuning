# PC-Tuning

[![Discord](https://discordapp.com/api/guilds/994887453599076422/widget.png?style=shield)](https://discord.com/invite/yrAnChXXZw)

[![Buy Me A Coffee](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/amitxv)

## Rationale

Latency refers to the time between initiating an action and experiencing the outcome such as a mouse click to pixel response which may be described as the entire latency pipeline. While several factors determine a computer's overall performance, latency is one primary driving factor that contributes to the perceived responsiveness of a system ([1](https://www.youtube.com/watch?v=vOvQCPLkPt4)). There are several components in the latency pipeline ([1](https://developer-blogs.nvidia.com/wp-content/uploads/2023/05/components-end-to-end-system-latency.png)). Reducing the time spent in any subcomponent of the pipeline contributes to reducing the time of the overall pipeline.

In this guide, you will learn how to configure your hardware, the operating system and software to reduce the time of the entire pipeline. Users are expected to follow the guidance in the sequential order listed below, starting with [Physical Setup](#1-physical-setup) through to [Post-Install Instructions](#3-post-install-instructions). Reducing the time of the pipeline is achieved in several ways such as overclocking the hardware, reducing CPU overhead by minimizing unnecessary interrupts and context switching and much more. It is important to mention that the content is not limited to minimizing latency. The guidance also elaborates on aiding privacy, addressing security concerns and improving the overall user experience. Namely, Windows is notorious for its ever-growing bloatware and third-party telemetry ([1](https://www.youtube.com/watch?v=yVNkMNVv4Y4), [2](https://www.youtube.com/watch?v=hwNAa_OdP1w)).

As pre-modified Windows ISOs and setup scripts have gained popularity over the years, the convenience of using them may be appealing to cut down on setup time. However, fine-tuning your own installation of Windows to suit your needs will outperform such projects that cater for a general audience. Furthermore, some of these projects are not open source so apart from them being potentially malicious, the performance and user experience related changes are unknown thus you will not be able to benchmark how certain changes influence performance scaling on your system as explained in the [Benchmarking](#benchmarking) section. They also lack information related to configuring the hardware, BIOS, overclocking, component stability and much more which is profoundly impactful but seems to be completely disregarded by the user base. On the contrary, the guidance involves instructions to customize an official Windows ISO using DISM then reinstall Windows which is necessary to eliminate apparent inconsistencies between systems assumed in the guidance.

## Staying Informed

The contents and information included in this repository will inevitably change over time. To stay up to date, it is recommended to review what has changed once in a while. At the time of reviewing, take a note of the 7 digit SHA code in the [latest commit](https://github.com/amitxv/PC-Tuning/commit/main) (e.g. ``2428150``) then use the URL below as an example to compare what has changed since the noted commit.

<https://github.com/amitxv/PC-Tuning/compare/2428150..main>

## Benchmarking

Before diving into the main content, it is important to learn and understand how to benchmark properly and what the appropriate tools for a given task are as you will need to carry out your own experiments throughout the guide to assist in decision-making (e.g. settings to use, verify performance scaling) rather than blindly applying settings.

- **[FrameView](https://www.nvidia.com/en-gb/geforce/technologies/frameview)** - [PC Latency](https://images.nvidia.com/content/images/article/system-latency-optimization-guide/nvidia-latency-optimization-guide-pc-latency.png) in games that support [PC Latency Stats](https://www.nvidia.com/en-gb/geforce/technologies/reflex/supported-products) and frame pacing
- **[PresentMon](https://boringboredom.github.io/Frame-Time-Analysis)** - Various metrics such as frame pacing and [GPU Busy](https://www.intel.com/content/www/us/en/docs/gpa/user-guide/2022-4/gpu-metrics.html). See a full list [here](https://github.com/GameTechDev/PresentMon/blob/main/README-CaptureApplication.md#metric-definitions)
- **[Windows Performance Toolkit](https://learn.microsoft.com/en-us/windows-hardware/test/wpt)** - Advanced performance analysis library for Windows. Measure ISR/DPC execution times with [xperf](https://gist.github.com/amitxv/896a68330d037684fee5b933102f24f2)
- **[Mouse Tester](https://github.com/amitxv/MouseTester)** - Polling interval, X/Y counts and more plots against time
- **[NVIDIA Reflex Analyzer](https://www.nvidia.com/en-gb/geforce/news/reflex-latency-analyzer-360hz-g-sync-monitors)** - End-to-end latency
- **[Frame-Time-Analysis](https://boringboredom.github.io/Frame-Time-Analysis)** - Analyze CSV data logged by the programs mentioned above including 1%, 0.1% lows metrics
- **[Reflex Latency Analyzer Grapher](https://boringboredom.github.io/tools/nvidialatencygrapher)** - Analyze latency results from RLA and FrameView

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

- [Calypto's Latency Guide](https://calypto.us)

- [djdallmann/GamingPCSetup](https://github.com/djdallmann/GamingPCSetup)

- [klasbo/GamePerfTesting](https://github.com/klasbo/GamePerfTesting)

- [sieger/handbook](https://github.com/sieger/handbook)

- Windows Internals, Part 1: System Architecture, Processes, Threads, Memory Management, and More

- Windows Internals, Part 2
