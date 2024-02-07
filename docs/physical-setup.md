# Physical Setup

## Table of Contents

- [General](#general)
- [Cooling](#cooling)
- [Minimize Interference](#minimize-interference)
- [Configure USB Port Layout](#configure-usb-port-layout)
- [Configure Peripherals](#configure-peripherals)
- [BIOS](#bios)
- [Stability, Hardware Clocking and Thermal Performance](#stability-hardware-clocking-and-thermal-performance)
    - [Stess-Testing Tools](#stess-testing-tools)

## General

- A new installation of Windows is recommended after major hardware changes including but not limited to motherboards, CPUs, platforms and chipsets

- See [Higher Airflow Cases | Calypto](https://docs.google.com/spreadsheets/d/14Kt2cAn8a7j2sGXiPGt4GcxpR3RXVcDAx9R5c2M8680/edit#gid=0)

- Avoid multi-CCX Ryzen CPUs due to latency penalty incurred from inter-CCX communication ([1](https://calypto.us), [2](https://www.anandtech.com/show/17585/amd-zen-4-ryzen-9-7950x-and-ryzen-5-7600x-review-retaking-the-high-end/10))

- See [Low Latency Hardware | Calypto](https://calypto.us)

- Favor wired over cordless (e.g. peripherals, Wi-Fi) due to the degraded performance and inconsistency associated with wireless devices, aggressive power-saving features for a longer battery life where applicable along with the downside of being negatively affected by interference and transmission overhead ([1](https://www.meetion.com/a-the-impact-of-lift-off-distance-on-battery-life-with-wireless-vs-wired-gaming-mice.html), [2](https://en.wikipedia.org/wiki/2.4_GHz_radio_use), [3](https://raw.githubusercontent.com/BoringBoredom/PC-Optimization-Hub/main/content/peripherals/wireless%20overhead.png), [4](https://www.logitechg.com/en-gb/innovation/hero.html), [5](https://www.youtube.com/watch?v=Zn7WjyIvAWA))

- An SSD or NVMe is strongly recommended due to the degraded performance and excessive interference of HDDs ([1](https://unihost.com/help/nvme-vs-ssd-vs-hdd-overview-and-comparison)). Ensure that there is always a sufficient amount of free space as SSDs slow down as they are filled up although most drives are overprovisioned from factory ([1](https://www.howtogeek.com/165542/why-solid-state-drives-slow-down-as-you-fill-them-up), [2](https://download.semiconductor.samsung.com/resources/white-paper/S190311-SAMSUNG-Memory-Over-Provisioning-White-paper.pdf))

- Assess the condition and performance of storage devices with [CrystalDiskInfo](https://crystalmark.info/en/software/crystaldiskinfo) and [CrystalDiskMark](https://crystalmark.info/en/software/crystaldiskmark)

- Check for and update the firmware for devices including but not limited to NVMe, NICs, peripherals and more

- Avoid single-channel and mismatching RAM ([1](https://www.youtube.com/watch?v=bDgDtz7ImGI)). Refer to the motherboard manual to ensure that they are in the correct slots. Consider the memory trace layout when determining the amount of sticks to use ([1](https://www.youtube.com/watch?v=3vQwGGbW1AE))

- Favor PCIe ports that go straight to the CPU rather than PCH, this typically applies to M.2, NVMe and GPUs. This can be determined with the ``PCIe Bus`` category in [HWiNFO](https://www.hwinfo.com)

- Ensure that your PCIe devices under the ``PCIe Bus`` category are running at their rated specification such as ``x16 3.0`` in [HWiNFO](https://www.hwinfo.com). The current link width/speed of the device should match the maximum supported by the device

    - The link speed for GPUs that aren't limited to P-State 0 may decrease when idling. Check with [GPU-Z](https://www.techpowerup.com/gpuz) while running the built-in render test

        - See [media/gpuz-bus-interface.png](/media/gpuz-bus-interface.png)

    - See [media/hwinfo-pcie-width-speed.png](/media/hwinfo-pcie-width-speed.png)

- IRQ sharing is problematic and is a source of high interrupt latency ([1](https://repo.zenk-security.com/Linux%20et%20systemes%20d.exploitations/Windows%20Internals%20Part%201_6th%20Edition.pdf)). The causes may be due to the hardware or software configuration. I recommend enabling [message signaled interrupts](/docs/post-install.md#message-signaled-interrupts) to rule out the software related causes then check that there is no IRQ sharing caused by the hardware configuration by typing ``msinfo32`` in ``Win+R`` then navigating to the ``Conflicts/Sharing section``

- If you have more than one onboard Ethernet NIC, consider using the one that supports MSI-X by checking in [MSI Utility](https://forums.guru3d.com/threads/windows-line-based-vs-message-signaled-based-interrupts-msi-tool.378044) or [GoInterruptPolicy](https://github.com/spddl/GoInterruptPolicy) as it is required for Receive Side Scaling to function properly ([1](https://www.reddit.com/r/intel/comments/9uc03d/the_i219v_nic_on_your_new_z390_motherboard_and)). This can be achieved by plugging the Ethernet cable into the corresponding port on the motherboard

- Measure and minimize bufferbloat as it is a cause of high latency and jitter in packet-switched networks caused by excess buffering of packets ([1](https://en.wikipedia.org/wiki/Bufferbloat), [2](https://www.bufferbloat.net/projects))

    - See [Waveform Bufferbloat and Internet Speed Test](https://www.waveform.com/tools/bufferbloat)

    - See [How to test your Internet Ping (PingPlotter) | Netduma](https://support.netduma.com/support/solutions/articles/16000074717-how-to-test-your-internet-ping)

    - See [What Can I Do About Bufferbloat? | Bufferbloat.net](https://www.bufferbloat.net/projects/bloat/wiki/What_can_I_do_about_Bufferbloat)

- Avoid daisy-chaining power cables anywhere in your setup

    - See [Installation remark for high power consumption graphics cards | Seasonic](https://knowledge.seasonic.com/article/8-installation-remark-for-high-power-consumption-graphics-cards)

- Favor shielded cables and avoid unnecessarily long ones as they offer more protection against interference ([1](https://precmfgco.com/blog/shielded-vs-unshielded-cables))

- Clean dust from components and heat sinks as they have the potential to cause short circuits and reduce airflow ([1](https://www.armagard.co.uk/articles/dust-computer-killer.html))

- Clean the pins and connectors of components. Use compressed air to remove dust from slots before installing components such as PCIe, NVMe, RAM and more

    - See [Cleaning contacts on RAM Memory and Graphics Card | zodox](https://www.youtube.com/watch?v=OTrzzC10Scg)

- Don't make the mistake of plugging in the display cable in to the motherboard port in the event of a dGPU being present

- If you aren't already using the partition style you would like to be using, you should switch now because some settings listed in the [BIOS](#bios) section depend on the partition style (search for *"GPT/UEFI"*). The official method to convert the partition style is to wipe and convert the disk using diskpart within Windows setup ([1](https://learn.microsoft.com/en-us/windows-server/storage/disk-management/change-an-mbr-disk-into-a-gpt-disk)). GPT/UEFI is recommended for most systems ([1](https://www.diskpart.com/gpt-mbr/mbr-vs-gpt-1004.html))

    - See [media/identify-bios-mode.png](/media/identify-bios-mode.png)

    - See [How to Convert MBR to GPT During Windows 10/8/7 Installation | MDTechVideos](https://www.youtube.com/watch?v=f81qKAJUdKc)

- Consider what Windows version you will be using because some settings listed in the [BIOS](#bios) section depend on the Windows version used (search for *"Windows"*)

    - See [What Version of Windows Should You Use?](/docs/pre-install.md#what-version-of-windows-should-you-use)

- Avoid a multi-monitor setup as there is the potential for greater processing overhead ([1](https://www.youtube.com/watch?v=5wBxYQdN96s))

## Cooling

- If you plan on overclocking, consider the points below to maximize temperature headroom and overclocking potential. It is important to note that lower temperatures can affect other variables even if you are not overclocking such as CPU boosting behavior as the boost algorithm is affected by temperature

    - Remove the side panels from your case as they tend to trap heat or consider an open-bench setup (beware of dust)

    - Delid your CPU and use liquid metal for a significant thermal improvement ([1](https://www.youtube.com/watch?v=rUy3WcDlBXE)). Direct die and lapping are also worth considering however users should assess the risk with carrying out these procedures

    - Avoid tower and air coolers due to limited cooling potential and lack of space for fans to cool other components such as RAM and VRMs ([1](https://www.youtube.com/watch?v=Vex9_84VpYs))

    - Remove the heat sink from your RAM as they tend to trap heat due to them being attached to the PCB with foam or glue. Get creative with mounting a fan (140mm recommended) over it using cable ties ([1](https://i.imgur.com/7KvbxTv.jpg))

    - Mount a fan over VRMs, CPU backplate, PCH and other hot spots

    - Replace thermal pads with higher-quality ones if the stock pads are inadequate

    - Repaste GPU due to factory application of thermal paste often being inadequate and optionally replace the stock fans with higher quality ones

- Consider contact frames and offset mounts if applicable

    - See [Investigating Intel's CPU Socket Problems | Thermal Grizzly Contact Frame Benchmark | Gamers Nexus](https://www.youtube.com/watch?v=Ysb25vsNBQI)

    - See [Noctua Releases Offset Mounting for Improved Cooling Performance on AMD AM5 CPUs | Noctua](https://noctua.at/en/noctua-releases-offset-mounting-for-improved-cooling-performance-on-amd-am5-processors)

- Use high-quality thermal interface material and an adequate amount upon application

    - See [Best Thermal Paste for CPUs | Tom's Hardware](https://www.tomshardware.com/best-picks/best-thermal-paste)

- Assess contact patches on the IHS/Die and cold plate

- Mount your AIO cooler properly

    - See [Stop Doing It Wrong: How to Kill Your CPU Cooler | Gamers Nexus](https://www.youtube.com/watch?v=BbGomv195sk)

- Use non-RGB fans with a high static pressure

    - See [PC Fans | Calypto](https://docs.google.com/spreadsheets/d/1AydYHI_M6ov9a3OgVuYXhLEGps0J55LniH9htAHy2wU)

- Ensure not to overload the motherboard fan header, especially if you are using splitters

- Use an M.2/NVMe heat sink and optionally mount a fan over it

## Minimize Interference

- Move devices that produce interference including but not limited radios, cell phones, routers and more away from your setup as they have the potential to increase latency due to unwanted behavior of electrical components ([1](https://forums.blurbusters.com/viewtopic.php?f=24&t=9133#p71950), [2](https://forums.blurbusters.com/viewtopic.php?f=10&t=7168&start=30#p62185))

- Ensure that there is a moderate amount of space between all cables to reduce the risk of [coupling](https://en.wikipedia.org/wiki/Coupling_(electronics))

- Disconnect unnecessary devices from your motherboard, setup and peripherals such as LEDs, RGB light strips, front panel connectors, USB devices, unused drives and all HDDs. Refer to [USB Device Tree Viewer](https://www.uwe-sieber.de/usbtreeview_e.html) for onboard devices (LED controllers, IR receivers) and disable them in BIOS if you can not physically disconnect them

    - Some motherboards have the motherboard's High Definition Audio controller linked to the XHCI controller ([1](https://www.igorslab.de/en/the-old-alc4080-on-the-new-intel-boards-demystified-and-the-differences-from-alc1220-insider))

> [!NOTE]
> Take a note of any BIOS related changes as they might be reset in the first few steps of the [BIOS](#bios) section.

## Configure USB Port Layout

- Familiarize yourself with which USB ports correspond to given XHCI controllers as some ports shown in [USB Device Tree Viewer](https://www.uwe-sieber.de/usbtreeview_e.html) may not be physically accessible. It is recommended to plug a device into every accessible port on your system including but not limited to the motherboard I/O ports then take note of which controller and port they appear in USB Device Tree Viewer

- Ryzen systems have an XHCI controller that is directly connected to the CPU which can be identified under the ``PCIe Bus`` category in [HWiNFO](https://www.hwinfo.com) ([1](https://hexus.net/tech/features/mainboard/131789-amd-ryzen-3000-supporting-x570-chipset-examined)). It is usually the XHCI controller that is connected to an ``Internal PCIe Bridge to bus`` which is also labeled with the CPU architecture

    - See [media/ryzen-xhci-controller.png](/media/ryzen-xhci-controller.png)

- Favor the first few accessible ports on the desired XHCI controller. Avoid companion ports which is indicated in the right section of the program and [internal headers](/media/xhci-internal-headers.png)

- If you have more than one XHCI controller, you can isolate devices such as your mouse, keyboard and audio devices (if any) onto another controller as they have the potential to interfere with polling consistency ([1](https://forums.blurbusters.com/viewtopic.php?f=10&t=7618#p58449)). Another controller may be made available by using ports connected to the USB 3.0 front panel header. Always verify with [USB Device Tree Viewer](https://www.uwe-sieber.de/usbtreeview_e.html)

## Configure Peripherals

- Most modern peripherals support onboard memory profiles. Configure them before configuring the operating system as you will not be required to install the bloatware to change the settings later. More details on separating environments for work/bloatware and your real-time application with a [dual-boot](https://en.wikipedia.org/wiki/Multi-booting) in the next section

- Higher DPI reduces latency and helps to saturate polls with motion data ([1](https://www.youtube.com/watch?v=6AoRfv9W110), [2](https://www.youtube.com/watch?v=mwf_F2VboFQ&t=458s), [3](https://www.youtube.com/watch?v=imYBTj2RXFs&t=275s)). Use the highest DPI possible without [sensor smoothing](https://www.reddit.com/r/MouseReview/comments/5haxn4/sensor_smoothing). If your game uses raw input, you can [reduce the pointer speed](https://boringboredom.github.io/tools/winsenscalculator) in Windows to offset the sensitivity from higher DPI. Otherwise, leave the slider at the default position as input will be negatively affected due to scaling

    - One way to determine whether a given application is using raw input is to spy on the raw input API calls with [API Monitor](http://www.rohitab.com/apimonitor) or check whether the ``enhance pointer precision`` option has any effect in-game. If you are still unsure or have doubts, leave the slider at the default position

- Higher polling rate reduces jitter and latency ([1](https://www.youtube.com/watch?app=desktop&v=djCLZ6qEVuA), [2](https://www.youtube.com/watch?v=mwf_F2VboFQ&t=458s), [3](https://www.youtube.com/watch?v=mwf_F2VboFQ&t=618s)). Higher polling rates may negatively impact performance depending on your hardware so adjust accordingly. This is less of an issue after the May 2023 Windows 11 update ([1](https://blogs.windows.com/windowsdeveloper/2023/05/26/delivering-delightful-performance-for-more-than-one-billion-users-worldwide))

- USB output is limited to ~7A and RGB requires unnecessary power ([1](https://en.wikipedia.org/wiki/USB)). Turn off lighting effects or strip the LED from the peripheral as running an RGB effect/animation can take a great toll on the MCU and will delay other processes ([1](https://wooting.io/post/what-influences-keyboard-speed), [2](https://www.techpowerup.com/review/endgame-gear-xm1-rgb/5.html#:~:text=tracking%20quality%20takes%20a%20hit%20as%20soon%20as%20RGB%20is%20enabled), [3](https://www.techpowerup.com/review/roccat-kone-pro-air/5.html#:~:text=after%20having%20disabled%20all%20RGB%20lighting,%20these%20outliers%20disappeared%20entirely))

- Use [Mouse Tester](https://github.com/amitxv/MouseTester) to check whether each poll contains data. As an example, if the interval is spiking to 2ms (500Hz) or higher from 1ms (1kHz), this is problematic and may be due to several variables such as the device itself, cable, power issues, hardware, operating system and more. You may need to lower or disable the XHCI interrupt moderation interval if there are multiple devices generating interrupts on the same XHCI controller during the benchmark

    - See [XHCI Interrupt Moderation (IMOD)](/docs/post-install.md#xhci-interrupt-moderation-imod)

- Carefully use an [air dust blower](https://www.amazon.com/s?k=air+dust+blower) to remove dirt and debris from the mouse sensor lens without damage

- Factory reset your monitor and reconfigure the settings. Avoid post-processing effects and set overdrive/AMA to an acceptably high setting as it reduces latency but comes with a penalty of additional overshoot ([1](https://twitter.com/CaIypto/status/1464236780190851078))

## BIOS

> [!WARNING]
> 🔒 Some recommendations outlined in this section may negatively impact security. Users should assess the security risk involved with modifying the mentioned settings.

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

    - For changing hidden settings without flashing a modded BIOS, you can start by configuring what is already accessible in UEFI then use [GRUB](https://github.com/BoringBoredom/UEFI-Editor#how-to-change-hidden-settings-without-flashing-a-modded-bios) or [SCEWIN](https://github.com/amitxv/SCEWIN) to change the hidden settings

- Disable [Hyper-Threading/Simultaneous Multithreading](https://en.wikipedia.org/wiki/Hyper-threading) if you have enough CPUs for your real-time application. This feature is beneficial for highly threaded operations such as encoding, compiling and rendering however using multiple execution threads per CPU increases contention on processor resources and is a potential source of system latency and jitter ([1](https://www.intel.com/content/www/us/en/developer/articles/technical/optimizing-computer-applications-for-latency-part-1-configuring-the-hardware.html)). Disabling HT/SMT has the additional benefit of increased overclocking potential due to lower temperatures in which, a similar concept can be applied to Intel's E-Cores (efficiency cores)

- Limit C-States (e.g. search for *C1E*, *C6*), P-States (e.g. search for *P0*), T-States, S-States (e.g. search for *S3*, *S6*), D-States (e.g. search for *D3*) and hibernation to the minimum or disable them completely as they account for 10s to 100s of microseconds in terms of jitter ([1](https://www.intel.com/content/www/us/en/developer/articles/technical/optimizing-computer-applications-for-latency-part-2-tuning-applications.html)). This mitigates the undesirable delay to execute new instructions on a CPU that has entered a deeper power-saving state at the expense of higher idle temperatures and power consumption

    - Verify C-State residency with [HWiNFO](https://www.hwinfo.com)

    - Verify S-State status with ``powercfg /a`` in CMD

- Disable [Virtualization/SVM Mode](https://en.wikipedia.org/wiki/Desktop_virtualization) and [IOMMU (Intel VT-d/AMD-Vi)](https://en.wikipedia.org/wiki/Input%E2%80%93output_memory_management_unit) if applicable as they can cause a difference in latency for memory access ([1](https://www.amd.com/system/files/TechDocs/56263-EPYC-performance-tuning-app-note.pdf)). Virtualization also has the potential to affect BCLK ([1](https://linustechtips.com/topic/1479168-issue-enabling-svm-virtualization-causes-bclk-to-fluctuate-a-lot))

    - Verify Virtualization/SVM status in Task Manager

- Disable all power-saving features such as [ASPM (Active State Power Management)](https://en.wikipedia.org/wiki/Active_State_Power_Management) (e.g. search for *L0*, *L1*), [ALPM (Aggressive Link Power Management)](https://en.wikipedia.org/wiki/Aggressive_Link_Power_Management), DRAM Power Down Mode, DRAM Self Refresh (may cause issues with restart/shutdown), Power/Clock Gating and more. You can also look out for options named *power management* or *power saving*. Search the internet if you are unsure whether a given setting is power-saving related

- Disable unnecessary devices such as WLAN, Bluetooth, High Definition Audio (if you aren't using motherboard audio) controllers and unused USB ports (refer to [USB Device Tree Viewer](https://www.uwe-sieber.de/usbtreeview_e.html)), PCIe slots, iGPU, SATA and RAM slots

- Disable Trusted Platform Module. On Windows 11, a minority of anti-cheats (Vanguard, FACEIT) require it to be enabled

    - Verify TPM status by typing ``tpm.msc`` in ``Win+R``

- Enable High Precision Event Timer. If the setting is hidden, there is a good chance that it is enabled by default

    - On AMD systems with newer AGESA firmware, changing this setting will have no effect

- MBR/Legacy requires Compatibility Support Module and typically, only the storage and PCIe OpROMs are required, but you can enable all of them if you are unsure. Disable CSM if you are using GPT/UEFI

    - Windows 7 GPT/UEFI requires CSM and OpROMs unless you are using [uefiseven](https://github.com/manatails/uefiseven)

- Disable Secure Boot. On Windows 11, a minority of anti-cheats (Vanguard, FACEIT) require it to be enabled

    - Verify Secure Boot status by typing ``msinfo32`` in ``Win+R``

- Disable Fast Startup, Suspend to RAM or similar options

- Disable Spread Spectrum and ensure BCLK frequency is close to the desired value as possible (e.g. 100.00MHz not 99.97MHz) in [HWiNFO](https://www.hwinfo.com)/[CPU-Z](https://www.cpuid.com/softwares/cpu-z.html)

- Disable Legacy USB Support as it generates unnecessary SMIs ([1](https://patents.google.com/patent/US6067589)). You may need to turn this on to install a new operating system or to access BIOS

- Disable XHCI Hand-off

- If applicable, disable software installation options such as ASUS Armoury Crate

- Set the primary graphics to dGPU instead of iGPU if applicable

- Set PCIe link speed to the maximum supported such as ``Gen 3.0``. This may be represented as gigatransfers per second (GT/s)

- Disable Execute Disable Bit/NX Mode. A minority of applications (Valorant) require it to be enabled

- If you are configuring a static frequency/voltage for the CPU in the next section, disable dynamic frequency features such as Speed Shift, SpeedStep and set the AVX offset to 0 so that the CPU does not downclock during AVX workloads. [Precision Boost Overdrive](https://www.amd.com/en/support/kb/faq/cpu-pb2) for Ryzen CPUs is an alternative option to a static frequency and voltages

    - In some cases, the settings mentioned above may prevent the processor from exceeding its base frequency despite manually configuring it in BIOS. Adjust accordingly if this is encountered and ensure that your CPU is able to run boost clocks in [HWiNFO](https://www.hwinfo.com)

- Configure fan curves or set a static, high, noise-acceptable RPM. Set your AIO pump speed to full if applicable

    - See [Ultimate fan speed curve (by KGCT, iteration 1)](https://imgur.com/a/2UDYXp0)

- When overclocking, you may be required to raise various power limits if the default limits are exceeded

- Backup BIOS by saving the current settings to a profile or export to local storage as clearing CMOS will wipe all settings if you need to do so while overclocking

    - In my experience on various motherboards, loading a saved profile doesn't restore some settings after clearing CMOS. It is recommended to dump nvram using a tool such as [SCEWIN](https://github.com/amitxv/SCEWIN) so that when you restore a profile, dump nvram again then compare it to the previous/original one to see whether anything failed to restore by using a text comparison tool such as the [Notepad++ Compare plugin](https://sourceforge.net/projects/npp-compare) or [Visual Studio Code](https://code.visualstudio.com/download)

## Stability, Hardware Clocking and Thermal Performance

Ensure that all of your hardware is stable before configuring a new operating system as unstable hardware can lead to crashes, data corruption, worse performance or irreversible damage to hardware. The effectiveness of testing for instability varies between tools which is why it is important to use a range of them for a sufficient amount of time (a non-exhaustive list of recommended tools is listed below).

- It is recommended to dual-boot a fresh installation of Windows to avoid corrupting your main operating system while stress-testing and overclocking. In terms of memory stress-testing, this also allows the stress-test to use more RAM as it isn't being hogged by potential bloatware on your current installation

- Verify and validate changes within software to avoid unexpected results and behavior (e.g. frequency, voltages, timings)

- Save a BIOS profile before each change when overclocking such as changing CPU/RAM frequency and RAM timings so that you don't lose progress if you need to clear CMOS. Refer to the last point in the [BIOS](#bios) section regarding restoring settings properly

- Use [HWiNFO](https://www.hwinfo.com) to monitor system sensors. A higher polling interval can help to identify sudden spikes but not transients on a microsecond scale as an example. Avoid running while benchmarking as it has the potential to reduce the reliability of results

- A single error or crash is one too many

- Monitoring voltages where applicable due to potential overvolting

- Overclocking does not necessarily mean that the system will perform better due to factors such as error correction. You should verify whether whatever you are changing scales positively by adopting a systematic testing methodology in benchmarks such as [liblava](https://github.com/liblava/liblava) and [Intel Memory Latency Checker](https://amitxv.github.io/IMLC-Analyzer)

- There are countless factors that contribute to stability such as temperature, power delivery, quality of hardware in general, silicon lottery and more. To apply additional stress when tuning any component (e.g. CPU, RAM, GPU), consider turning off case, RAM fans or reducing RPM along with generating extra heat (e.g. GPU load, room heaters) while stress-testing

    - See [RAM overclock stability and heat management | Actually Hardcore Overclocking](https://www.youtube.com/watch?v=iCD0ih4qzHw)

- Avoid thermal throttling at all costs. As a reminder, ambient temperature will generally increase during the summer. Deliberately underclock if your cooler is inadequate. A thermally stable component with an overall lower frequency is always better and safer compared to thermal throttling at a higher frequency/voltage

- Monitor WHEAs. [HWiNFO](https://www.hwinfo.com) has an error count

- If desired, configure load-line calibration. This isn't a recommendation for what mode to use

    - See [VRM Load-Line Visualized | ElmorLabs](https://elmorlabs.com/2019-09-05/vrm-load-line-visualized)

    - See [Vdroop setting and it’s impact on CPU operation | xDevs](https://xdevs.com/guide/e399ocg/#vdroop)

    - See [Why Vdroop is good for overclocking and taking a look at Gigabyte's Override Vcore mode | Actually Hardcore Overclocking](https://www.youtube.com/watch?v=zqvNkh4TVw8)

- Overclock your GPU. You may be required to flash a BIOS with a higher power limit

    - Ensure to disable ``CUDA - Force P2 State`` with [NVIDIA Profile Inspector](https://github.com/Orbmu2k/nvidiaProfileInspector) to prevent memory downclocking while stress-testing

    - See [A slightly better way to overclock and tweak your Nvidia GPU | Cancerogeno](https://docs.google.com/document/d/14ma-_Os3rNzio85yBemD-YSpF_1z75mZJz1UdzmW8GE/edit)

    - See [LunarPSD/NvidiaOverclocking](https://github.com/LunarPSD/NvidiaOverclocking/blob/main/Nvidia%20Overclocking.md)

- Configure RAM frequency and timings manually for a significant performance improvement ([1](https://kingfaris.co.uk/blog/intel-ram-oc-impact)). XMP does not tune many timings nor does it guarantee stability

    - See [Eden’s DDR4 guide](https://cdn.discordapp.com/attachments/328891236918493184/1172922515962724444/DDR4_Guide_V1.2.1.pdf)

    - See [KoTbelowall/INTEL-DDR4-RAM-OC-GUIDE-by-KoT](https://github.com/KoTbelowall/INTEL-DDR4-RAM-OC-GUIDE-by-KoT)

    - See [integralfx/MemTestHelper](https://github.com/integralfx/MemTestHelper/blob/oc-guide/DDR4%20OC%20Guide.md)

- Configure static all-core frequencies and voltages for the CPU. Variations in hardware clocks can introduce jitter due to the process of frequency transitions. [Precision Boost Overdrive](https://www.amd.com/en/support/kb/faq/cpu-pb2) for Ryzen CPUs is an alternative option to a static frequency and voltages

- The previous two bullet points affect each other in terms of stability which means that your RAM overclock may become unstable after overclocking your CPU, so run RAM stress-tests again and adjust your CPU settings if required

- Tune and optionally overclock your display with [Custom Resolution Utility](https://www.monitortests.com/forum/Thread-Custom-Resolution-Utility-CRU) and test for [frame skipping](https://www.testufo.com/frameskipping)

    - Aim for an ``actual`` integer refresh rate such as 60.00/240.00, not 59.94/239.76. Using the exact timing can help achieve this

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

- [FIRESTARTER](https://github.com/tud-zih-energy/FIRESTARTER)

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
