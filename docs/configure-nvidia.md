# Configure the NVIDIA Driver

## Strip and Install the Driver

Download the latest game ready (not security update) driver using the [advanced driver search](https://www.nvidia.com/download/find.aspx) page.

- Extract the driver executable package with 7-Zip and remove all files and folders except the following:

    ```txt
    Display.Driver
    NVI2
    EULA.txt
    ListDevices.txt
    setup.cfg
    setup.exe
    ```

- Remove the following consecutive lines from ``setup.cfg`` (near the bottom):

    ```txt
    <file name="${{EulaHtmlFile}}"/>
    <file name="${{FunctionalConsentFile}}"/>
    <file name="${{PrivacyPolicyFile}}"/>
    ```

- In ``NVI2\presentations.cfg`` set the value for ProgressPresentationUrl and ProgressPresentationSelectedPackageUrl to an empty string:

    ```txt
    <string name="ProgressPresentationUrl" value=""/>
    <string name="ProgressPresentationSelectedPackageUrl" value=""/>
    ```

- Run ``setup.exe`` to install the driver

- Open CMD and enter the commands below to disable telemetry

    ```bat
    reg.exe add "HKLM\SOFTWARE\NVIDIA Corporation\NvControlPanel2\Client" /v "OptInOrOutPreference" /t REG_DWORD /d "0" /f
    ```

    ```bat
    reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup" /v "SendTelemetryData" /t REG_DWORD /d "0" /f
    ```

## Disable HDCP (required for DRM content)

HDCP can be disabled with the [following registry key](https://github.com/djdallmann/GamingPCSetup/blob/master/CONTENT/RESEARCH/WINDRIVERS/README.md#q-are-there-any-configuration-options-that-allow-you-to-disable-hdcp-when-using-nvidia-based-graphics-cards) (reboot required), ensure to change the driver key to suit your needs.

- Run ``C:\bin\scripts\query-driver-key.bat Win32_VideoController`` in CMD to get the GPU driver keys on your system

    ```bat
    reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMHdcpKeyglobZero" /t REG_DWORD /d "1" /f
    ```

## Configure NVIDIA Control Panel

- Configure the following in the manage 3D settings page:

    - Anisotropic filtering - Off

    - Antialiasing - Gamma correction - Off

    - Low Latency Mode - On (limits prerendered frames to 1)

    - Power management mode - Prefer maximum performance

    - Shader Cache Size - Unlimited

    - Texture filtering - Quality - High performance

    - [Threaded Optimization offloads GPU-related processing tasks on the CPU](https://tweakguides.pcgamingwiki.com/NVFORCE_8.html), it usually hurts frame pacing but feel free to benchmark it yourself. You should also consider whether you are already CPU bottlenecked if you do choose to enable the setting

- Set the scaling mode to no scaling and set perform scaling on display. Configure your resolution and refresh rate

- Consider disabling G-Sync. It has the potential to increase input latency due to extra processing. However, it has supposedly improved over time, so feel free to benchmark it yourself, your mileage may vary

## Lock GPU Clocks/P-State 0

Force P-State 0 with the [registry key](https://github.com/djdallmann/GamingPCSetup/blob/master/CONTENT/RESEARCH/WINDRIVERS/README.md#q-is-there-a-registry-setting-that-can-force-your-display-adapter-to-remain-at-its-highest-performance-state-pstate-p0) below (reboot required). Ensure to change the driver key to suit your needs. To reduce power consumption while not in-game, consider using [limit-nvpstate](https://github.com/amitxv/limit-nvpstate).

- Run ``C:\bin\scripts\query-driver-key.bat Win32_VideoController`` in CMD to get the GPU driver keys on your system

    ```bat
    reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableDynamicPstate" /t REG_DWORD /d "1" /f
    ```

## Configure NVIDIA Inspector

During CUDA workloads, the memory clock frequency will downclock to P-State 2 despite following the [Lock GPU Clocks/P-State 0](#lock-gpu-clocksp-state-0) steps. For this reason, you should disable CUDA - Force P2 State. [SILK Smoothness](https://www.avsim.com/forums/topic/552651-nvidia-setting-silk-smoothness) and Enable Ansel can also be disabled.

- See [media/CUDA-force-p2-state-analysis](../media/cuda-force-p2-state-analysis.png)

- Download and extract [NVIDIA Profile Inspector](https://github.com/Orbmu2k/nvidiaProfileInspector)
