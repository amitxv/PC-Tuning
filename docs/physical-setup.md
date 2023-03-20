# Physical Setup

## General

- At least one SSD/NVMe (512 GB or larger preferred) is mandatory in the modern day due to the unreliability, degraded performance and excessive EMI of HDDs

- See [Avoid Multi-CCX Ryzen CPUs (1XXX, 2XXX, 3XXX, 59XX) | Calypto](https://docs.google.com/document/d/1c2-lUJq74wuYK1WrA_bIvgb89dUN0sj8-hO3vqmrau4/edit#bookmark=kix.alwwrke7e395)

- See [Low Latency Hardware | Calypto](https://docs.google.com/document/d/1c2-lUJq74wuYK1WrA_bIvgb89dUN0sj8-hO3vqmrau4/edit#bookmark=kix.alwwrke7e395)

- Avoid single-channel and mixing/matching DIMMs

- Favor PCIe ports that go straight to the CPU rather than PCH. This typically applies to M.2/NVMe SSDs and GPUs (usually the top slot). Beware of limitations with the amount of lanes available

- Ensure that your PCIe devices under the ``PCIe Bus`` category are running at their rated specification (e.g. x16 3.0) in [HWiNFO](https://www.hwinfo.com). The current link width/speed of the device should match the maximum supported

    - Link speed specifically for GPUs that are not limited to P-State 0 will decrease when idling. For this reason, you can check with GPU-Z while running the built-in render test. See [this example](/media/gpuz-bus-interface.png)

    - See [media/hwinfo-pcie-width-speed.png](/media/hwinfo-pcie-width-speed.png)

- IRQ sharing is problematic and is a source of high interrupt latency. Ensure that there is no IRQ sharing on your system by typing ``msinfo32`` in ``Win+R`` then navigating to the Conflicts/Sharing section

    - Enabling [message signaled interrupts](/docs/post-install.md#message-signaled-interrupts) on devices may resolve the software related causes of IRQ sharing but the purpose of checking this now is to resolve the hardware related causes

- Avoid daisy-chaining power cables

- Bufferbloat is a cause of high latency and jitter in packet-switched networks caused by excess buffering of packets. [Measure](https://www.waveform.com/tools/bufferbloat) and [minimize](https://www.bufferbloat.net/projects/bloat/wiki/What_can_I_do_about_Bufferbloat) it

- Tape the end of loose power cables to reduce the risk of shorting components

## Cooling

- Remove the side panels from your case or consider not using one entirely (open bench)

- Delid your CPU and use liquid metal for a [significant thermal improvement](https://www.youtube.com/watch?v=rUy3WcDlBXE). Carry out research before attempting

- Avoid tower/air coolers due to limited cooling potential and lack of space for fans to cool other components

- Consider mounting a fan over VRMs, CPU backplate, storage devices, PCH, NIC and other hot spots

- Mount your AIO properly

    - See [Stop Doing It Wrong: How to Kill Your CPU Cooler | Gamers Nexus](https://www.youtube.com/watch?v=BbGomv195sk)

    - See [media/aio-orientation.png](/media/aio-orientation.png)

- Invest in non-RGB fans with a high static pressure

    - See [PC Fans | Calypto](https://docs.google.com/spreadsheets/d/1AydYHI_M6ov9a3OgVuYXhLEGps0J55LniH9htAHy2wU)

- Ensure not to overload the motherboard fan header if you are using splitters

- Remove the heat sink from your DIMMs and mount a fan over it using cable ties

- Consider using an M.2/NVMe heat sink

- Configure fan curves or set a static, high, noise-acceptable RPM

    - See [Ultimate fan speed curve (by KGCT, iteration 1)](https://imgur.com/a/2UDYXp0)

- Replace stock thermal pads with higher quality ones

- Repaste GPU due to factory application of thermal paste often being inadequate. Also consider replacing the stock fans with higher quality ones

## Minimize Interference

- Move devices that produce RF, EMF and EMI such as radios, cellphones and routers away from your setup as they have the potential to increase latency due to unwanted behavior of electrical components

- Always favor wired over cordless. Wireless devices also tend to implement power saving for a longer battery life

- Ensure that there is a moderate amount of space between all cables to reduce the risk of [coupling](https://en.wikipedia.org/wiki/Coupling_(electronics))

- Disconnect unnecessary devices from your motherboard/setup such as LEDs, RGB light strips, front panel connectors, USB devices, unused drives and all HDDs. Refer to [USB Device Tree Viewer](https://www.uwe-sieber.de/usbtreeview_e.html) for onboard devices (LED controllers, IR receivers) and disable them in BIOS if you can not physically disconnect them

## Configure USB Port Layout

- Plug your mouse and keyboard into the first two ports on your first USB controller. This can be determined in [USB Device Tree Viewer](https://www.uwe-sieber.de/usbtreeview_e.html) with trial and error. Use the motherboard ports and avoid companion ports (indicated in the right section of the program) as the data has to go through a hub

    - Ryzen systems have a USB controller that is directly connected to the CPU which can be identified under the ``PCIe Bus`` category in [HWiNFO](https://www.hwinfo.com). It is usually the USB controller that is connected to a ``Internal PCIe Bridge`` which is also labeled with the CPU architecture

        - See [media/ryzen-xhci-controller.png](/media/ryzen-xhci-controller.png)

- If you have more than one USB controller, you can isolate devices such as DACs, headsets and other devices onto another controller to [prevent them interfering with polling consistency](https://forums.blurbusters.com/viewtopic.php?f=10&t=7618#p58449)

## Configure Peripherals

- Most modern peripherals support onboard memory profiles. Configure them before configuring the operating system as you will not be required to install the bloatware to change the settings later. More details on separating work/bloatware and gaming environments with a [dual-boot](https://en.wikipedia.org/wiki/Multi-booting) in the next section

- [Higher DPI reduces latency](https://www.youtube.com/watch?v=6AoRfv9W110). Most mice are able to handle 1600 DPI without [sensor smoothing](https://www.reddit.com/r/MouseReview/comments/5haxn4/sensor_smoothing). Optionally [reduce the pointer speed](https://boringboredom.github.io/tools/#/WinSens) in Windows. This will not interfere with in-game input as modern games use raw input

- [Higher polling rate reduces jitter](https://www.youtube.com/watch?app=desktop&v=djCLZ6qEVuA). Polling rates higher than 1kHz may negatively impact performance depending on your hardware so adjust accordingly

- USB output is limited to roughly 7A and RGB requires unnecessary power. Turn off RGB where you can or strip the LEDs from the peripheral as [running an RGB effect/animation can take a great toll on the MCU and will delay other processes](https://blog.wooting.nl/what-influences-keyboard-speed)

    - See [OpenRGB](https://openrgb.org)

- Use [Mouse Tester](https://github.com/microe1/MouseTester) to check if each poll contains data. If the interval is spiking to 2ms (500hz) or higher from 1ms (1000hz), this is obviously problematic and often caused by an inadequate sensor

- Get a [lint roller](https://www.ikea.com/us/en/p/baestis-lint-roller-gray-90425626) to remove dirt and debris from your mouse pad

- Get an [air dust blower](https://www.amazon.com/s?k=air+dust+blower) to remove dirt and debris from the mouse sensor lens

- Factory reset your monitor and reconfigure the settings. Avoid post-processing effects and set overdrive/AMA to an acceptably high setting [as it reduces latency](https://twitter.com/CaIypto/status/1464236780190851078) but comes with a penalty of additional overshoot

## BIOS

- Check Spectre, Meltdown and CPU microcode status after following the steps in the [Spectre, Meltdown and CPU Microcode](/docs/post-install.md#spectre-meltdown-and-cpu-microcode) section on your current operating system. If you are unable to reproduce the results in the example images, you may need to roll back microcode on a BIOS level

- Reset all settings to default settings with the option in BIOS to work with a clean slate

- You can use BIOS and/or GRUB to change settings. I recommend configuring what you can in BIOS then use [this method](https://github.com/BoringBoredom/UEFI-Editor#how-to-change-hidden-settings-without-flashing-a-modded-bios) to change hidden settings

    - On some boards, you can enable Hidden OC Item or Hide Item if present to unlock a vast amount of options in BIOS

- Disable [Hyper-Threading/Simultaneous Multithreading](https://en.wikipedia.org/wiki/Hyper-threading). This feature is beneficial for highly threaded operations such as encoding, compiling and rendering however using multiple execution threads per core requires resource sharing and is a potential [source of system latency and jitter](https://www.intel.com/content/www/us/en/developer/articles/technical/optimizing-computer-applications-for-latency-part-1-configuring-the-hardware.html). Other drawbacks include limited overclocking potential due to increased temperatures

- Limit C-States, P-States and S-States to the minimum or disable them completely. It is a source of jitter due to the process of state transition

    - Verify S-State status with ``powercfg -a`` in CMD

- Disable [Virtualization](https://en.wikipedia.org/wiki/Desktop_virtualization) and [IOMMU](https://en.wikipedia.org/wiki/Input%E2%80%93output_memory_management_unit) if applicable as they can cause a [difference in latency for memory access](https://developer.amd.com/wordpress/media/2013/12/PerformanceTuningGuidelinesforLowLatencyResponse.pdf)

- Disable all power saving features such as [Active State Power Management](https://en.wikipedia.org/wiki/Active_State_Power_Management), [Aggressive Link Power Management](https://en.wikipedia.org/wiki/Aggressive_Link_Power_Management), DRAM Power Down Mode, PCI Clock Gating etc. Search the internet if you are unsure whether a given setting is power saving related

- Disable unnecessary devices such as WLAN, Bluetooth, High Definition Audio (if you are not using aux/line-in audio) controllers and unused USB ports (refer to [USB Device Tree Viewer](https://www.uwe-sieber.de/usbtreeview_e.html)), PCIe slots, iGPU and DIMM slots

- Disable Trusted Platform Module. On Windows 11, a minority of anticheats (Vanguard, FACEIT) require it to be enabled

    - Verify TPM status by typing ``tpm.msc`` in ``Win+R``

- Enable High Precision Event Timer. If the setting is hidden, there is a good chance that it is enabled by default

    - On AMD systems with newer AGESA firmware, changing this setting will have no effect

- Resizable BAR requires GPT/UEFI

- MBR/Legacy requires Compatibility Support Module and typically, only the storage and PCI OpROMs are required, but you can enable all of them if you are unsure. Disable CSM if you are using GPT/UEFI

    - Windows 7 UEFI requires CSM and OpROMs unless you are using [uefiseven](https://github.com/manatails/uefiseven)

- Disable Secure Boot. On Windows 11, a minority of anticheats (Vanguard, FACEIT) require it to be enabled

- Disable Fast Startup or similar options

- Disable Spread Spectrum and ensure BCLK frequency is close to 100.00 as possible in [HWiNFO](https://www.hwinfo.com)/[CPU-Z](https://www.cpuid.com/softwares/cpu-z.html)

- Disable Legacy USB Support as [it generates unnecessary SMIs](https://patents.google.com/patent/US6067589). You may need to turn this on while installing a new operating system or to access BIOS

- Set the primary graphics to dGPU instead of iGPU if applicable

- Set PCIe link speed to the maximum supported (e.g. Gen 4.0)

- As we will be configuring a static frequency/voltage for the CPU, disable dynamic frequency features such as Speed Shift, SpeedStep, Turbo Boost and set the AVX offset to 0 so that the CPU does not downclock during AVX workloads

    - In some cases, the settings mentioned above may prevent the processor exceeding its base frequency despite manually configuring it in BIOS. Adjust accordingly if this is encountered

- Set a static all-core frequency and voltage for the CPU. Variation in hardware clocks can introduce jitter due to the process of frequency transitions. Enable XMP for your RAM or configure the frequency and timings manually (see MemTestHelper). While increasing frequency or changing timings, ensure that the changes scale positively in benchmarks such as [liblava](https://github.com/liblava/liblava) and [MLC](https://www.intel.com/content/www/us/en/developer/articles/tool/intelr-memory-latency-checker.html) due to error correction. Core/uncore/memory affect each other in terms of stability, see the [Stability and Hardware Clocking](#stability-hardware-clocking-and-thermal-performance) section for more information

    - Configure load-line calibration to minimize vcore fluctuation under load (try to aim for a flat line), this setting varies between motherboards so do your own research
    - See [integralfx/MemTestHelper](https://github.com/integralfx/MemTestHelper/blob/oc-guide/DDR4%20OC%20Guide.md)

- Try not to leave voltage settings on automatic due to potentially overvolting to a dangerous level

## Stability, Hardware Clocking and Thermal Performance

Ensure your CPU, RAM and GPU (with overclock applied) are stable before configuring a new operating system as crashes can lead to data corruption or irreversible damage to hardware. There are many tools to test different hardware and algorithms vary between tools which is why it is important to use a range of them (non-exhaustive list of recommended tools are listed below).

- Ensure to disable CUDA - Force P2 State with [NVIDIA Profile Inspector](https://github.com/Orbmu2k/nvidiaProfileInspector) to prevent memory downclocking while stress testing

- There are countless factors that contribute to stability such as temperature, power quality, quality of VRMs, silicon lottery...

- A single error is one too many

- Avoid thermal throttling at all costs, ambient temperature will increase during the summer which can be replicated with a heater to create a worst-case scenario. An important note to make is that you can pass hours of stress tests (e.g. RAM) but as soon as another component (e.g. GPU) begins to warm up, you will encounter instability so ensure to cater for such scenario

- Deliberately underclock if your cooler is inadequate. A thermally stable component with an overall lower frequency is always better than thermal throttling at a higher frequency

- Use [HWiNFO](https://www.hwinfo.com) to monitor system sensors, a higher polling interval can help to identify sudden spikes. Avoid running while benchmarking as it has the potential to reduce the reliability of results

- Disable the paging file and use safe mode for stress testing preferably on a throwaway operating system in case it becomes corrupted

- Tools

    - [Linpack-Extended (Intel)](https://github.com/BoringBoredom/Linpack-Extended)/[Linpack Xtreme Bootable](https://www.techpowerup.com/download/linpack-xtreme/)

        - Use a range of [problem sizes](https://github.com/BoringBoredom/Linpack-Extended/blob/master/leading%20dimensions.html)

        - Residuals should match, otherwise it is a sign of instability

        - GFLOP variation should be minimal

    - [Prime95](https://www.mersenne.org/download) - Small/Large FFTs

    - [y-cruncher](http://www.numberworld.org/y-cruncher)

    - [Memory Testing Software](https://github.com/integralfx/MemTestHelper/blob/oc-guide/DDR4%20OC%20Guide.md#memory-testing-software)

    - [UNIGINE Superposition](https://benchmark.unigine.com/superposition)

    - [OCCT](https://www.ocbase.com/) - VRAM
