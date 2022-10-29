# Configure the NVIDIA Driver

## Strip and Install the Driver

I recommend using the 472.12 ([Windows 7/Windows 8](https://www.nvidia.co.uk/Download/driverResults.aspx/180606/en-uk), [Windows 10+](https://www.nvidia.com/download/driverResults.aspx/180555/en-us)) as it is the latest non-DCH driver. The latest DCH driver now ships with the NVidia control panel, Windows Store is no longer required to install it so feel free to use it on Windows 10+.

- Extract the driver executable package with 7-Zip and remove all folders **except** the following:

    ```
    Display.Driver
    NVI2
    EULA.txt
    ListDevices.txt
    setup.cfg
    setup.exe
    ```
        
- Remove the following lines from **setup.cfg** (near the bottom):

    ```
    <file name="${{EulaHtmlFile}}"/>
    <file name="${{FunctionalConsentFile}}"/>
    <file name="${{PrivacyPolicyFile}}"/>
    ```

- In ``.\NVI2\presentations.cfg`` set the value for **ProgressPresentationUrl** and **ProgressPresentationSelectedPackageUrl** to an empty string:

    ```
    <string name="ProgressPresentationUrl" value=""/>
    <string name="ProgressPresentationSelectedPackageUrl" value=""/>
    ```

- Run setup.exe to install the driver

    - If setup fails however you followed the steps above correctly, try redownload the driver and follow the steps again. Some users have reported this is due to a corrupted download

- Open CMD and enter the commands below to disable telemetry

    ```bat
    reg.exe add "HKLM\SOFTWARE\NVIDIA Corporation\NvControlPanel2\Client" /v "OptInOrOutPreference" /t REG_DWORD /d 0 /f
    ```

    ```bat
    reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup" /v "SendTelemetryData" /t REG_DWORD /d 0 /f
    ```

## Disable HDCP (required for DRM content)

HDCP Can be disabled with the [following registry key](https://github.com/djdallmann/GamingPCSetup/blob/master/CONTENT/RESEARCH/WINDRIVERS/README.md#q-are-there-any-configuration-options-that-allow-you-to-disable-hdcp-when-using-nvidia-based-graphics-cards) (reboot required), ensure to change the driver key to suit your needs.

- Run ``C:\prerequisites\scripts\get-driver-keys.bat`` to get the driver keys on your system
        
    ```bat
    reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMHdcpKeyglobZero" /t REG_DWORD /d "1" /f
    ```

## Configure NVIDIA Control Panel

- Disable **Desktop > Show Notification Tray Icon**

- In the **3D Settings > Manage 3D settings** section, configure the following:

    - Anisotropic filtering - Off
    - Antialiasing - Gamma correction - Off
    - Low Latency Mode - On (limits prerendered frames to 1)
    - Power management mode - Prefer maximum performance
    - Texture filtering - Quality - High performance
    - [Threaded Optimization offloads GPU-related processing tasks on the CPU](https://tweakguides.pcgamingwiki.com/NVFORCE_8.html), it usually hurts frametime consistency but feel free to benchmark it yourself. You should also consider whether or not you are already CPU bottlenecked if you do choose to enable the setting

- In the **Display > Adjust Desktop size and position** section, set the scaling mode to **No Scaling** and set perform scaling on to **Display**. Configure your resolution and refresh rate

- Consider disabling G-Sync, it has the potential to increase input latency due to extra processing however it has supposedly improved over time so feel free to benchmark it yourself, your mileage may vary

## Lock Clocks/P-State 0
    
Force P-State 0 with the [following registry key](https://github.com/djdallmann/GamingPCSetup/blob/master/CONTENT/RESEARCH/WINDRIVERS/README.md#q-is-there-a-registry-setting-that-can-force-your-display-adapter-to-remain-at-its-highest-performance-state-pstate-p0) to reduce render time and jitter caused by frequency transitions (reboot required), ensure to change the driver key to suit your needs.

- Run ``C:\prerequisites\scripts\get-driver-keys.bat`` to get the driver keys on your system

    ```bat
    reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableDynamicPstate" /t REG_DWORD /d "1" /f
    ```

## Disable Ansel

Disable Ansel with ``C:\prerequisites\nvidia-ansel-configurator\NvCameraConfiguration_v1.0.0.6.exe``.

## Configure NVIDIA Inspector

During CUDA workloads, the memory clock frequency will downclock to P-State 2 despite following the [Lock Clocks/P-State 0](#lock-clocksp-state-0) step. For this reason, you should set **CUDA - Force P2 State** to **Off**. [**SILK Smoothness**](https://www.avsim.com/forums/topic/552651-nvidia-setting-silk-smoothness) can also be disabled.

- See [CUDA-force-p2-state-analysis](../media/cuda-force-p2-state-analysis.png)

```
C:\prerequisites\nvidia-profile-inspector\nvidiaProfileInspector.exe
```