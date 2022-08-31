# Physical Setup

## Cooling

- Consider not using a case (open bench), best case cooling scenario. If you must use a case, at least remove the side panels

- Remove the heatsink from your RAM & mount a fan over it using zipties

- Mount your AIO properly

    - See [Stop Doing It Wrong: How to Kill Your CPU Cooler | Gamers Nexus](https://www.youtube.com/watch?v=BbGomv195sk)

    - See [media/aio-orientation.png](../media/aio-orientation.png)

- Configure fan curves or set a static fan speed for the CPU & case fans. I personally set all fans to a reasonably high, constant, noise-acceptable speed

- Ensure not to overload the motherboard fan header if using splitters, check your motherborad manual for the maximum current supported by each header

## USB Port Configuration

- Plug your mouse & keyboard into the first two ports on your first USB controller. This can be determined in [USB Device Tree Viewer](https://www.uwe-sieber.de/usbtreeview_e.html#download) with trial & error. Use the motherboard ports & avoid companion ports (indicated on the right section of the program)

    - Ryzen systems have a USB port that is directly connected to the CPU which can be identified through the motherboard manual

- If you have more than one USB controller, you can isolate devices such as DACs, headsets & other devices onto another controller to prevent them interfering with polling consistency

- Unplug any other unnecessary devices (charge your phone somewhere else for goodness sake)

## BIOS

- You can use UEFI or grub to change both visible & hidden BIOS settings. I recommend configuring what you can in UEFI then use [this method](https://github.com/BoringBoredom/UEFI-Editor) to change hidden settings

    - On some BIOSs, you can enable **Hidden OC Item** or **Hide Item** to unlock a vast amount of settings in UEFI

- Disable [Hyper-Threading](https://en.wikipedia.org/wiki/Hyper-threading)/[Simultaneous Multithreading](https://en.wikipedia.org/wiki/Simultaneous_multithreading). This feature is beneficial for highly threaded operations such as video editing, compiling & rendering however using multiple execution threads per core requires resource sharing & is a potential source of system latency & jitter [[1](https://developer.amd.com/wordpress/media/2013/12/PerformanceTuningGuidelinesforLowLatencyResponse.pdf), [2](https://www.intel.com/content/www/us/en/developer/articles/technical/optimizing-computer-applications-for-latency-part-1-configuring-the-hardware.html)]. Other drawbacks include limited overclocking potential & increased core package temperatures

- Limit C-States, P-States & S-States to the minimum or disable them. It is a source of jitter due to the process of state transition

- Disable [Virtualization](https://en.wikipedia.org/wiki/Desktop_virtualization) & [IOMMU](https://en.wikipedia.org/wiki/Input%E2%80%93output_memory_management_unit) if applicable, it can cause differences in latency for memory access [[1](https://developer.amd.com/wordpress/media/2013/12/PerformanceTuningGuidelinesforLowLatencyResponse.pdf), [2](https://www.intel.com/content/www/us/en/developer/articles/technical/optimizing-computer-applications-for-latency-part-1-configuring-the-hardware.html)]

- Disable [ASPM/Active State Power Management](https://en.wikipedia.org/wiki/Active_State_Power_Management) & any other power saving features you can locate in BIOS

- Disable unnecessary devices such as WLAN, bluetooth, unused USB controllers & unused PCI ports

- Disable TPM/Trusted Platform Module

    - You can verify that it is disabled in win + r, **tpm.msc**

- Keep HPET/High Precision Event Timer enabled

    - On AMD systems with newer AGESA firmware, disabling this setting will have no effect

- Disable the integrated GPU if not in use

- Windows 7 requires CSM/Compatibility Support Module to be enabled, disable it if configuring Windows 8+

- Disable Secure Boot

- Disable Fast Boot or similar options

- Disable DRAM Power Down Mode

- Set a static all-core frequency & voltage for the CPU. Variation in hardware clocks can introduce jitter due to the frequency transitions of cores [[1](https://developer.amd.com/wordpress/media/2013/12/PerformanceTuningGuidelinesforLowLatencyResponse.pdf)]. Enable XMP for your RAM or configure the frequency & timings manually (see MemTestHelper). While raising the clock frequency or changing timings, ensure that the changes are positive in benchmarks such as [liblava](https://github.com/liblava/liblava) & [MLC](https://www.intel.com/content/www/us/en/developer/articles/tool/intelr-memory-latency-checker.html). Core/uncore/memory affect each other in terms of stability, see the [Stability & Hardware Clocking](#stability--hardware-clocking) section for more information

    - Configure load-line calibration to minimize vcore fluctuation under load (try to aim for a flat line), this setting varies between motherboards so do your own research

    - See [integralfx/MemTestHelper](https://github.com/integralfx/MemTestHelper/blob/oc-guide/DDR4%20OC%20Guide.md)

## Minimizing Interference

- Move devices that emit RF/EMF/EMI away from your setup & bedroom such as radios, mobile phones & routers. They have the potential to increase latency due to unintended behaviour of electrical components

- Always favor wired over cordless

- Ensure there is a moderate amount of space between cables to reduce the risk of [coupling](https://en.wikipedia.org/wiki/Coupling_(electronics))

- Disconnect unnecessary devices from your motherboard such as LEDs, case USB ports, extra unused drives & RGB light strips

## Configure Peripherals

- If your peripherals support onboard memory profiles, it is recommended to configure them before booting into the Windows image you plan on configuring as you will not need to install bloatware to configure this later. More details on separating work & gaming environments with a [dual-boot](https://en.wikipedia.org/wiki/Multi-booting) later in the guide

- Increasing DPI reduces latency [[1](https://www.youtube.com/watch?v=6AoRfv9W110)]. Most mice are able to handle 1600 DPI without [sensor smoothing](https://www.reddit.com/r/MouseReview/comments/5haxn4/sensor_smoothing)

- Higher polling rate reduces jitter [[1](https://youtu.be/gOQNRvJbpmk?t=540), [2](https://www.youtube.com/watch?app=desktop&v=djCLZ6qEVuA)]. Depending on your hardware, 8kHz may heavily impact performance while in use, in this case, consider downclocking slightly (4kHz, 2kHz & 1kHz options are commonly available)

- USB output is limited to roughly 7A & RGB requires unnecessary power. Turn off RGB where you can or strip the LED from the peripheral as running a RGB effect/animation can take a great toll on the MCU. It requires a lot of processing power & will delay other processes [[1](https://blog.wooting.nl/what-influences-keyboard-speed)]

- Buy a [lint roller](https://www.ikea.com/gb/en/p/baestis-lint-roller-grey-90425626) to remove dirt & debris from the mousepad once in a while

- Buy a small [air dust blower](https://www.amazon.co.uk/s?k=air+dust+blower) to remove dirt & debris from the mouse sensor lens often

- Factory reset your monitor & reconfigure the settings. Avoid post-processing effects & set overdrive/AMA to an acceptably high setting as it reduces latency but comes with a penalty of overshoot [[1](https://twitter.com/CaIypto/status/1464236780190851078)]

## Stability & Hardware Clocking

- Ensure your CPU, RAM & GPU are completely stable before configuring a new operating system as crashes can lead to data corruption or irreversible damage to hardware

- There are many tools to stress different components & every tool may have different algorithms which is why it is a good idea to use a variety of tools. There are countless factors that contribute to stability such as temperature, power quality, quality of VRMs, silicon lottery etc
