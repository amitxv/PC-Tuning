# Configure the AMD Driver

Disclaimer: I no longer own an AMD GPU meaning this section may be incomplete/unmaintained.

## Strip and Install the Driver

- Download and extract the latest recommended driver from the [AMD drivers and support page](https://www.amd.com/en/support)

- Move ``Packages\Drivers\Display\XXXX_INF`` to the desktop (the folder may be named differently on other driver versions). Delete everything apart from the following:

    - See [media/amd-driver-example.png](/media/amd-driver-example.png)

- Open Device Manager and install the driver by right-clicking on the display adapter, then select ``Update driver`` and select the driver folder

- Navigate to the driver directory (mine is ``B381690``) and extract ``ccc2_install.exe`` with 7-Zip and run ``CN\cnext\cnext64\ccc-next64.msi`` to install the Radeon software control panel

- Ensure to disable the unnecessary AMD services and drivers in [ServiWin](https://www.nirsoft.net/utils/serviwin.html). These are typically the ``AMD Crash Defender`` services and ``AMD External Events Utility`` (required for VRR)

## Configure AMD Control Panel

- Configure the following in the ``Graphics`` section:

    - Texture Filtering Quality - Performance

    - Tessellation Mode - Override application settings

    - Maximum Tessellation Level - Off

- Configure the following in the `Display` section:

    - HDCP Support - Disable (required for DRM content)

## Lock GPU Clocks/P-State 0

- Force P-State 0 with [MorePowerTool](https://www.igorslab.de/en/red-bios-editor-and-morepowertool-adjust-and-optimize-your-vbios-and-even-more-stable-overclocking-navi-unlimited), [MoreClockTool](https://www.igorslab.de/en/the-moreclocktool-mct-for-free-download-the-practical-oc-attachment-to-the-morepowertool-replaces-the-wattman) or [OverdriveNTool](https://forums.guru3d.com/threads/overdriventool-tool-for-amd-gpus.416116)
