# Physical Setup

## General

- A SSD/NVMe is mandatory in the modern day due to the unreliability, degraded performance and excessive EMI of HDDs. Ensure that there is always a sufficient amount of free space as [SSDs slow down as they are filled up](https://www.howtogeek.com/165542/why-solid-state-drives-slow-down-as-you-fill-them-up)

- Check the general condition of storage devices with [CrystalDiskInfo](https://crystalmark.info/en/software/crystaldiskinfo) and [CrystalDiskMark](https://crystalmark.info/en/software/crystaldiskmark). When purchasing a new drive, check the total host read/writes to determine whether it is unused

- Update firmware for storage devices

- See [Avoid Multi-CCX Ryzen CPUs (1XXX, 2XXX, 3XXX, 59XX) | Calypto](https://docs.google.com/document/d/1c2-lUJq74wuYK1WrA_bIvgb89dUN0sj8-hO3vqmrau4/edit)

- See [Low Latency Hardware | Calypto](https://docs.google.com/document/d/1c2-lUJq74wuYK1WrA_bIvgb89dUN0sj8-hO3vqmrau4/edit#bookmark=kix.alwwrke7e395)

- Avoid single-channel, mismatching RAM and refer to the motherboard manual to ensure that they are in the correct slots. Consider the memory trace layout when determining the amount of sticks to use

- Favor PCIe ports that go straight to the CPU rather than PCH. This typically applies to M.2/NVMe SSDs and GPUs (usually the top slot). Beware of limitations with the amount of lanes available

- Ensure that your PCIe devices under the ``PCIe Bus`` category are running at their rated specification (e.g. x16 3.0) in [HWiNFO](https://www.hwinfo.com). The current link width/speed of the device should match the maximum supported

    - Link speed specifically for GPUs that are not limited to P-State 0 may decrease when idling. For this reason, you can check with GPU-Z while running the built-in render test

        - See [media/gpuz-bus-interface.png](/media/gpuz-bus-interface.png)

    - See [media/hwinfo-pcie-width-speed.png](/media/hwinfo-pcie-width-speed.png)

- IRQ sharing is problematic and is a source of high interrupt latency. Ensure that there is no IRQ sharing on your system by typing ``msinfo32`` in ``Win+R`` then navigating to the Conflicts/Sharing section

    - Enabling [message signaled interrupts](/docs/post-install.md#message-signaled-interrupts) on devices may resolve the software related causes of IRQ sharing but the purpose of checking this now is to resolve the hardware related causes

- Avoid daisy-chaining power cables anywhere

- Bufferbloat is a cause of high latency and jitter in packet-switched networks caused by excess buffering of packets. [Measure](https://www.waveform.com/tools/bufferbloat) and [minimize](https://www.bufferbloat.net/projects/bloat/wiki/What_can_I_do_about_Bufferbloat) it

    - See [How to test your Internet Ping](https://support.netduma.com/support/solutions/articles/16000074717-how-to-test-your-internet-ping)

- Tape the end of loose power cables to reduce the risk of short-circuiting components

- Favor short, shielded cables

- Clean pins and connectors of devices. Use compressed air to remove dust from slots such as PCIe, NVMe, RAM etc

- If you are not already using the partition style you want to be using, you should switch now because some settings listed in the [BIOS](#bios) section depend on the partition style (ctrl-f GPT/UEFI). The official method to convert the partition style is to wipe and convert the disk using diskpart within Windows setup. There are third party tools that can also do this without the need to wipe the disk, but I am not sure how well they work. GPT/UEFI should be fine for most people

    - See [media/identify-bios-mode.png](/media/identify-bios-mode.png)

    - See [MBR vs GPT: Which One Is Better for You?](https://www.diskpart.com/gpt-mbr/mbr-vs-gpt-1004.html)

    - See [How to Convert MBR to GPT During Windows 10/8/7 Installation |
MDTechVideos
](https://www.youtube.com/watch?v=f81qKAJUdKc)

## Cooling

- Generally, the goal is to run components as close as possible to ambient temperature

- Remove the side panels from your case or consider not using one entirely (open bench)

- Delid your CPU and use liquid metal for a [significant thermal improvement](https://www.youtube.com/watch?v=rUy3WcDlBXE). Direct die and lapping are also worth taking into consideration. Carry out research before attempting

- Use a contact frame if your CPU/socket is affected by ILM (independent loading mechanism) issues

- Check for contact patches on IHS/Die and cold plate

- Invest in high quality thermal paste

    - See [Best Thermal Paste for CPUs](https://www.tomshardware.com/best-picks/best-thermal-paste)

- Avoid tower/air coolers due to limited cooling potential and lack of space for fans to cool other components

- Mount your AIO properly

    - See [Stop Doing It Wrong: How to Kill Your CPU Cooler | Gamers Nexus](https://www.youtube.com/watch?v=BbGomv195sk)

    - See [media/aio-orientation.png](/media/aio-orientation.png)

- Invest in non-RGB fans with a high static pressure

    - See [PC Fans | Calypto](https://docs.google.com/spreadsheets/d/1AydYHI_M6ov9a3OgVuYXhLEGps0J55LniH9htAHy2wU)

- Ensure not to overload the motherboard fan header if you are using splitters

- Remove the heat sink from your RAM and mount a fan over it using cable ties

- Consider using an M.2/NVMe heat sink

- Mount a fan over VRMs, CPU backplate, storage devices, PCH, NIC and other hot spots

- Configure fan curves or set a static, high, noise-acceptable RPM

    - See [Ultimate fan speed curve (by KGCT, iteration 1)](https://imgur.com/a/2UDYXp0)

- Replace stock thermal pads with higher quality ones

- Repaste GPU due to factory application of thermal paste often being inadequate. Also consider replacing the stock fans with higher quality ones

- Consider replacing the stock PSU fan and connect it to a motherboard fan header or hub. Carry out research before attempting

## Minimize Interference

- Move devices that produce RF, EMF and EMI such as radios, cellphones and routers away from your setup as they have the potential to increase latency due to unwanted behavior of electrical components

- Always favor wired over cordless. Wireless devices also tend to implement aggressive power saving for a longer battery life

- Ensure that there is a moderate amount of space between all cables to reduce the risk of [coupling](https://en.wikipedia.org/wiki/Coupling_(electronics))

- Disconnect unnecessary devices from your motherboard, setup and peripherals such as LEDs, RGB light strips, front panel connectors, USB devices, unused drives and all HDDs. Refer to [USB Device Tree Viewer](https://www.uwe-sieber.de/usbtreeview_e.html) for onboard devices (LED controllers, IR receivers) and disable them in BIOS if you can not physically disconnect them

    - Some new motherboards have the High Definition Audio controller (motherboard audio) linked to the USB controller

## Configure USB Port Layout

- Favor the first few ports on the desired USB controller. Some of them may not be physically accessible due to onboard headers which can be determined in [USB Device Tree Viewer](https://www.uwe-sieber.de/usbtreeview_e.html) with trial and error. Use the motherboard ports and avoid companion ports (indicated in the right section of the program) as the data has to go through a hub

    - Ryzen systems have a USB controller that is directly connected to the CPU which can be identified under the ``PCIe Bus`` category in [HWiNFO](https://www.hwinfo.com). It is usually the USB controller that is connected to a ``Internal PCIe Bridge`` which is also labeled with the CPU architecture

        - See [media/ryzen-xhci-controller.png](/media/ryzen-xhci-controller.png)

- If you have more than one USB controller, you can isolate devices such as your mouse, keyboard and audio devices (if any) onto another controller to [prevent them interfering with polling consistency](https://forums.blurbusters.com/viewtopic.php?f=10&t=7618#p58449)

## Configure Peripherals

- Most modern peripherals support onboard memory profiles. Configure them before configuring the operating system as you will not be required to install the bloatware to change the settings later. More details on separating environments for work/bloatware and your real-time application with a [dual-boot](https://en.wikipedia.org/wiki/Multi-booting) in the next section

- [Higher DPI reduces latency](https://www.youtube.com/watch?v=6AoRfv9W110). Most mice are able to handle 1600 DPI without [sensor smoothing](https://www.reddit.com/r/MouseReview/comments/5haxn4/sensor_smoothing). Optionally [reduce the pointer speed](https://boringboredom.github.io/tools/#/WinSens) in Windows. This will not interfere with in-game input as modern games use raw input

- [Higher polling rate reduces jitter](https://www.youtube.com/watch?app=desktop&v=djCLZ6qEVuA). Polling rates higher than 1kHz may negatively impact performance depending on your hardware so adjust accordingly. This is less of an issue after the May 2023 Windows 11 update

    - See [Reduced game stutter with high report rate mice](https://blogs.windows.com/windowsdeveloper/2023/05/26/delivering-delightful-performance-for-more-than-one-billion-users-worldwide/)

- USB output is limited to ~7A and RGB requires unnecessary power. Turn off lighting effects or strip the LED from the peripheral as [running an RGB effect/animation can take a great toll on the MCU and will delay other processes](https://blog.wooting.nl/what-influences-keyboard-speed)

    - See [OpenRGB](https://openrgb.org)

- Use [Mouse Tester](https://github.com/microe1/MouseTester) to check whether each poll contains data. As an example, if the interval is spiking to 2ms (500Hz) or higher from 1ms (1kHz), this is obviously problematic and often caused by an inadequate sensor. You may need to lower or disable the XHCI interrupt moderation interval when using a device with a high polling rate (8kHz).

    - See [XHCI Interrupt Moderation (IMOD)](/docs/post-install.md#xhci-interrupt-moderation-imod)

- Use a [lint roller](https://www.ikea.com/us/en/p/baestis-lint-roller-gray-90425626) to remove dirt and debris from your mouse pad

- Use an [air dust blower](https://www.amazon.com/s?k=air+dust+blower) to remove dirt and debris from the mouse sensor lens

- Factory reset your monitor and reconfigure the settings. Avoid post-processing effects and set overdrive/AMA to an acceptably high setting [as it reduces latency](https://twitter.com/CaIypto/status/1464236780190851078) but comes with a penalty of additional overshoot

## BIOS

- Keep in mind, anything can go sideways when modifying BIOS. You should explore methods to flash a stock BIOS if [clearing CMOS](https://www.intel.co.uk/content/www/uk/en/support/articles/000025368/processors.html) does not work in case anything goes wrong (e.g. working USB flashback or a [CH341A](https://www.techinferno.com/index.php?/topic/12230-some-guide-how-to-use-spi-programmer-ch341a) programmer)

- Check for BIOS updates and positive changes in the change log (e.g. increased memory stability). Beware of problems brought up in reviews and forums

- Check Spectre, Meltdown and CPU microcode status after following the steps in the [Spectre, Meltdown and CPU Microcode](/docs/post-install.md#spectre-meltdown-and-cpu-microcode) section on your current operating system. If you are unable to reproduce the results in the example images, you may need to roll back microcode on a BIOS level

- Resizable BAR

    - Requires GPT/UEFI

    - Consider [ReBarUEFI](https://github.com/xCuri0/ReBarUEFI) to enable it on unsupported systems

- Ensure that the settings you are changing scale positively and make note of them on a piece of paper for future reference/backtracking to resolve potential issues

- Reset all settings to default settings with the option in BIOS to work with a clean slate

- Access BIOS settings. Motherboard vendors hide/lock a lot of useful settings so that they are not visible to a regular user. For clarification, unlocking BIOS corresponds to making hidden settings accessible/visible

    - On some boards, you can enable ``Hidden OC Item`` or ``Hide Item`` if present to unlock BIOS

    - The easiest approach to take is to change the access levels within the BIOS file using [UEFI-Editor](https://github.com/BoringBoredom/UEFI-Editor#usage-guide) or AMIBCP then flash it

    - For changing hidden settings without flashing a modded BIOS, you can start by configuring what is already accessible then use [GRUB](https://github.com/BoringBoredom/UEFI-Editor#how-to-change-hidden-settings-without-flashing-a-modded-bios) or SCEWIN to change the hidden settings

- Disable [Hyper-Threading/Simultaneous Multithreading](https://en.wikipedia.org/wiki/Hyper-threading) if you have enough cores for your real-time application. This feature is beneficial for highly threaded operations such as encoding, compiling and rendering however using multiple execution threads per core increases contention on processor resources and is a potential [source of system latency and jitter](https://www.intel.com/content/www/us/en/developer/articles/technical/optimizing-computer-applications-for-latency-part-1-configuring-the-hardware.html). [Disabling HT/SMT has the additional benefit of doubling (in case of 2-way SMT) the effective L1 and L2 cache available to a thread](https://rigtorp.se/low-latency-guide) and increased overclocking potential due to lower temperatures

- Limit C-States, P-States and S-States to the minimum or disable them completely. It is a source of jitter due to the process of state transition

    - Verify S-State status with ``powercfg -a`` in CMD

- Disable [Virtualization/SVM Mode](https://en.wikipedia.org/wiki/Desktop_virtualization) and [IOMMU (Intel VT-d/AMD-Vi)](https://en.wikipedia.org/wiki/Input%E2%80%93output_memory_management_unit) if applicable as they can cause a [difference in latency for memory access](https://www.amd.com/system/files/TechDocs/56263-EPYC-performance-tuning-app-note.pdf)

- Disable all power saving features such as [Active State Power Management](https://en.wikipedia.org/wiki/Active_State_Power_Management), [Aggressive Link Power Management](https://en.wikipedia.org/wiki/Aggressive_Link_Power_Management), DRAM Power Down Mode, DRAM Self Refresh (may cause issues with restart/shutdown), PCIe Clock Gating and more. Search the internet if you are unsure whether a given setting is power saving related

- Disable unnecessary devices such as WLAN, Bluetooth, High Definition Audio (if you are not using motherboard audio) controllers and unused USB ports (refer to [USB Device Tree Viewer](https://www.uwe-sieber.de/usbtreeview_e.html)), PCIe slots, iGPU and RAM slots

- Disable Trusted Platform Module. On Windows 11, a minority of anticheats (Vanguard, FACEIT) require it to be enabled

    - Verify TPM status by typing ``tpm.msc`` in ``Win+R``

- Enable High Precision Event Timer. If the setting is hidden, there is a good chance that it is enabled by default

    - On AMD systems with newer AGESA firmware, changing this setting will have no effect

- MBR/Legacy requires Compatibility Support Module and typically, only the storage and PCIe OpROMs are required, but you can enable all of them if you are unsure. Disable CSM if you are using GPT/UEFI

    - Windows 7 GPT/UEFI requires CSM and OpROMs unless you are using [uefiseven](https://github.com/manatails/uefiseven)

- Disable Secure Boot. On Windows 11, a minority of anticheats (Vanguard, FACEIT) require it to be enabled

- Disable Fast Startup or similar options

- Disable Spread Spectrum and ensure BCLK frequency is close to 100.00 as possible in [HWiNFO](https://www.hwinfo.com)/[CPU-Z](https://www.cpuid.com/softwares/cpu-z.html)

- Disable Legacy USB Support as [it generates unnecessary SMIs](https://patents.google.com/patent/US6067589). You may need to turn this on to install a new operating system or to access BIOS

- Disable XHCI Hand-off

- Set the primary graphics to dGPU instead of iGPU if applicable

- Set PCIe link speed to the maximum supported (e.g. Gen 3.0)

- Disable Execute Disable Bit/NX Mode. A minority of applications (Valorant) require it to be enabled

- As we will be configuring a static frequency/voltage for the CPU in the next section, disable dynamic frequency features such as Speed Shift, SpeedStep, Turbo Boost and set the AVX offset to 0 so that the CPU does not downclock during AVX workloads

    - In some cases, the settings mentioned above may prevent the processor exceeding its base frequency despite manually configuring it in BIOS. Adjust accordingly if this is encountered

- Backup BIOS by saving the current settings to a profile or use SCEWIN as clearing CMOS will wipe all settings if you need to do so while e.g. overclocking RAM and you are not able to POST

## Stability, Hardware Clocking and Thermal Performance

Ensure all of your hardware (e.g. CPU, RAM, GPU) are stable before configuring a new operating system as unstable hardware can lead to crashes, data corruption, worse performance and irreversible damage to hardware. There are many tools to test different components and algorithms vary between tools which is why it is important to use a range of them for a sufficient amount of time (non-exhaustive list of recommended tools are listed below).

- Tools

    - Linpack

        - [Linpack-Extended](https://github.com/BoringBoredom/Linpack-Extended)

        - [PorteusLinpack Bootable by SlovenianSlobodan#9859](https://drive.google.com/file/d/1g6hY_klVOyd2FQy0Ozit2aFrEyuC4r48/view?usp=sharing)

            - The default config is 100 trials of 10 GB problem size. To customize the config, type ``vi lininput_xeon64``. See [this video](https://www.youtube.com/watch?v=vo2FXvPkcEA) for a basic overview of the vi editor

            - Use the [sample config](https://raw.githubusercontent.com/BoringBoredom/Linpack-Extended/master/dependencies/linpack/misc/lininput_xeon64) as an example to chain multiple tests

            - To run the test, type ``./runme_xeon64``

            - To access sensors while the test is running, press ``Ctrl+Alt+F2`` to switch to TTY 2 then type ``./sensors``. Use ``Ctrl+Alt+F1`` to switch back to TTY 1 to view the output of the test

        - [Linpack Xtreme Bootable](https://www.techpowerup.com/download/linpack-xtreme) - Outdated binaries

        - Use a range of [problem sizes](https://github.com/BoringBoredom/Linpack-Extended/blob/master/leading%20dimensions.html)

        - Residuals should match, otherwise it is a sign of instability

        - GFLOP variation should be minimal

    - [Prime95](https://www.mersenne.org/download) - Small/Large FFTs

    - [y-cruncher](http://www.numberworld.org/y-cruncher)

    - [Memory Testing Software](https://github.com/integralfx/MemTestHelper/blob/oc-guide/DDR4%20OC%20Guide.md#memory-testing-software)

        - [HCI](https://hcidesign.com/memtest)

        - [MemTest86](https://www.memtest86.com) (bootable)

        - [MemTest86+](https://memtest.org) (bootable)

    - [UNIGINE Superposition](https://benchmark.unigine.com/superposition)

    - [OCCT](https://www.ocbase.com)

- Use [HWiNFO](https://www.hwinfo.com) to monitor system sensors. A higher polling interval can help to identify sudden spikes but not e.g. transients on a microsecond scale. Avoid running while benchmarking as it has the potential to reduce the reliability of results

- A single error or crash is one too many

- Try not to leave voltage settings on automatic due to potential overvolting

- Overclocking does not necessarily mean that the system will perform better due to factors such as error correction. You should verify whether whatever you are changing (e.g. frequency, timings) scale positively by adopting a systematic testing methodology in benchmarks such as [liblava](https://github.com/liblava/liblava) and [MLC](https://www.intel.com/content/www/us/en/developer/articles/tool/intelr-memory-latency-checker.html) (run as administrator to disable prefetching and ensure that the ``mlcdrv.sys`` driver is loaded)

- There are countless factors that contribute to stability such as temperature, power delivery, quality of hardware in general, silicon lottery and more

    - An important note to make is that you can pass hours of stress tests (e.g. RAM) but as soon as another component (e.g. GPU) begins to warm up and increase ambient temperature, you may encounter instability so ensure to cater for such scenario. Assuming a fan is mounted to blow air onto the RAM, consider stress testing RAM without a fan or reduce the RPM to deliberately allow them to run warmer so that greater stability can be ensured once the fan is running at full RPM again

- Avoid thermal throttling at all costs, ambient temperature will generally increase during the summer which can be replicated with a heater to mimic a worst-case scenario

    - Deliberately underclock if your cooler is inadequate. A thermally stable component with an overall lower frequency is always better and safer compared to thermal throttling at a higher frequency

- Monitor WHEAs. [HWiNFO](https://www.hwinfo.com) has an error count

- Disable the paging file and use safe mode for stress testing preferably on a throwaway operating system in case it becomes corrupted

- Configure load-line calibration. Opinionated setting, mentioning for awareness. This is not a recommendation for what mode to use

    - See [Vdroop setting and it’s impact on CPU operation](https://xdevs.com/guide/e399ocg/#vdroop)

    - See [Why Vdroop is good for overclocking and taking a look at Gigabyte's Override Vcore mode | Actually Hardcore Overclocking](https://www.youtube.com/watch?v=zqvNkh4TVw8)

- Set a static all-core core/uncore frequency and voltage for the CPU. Variation in hardware clocks can introduce jitter due to the process of frequency transitions

- Configure RAM frequency and timings manually [for a significant performance improvement](https://kingfaris.co.uk/blog/intel-ram-oc-impact). XMP does not tune many subtimings nor does it guarantee stability

    - See [integralfx/MemTestHelper](https://github.com/integralfx/MemTestHelper/blob/oc-guide/DDR4%20OC%20Guide.md)

    - See [KoTbelowall/INTEL-DDR4-RAM-OC-GUIDE-by-KoT](https://github.com/KoTbelowall/INTEL-DDR4-RAM-OC-GUIDE-by-KoT)

- The previous two bullet points (core/uncore/memory) affect each other in terms of stability which means you should re-test each component after tinkering with the other

- Overclock your GPU. You may be required to flash a BIOS with a higher power limit

    - Ensure to disable ``CUDA - Force P2 State`` with [NVIDIA Profile Inspector](https://github.com/Orbmu2k/nvidiaProfileInspector) to prevent memory downclocking while stress testing

    - See [A slightly better way to overclock and tweak your Nvidia GPU | Cancerogeno](https://docs.google.com/document/d/14ma-_Os3rNzio85yBemD-YSpF_1z75mZJz1UdzmW8GE/edit)

    - See [LunarPSD/NvidiaOverclocking](https://github.com/LunarPSD/NvidiaOverclocking/blob/main/Nvidia%20Overclocking.md)

- Tune and overclock your display with [Custom Resolution Utility](https://www.monitortests.com/forum/Thread-Custom-Resolution-Utility-CRU) and test for [frame skipping](https://www.testufo.com/frameskipping)

    - Aim for an "actual" integer refresh rate (e.g. 60.00/240.00 not 59.94/239.76). Using the exact timing can help achieve this
