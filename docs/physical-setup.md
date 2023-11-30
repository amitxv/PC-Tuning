# Physical Setup

## General

- Typically, you should re-install Windows after major hardware swaps (e.g. motherboard, CPU, platform, chipsets)

- See [Avoid Multi-CCX Ryzen CPUs | Calypto](https://docs.google.com/document/d/1c2-lUJq74wuYK1WrA_bIvgb89dUN0sj8-hO3vqmrau4/edit)

- See [Low Latency Hardware | Calypto](https://docs.google.com/document/d/1c2-lUJq74wuYK1WrA_bIvgb89dUN0sj8-hO3vqmrau4/edit#bookmark=kix.alwwrke7e395)

- Always favor wired over cordless as wireless devices tend to implement aggressive power-saving for a longer battery life along with the downside of excessive interference

- An SSD or NVMe is strongly recommended due to the unreliability, degraded performance and excessive interference of HDDs. Ensure that there is always a sufficient amount of free space as [SSDs slow down as they are filled up](https://www.howtogeek.com/165542/why-solid-state-drives-slow-down-as-you-fill-them-up)

- Assess the general condition of storage devices with [CrystalDiskInfo](https://crystalmark.info/en/software/crystaldiskinfo) and [CrystalDiskMark](https://crystalmark.info/en/software/crystaldiskmark). When purchasing a new drive, check the total host read/writes to determine whether it is unused

- Update the firmware for devices such as storage, network interface controller, peripherals and more

- Avoid single-channel and mismatching RAM. Refer to the motherboard manual to ensure that they are in the correct slots. Consider the memory trace layout when determining the amount of sticks to use

- Favor PCIe ports that go straight to the CPU rather than PCH, this typically applies to M.2, NVMe and GPUs. This can be determined with the ``PCIe Bus`` category in [HWiNFO](https://www.hwinfo.com). Beware of limitations with the amount of lanes available

- Ensure that your PCIe devices under the ``PCIe Bus`` category are running at their rated specification such as ``x16 3.0`` in [HWiNFO](https://www.hwinfo.com). The current link width/speed of the device should match the maximum supported

    - The link speed for GPUs that aren't limited to P-State 0 may decrease when idling. Check with [GPU-Z](https://www.techpowerup.com/gpuz) while running the built-in render test

        - See [media/gpuz-bus-interface.png](/media/gpuz-bus-interface.png)

    - See [media/hwinfo-pcie-width-speed.png](/media/hwinfo-pcie-width-speed.png)

- IRQ sharing is problematic and is a source of high interrupt latency. Ensure that there is no IRQ sharing on your system by typing ``msinfo32`` in ``Win+R`` then navigating to the ``Conflicts/Sharing section``

    - Enabling [message signaled interrupts](/docs/post-install.md#message-signaled-interrupts) on devices may resolve the software-related causes of IRQ sharing but the purpose of checking IRQ sharing now is to resolve the hardware-related causes

- An Ethernet cable is strongly recommended due to the unreliability, degraded performance and excessive interference of wireless connections

- If you have more than one onboard Ethernet network interface controller, consider using the one that supports MSI-X by checking in [MSI Utility](https://forums.guru3d.com/threads/windows-line-based-vs-message-signaled-based-interrupts-msi-tool.378044) or [GoInterruptPolicy](https://github.com/spddl/GoInterruptPolicy) as it is required [for RSS to function properly](https://www.reddit.com/r/intel/comments/9uc03d/the_i219v_nic_on_your_new_z390_motherboard_and). This can be achieved by plugging the Ethernet cable into the corresponding port on the motherboard

- Measure and minimize bufferbloat as it is a cause of high latency and jitter in packet-switched networks caused by excess buffering of packets

    - See [Bufferbloat and Internet Speed Test](https://www.waveform.com/tools/bufferbloat)

    - See [How to test your Internet Ping (PingPlotter)](https://support.netduma.com/support/solutions/articles/16000074717-how-to-test-your-internet-ping)

    - See [What Can I Do About Bufferbloat?](https://www.bufferbloat.net/projects/bloat/wiki/What_can_I_do_about_Bufferbloat)

- Avoid daisy-chaining power cables anywhere in your setup

- Tape the end of loose power cables to reduce the risk of short-circuiting components

- Favor shielded cables and avoid unnecessarily long ones

- Clean dust from components and heat sinks as they have the potential to cause short circuits and reduce airflow

    - See [Dust: The Computer Killer](https://www.armagard.co.uk/articles/dust-computer-killer.html)

- Clean the pins and connectors of components. Use compressed air to remove dust from slots before installing components such as PCIe, NVMe, RAM and more

    - See [Cleaning contacts on RAM Memory and Graphics Card | zodox](https://www.youtube.com/watch?v=OTrzzC10Scg)

- If applicable, don't make the mistake of plugging in the display cable in to the motherboard port in the event of a dGPU being present

- If you aren't already using the partition style you would like to be using, you should switch now because some settings listed in the [BIOS](#bios) section depend on the partition style (search for *"GPT/UEFI"*). The official method to convert the partition style is to wipe and convert the disk using diskpart within Windows setup. GPT/UEFI is recommended for most people

    - See [media/identify-bios-mode.png](/media/identify-bios-mode.png)

    - See [MBR vs GPT: Which One Is Better for You?](https://www.diskpart.com/gpt-mbr/mbr-vs-gpt-1004.html)

    - See [How to Convert MBR to GPT During Windows 10/8/7 Installation | MDTechVideos](https://www.youtube.com/watch?v=f81qKAJUdKc)

- Consider what Windows version you will be using because some settings listed in the [BIOS](#bios) section depend on the Windows version used (search for *"Windows"*)

    - See [What Version of Windows Should You Use?](/docs/pre-install.md#what-version-of-windows-should-you-use)

- Avoid a multi-monitor setup as there is the potential for greater processing overhead

    - See [Extra Monitors DO Hurt Your Gaming Performance | Linus Tech Tips](https://www.youtube.com/watch?v=5wBxYQdN96s)

## Cooling

- Remove the side panels from your case or consider an open-bench setup

- Delid your CPU and use liquid metal for a [significant thermal improvement](https://www.youtube.com/watch?v=rUy3WcDlBXE). Direct die and lapping are also worth considering

- Use a contact frame if your CPU/socket is affected by ILM issues

    - See [Investigating Intel's CPU Socket Problems | Thermal Grizzly Contact Frame Benchmark | Gamers Nexus](https://www.youtube.com/watch?v=Ysb25vsNBQI)

- Check for contact patches on the IHS/Die and cold plate

- Use high-quality TIM (thermal interface material) and an adequate amount upon application

    - See [Best Thermal Paste for CPUs](https://www.tomshardware.com/best-picks/best-thermal-paste)

- Avoid tower and air coolers due to limited cooling potential and lack of space for fans to cool other components such as RAM and VRMs

- Mount your AIO cooler properly

    - See [Stop Doing It Wrong: How to Kill Your CPU Cooler | Gamers Nexus](https://www.youtube.com/watch?v=BbGomv195sk)

- Use non-RGB fans with a high static pressure

    - See [PC Fans | Calypto](https://docs.google.com/spreadsheets/d/1AydYHI_M6ov9a3OgVuYXhLEGps0J55LniH9htAHy2wU)

- Ensure not to overload the motherboard fan header, especially if you are using splitters

- Remove the heat sink from your RAM and get creative with mounting a fan over it (e.g. using cable ties)

- Use an M.2/NVMe heat sink

- Mount a fan over VRMs, CPU backplate, storage devices, PCH, network interface controller and other hot spots

- Replace stock thermal pads with higher-quality ones

- Repaste GPU due to factory application of thermal paste often being inadequate and replace the stock fans with higher quality ones

- Consider replacing the stock PSU fan and connecting it to a motherboard fan header for potentially greater efficiency. Most modern PSUs ship with a zero-rpm mode

## Minimize Interference

- Move devices that produce interference such as radios, cell phones, routers and more away from your setup as they have the potential to increase latency due to unwanted behavior of electrical components

- Ensure that there is a moderate amount of space between all cables to reduce the risk of [coupling](https://en.wikipedia.org/wiki/Coupling_(electronics))

- Disconnect unnecessary devices from your motherboard, setup and peripherals such as LEDs, RGB light strips, front panel connectors, USB devices, unused drives and all HDDs. Refer to [USB Device Tree Viewer](https://www.uwe-sieber.de/usbtreeview_e.html) for onboard devices (LED controllers, IR receivers) and disable them in BIOS if you can not physically disconnect them

    - Some motherboards have the High Definition Audio controller (motherboard audio) linked to the XHCI controller

> [!NOTE]
> Take a note of any BIOS related changes as they might be reset in the first few steps of the [BIOS](#bios) section.

## Configure USB Port Layout

- Favor the first few ports on the desired XHCI controller. Some of them may not be physically accessible which can be determined in [USB Device Tree Viewer](https://www.uwe-sieber.de/usbtreeview_e.html) with trial and error. Use the motherboard ports, avoid companion ports (indicated in the right section of the program) and [internal headers](/media/xhci-internal-headers.png) as the data must go through hubs

    - Ryzen systems have an XHCI controller that is directly connected to the CPU which can be identified under the ``PCIe Bus`` category in [HWiNFO](https://www.hwinfo.com). It is usually the XHCI controller that is connected to an ``Internal PCIe Bridge X to bus`` which is also labeled with the CPU architecture

        - See [media/ryzen-xhci-controller.png](/media/ryzen-xhci-controller.png)

- If you have more than one XHCI controller, you can isolate devices such as your mouse, keyboard and audio devices (if any) onto another controller to [prevent them from interfering with polling consistency](https://forums.blurbusters.com/viewtopic.php?f=10&t=7618#p58449)

## Configure Peripherals

- Most modern peripherals support onboard memory profiles. Configure them before configuring the operating system as you will not be required to install the bloatware to change the settings later. More details on separating environments for work/bloatware and your real-time application with a [dual-boot](https://en.wikipedia.org/wiki/Multi-booting) in the next section

- [Higher DPI reduces latency](https://www.youtube.com/watch?v=6AoRfv9W110). Use the highest DPI possible without [sensor smoothing](https://www.reddit.com/r/MouseReview/comments/5haxn4/sensor_smoothing). If your game uses raw input, you can [reduce the pointer speed](https://boringboredom.github.io/tools/#/WinSens) in Windows. Otherwise, leave the slider at the default position as input will be negatively affected due to scaling

    - One way to determine whether a given application is using raw input is to spy on the raw input API calls with [API Monitor](http://www.rohitab.com/apimonitor) or check whether the ``enhance pointer precision`` option has any effect in-game. If you are still unsure or have doubts, leave the slider at the default position

- [Higher polling rate reduces jitter](https://www.youtube.com/watch?app=desktop&v=djCLZ6qEVuA). Polling rates higher than 1kHz may negatively impact performance depending on your hardware so adjust accordingly. This is less of an issue after the May 2023 Windows 11 update

    - See [Reduced game stutter with high report rate mice](https://blogs.windows.com/windowsdeveloper/2023/05/26/delivering-delightful-performance-for-more-than-one-billion-users-worldwide)

- USB output is limited to ~7A and RGB requires unnecessary power. Turn off lighting effects or strip the LED from the peripheral as [running an RGB effect/animation can take a great toll on the MCU and will delay other processes](https://wooting.io/post/what-influences-keyboard-speed)

    - See [OpenRGB](https://openrgb.org)

- Use [Mouse Tester](https://github.com/amitxv/MouseTester) to check whether each poll contains data. As an example, if the interval is spiking to 2ms (500Hz) or higher from 1ms (1kHz), this is problematic and may be due to several variables such as the device itself, cable, power issues, hardware, operating system and more. You may need to lower or disable the XHCI interrupt moderation interval when using a device with a high polling rate (8kHz)

    - See [XHCI Interrupt Moderation (IMOD)](/docs/post-install.md#xhci-interrupt-moderation-imod)

- Use an [air dust blower](https://www.amazon.com/s?k=air+dust+blower) to remove dirt and debris from the mouse sensor lens

- Factory reset your monitor and reconfigure the settings. Avoid post-processing effects and set overdrive/AMA to an acceptably high setting [as it reduces latency](https://twitter.com/CaIypto/status/1464236780190851078) but comes with a penalty of additional overshoot

## BIOS

- Modifying BIOS is never without risks. Explore methods to flash a stock BIOS such as USB flashback or a [CH341A](https://www.techinferno.com/index.php?/topic/12230-some-guide-how-to-use-spi-programmer-ch341a) programmer if [clearing CMOS](https://www.intel.co.uk/content/www/uk/en/support/articles/000025368/processors.html) does not restore everything to its original state

- Check for BIOS updates and positive changes in the change log such as increased memory stability. Beware of problems brought up in reviews and forums

- Check Spectre, Meltdown and CPU microcode status after following the steps in the [Spectre, Meltdown and CPU Microcode](/docs/post-install.md#spectre-meltdown-and-cpu-microcode) section on your current operating system. If you are unable to reproduce the results in the example images, you may need to roll back the microcode on a BIOS level if possible

- Resizable BAR

    - Requires GPT/UEFI

    - Requires ``Above 4G Decoding`` to be enabled

    - Consider using [ReBarUEFI](https://github.com/xCuri0/ReBarUEFI) to enable it on unsupported systems

    - Verify Resizable BAR status with [GPU-Z](https://www.techpowerup.com/gpuz)

- Ensure that the settings you are changing scale positively and make note of them for future reference/backtracking to resolve potential issues

- Reset all settings to default settings with the option in BIOS to work with a clean slate

- Motherboard vendors hide/lock a lot of useful settings so that they aren't visible to a regular user. For clarification, unlocking BIOS corresponds to making hidden settings accessible and visible

    - On some boards, you can toggle ``Hidden OC Item`` or ``Hide Item`` to unlock BIOS if present

    - The easiest approach to take is to change the access levels within the BIOS using [UEFI-Editor](https://github.com/BoringBoredom/UEFI-Editor#usage-guide) or AMIBCP then flash it

    - For changing hidden settings without flashing a modded BIOS, you can start by configuring what is already accessible then use [GRUB](https://github.com/BoringBoredom/UEFI-Editor#how-to-change-hidden-settings-without-flashing-a-modded-bios) or [SCEWIN](https://github.com/amitxv/SCEWIN) to change the hidden settings

- Disable [Hyper-Threading/Simultaneous Multithreading](https://en.wikipedia.org/wiki/Hyper-threading) if you have enough CPUs for your real-time application. This feature is beneficial for highly threaded operations such as encoding, compiling and rendering however using multiple execution threads per CPU increases contention on processor resources and is a potential [source of system latency and jitter](https://www.intel.com/content/www/us/en/developer/articles/technical/optimizing-computer-applications-for-latency-part-1-configuring-the-hardware.html). Disabling HT/SMT has the additional benefit of increased overclocking potential due to lower temperatures in which, a similar concept can be applied to Intel's E-Cores (efficiency cores)

- Limit C-States, P-States, T-States, S-States, D-States and hibernation to the minimum or disable them completely. [It is a source of jitter due to the process of state transition and accounts for 10s to 100s of microseconds](https://www.intel.com/content/www/us/en/developer/articles/technical/optimizing-computer-applications-for-latency-part-2-tuning-applications.html)

    - Verify C-State residency with [HWiNFO](https://www.hwinfo.com)

    - Verify S-State status with ``powercfg /a`` in CMD

- Disable [Virtualization/SVM Mode](https://en.wikipedia.org/wiki/Desktop_virtualization) and [IOMMU (Intel VT-d/AMD-Vi)](https://en.wikipedia.org/wiki/Input%E2%80%93output_memory_management_unit) if applicable as they can cause a [difference in latency for memory access](https://www.amd.com/system/files/TechDocs/56263-EPYC-performance-tuning-app-note.pdf). Virtualization also has the potential to [affect BCLK](https://linustechtips.com/topic/1479168-issue-enabling-svm-virtualization-causes-bclk-to-fluctuate-a-lot)

    - Verify Virtualization/SVM status in Task Manager

- Disable all power-saving features such as [ASPM (Active State Power Management)](https://en.wikipedia.org/wiki/Active_State_Power_Management), [ALPM (Aggressive Link Power Management)](https://en.wikipedia.org/wiki/Aggressive_Link_Power_Management), DRAM Power Down Mode, DRAM Self Refresh (may cause issues with restart/shutdown), Clock Gating and more. You can also look out for options named *power management* or *power saving*. Search the internet if you are unsure whether a given setting is power-saving related

- Disable unnecessary devices such as WLAN, Bluetooth, High Definition Audio (if you aren't using motherboard audio) controllers and unused USB ports (refer to [USB Device Tree Viewer](https://www.uwe-sieber.de/usbtreeview_e.html)), PCIe slots, iGPU and RAM slots

- Disable Trusted Platform Module. On Windows 11, a minority of anti-cheats (Vanguard, FACEIT) require it to be enabled

    - Verify TPM status by typing ``tpm.msc`` in ``Win+R``

- Enable High Precision Event Timer. If the setting is hidden, there is a good chance that it is enabled by default

    - On AMD systems with newer AGESA firmware, changing this setting will have no effect

- MBR/Legacy requires Compatibility Support Module and typically, only the storage and PCIe OpROMs are required, but you can enable all of them if you are unsure. Disable CSM if you are using GPT/UEFI

    - Windows 7 GPT/UEFI requires CSM and OpROMs unless you are using [uefiseven](https://github.com/manatails/uefiseven)

- Disable Secure Boot. On Windows 11, a minority of anti-cheats (Vanguard, FACEIT) require it to be enabled

    - Verify Secure Boot status by typing ``msinfo32`` in ``Win+R``

- Disable Fast Startup, Suspend to RAM or similar options

- Disable Spread Spectrum and ensure BCLK frequency is close to 100.00 as possible in [HWiNFO](https://www.hwinfo.com)/[CPU-Z](https://www.cpuid.com/softwares/cpu-z.html)

- Disable Legacy USB Support as [it generates unnecessary SMIs](https://patents.google.com/patent/US6067589). You may need to turn this on to install a new operating system or to access BIOS

- Disable XHCI Hand-off

- Set the primary graphics to dGPU instead of iGPU if applicable

- Set PCIe link speed to the maximum supported such as ``Gen 3.0``

- Disable Execute Disable Bit/NX Mode. A minority of applications (Valorant) require it to be enabled

- If you are configuring a static frequency/voltage for the CPU in the next section, disable dynamic frequency features such as Speed Shift, SpeedStep and set the AVX offset to 0 so that the CPU does not downclock during AVX workloads. [Precision Boost Overdrive](https://www.amd.com/en/support/kb/faq/cpu-pb2) for Ryzen CPUs is an alternative option to a static frequency and voltages

    - In some cases, the settings mentioned above may prevent the processor from exceeding its base frequency despite manually configuring it in BIOS. Adjust accordingly if this is encountered

- Configure fan curves or set a static, high, noise-acceptable RPM

    - See [Ultimate fan speed curve (by KGCT, iteration 1)](https://imgur.com/a/2UDYXp0)

- When overclocking, you may be required to raise various power limits if the default limits are exceeded

- Backup BIOS by saving the current settings to a profile or export to local storage as clearing CMOS will wipe all settings if you need to do so while overclocking

    - In my experience on various motherboards, loading a saved profile doesn't restore some settings after clearing CMOS. It is recommended to dump nvram using a tool such as [SCEWIN](https://github.com/amitxv/SCEWIN) so that when you restore a profile, dump nvram again then compare it to the previous/original one to see whether anything failed to restore by using a text comparison tool such as the [Notepad++ Compare plugin](https://sourceforge.net/projects/npp-compare) or [Visual Studio Code](https://code.visualstudio.com/download)

## Stability, Hardware Clocking and Thermal Performance

Ensure that all of your hardware is stable before configuring a new operating system as unstable hardware can lead to crashes, data corruption, worse performance or irreversible damage to hardware. The effectiveness of testing for instability varies between tools which is why it is important to use a range of them for a sufficient amount of time (a non-exhaustive list of recommended tools is listed below).

- It is recommended to dual-boot a fresh installation of Windows to avoid corrupting your main operating system while stress-testing and overclocking. In terms of memory stress-testing, this also allows the stress-test to use more RAM as it isn't being hogged by potential bloatware

- Verify and validate changes within software to avoid unexpected results and behavior (e.g. frequency, voltages, timings)

- Save a BIOS profile before each change when overclocking such as changing CPU/RAM frequency and RAM timings so that you don't lose progress if you need to clear CMOS. Refer to the last point in the [BIOS](#bios) section regarding restoring settings properly

- Use [HWiNFO](https://www.hwinfo.com) to monitor system sensors. A higher polling interval can help to identify sudden spikes but not transients on a microsecond scale as an example. Avoid running while benchmarking as it has the potential to reduce the reliability of results

- A single error or crash is one too many

- Monitoring voltages where applicable due to potential overvolting

- Overclocking does not necessarily mean that the system will perform better due to factors such as error correction. You should verify whether whatever you are changing scales positively by adopting a systematic testing methodology in benchmarks such as [liblava](https://github.com/liblava/liblava) and [Intel Memory Latency Checker](https://amitxv.github.io/IMLC-Analyzer)

- There are countless factors that contribute to stability such as temperature, power delivery, quality of hardware in general, silicon lottery and more

    - See [RAM overclock stability and heat management | Actually Hardcore Overclocking](https://www.youtube.com/watch?v=iCD0ih4qzHw)

- Avoid thermal throttling at all costs, ambient temperature will generally increase during the summer which can be replicated with a heater to mimic a worst-case scenario

    - Deliberately underclock if your cooler is inadequate. A thermally stable component with an overall lower frequency is always better and safer compared to thermal throttling at a higher frequency

- Monitor WHEAs. [HWiNFO](https://www.hwinfo.com) has an error count

- If desired, configure load-line calibration. This isn't a recommendation for what mode to use

    - See [VRM Load-Line Visualized](https://elmorlabs.com/2019-09-05/vrm-load-line-visualized)

    - See [Vdroop setting and it’s impact on CPU operation](https://xdevs.com/guide/e399ocg/#vdroop)

    - See [Why Vdroop is good for overclocking and taking a look at Gigabyte's Override Vcore mode | Actually Hardcore Overclocking](https://www.youtube.com/watch?v=zqvNkh4TVw8)

- Configure RAM frequency and timings manually [for a significant performance improvement](https://kingfaris.co.uk/blog/intel-ram-oc-impact). XMP does not tune many subtimings nor does it guarantee stability

    - See [KoTbelowall/INTEL-DDR4-RAM-OC-GUIDE-by-KoT](https://github.com/KoTbelowall/INTEL-DDR4-RAM-OC-GUIDE-by-KoT)

    - See [integralfx/MemTestHelper](https://github.com/integralfx/MemTestHelper/blob/oc-guide/DDR4%20OC%20Guide.md)

- Configure static all-core frequencies and voltages for the CPU. Variations in hardware clocks can introduce jitter due to the process of frequency transitions. [Precision Boost Overdrive](https://www.amd.com/en/support/kb/faq/cpu-pb2) for Ryzen CPUs is an alternative option to a static frequency and voltages

- The previous two bullet points affect each other in terms of stability which means you should re-test each component after tinkering with the other

- Tune and overclock your display with [Custom Resolution Utility](https://www.monitortests.com/forum/Thread-Custom-Resolution-Utility-CRU) and test for [frame skipping](https://www.testufo.com/frameskipping)

    - Aim for an ``actual`` integer refresh rate such as 60.00/240.00, not 59.94/239.76. Using the exact timing can help achieve this

- Overclock your GPU. You may be required to flash a BIOS with a higher power limit

    - Ensure to disable ``CUDA - Force P2 State`` with [NVIDIA Profile Inspector](https://github.com/Orbmu2k/nvidiaProfileInspector) to prevent memory downclocking while stress-testing

    - See [A slightly better way to overclock and tweak your Nvidia GPU | Cancerogeno](https://docs.google.com/document/d/14ma-_Os3rNzio85yBemD-YSpF_1z75mZJz1UdzmW8GE/edit)

    - See [LunarPSD/NvidiaOverclocking](https://github.com/LunarPSD/NvidiaOverclocking/blob/main/Nvidia%20Overclocking.md)

### Stess-Testing Tools

- Linpack

    - [Linpack-Extended](https://github.com/BoringBoredom/Linpack-Extended)

    - [PorteusLinpack Bootable by SlovenianSlobodan#9859](https://drive.google.com/file/d/1MgHcZIoLth-i50o8pYF8XPR1kG1pw0y3/view?usp=sharing)

        - Login is root, password is toor

        - The default config is 100 trials of 10 GB problem size. To customize the config, type ``vi lininput_xeon64``. See [this video](https://www.youtube.com/watch?v=vo2FXvPkcEA) for a basic overview of the vi editor

        - Use the [sample config](https://raw.githubusercontent.com/BoringBoredom/Linpack-Extended/master/dependencies/linpack/misc/lininput_xeon64) as an example to chain multiple tests

        - To run the test, type ``./runme_xeon64``

        - To access sensors while the test is running, press ``Ctrl+Alt+F2`` to switch to TTY 2 then type ``./sensors``. Use ``Ctrl+Alt+F1`` to switch back to TTY 1 to view the output of the test

        - ``lin_xeon64.txt`` is overwritten with the results. Use ``vi lin_xeon64.txt`` to open it in the vi editor so that you can freely scroll through the trials

    - [Linpack Xtreme Bootable](https://www.techpowerup.com/download/linpack-xtreme) - Outdated binaries

    - Use a range of [problem sizes](https://github.com/BoringBoredom/Linpack-Extended/blob/master/leading%20dimensions.html)

    - Residuals should match, otherwise, it is a sign of instability

    - GFLOP variation should be minimal

- [Prime95](https://www.mersenne.org/download)

- [y-cruncher](http://www.numberworld.org/y-cruncher)

- [Memory Testing Software](https://github.com/integralfx/MemTestHelper/blob/oc-guide/DDR4%20OC%20Guide.md#memory-testing-software)

    - [HCI](https://hcidesign.com/memtest)

    - [MemTest86](https://www.memtest86.com) (bootable)

    - [MemTest86+](https://memtest.org) (bootable)

- [UNIGINE Superposition](https://benchmark.unigine.com/superposition)

- [OCCT](https://www.ocbase.com)

- [memtest_vulkan](https://github.com/GpuZelenograd/memtest_vulkan)

---

Continue to [docs/pre-install.md](/docs/pre-install.md).
