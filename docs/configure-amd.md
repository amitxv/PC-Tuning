# Configure the AMD Driver

## Strip and Install the Driver

- Download and extract the latest recommended driver from the [AMD drivers and support page](https://www.amd.com/en/support)

- Move ``Packages\Drivers\Display\XXXX_INF`` to the desktop (folder may be named differently on other driver versions). Delete everything apart from the following:

    - See [media/amd-driver-example.png](../media/amd-driver-example.png)

- In the folder of the driver directory (mine is ``B381690`` in the example above), move ``ccc2_install.exe`` to the desktop. This will be used in a later step

- Open notepad file and save it as ``ccc2_install.exe`` to the driver folder as shown below

    - See [media/replace-ccc2_install-example.png](../media/replace-ccc2_install-example.png)

- Open device manager and install the driver by right-clicking on the display adapter, browse my computer for driver software and select the driver folder

- Once the driver has installed, extract ``ccc2_install.exe`` with 7-Zip and run ``CN\cnext\cnext64\ccc-next64.msi`` to install the Radeon software control panel

- Ensure to disable the bloatware AMD services. They can be accessed by typing ``services.msc`` in ``Win+R``

## Configure AMD Control Panel

- Configure the following in the graphics section:

    - Texture Filtering Quality - Performance

    - Tessellation Mode - Override application settings

    - Maximum Tessellation Level - Off

- Configure the following in the display section:

    - FreeSync - Has the potential to increase input latency due to extra processing. However, it has supposedly improved over time so feel free to benchmark it yourself, your mileage may vary

    - GPU Scaling - Off

    - HDCP Support - Disable (required for DRM content)

## Lock GPU Clocks/P-State 0

- Force P-State 0 with [MorePowerTool](https://www.igorslab.de/en/red-bios-editor-and-morepowertool-adjust-and-optimize-your-vbios-and-even-more-stable-overclocking-navi-unlimited), [MoreClockTool](https://www.igorslab.de/en/the-moreclocktool-mct-for-free-download-the-practical-oc-attachment-to-the-morepowertool-replaces-the-wattman) or [OverdriveNTool](https://forums.guru3d.com/threads/overdriventool-tool-for-amd-gpus.416116)

## Configure Flip Queue Size and ULPS

The following commands disable ultra low power states and set the flip queue size to 1.

- Run ``C:\bin\scripts\query-driver-key.bat Win32_VideoController`` in CMD to get the GPU driver keys on your system

    ```bat
    set "key=0000"
    reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%key%" /v "EnableUlps" /t REG_DWORD /d "0" /f
    reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%key%\UMD" /v "Main3D_DEF" /t REG_SZ /d "1" /f
    reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%key%\UMD" /v "Main3D" /t REG_BINARY /d "3100" /f
    reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%key%\UMD" /v "FlipQueueSize" /t REG_BINARY /d "3100" /f
    ```
