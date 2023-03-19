# Configure the AMD Driver

## Strip and Install the Driver

- Download and extract the latest recommended driver from the [AMD drivers and support page](https://www.amd.com/en/support)

- Move ``Packages\Drivers\Display\XXXX_INF`` to the desktop (folder may be named differently on other driver versions). Delete everything apart from the following:

    - See [media/amd-driver-example.png](/media/amd-driver-example.png)

- Open device manager and install the driver by right-clicking on the display adapter, browse my computer for driver software and select the driver folder

- Navigate to the driver directory (mine is ``B381690``) and extract ``ccc2_install.exe`` with 7-Zip and run ``CN\cnext\cnext64\ccc-next64.msi`` to install the Radeon software control panel

- Ensure to disable the bloatware AMD services. They can be accessed by typing ``services.msc`` in ``Win+R``

## Configure AMD Control Panel

- Configure the following in the graphics section:

    - Texture Filtering Quality - Performance

    - Tessellation Mode - Override application settings

    - Maximum Tessellation Level - Off

- Configure the following in the display section:

    - FreeSync - Has the potential to increase input latency due to extra processing. However, it has supposedly improved over time, your mileage may vary

    - GPU Scaling - Off

    - HDCP Support - Disable (required for DRM content)

## Lock GPU Clocks/P-State 0

- Force P-State 0 with [MorePowerTool](https://www.igorslab.de/en/red-bios-editor-and-morepowertool-adjust-and-optimize-your-vbios-and-even-more-stable-overclocking-navi-unlimited), [MoreClockTool](https://www.igorslab.de/en/the-moreclocktool-mct-for-free-download-the-practical-oc-attachment-to-the-morepowertool-replaces-the-wattman) or [OverdriveNTool](https://forums.guru3d.com/threads/overdriventool-tool-for-amd-gpus.416116)
