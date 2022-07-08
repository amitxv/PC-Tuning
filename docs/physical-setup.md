# Physical Setup

## Content Overview

- [USB Port configuration](#usb-port-configuration)
- [BIOS](#bios)
- [Minimizing Interference](#minimizing-interference)
- [Configure Peripherals](#configure-peripherals)
- [Stability & Hardware Clocking](#stability-and-hardware-clocking)

## USB Port configuration

- Plug your mouse & keyboard into the first two ports on your first usb controller. This can be determined in [USB Device Tree Viewer](https://www.uwe-sieber.de/usbtreeview_e.html#download) with trial & error.

    - Ryzen systems have a usb port that is directly connected to the cpu which can be identified through the motherboard manual

- If you have more than one usb controller, you can isolate devices such as DACs, headsets & other devices onto another controller to prevent them interfering with polling consistency.

## BIOS

- Disable [Hyper-Threading](https://en.wikipedia.org/wiki/Hyper-threading)/ [Simultaneous Multithreading](https://en.wikipedia.org/wiki/Simultaneous_multithreading). This feature is beneficial for highly threaded operations such as video editing, compiling & rendering however using multiple execution threads per core requires resource sharing & is a potential source of system latency & jitter [[1](https://developer.amd.com/wordpress/media/2013/12/PerformanceTuningGuidelinesforLowLatencyResponse.pdf)][[2](https://www.intel.com/content/www/us/en/developer/articles/technical/optimizing-computer-applications-for-latency-part-1-configuring-the-hardware.html)]. Other drawbacks include limited overclocking potential & increased core package temperatures.

- Limit C-States, P-States & S-States to the minimum or disable them. It is a source of jitter due to the process of state transition.

- Enable XMP for your RAM or configure the frequency & timings manually.

- Set a static all-core frequency & voltage for the CPU. Variation in hardware clocks can introduce jitter due to the frequency transitions of cores [[1](https://developer.amd.com/wordpress/media/2013/12/PerformanceTuningGuidelinesforLowLatencyResponse.pdf)].

    - Configure load-line calibration to minimize voltage fluctuation under load.

- Disable [Virtualization](https://en.wikipedia.org/wiki/Desktop_virtualization) & [IOMMU](https://en.wikipedia.org/wiki/Input%E2%80%93output_memory_management_unit) if applicable, it can cause differences in latency for memory access [[1](https://developer.amd.com/wordpress/media/2013/12/PerformanceTuningGuidelinesforLowLatencyResponse.pdf)][[2](https://www.intel.com/content/www/us/en/developer/articles/technical/optimizing-computer-applications-for-latency-part-1-configuring-the-hardware.html)].

- Disable [Active State Power Management](https://en.wikipedia.org/wiki/Active_State_Power_Management) & any other power saving features you can locate in BIOS.

- Disable unnecessary devices such as the Wireless LAN Controller, Bluetooth, unused USB controllers & unused PCI ports.

- Configure fan curves or set a static fan speed for the CPU & case fans. I personally set all fans to a reasonably high, constant, noise-acceptable speed.

- Disable TPM.

    - You can verify that it is disabled in win + r, ``tpm.msc``

- Keep HPET/ High Precision Event Timer enabled.

    - On AMD systems with newer AGESA firmware, disabling this setting will have no effect.

- Disable integrated graphics if not in use.

- Windows 7 requires Compatibility Support Module (CSM) to be enabled.

- Disable Secure Boot.

## Minimizing Interference

- Move devices that emit RF/EMF/EMI away from your setup & bedroom such as radios, mobile phones & routers. They have the potential to increase latency due to unintended behaviour of electrical components.

- Favor wired over cordless, this generally applies to mice, headsets & speakers.

- Ensure there is a moderate amount of space between cables to reduce the risk of [coupling](https://en.wikipedia.org/wiki/Coupling_(electronics)).

- Disconnect unnecessary devices from your motherboard such as LEDs, case USB ports, extra unused drives & RGB light strips etc.

## Configure Peripherals

- If your peripherals support onboard memory profiles, it is recommended to configure them before booting into the windows image you plan on configuring as you will not need to install bloatware to configure this later. More details on separating work & gaming environments with a [dual-boot](https://en.wikipedia.org/wiki/Multi-booting) later in ths guide.

- Increasing DPI reduces latency [[1](https://www.youtube.com/watch?v=6AoRfv9W110)]. Most pice are able to handle 1600 DPI without [sensor smoothing](https://www.reddit.com/r/MouseReview/comments/5haxn4/sensor_smoothing).

- Higher polling rate reduces jitter [[1](https://youtu.be/gOQNRvJbpmk?t=540)][[2](https://www.youtube.com/watch?app=desktop&v=djCLZ6qEVuA)].

- USB output is limited to roughly 7A & RGB requires unnecessary power. Turn off RGB where you can or strip the LED from the peripheral as running a RGB effect/animation can take a great toll on the MCU. It requires a lot of processing power & will delay other processes [[1](https://blog.wooting.nl/what-influences-keyboard-speed)].

- Buy a [lint roller](https://www.ikea.com/gb/en/p/baestis-lint-roller-grey-90425626) to remove dirt & debris from the mousepad once in a while.

- Buy a small [air dust blower](https://www.amazon.co.uk/s?k=air+dust+blower) to remove dirt & debris from the mouse sensor lens often.

- Factory reset your monitor & reconfigure the settings. Avoid post-processing effects & set overdrive/ AMA to an acceptably high setting as it reduces latency [[1](https://twitter.com/CaIypto/status/1464236780190851078)] but comes with a penalty of overshoot.

## Stability & Hardware Clocking

- It is highly recommended that you ensure your CPU, RAM & GPU are completely stable before configuring a new operating system (or using your PC at all) as crashes can lead to data corruption or irreversible damage to hardware.

- Stress testing involves running a heavy load on a specific hardware component to ensure that it can withstand the load without crashing, temperatures of the component will increase during this stage.

- There are many tools to stress different components, & every tool may have different algorithms which is why it is a good idea to use a variety of tools. There are countless factors that contribute to stability such as temperature, power quality, quality of VRMs, silicon lottery etc. It is also important to stress the component for a sufficient amount of time.
