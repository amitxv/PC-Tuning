# Physical Setup

## Hardware

- Ethernet and at least one SSD/NVME is a requirement

- See [Low Latency Hardware | Calypto](https://docs.google.com/document/d/1c2-lUJq74wuYK1WrA_bIvgb89dUN0sj8-hO3vqmrau4/edit)

- Avoid Ryzen as its architecture does not allow for low RAM latencies when compared to Intel as of 2022

- Avoid single-channel and mixing/matching DIMMs

- Ensure your GPU is installed in the top PCIe slot and that it is running at the rated bandwidth in [GPU-Z](https://www.techpowerup.com/gpuz) while running the build-in render test

    - See [media/gpuz-bus-interface.png](../media/gpuz-bus-interface.png)

## Cooling

- Remove the side panels from your case or consider not using one entirely (open bench)

- Mount your AIO properly

    - See [Stop Doing It Wrong: How to Kill Your CPU Cooler | Gamers Nexus](https://www.youtube.com/watch?v=BbGomv195sk)
    - See [media/aio-orientation.png](../media/aio-orientation.png)

- Invest in non-RGB fans with a high static pressure

    - See [PC Fans | Calypto](https://docs.google.com/spreadsheets/d/1AydYHI_M6ov9a3OgVuYXhLEGps0J55LniH9htAHy2wU/edit#gid=0)

- Ensure not to overload the motherboard fan header if you are using splitters

- Remove the heatsink from your DIMMs and mount a fan over it using cable ties

- Along with a M.2/NVME heatsink, optionally place a fan over it

- Configure fan curves or set a static, high, noise-acceptable RPM

## Minimize Interference

- Move devices that produce RF, EMF and EMI such as radios, phones and routers away from your setup as they have the potential to increase latency due to unintended behavior of electrical components
- Always favor wired over cordless
- Ensure there is a moderate amount of space between all cables to reduce the risk of [coupling](https://en.wikipedia.org/wiki/Coupling_(electronics))
- Disconnect unnecessary devices from your motherboard/setup such as LEDs, front panel connectors, unused drives, RGB light strips and all HDDs

## Configure USB Port Layout

- Unplug any other unnecessary devices such as portable device chargers

- Plug your mouse and keyboard into the first two ports on your first USB controller. This can be determined in [USB Device Tree Viewer](https://www.uwe-sieber.de/usbtreeview_e.html#download) with trial and error. Use the motherboard ports and avoid companion ports (indicated on the right section of the program)

    - Ryzen systems have a USB port that is directly connected to the CPU which can be identified through the motherboard manual

- If you have more than one USB controller, you can isolate devices such as DACs, headsets and other devices onto another controller to prevent them interfering with polling consistency

## Configure Peripherals

- Most modern peripherals support onboard memory profiles. You should configure them now (before configuring the operating system) as you will not be required to install the bloatware to change the settings later. More details on separating work/bloatware and gaming environments with a [dual-boot](https://en.wikipedia.org/wiki/Multi-booting) in a later section
- [Higher DPI reduces latency](https://www.youtube.com/watch?v=6AoRfv9W110). Most mice are able to handle 1600 DPI without [sensor smoothing](https://www.reddit.com/r/MouseReview/comments/5haxn4/sensor_smoothing)
- [Higher polling rate reduces jitter](https://www.youtube.com/watch?app=desktop&v=djCLZ6qEVuA). Polling rates higher than 1kHz may negatively impact performance depending on your hardware so adjust accordingly
- USB output is limited to roughly 7A and RGB requires unnecessary power. Turn off RGB where you can or strip the LEDs from the peripheral as [running a RGB effect/animation can take a great toll on the MCU and will delay other processes](https://blog.wooting.nl/what-influences-keyboard-speed)
- Get a [lint roller](https://www.ikea.com/gb/en/p/baestis-lint-roller-grey-90425626) to remove dirt and debris from your mousepad once in a while
- Get a [air dust blower](https://www.amazon.co.uk/s?k=air+dust+blower) to remove dirt and debris from the mouse sensor lens
- Factory reset your monitor and reconfigure the settings. Avoid post-processing effects and set overdrive/AMA to an acceptably [high setting as it reduces latency](https://twitter.com/CaIypto/status/1464236780190851078) but comes with a penalty of overshoot

## BIOS

- Reset all settings to default settings with the option in UEFI

- You can use UEFI and/or grub to change settings. I recommend configuring what you can in UEFI then use [this method](https://github.com/BoringBoredom/UEFI-Editor) to change hidden settings

    - On some boards, you can enable **Hidden OC Item** or **Hide Item** if present to unlock a vast amount of options in UEFI

- Disable [Hyper-Threading/Simultaneous Multithreading](https://en.wikipedia.org/wiki/Hyper-threading). This feature is beneficial for highly threaded operations such as video editing, compiling and rendering however using multiple execution threads per core requires resource sharing and is a potential [source of system latency and jitter](https://www.intel.com/content/www/us/en/developer/articles/technical/optimizing-computer-applications-for-latency-part-1-configuring-the-hardware.html). Other drawbacks include limited overclocking potential due to increased temperatures

- Limit C-States, P-States and S-States to the minimum or disable them. It is a source of jitter due to the process of state transition

- Disable [Virtualization](https://en.wikipedia.org/wiki/Desktop_virtualization) and [IOMMU](https://en.wikipedia.org/wiki/Input%E2%80%93output_memory_management_unit) if applicable as they can cause a [difference in latency for memory access](https://developer.amd.com/wordpress/media/2013/12/PerformanceTuningGuidelinesforLowLatencyResponse.pdf)

- Disable [Active State Power Management](https://en.wikipedia.org/wiki/Active_State_Power_Management) and any other power saving features you can locate

- Disable unnecessary devices such as WLAN, Bluetooth, High Definition Audio Controller (if not using aux/line-in audio) and unused USB, PCIe, iGPU and DIMM slots

- Disable Trusted Platform Module. On Windows 11, a minority of anticheats (Vanguard, FACEIT) require it to be enabled

    - Verify its status in win + r, **tpm.msc**

- Enable High Precision Event Timer

    - On AMD systems with newer AGESA firmware, changing this setting will have no effect

- MBR/Legacy requires Compatibility Support Module and typically, only the storage and PCI OpROMs are required but you can enable all of them if unsure. Disable CSM if using GPT/UEFI

    - Windows 7 UEFI requires CSM and OpROMs unless using [uefiseven](https://github.com/manatails/uefiseven)

- Disable Secure Boot. On Windows 11, a minority of anticheats (Vanguard, FACEIT) require it to be enabled

- Disable Fast Boot or similar options

- Disable DRAM Power Down Mode

- Set a static all-core frequency and voltage for the CPU. Variation in hardware clocks can introduce jitter due to the process of frequency transitions. Enable XMP for your RAM or configure the frequency and timings manually (see MemTestHelper). While increasing frequency or changing timings, ensure that the changes are positive in benchmarks such as [liblava](https://github.com/liblava/liblava) and [MLC](https://www.intel.com/content/www/us/en/developer/articles/tool/intelr-memory-latency-checker.html). Core/uncore/memory affect each other in terms of stability, see the [Stability and Hardware Clocking](#stability-and-hardware-clocking) section for more information

    - Configure load-line calibration to minimize vcore fluctuation under load (try to aim for a flat line), this setting varies between motherboards so do your own research
    - See [integralfx/MemTestHelper](https://github.com/integralfx/MemTestHelper/blob/oc-guide/DDR4%20OC%20Guide.md)

## Stability and Hardware Clocking

Ensure your CPU, RAM and GPU (with overclock applied) are stable before configuring a new operating system as crashes can lead to data corruption or irreversible damage to hardware. There are many tools to test different hardware and every tool may have a different algorithm which is why it is important to use a range of tools. There are countless factors that contribute to stability such as temperature (increases with time, avoid thermal throttling), power quality, quality of VRMs, silicon lottery... Remember, a single error is one too many. Non-exhaustive list of recommended tools are listed below.

- [Linpack-Extended](https://github.com/BoringBoredom/Linpack-Extended)

    - Residuals should match, otherwise it may be a sign of instability
    - GFLOP variation should be minimal 
    - Use a range of problem sizes while testing for stability

- [Prime95](https://www.mersenne.org/download)

- [y-cruncher](http://www.numberworld.org/y-cruncher)

- [Memory Testing Software](https://github.com/integralfx/MemTestHelper/blob/oc-guide/DDR4%20OC%20Guide.md#memory-testing-software)

- [UNIGINE Superposition](https://benchmark.unigine.com/superposition)