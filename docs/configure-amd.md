# Configure the AMD Driver

## Stripping & Installing the Driver

- Download & extract the latest driver from the [AMD drivers & support page](https://www.amd.com/en/support)

- Move ``\Packages\Drivers\Display\XXXX_INF`` to the Desktop (folder may be named differently on other driver versions). Delete everything apart from the following:

    - See [media/amd-driver-example.png](../media/amd-driver-example.png)

- In the folder of the driver directory (mine is **B381690** in the example above), move **ccc2_install.exe** to the Desktop. This will be used in a later step

- Open device manager & install the driver by right clicking the display adapter, browse my computer for driver software & select the driver folder

- Once the driver has installed, extract **ccc2_install.exe** with 7-Zip & run ``\CN\cnext\cnext64\ccc-next64.msi`` to install the radeon software control panel.

- Ensure to disable the bloat AMD services in win + r, **services.msc**

## Configure AMD Control Panel

- In the **Settings > Graphics** section, configure the following:

    - Texture Filtering Quality - Performance

    - Tessellation Mode - Override application settings

    - Maximum Tessellation Level - Off

- In the **Settings > Display section**, configure the following:

    - FreeSync - Has the potential to increase input latency due to extra processing however it has supposedly improved over time so feel free to test it yourself, your mileage may vary

    - GPU Scaling - Off
    
    - HDCP Support - Disable (required for DRM content)

## Locking Clocks/P-State 0

- Use [OverdriveNTool](https://forums.guru3d.com/threads/overdriventool-tool-for-amd-gpus.416116) or [MorePowerTool](https://www.igorslab.de/en/red-bios-editor-and-morepowertool-adjust-and-optimize-your-vbios-and-even-more-stable-overclocking-navi-unlimited) to reduce render time & jitter caused by frequency transitions

## Configure Flip Queue Size & ULPS

The following commands disable ultra low power states & set the flip queue size to 1

- Run ``C:\prerequisites\scripts\get-driver-keys.bat`` to get the driver keys on your system

    ```bat
    set "key=0000"
    Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%key%" /v "EnableUlps" /t REG_DWORD /d "0" /f
    Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%key%\UMD" /v "Main3D_DEF" /t REG_SZ /d "1" /f
    Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%key%\UMD" /v "Main3D" /t REG_BINARY /d "3100" /f
    Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\%key%\UMD" /v "FlipQueueSize" /t REG_BINARY /d "3100" /f
    ```
