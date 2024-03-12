# Configure the AMD Driver

> [!IMPORTANT]
> Disclaimer: I no longer own an AMD GPU meaning this section may be incomplete/unmaintained. For this reason, you can visit the AMD GPUs section in [Calypto's Latency Guide](https://calypto.us).

## Table of Contents

- [Strip and Install the Driver](#strip-and-install-the-driver)
- [Configure AMD Control Panel](#configure-amd-control-panel)
- [Lock GPU Clocks/P-State 0](#lock-gpu-clocksp-state-0)

## Strip and Install the Driver

- Download and extract the latest recommended driver from the [AMD drivers and support page](https://www.amd.com/en/support)

- Move ``Packages\Drivers\Display\XXXX_INF`` to the desktop. The folder may be named differently on other driver versions

- Open Device Manager and install the driver by right-clicking on the display adapter, then select ``Update driver`` and select the driver folder

- Extract ``XXXX_INF\ccc2_install.exe`` with 7-Zip and run ``CN\cnext\cnext64\ccc-next64.msi`` to install the Radeon software control panel

- Download [Autoruns](https://learn.microsoft.com/en-us/sysinternals/downloads/autoruns) and navigate to the ``Everything`` section, then disable unnecessary AMD entries such as ``AMD Crash Defender``, ``AMD External Events Utility`` (required for VRR) and more. Ensure not to disable the core kernel-mode driver or other important components

## Configure AMD Control Panel

> [!WARNING]
> 💻 If you are configuring a system for general-purpose use such as for work or school, then skip this step as it is not required.

- Configure the following in the `Display` section:

    - HDCP Support - Disable (required for DRM content)

## Lock GPU Clocks/P-State 0

> [!WARNING]
> 💻 If you are configuring a system for general-purpose use such as for work or school, then skip this step as it is not required.

- Force P-State 0 with [MorePowerTool](https://www.igorslab.de/en/red-bios-editor-and-morepowertool-adjust-and-optimize-your-vbios-and-even-more-stable-overclocking-navi-unlimited), [MoreClockTool](https://www.igorslab.de/en/the-moreclocktool-mct-for-free-download-the-practical-oc-attachment-to-the-morepowertool-replaces-the-wattman) or [OverdriveNTool](https://forums.guru3d.com/threads/overdriventool-tool-for-amd-gpus.416116). This mitigates the undesirable delay to execute new instructions when the unit enters a deeper power-saving state at the expense of higher idle temperatures and power consumption
