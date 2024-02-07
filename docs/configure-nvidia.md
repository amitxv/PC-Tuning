# Configure the NVIDIA Driver

## Table of Contents

- [Strip and Install the Driver](#strip-and-install-the-driver)
- [Disable HDCP (required for DRM content)](#disable-hdcp-required-for-drm-content)
- [Configure NVIDIA Control Panel](#configure-nvidia-control-panel)
    - [Manage 3D Settings](#manage-3d-settings)
    - [Change Resolution](#change-resolution)
    - [Adjust Video Color Settings](#adjust-video-color-settings)
- [Lock GPU Clocks/P-State 0](#lock-gpu-clocksp-state-0)
- [Configure NVIDIA Inspector](#configure-nvidia-inspector)

## Strip and Install the Driver

Download the latest game ready (not security update) driver using the [advanced driver search](https://www.nvidia.com/download/find.aspx) page. DCH drivers are supported on Windows 10 1803+ ([1](https://nvidia.custhelp.com/app/answers/detail/a_id/4777/~/nvidia-dch%2Fstandard-display-drivers-for-windows-10-faq)).

- Extract the driver executable package with 7-Zip and remove all files and folders except the following:

    ```
    Display.Driver
    NVI2
    EULA.txt
    ListDevices.txt
    setup.cfg
    setup.exe
    ```

- Remove the following lines from ``setup.cfg``:

    ```
    <file name="${{EulaHtmlFile}}"/>
    <file name="${{FunctionalConsentFile}}"/>
    <file name="${{PrivacyPolicyFile}}"/>
    ```

- In ``NVI2\presentations.cfg`` set the value for ``ProgressPresentationUrl`` and ``ProgressPresentationSelectedPackageUrl`` to an empty string to remove adware in the installer:

    ```
    <string name="ProgressPresentationUrl" value=""/>
    <string name="ProgressPresentationSelectedPackageUrl" value=""/>
    ```

- Run ``setup.exe`` to install the driver

- Open CMD and enter the command below to disable telemetry

    ```bat
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\SendTelemetryData" /t REG_DWORD /d "0" /f
    ```

## Disable HDCP (required for DRM content)

> [!WARNING]
> 💻 If you are configuring a system for general-purpose use such as for work or school, then skip this step as it is not required.

HDCP can be disabled with the [following registry key](https://github.com/djdallmann/GamingPCSetup/blob/master/CONTENT/RESEARCH/WINDRIVERS/README.md#q-are-there-any-configuration-options-that-allow-you-to-disable-hdcp-when-using-nvidia-based-graphics-cards) (reboot required). Ensure to change the driver key to the one that corresponds to the correct NVIDIA GPU.

- See [media/find-driver-key-example.png](/media/find-driver-key-example.png) to obtain the correct driver key in Device Manager

    ```bat
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMHdcpKeyglobZero" /t REG_DWORD /d "1" /f
    ```

## Configure NVIDIA Control Panel

### Manage 3D Settings

> [!WARNING]
> 💻 If you are configuring a system for general-purpose use such as for work or school, then skip this step as it is not required.

- Anisotropic filtering - Off

- Antialiasing - Gamma correction - Off

- Low Latency Mode - On/Ultra

    > If a game supports the NVIDIA Reflex Low Latency mode, we recommend using that mode over the Ultra Low Latency mode in the driver. However, if you leave both on, the Reflex Low Latency mode will take higher priority automatically for you ([1](https://www.nvidia.com/en-gb/geforce/news/reflex-low-latency-platform))

- Power management mode - Prefer maximum performance

- Shader Cache Size - Unlimited

- Texture filtering - Quality - High performance

- Threaded Optimization - offloads GPU-related processing tasks on the CPU ([1](https://tweakguides.pcgamingwiki.com/NVFORCE_8.html)). It usually hurts frame pacing as it takes CPU time away from your real-time application. You should also determine whether you are already CPU bottlenecked if you do choose to enable the setting

- Ensure that settings aren't being overridden for programs in the ``Program Settings`` tab, such as Image Sharpening for some EAC games

### Change Resolution

- Output dynamic range - Full

### Adjust Video Color Settings

- Dynamic range - Full

## Lock GPU Clocks/P-State 0

> [!WARNING]
> 💻 If you are configuring a system for general-purpose use such as for work or school, then skip this step as it is not required.

Force P-State 0 with the [registry key](https://github.com/djdallmann/GamingPCSetup/blob/master/CONTENT/RESEARCH/WINDRIVERS/README.md#q-is-there-a-registry-setting-that-can-force-your-display-adapter-to-remain-at-its-highest-performance-state-pstate-p0) below (reboot required). Ensure to change the driver key to the one that corresponds to the correct NVIDIA GPU. To reduce power consumption while your real-time application isn't running, use [limit-nvpstate](https://github.com/amitxv/limit-nvpstate). This mitigates the undesirable delay to execute new instructions when the unit enters a deeper power-saving state at the expense of higher idle temperatures and power consumption

- See [media/find-driver-key-example.png](/media/find-driver-key-example.png) to obtain the correct driver key in Device Manager

    ```bat
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableDynamicPstate" /t REG_DWORD /d "1" /f
    ```

## Configure NVIDIA Inspector

> [!WARNING]
> 💻 If you are configuring a system for general-purpose use such as for work or school, then skip this step as it is not required.

- Download and extract [NVIDIA Profile Inspector](https://github.com/Orbmu2k/nvidiaProfileInspector)

- Disable ``Enable Ansel`` as it is injected in all games by the display drivers, regardless if the game supports Ansel or not which may cause conflicts with third-party tools or injectors ([1](https://www.pcgamingwiki.com/wiki/Nvidia#Ansel))

- If applicable, you can experiment with forcing Resizable BAR on unsupported games for a potential performance improvement by toggling the options below ([1](https://www.youtube.com/watch?v=ZTOtqWTFSK8))

    - rBAR - Feature

    - rBAR - Options

    - rBAR - Size Limit

- Disable ``CUDA - Force P2 State`` to prevent the memory clock frequency from downclocking during CUDA workloads as it enters P-State 2 despite following the [Lock GPU Clocks/P-State 0](#lock-gpu-clocksp-state-0) steps ([1](/media/cuda-force-p2-state-analysis.png))
