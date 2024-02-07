# Post-Install Instructions

> [!IMPORTANT]
> This section is not designed to be followed on existing Windows installations. At this stage, you should be booted into the ISO that you created with the steps in [docs/pre-install.md](pre-install.md). If you have no idea what this means, then go back to the pre-install instructions in the document linked above and follow the instructions from start to finish.

## Table of Contents

- [Preliminary Notes](#preliminary-notes)
- [OOBE Setup](#oobe-setup)
- [Unrestricted PowerShell Execution Policy](#unrestricted-powershell-execution-policy)
- [Merge the Registry Files](#merge-the-registry-files)
- [Visual Cleanup](#visual-cleanup)
- [Install Drivers](#install-drivers)
- [Time, Language and Region](#time-language-and-region)
- [Activate Windows](#activate-windows)
- [Configure a Web Browser](#configure-a-web-browser)
- [Disable Residual Scheduled Tasks](#disable-residual-scheduled-tasks)
- [Miscellaneous](#miscellaneous)
- [Install Runtimes](#install-runtimes)
- [Manage Appx Packages (Windows 8+)](#manage-appx-packages-windows-8)
- [Handle Bloatware](#handle-bloatware)
- [Install 7-Zip](#install-7-zip)
- [Configure the Graphics Driver](#configure-the-graphics-driver)
- [Configure MSI Afterburner](#configure-msi-afterburner)
- [Display Resolutions and Scaling Modes](#display-resolutions-and-scaling-modes)
- [Install Open-Shell (Windows 8+)](#install-open-shell-windows-8)
- [Spectre, Meltdown and CPU Microcode](#spectre-meltdown-and-cpu-microcode)
- [Install a Media Player](#install-a-media-player)
- [Configure Power Options](#configure-power-options)
- [Configure the BCD Store](#configure-the-bcd-store)
- [Replace Task Manager with Process Explorer](#replace-task-manager-with-process-explorer)
- [Disable Process Mitigations (Windows 10 1709+)](#disable-process-mitigations-windows-10-1709)
- [Configure Memory Management Settings (Windows 8+)](#configure-memory-management-settings-windows-8)
- [Configure the Network Adapter](#configure-the-network-adapter)
- [Configure Audio Devices](#configure-audio-devices)
- [Configure Services and Drivers](#configure-services-and-drivers)
    - [Debugging Services](#debugging-services)
- [Configure Device Manager](#configure-device-manager)
- [Disable Driver Power-Saving](#disable-driver-power-saving)
- [Configure Event Trace Sessions](#configure-event-trace-sessions)
- [Optimize the File System](#optimize-the-file-system)
- [Message Signaled Interrupts](#message-signaled-interrupts)
- [XHCI Interrupt Moderation (IMOD)](#xhci-interrupt-moderation-imod)
- [Configure Control Panel](#configure-control-panel)
- [Configuring Applications](#configuring-applications)
    - [NVIDIA Reflex](#nvidia-reflex)
    - [Framerate Limit](#framerate-limit)
    - [Presentation Mode](#presentation-mode)
    - [QoS Policies](#qos-policies)
- [Per-CPU Scheduling](#per-cpu-scheduling)
    - [Kernel-Mode (Interrupts, DPCs and more)](#kernel-mode-interrupts-dpcs-and-more)
        - [GPU and DirectX Graphics Kernel](#gpu-and-directx-graphics-kernel)
        - [XHCI and Audio Controller](#xhci-and-audio-controller)
        - [Network Interface Card](#network-interface-card)
    - [User-Mode (Processes, Threads)](#user-mode-processes-threads)
        - [Starting a Process with a Specified Affinity Mask](#starting-a-process-with-a-specified-affinity-mask)
        - [Specifying an Affinity Mask for Running Processes](#specifying-an-affinity-mask-for-running-processes)
    - [Reserved CPU Sets (Windows 10+)](#reserved-cpu-sets-windows-10)
        - [Use Cases](#use-cases)
- [Raise the Clock Interrupt Frequency (Timer Resolution)](#raise-the-clock-interrupt-frequency-timer-resolution)
- [Disable Desktop Composition (DWM)](#disable-desktop-composition-dwm)
- [Analyze Event Viewer](#analyze-event-viewer)
- [CPU Idle States/C-State 0](#cpu-idle-statesc-state-0)
    - [Disable Idle States](#disable-idle-states)
    - [Enable Idle States (default)](#enable-idle-states-default)
- [Cleanup](#cleanup)
- [Final Thoughts and Tips](#final-thoughts-and-tips)

## Preliminary Notes

- Avoid applying or using random, unknown or undocumented changes and programs on your system without a comprehensive understanding of what they are changing and what impact they have on security, privacy and performance. Large all-in-one projects and closed-sourced software usually obfuscate changes being made which make it difficult to understand what goes on under the hood

- Try to favor free, open source and reputable software. Stay away from proprietary software where you can and ensure to scan files with [VirusTotal](https://www.virustotal.com/gui/home/upload) before running them

## OOBE Setup

- Windows Server may force you to enter a password which can be removed in later steps

- If you are configuring Windows 11, press ``Shift+F10`` to open CMD and execute ``oobe\BypassNRO.cmd``. This will allow us to continue without an internet connection as demonstrated in the video examples below

- See [media/oobe-windows7-example.mp4](https://raw.githubusercontent.com/amitxv/PC-Tuning/main/media/oobe-windows7-example.mp4)

- See [media/oobe-windows8-example.mp4](https://raw.githubusercontent.com/amitxv/PC-Tuning/main/media/oobe-windows8-example.mp4)

- See [media/oobe-windows10+-example.mp4](https://raw.githubusercontent.com/amitxv/PC-Tuning/main/media/oobe-windows10+-example.mp4)

- Windows Server Only:

    - To enable Wi-Fi, navigate to ``Manage -> Add Roles and Features`` in the Server Manager dashboard and enable ``Wireless LAN Service``

## Unrestricted PowerShell Execution Policy

This is required to execute the scripts within the repository. Open PowerShell as administrator and enter the command below.

```powershell
Set-ExecutionPolicy Unrestricted
```

<!-- NOTE TO SELF: Check Windows Defender UI for new options before merging registry files as the UI will become inaccessible -->

## Merge the Registry Files

> [!WARNING]
> 🔒 Some changes outlined in the table below may negatively impact security. Users should assess the security risk involved with modifying the mentioned setting.

The registry settings are merged with the ``apply-registry.ps1`` script. As for which options get applied as outlined in the table below, this can be customized by editing ``C:\bin\registry-options.json`` in a text editor and setting properties to either ``true`` or ``false``. You can safely backup the config file so that you don't need to modify it each time.

> [!IMPORTANT]
> The script does not revert options if re-run. For example, if the script was run with an option set to ``true``, then running the script with a given option set to ``false`` will not revert the changed made as the script is unaware of the previous state of the registry keys associated with the option.

|Option|Notes|Default Value|
|---|---|---|
|``disable windows update``|🔒 A value of ``true`` may negatively impact security. Users should assess the security risk involved with modifying the mentioned setting<br><br>Telemetry, intrusive, prevents CPU overhead and prevents installation of unwanted updates. Disabling Windows Update is in Microsoft's recommendations for configuring devices for real-time performance ([1](https://learn.microsoft.com/en-us/windows/iot/iot-enterprise/soft-real-time/soft-real-time-device))|``true``|
|``disable automatic windows updates``|Prevents automatic download and installation of Windows updates as the process can be intrusive compared to disabling Windows Update completely. This option is overridden if ``disable windows update`` is set to ``true``|``true``|
|``disable user account control``|🔒 A value of ``true`` may negatively impact security. Users should assess the security risk involved with modifying the mentioned setting<br><br>Eliminates [this](https://learn.microsoft.com/en-us/windows/security/application-security/application-control/user-account-control/how-it-works#uac-elevation-prompts) intrusive UAC elevation prompt and is required for running the PowerShell scripts outlined in this repository with Administrator privileges with ``shell:startup``. The only other method that I'm aware of to do so is with Task Scheduler however, its service gets disabled to mitigate CPU overhead as outlined in the [Configure Services and Drivers](#configure-services-and-drivers) section. Please note that it is recommended to skip the [Configure Services and Drivers](#configure-services-and-drivers) section when configuring a system for general-purpose use, so if this applies to you then this option can be set to ``false`` as you can use Task Scheduler since its service will not be disabled. Disabling UAC may negatively impact security as all processes are run with Administrator privileges by default ([1](https://www.howtogeek.com/124754/htg-explains-why-you-shouldnt-disable-uac/), [2](https://raptor.solutions/the-risks-of-disabling-uac-in-windows-10/))|``true``|
|``disable windows marking file attachments with information about their zone of origin``|🔒 A value of ``true`` may negatively impact security. Users should assess the security risk involved with modifying the mentioned setting<br><br>Prevents [this](https://www.tenforums.com/tutorials/85418-how-disable-downloaded-files-being-blocked-windows.html) intrusive security warning as downloaded files are constantly required to be unblocked however this may negatively impact security as the user will not be notified of blocked files as a security warning ([1](https://www.tenforums.com/tutorials/85418-how-disable-downloaded-files-being-blocked-windows.html))|``true``|
|``disable windows defender``|🔒 A value of ``true`` may negatively impact security. Users should assess the security risk involved with modifying the mentioned setting<br><br>Prevents CPU overhead and interferes with the CPU operating in C-State 0 ([1](https://www.techpowerup.com/295877/windows-defender-can-significantly-impact-intel-cpu-performance-we-have-the-fix))|``true``|
|``disable PC is out of support message``|Disables [this](https://support.microsoft.com/en-us/topic/you-received-a-notification-your-windows-7-pc-is-out-of-support-3278599f-9613-5cc1-e0ee-4f81f623adcf) intrusive message|``true``|
|``disable driver installation via windows update``|Prevents outdated, vulnerable and bloated drivers from being installed via Windows Update. It is recommended to manually only install ones that you require along with the latest version directly from the manufacture's website as outlined in the [Install Drivers](#install-drivers) section. This option is overridden if ``disable windows update`` is set to ``true``|``true``|
|``disable automatic maintenance``|Intrusive|``true``|
|``disable search indexing``|Prevents CPU overhead as files are indexed constantly in the background|``true``|
|``disable program compatibility assistant``|Prevent Windows applying changes anonymously after running troubleshooters|``true``|
|``disable customer experience improvement program``|Telemetry ([1](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/jj618322(v=ws.11)))|``true``|
|``disable fault tolerant heap``|Prevents Windows autonomously applying mitigations to prevent future crashes on a per-application basis ([1](https://learn.microsoft.com/en-us/windows/win32/win7appqual/fault-tolerant-heap))|``true``|
|``disable sticky keys``|Disables the *Do you want to turn on Sticky Keys?* promt when the hotkey is pressed a certain number of times. This is severely intrusive in applications that utilize the ``Shift`` key for controls such as games|``true``|
|``disable pointer acceleration``|Ensures one-to-one mouse response for games that do not subscribe to raw input events and on Desktop|``true``|
|``disable fast startup``|Interferes with shutting down|``true``|
|``disable hibernation``|Eliminates the need for a hibernation file. It is recommended to shut down instead. This option is overridden if ``disable fast startup`` is set to ``true``|``true``|
|``disable windows error reporting``|Telemetry|``true``|
|``reserve 10% of CPU resources for low-priority tasks instead of the default 20%``|On an optimized system with few background tasks, it is desirable to allocate most of the CPU time to the foreground process ([1](https://learn.microsoft.com/en-us/windows/win32/procthread/multimedia-class-scheduler-service))|``true``|
|``disable remote assistance``|Security risk|``true``|
|``show file extensions``|Security risk|``true``|
|``disable corner navigation``|Disables [corner navigation](https://edu.gcfglobal.org/en/windows8/getting-started-with-windows-8/1) which may become intrusive|``true``|
|``disable search the web or display web results in search``|Telemetry|``true``|
|``disable notifications network usage``|Telemetry, polls constantly prevents CPU overhead ([1](https://learn.microsoft.com/en-gb/windows/privacy/manage-connections-from-windows-operating-system-components-to-microsoft-services#10-live-tiles))|``true``|
|``disable sign-in and lock last interactive user after a restart``|Intrusive|``true``|
|``disable gamebarpresencewriter``|Prevents CPU overhead as the process runs constantly in the background even if the user disables Game Bar in settings|``true``|
|``disable telemetry``|Telemetry|``true``|
|``disable retrieval of online tips and help in the immersive control panel``|Telemetry|``true``|
|``enable the legacy photo viewer``|Alternative option to the Windows Photos app|``true``|
|``disable typing insights``|Telemetry|``true``|
|``disable transparency``|Prevents CPU overhead ([1](/media/transparency-effects-benchmark.png))|``true``|
|``disable background apps``|Disabled via policies as the option is not available in the interface on Windows 11|``true``|
|``disable suggestions in the search box and in search home``|Telemetry and intrusive|``true``|
|``allocate processor resources primarily to programs``|On client editions of Windows, this has no effect from the default behavior but is changed to ensure consistency between all editions including Windows Server|``true``|

- Open PowerShell as administrator and enter the command below

    ```powershell
    C:\bin\apply-registry.ps1
    ```

- If the command fails, try to disable tamper protection in Windows Defender (Windows 10 1909+). If that doesn't work, reboot then re-execute the command again

- Ensure that the script prints a "successfully applied" message to the console, if it does not then the registry files were not successfully merged

- After and only after a restart, you can establish an internet connection as the Windows update policies will take effect

## Visual Cleanup

Disable features on the taskbar, unpin shortcuts and tiles from the taskbar and start menu.

- See [media/visual-cleanup-windows7-example.mp4](https://raw.githubusercontent.com/amitxv/PC-Tuning/main/media/visual-cleanup-windows7-example.mp4)

- See [media/visual-cleanup-windows8-example.mp4](https://raw.githubusercontent.com/amitxv/PC-Tuning/main/media/visual-cleanup-windows8-example.mp4)

- See [media/visual-cleanup-windows10+-example.mp4](https://raw.githubusercontent.com/amitxv/PC-Tuning/main/media/visual-cleanup-windows10+-example.mp4)

## Install Drivers

- Chipset drivers are typically not required but if they are, their functionality can most likely be replicated manually with the advantage being no overhead from the drivers constantly running and forcing unnecessary context switches. An example of this would be the AMD chipset drivers used to manage per-CPU load for scheduling threads on the V-Cache CCX/CCD which can easily be achieved manually as described in the [Per-CPU Scheduling](#per-cpu-scheduling) section ([1](https://hwbusters.com/cpu/amd-ryzen-9-7950x3d-cpu-review-performance-thermals-power-analysis/2))

    - See [Chipset Device "Drivers" (= INF files) | Fernando](https://winraid.level1techs.com/t/intel-chipset-device-drivers-inf-files/30920)

- GPU drivers will be installed in the [Configure the Graphics Driver](#configure-the-graphics-driver) section so do not install them at this stage

- You can find drivers by searching for drivers that are compatible with your device's HWID. See [media/device-hwid-example.png](/media/device-hwid-example.png) in regard to finding your HWID in Device Manager for a given device

- Try to obtain the driver in its INF form so that it can be installed in Device Manager as executable installers usually install other bloatware along with the driver itself. Most of the time, you can extract the installer's executable with 7-Zip to obtain the driver

- It is recommended to update and install the following:

    - Network Interface Controller

        - If you do not have internet access at this stage, you will need to download your NIC driver from another device or dual-boot as they may not be packaged at all in some versions of Windows

    - [USB](https://winraid.level1techs.com/t/usb-3-0-3-1-drivers-original-and-modded/30871) and [NVMe](https://winraid.level1techs.com/t/recommended-ahci-raid-and-nvme-drivers/28310) (if you are configuring Windows 7, both may have already been integrated in pre-install)

        - See [Microsoft USB driver latency penalty](/docs/research.md#microsoft-usb-driver-latency-penalty)

    - [SATA](https://winraid.level1techs.com/t/recommended-ahci-raid-and-nvme-drivers/28310) (required on Windows 7 as enabling MSI on the stock SATA driver will result in a BSOD)

- Other required drivers can be installed with [Snappy Driver Installer Origin](https://www.snappy-driver-installer.org)

## Time, Language and Region

- Configure settings by typing ``intl.cpl`` and ``timedate.cpl`` in ``Win+R``

- Windows 10+ Only

    - Configure settings in ``Time & Language`` by pressing ``Win+I``

        - If you intend to exclusively use one language and keyboard layout, ensure that is the case in actuality so that you don't need to toggle the language bar hotkeys which can become intrusive otherwise as the hotkey can be accidentally pressed

## Activate Windows

Use the commands below to activate Windows using your license key if you do not have one linked to your HWID. Ensure that the activation process was successful by verifying the activation status in computer properties. Open CMD as administrator and enter the commands below.

```bat
slmgr /ipk <license key>
```

```bat
slmgr /ato
```

## Configure a Web Browser

Configure a browser of your choice.

- See [privacytests.org](https://privacytests.org)

- See [amitxv/firefox](https://github.com/amitxv/PC-Tuning) for a minimal Firefox installation script

## Disable Residual Scheduled Tasks

Open PowerShell and enter the command below to disable various scheduled tasks. This is useful if you would like finer control as to what runs on your OS in the background.

```powershell
C:\bin\disable-scheduled-tasks.ps1
```

## Miscellaneous

- Open CMD and enter the commands below

    - Optionally set the maximum password age to never expire to prevent Windows periodically asking to change or enter a password ([1](https://www.tenforums.com/tutorials/87386-change-maximum-minimum-password-age-local-accounts-windows-10-a.html))

        ```bat
        net accounts /maxpwage:unlimited
        ```

    - Optionally clean the WinSxS folder to reduce the size of it ([1](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/clean-up-the-winsxs-folder?view=windows-11)). Note that this can be a lengthy process

        ```bat
        DISM /Online /Cleanup-Image /StartComponentCleanup /ResetBase
        ```

    - Optionally disable [reserved storage](https://www.tenforums.com/tutorials/124858-enable-disable-reserved-storage-windows-10-a.html) (Windows 10 1903+)

        ```bat
        DISM /Online /Set-ReservedStorageState /State:Disabled
        ```

    - Configure the operating system name, it is recommended to set it to something meaningful or unique such has ``Windows 10 1803 Work`` or ``Windows 10 1803 Gaming`` for clarity when dual-booting. The partition label can also be renamed similarly for clarity

        ```bat
        bcdedit /set {current} description "OS_NAME"
        ```

        ```bat
        label C: "OS_NAME"
        ```

    - If an HDD isn't present in the system then Superfetch/Prefetch can be disabled with the command below. Disabling SysMain is in Microsoft's recommendations for configuring devices for real-time performance ([1](https://learn.microsoft.com/en-us/windows/iot/iot-enterprise/soft-real-time/soft-real-time-device))

        ```bat
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\SysMain" /v "Start" /t REG_DWORD /d "4" /f
        ```

- Configure the following by typing ``sysdm.cpl`` in ``Win+R``:

    - ``Advanced -> Performance -> Settings`` - configure ``Adjust for best performance``. If you have enough RAM for your applications, consider disabling the paging file for all drives to avoid unnecessary I/O and longer access times

    - ``System Protection`` - disable and delete system restore points. It has been proven to be unreliable ([1](https://askleo.com/why_i_dont_like_system_restore))

- Windows 8+ Only:

    - Disable all unnecessary permissions in the ``Privacy`` section by pressing ``Win+I``

- Windows Server+ Only:

    - In Server Manager, navigate to ``Manage -> Server Manager Properties`` and enable the option to prevent Server Manager from starting automatically

    - Set the ``Windows Audio`` and ``Windows Audio Endpoint Builder`` services startup type to automatic by typing ``services.msc`` in ``Win+R``

    - Navigate to ``Computer Configuration -> Windows Settings -> Security Settings -> Account Policies -> Password Policy`` by typing ``gpedit.msc`` in ``Win+R`` and disable ``Password must meet complexity requirements``

        - Open CMD and type ``gpupdate /force`` to apply the changes immediately

    - Navigate to ``Computer Configuration -> Administrative Templates -> System`` by typing ``gpedit.msc`` in ``Win+R`` and disable ``Display Shutdown Event Tracker`` to disable the shutdown prompt

    - To remove the user password, enter your current password and leave the new/confirm password fields blank in ``User Accounts`` by typing ``control userpasswords`` in ``Win+R``

## Install Runtimes

These are runtimes that are dependencies of applications worldwide.

- [Visual C++ Redistributable](https://github.com/abbodi1406/vcredist)

- [.NET 4.8](https://dotnet.microsoft.com/en-us/download/dotnet-framework/net48) (ships with Windows 10 1909+)

- [WebView](https://developer.microsoft.com/en-us/microsoft-edge/webview2)

- [DirectX](https://www.microsoft.com/en-gb/download/details.aspx?id=8109)

## Manage Appx Packages (Windows 8+)

- Download and open [AppxPackagesManager](https://github.com/amitxv/AppxPackagesManager) then remove everything that you don't need (which may be everything). It is usually fine to keep packages installed provided that they don't run in the background continually

- Required packages for Microsoft Store. It may be a suitable idea to keep this as you can download applications in the future if desired although, you can download ``.appx`` packages directly and install them manually without the store, but this may become tedious. See [here](https://superuser.com/questions/1721755/is-there-a-way-to-install-microsoft-store-exclusive-apps-without-store) for more information

    - ``Microsoft.WindowsStore``

- Required packages for Xbox Game Bar. It is highly recommended keeping this package to access the ``Remember this is a game`` in Game Bar to resolve game detection issues

    - ``Microsoft.XboxGamingOverlay``

- Required packages for Xbox Game Pass

    - ``Microsoft.XboxIdentityProvider``
    - ``Microsoft.Xbox.TCUI``
    - ``Microsoft.StorePurchaseApp``
    - ``Microsoft.GamingApp``
    - ``Microsoft.WindowsStore``
    - ``Microsoft.GamingServices``
    - ``Microsoft.XboxGamingOverlay``

## Handle Bloatware

- Open CMD and enter the command below to uninstall OneDrive

    ```bat
    for %a in ("SysWOW64" "System32") do (if exist "%windir%\%~a\OneDriveSetup.exe" ("%windir%\%~a\OneDriveSetup.exe" /uninstall)) && reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f > nul 2>&1
    ```

- Disable Chromium Microsoft Edge

    - The browser should be disabled instead of uninstalled to retain the WebView runtime

    - Download [Autoruns](https://learn.microsoft.com/en-us/sysinternals/downloads/autoruns) and navigate to the ``Everything`` section then search for *"edge"*. Disable every item that appears in the filtered results

    - Updating the browser will revert some changes made in the previous step. You can ensure that it does not update if it is opened accidentally with the command below. Ensure that there aren't any hidden Microsoft Edge process running in Task Manager

        ```bat
        rd /s /q "C:\Program Files (x86)\Microsoft\EdgeUpdate"
        ```

    - Open CMD and enter the command below to remove all related shortcuts

        ```bat
        for /f "delims=" %a in ('where /r C:\ *edge.lnk*') do (del /f /q "%a")
        ```

- Uninstall any bloatware that exists by typing ``appwiz.cpl`` in ``Win+R``

- Windows 10+ Only:

    - Disable Xbox Game Bar in settings or with the registry keys below to prevent ``GameBar.exe`` from running

        ```bat
        reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d "0" /f
        ```

        ```bat
        reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f
        ```

    - In the start menu, *uninstall* the residual links for applications. Keep in mind that these applications aren't actually installed, they get installed only if the user clicks on them so do not accidentally click on them

    - Windows 10 Only:

        - Uninstall bloatware in ``Apps -> Apps and Features`` by pressing ``Win+I``

        - In the ``Optional features`` section, uninstall everything that you don't need

    - Windows 11 Only:

        - Uninstall bloatware in ``Apps -> Installed apps`` by pressing ``Win+I``

        - In the ``System -> Optional features`` section, uninstall everything that you don't need

- If Windows Defender was disabled in the [Merge the Registry Files](#merge-the-registry-files) step,``smartscreen.exe`` ignores the registry key that controls whether it runs in the background persistently on later versions of Windows. For this reason, open CMD as TrustedInstaller with ``C:\bin\MinSudo.exe --TrustedInstaller --Privileged`` and enter the command below to remove the binary

    ```bat
    taskkill /f /im smartscreen.exe > nul 2>&1 & ren C:\Windows\System32\smartscreen.exe smartscreen.exee
    ```

- You can use Task Manager to check for residual bloatware that is running in the background and possibly create an issue on the repository so that it can be reviewed

## Install 7-Zip

Download and install [7-Zip](https://www.7-zip.org). Open ``C:\Program Files\7-Zip\7zFM.exe`` then navigate ``Tools -> Options`` and associate 7-Zip with all file extensions by clicking the ``+`` button. You may need to click it twice to override existing associated extensions.

## Configure the Graphics Driver

- See [docs/configure-nvidia.md](/docs/configure-nvidia.md)

- See [docs/configure-amd.md](/docs/configure-amd.md)

## Configure MSI Afterburner

If you use [MSI Afterburner](https://www.msi.com/Landing/afterburner/graphics-cards), download and install it.

- It is recommended to configure a static fan speed as using the fan curve feature requires the program to run continually

- To automatically load profile 1 (as an example) and exit, type ``shell:startup`` in ``Win+R`` then create a shortcut with a target of ``"C:\Program Files (x86)\MSI Afterburner\MSIAfterburner.exe" /Profile1 /Q``

## Display Resolutions and Scaling Modes

You may have already found a stable overclock for your display in the [Physical Setup](/docs/physical-setup.md) section which you can configure in this section.

- Typically, you have the option of performing scaling on the GPU or display. Native resolution does not require scaling thus results in the identity scaling mode being used. Furthermore, identity scaling renders most of the scaling options in the GPU control panel obsolete. If you are using a non-native resolution, there is an argument for favoring display scaling due to less GPU processing

- Aim for an ``actual`` integer refresh rate such as 60.00/240.00, not 59.94/239.76. Using the exact timing can help achieve this in [Custom Resolution Utility](https://www.monitortests.com/forum/Thread-Custom-Resolution-Utility-CRU)

- There are many ways to achieve the same outcome regarding GPU and display scaling. See the table in the link below for example scenarios

    - See [What is identity scaling and how can you use it?](/docs/research.md#what-is-identity-scaling-and-how-can-you-use-it)

    - Optionally use [QueryDisplayScaling](https://github.com/amitxv/QueryDisplayScaling) to query the current scaling mode

- Try to delete every resolution and the other bloatware (audio blocks) apart from your native resolution in CRU. This may be a workaround for the ~1-second black screen when alt-tabbing while using the ``Hardware: Legacy Flip`` presentation mode

    - On systems with an NVIDIA GPU, ensure that the ``Display`` option for the ``Perform scaling on`` setting is still available. If it is not, then find out what change you made in CRU results in it not being accessible through trial and error. This can be accomplished by running ``reset.exe`` to reset the settings to default then re-configure CRU. After each change, run ``restart64.exe`` then check whether the option is still available

- Ensure your resolution is configured properly by typing ``rundll32.exe display.dll,ShowAdapterSettings`` in ``Win+R``

## Install Open-Shell (Windows 8+)

- Download and install [Open-Shell](https://github.com/Open-Shell/Open-Shell-Menu). Only install the ``Open-Shell Menu``

- Settings:

    - General Behavior

        - Check for Windows updates on shutdown - Disable

- Windows 8 Only:

    - Open ``"C:\Program Files\Open-Shell\Start Menu Settings.lnk"``, enable ``Show all settings`` then navigate to the Windows 8 Settings section and set ``Disable active corners`` to ``All``

## Spectre, Meltdown and CPU Microcode

> [!WARNING]
> 🔒 Disabling Spectre and Meltdown may negatively impact security. Users should assess the security risk involved with modifying the mentioned setting.

- Disable Spectre and Meltdown with [InSpectre](https://www.grc.com/inspectre.htm)

    - AMD is unaffected by Meltdown. In some cases, it also performs better with Spectre enabled ([1](https://www.phoronix.com/review/amd-zen4-spectrev2))

    - A minority of anti-cheats (FACEIT) require Meltdown to be enabled

- Open CMD as TrustedInstaller with ``C:\bin\MinSudo.exe --TrustedInstaller --Privileged`` and enter the commands below to remove the CPU microcode updates

    ```bat
    ren C:\Windows\System32\mcupdate_GenuineIntel.dll mcupdate_GenuineIntel.dlll
    ```

    ```bat
    ren C:\Windows\System32\mcupdate_AuthenticAMD.dll mcupdate_AuthenticAMD.dlll
    ```

- Reboot and use [InSpectre](https://www.grc.com/inspectre.htm) and [CPU-Z's](https://www.cpuid.com/softwares/cpu-z.html) validation feature to check the status after a reboot

    - See [media/meltdown-spectre-example.png](/media/meltdown-spectre-example.png)

    - See [media/cpu-z-vulnerable-microcode.png](/media/cpu-z-vulnerable-microcode.png)

## Install a Media Player

- [mpv](https://mpv.io) or [mpv.net](https://github.com/stax76/mpv.net)

- [mpc-hc](https://mpc-hc.org) ([alternative link](https://github.com/clsid2/mpc-hc))

- [VLC](https://www.videolan.org)

## Configure Power Options

Open CMD and enter the commands below.

- Set the active power scheme to High performance

    ```bat
    powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    ```

- Remove the Balanced power scheme

    ```bat
    powercfg /delete 381b4222-f694-41f0-9685-ff5bb260df2e
    ```

- Remove the Power Saver power scheme

    ```bat
    powercfg /delete a1841308-3541-4fab-bc81-f71556f20b4a
    ```

- USB 3 Link Power Management - Off

    ```bat
    powercfg /setacvalueindex scheme_current 2a737441-1930-4402-8d77-b2bebba308a3 d4e98f31-5ffe-4ce1-be31-1b38b384c009 0
    ```

- USB Selective Suspend - Disabled

    ```bat
    powercfg /setacvalueindex scheme_current 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
    ```

- Processor performance core parking min cores - 100

    - CPU parking is disabled by default in the High Performance power scheme ([1](https://learn.microsoft.com/en-us/windows-server/administration/performance-tuning/hardware/power/power-performance-tuning#using-power-plans-in-windows-server)). However on Windows 11+ with modern CPUs, parking is overridden and enabled. Users can determine whether CPUs are parked by typing ``resmon`` in ``Win+R``. Apart from parking intended to be a power saving feature, videos such as [this](https://www.youtube.com/watch?v=2yOYfT_r0xI) and [this](https://www.youtube.com/watch?v=gyg7Gm7aN2A) explain that it is the desired behavior for correct thread scheduling which is probably fine for the average user, but they do not account for the latency penalty of unparking cores (as with C-State transitions) along with kernel-mode activity (interrupts, DPCs). In terms of per-CPU scheduling, you can easily achieve the same outcome by managing per-CPU load manually (e.g. pin the real-time application to a [single CCX/CCD](https://hwbusters.com/cpu/amd-ryzen-9-7950x3d-cpu-review-performance-thermals-power-analysis/2) or P-Cores) by configuring affinities with the advantage being no overhead from chipset drivers and Xbox processes constantly running in the background forcing unnecessary context switches. See the [Per-CPU Scheduling](#per-cpu-scheduling) section for more information

        ```bat
        powercfg /setacvalueindex scheme_current 54533251-82be-4824-96c1-47b60b740d00 0cc5b647-c1df-4637-891a-dec35c318583 100
        ```

        ```bat
        powercfg /setacvalueindex scheme_current 54533251-82be-4824-96c1-47b60b740d00 0cc5b647-c1df-4637-891a-dec35c318584 100
        ```

- Processor performance time check interval - 5000

    - There are a handful of ntoskrnl power management DPCs that are scheduled at a periodic interval to re-evaluate P-States and parked cores. With a static CPU frequency and core parking disabled, these checks become obsolete thus unnecessary DPCs get scheduled. The ``Processor performance time check interval`` setting controls how often these checks are taken place so increasing the setting's value can reduce CPU overhead as significantly fewer DPCs are scheduled. For reference and at the time of checking, the Power Saver, Balanced, High performance power schemes have a default value of 200, 15 and 15 respectively. 5000 is the maximum accepted value. Of course, if a dynamic CPU frequency is used (e.g. Precision Boost Overdrive, Turbo Boost) and parking is enabled, the effects of increasing this value should be evaluated as cores may not be able to boost their frequency in response to workloads as the OS is evaluating the current scenario less often

        <table style="text-align: center;">
            <tr>
                <td rowspan="2">DPC Function</td>
                <td colspan="3">Average DPC Rate</td>
                <td colspan="3">Total DPCs</td>
            </tr>
            <tr>
                <td>15</td>
                <td>200</td>
                <td>5000</td>
                <td>15</td>
                <td>200</td>
                <td>5000</td>
            </tr>
            <tr>
                <td>ntoskrnl!PpmPerfAction</td>
                <td>15.45Hz</td>
                <td>3.07Hz</td>
                <td>N/A</td>
                <td>311</td>
                <td>60</td>
                <td>1</td>
            </tr>
            <tr>
                <td>ntoskrnl!PpmCheckRun</td>
                <td>12.99Hz</td>
                <td>2.29Hz</td>
                <td>N/A</td>
                <td>262</td>
                <td>46</td>
                <td>1</td>
            </tr>
            <tr>
                <td>ntoskrnl!PpmCheckPeriodicStart</td>
                <td>60.39Hz</td>
                <td>4.99Hz</td>
                <td>0.2Hz</td>
                <td>1213</td>
                <td>100</td>
                <td>4</td>
            </tr>
        </table>

        ```bat
        powercfg /setacvalueindex scheme_current 54533251-82be-4824-96c1-47b60b740d00 4d2b0152-7d5c-498b-88e2-34345392a2c5 5000
        ```

- Set the active scheme as the current scheme

    ```bat
    powercfg /setactive scheme_current
    ```

## Configure the BCD Store

> [!WARNING]
> 🔒 Disabling DEP may negatively impact security. Users should assess the security risk involved with modifying the mentioned setting.

Open CMD and enter the commands below.

- [Data Execution Prevention](https://docs.microsoft.com/en-us/windows/win32/memory/data-execution-prevention) is set to ``Turn on for essential Windows programs and services only`` by default. However, DEP can be completely disabled with the command below but a minority of anti-cheats require DEP to be left on the default setting. Do not change if unsure

    ```bat
    bcdedit /set nx AlwaysOff
    ```

- Windows 8+ Only

    - A [tickless kernel](https://en.wikipedia.org/wiki/Tickless_kernel) is beneficial for battery-powered systems as it allows CPUs to sleep for an extended duration ([1](https://arstechnica.com/information-technology/2012/10/better-on-the-inside-under-the-hood-of-windows-8/2)). ``disabledynamictick`` can be used to enable regular timer tick interrupts (polling) however many articles have conflicting information and opinions regarding whether doing so is beneficial for latency-sensitive tasks and reducing jitter

    - See [Reducing timer tick interrupts | Erik Rigtorp](https://rigtorp.se/low-latency-guide)

    - See [(Nearly) full tickless operation | Jonathan Corbet](https://lwn.net/Articles/549580)

    - See [Low Latency Performance Tuning | Red Hat](https://access.redhat.com/sites/default/files/attachments/201501-perf-brief-low-latency-tuning-rhel7-v2.1.pdf)

        ```bat
        bcdedit /set disabledynamictick yes
        ```

- The command below can be used to revert to the Windows default if necessary

    ```bat
    bcdedit /deletevalue <option>
    ```

## Replace Task Manager with Process Explorer

Task Manager lacks useful metrics compared to a tool such as Process Explorer. On Windows 8+, Task Manager reports CPU utility in % which provides misleading CPU utilization details ([1](https://aaron-margosis.medium.com/task-managers-cpu-numbers-are-all-but-meaningless-2d165b421e43)). On the other hand, Windows 7's Task Manager and Process Explorer report time-based busy utilization. This also explains why disabling idle states within the OS results in 100% CPU utilization in Task Manager.

- Download and extract [Process Explorer](https://learn.microsoft.com/en-us/sysinternals/downloads/process-explorer)

- Copy ``procexp64.exe`` into a safe directory such as ``C:\Windows`` and open it

- Navigate to ``Options`` and select ``Replace Task Manager``. Optionally configure the following:

    - Confirm Kill

    - Allow Only One Instance

    - Always On Top (helpful for when applications crash and UI becomes unresponsive)

    - Enable the following columns for granular resource measurement metrics

        - Context Switch Delta (Process Performance)

        - CPU Cycles Delta (Process Performance)

        - Delta Reads (Process I/O)

        - Delta Writes (Process I/O)

        - Delta Other (Process I/O)

    - Enable the ``VirusTotal`` column

## Disable Process Mitigations (Windows 10 1709+)

> [!WARNING]
> 🔒 Disabling process mitigations may negatively impact security. Users should assess the security risk involved with modifying the mentioned setting.

Open CMD and enter the command below to disable [process mitigations](https://docs.microsoft.com/en-us/powershell/module/processmitigations/set-processmitigation?view=windowsserver2019-ps). Effects can be viewed with ``Get-ProcessMitigation -System`` in PowerShell.

```bat
C:\bin\disable-process-mitigations.bat
```

## Configure Memory Management Settings (Windows 8+)

- Open PowerShell and enter the command below

    ```powershell
    Get-MMAgent
    ```

- Use the command below as an example to disable a given setting. If you left Superfetch/Prefetch enabled in the [Miscellaneous](#miscellaneous) section, then you likely want the prefetching related features enabled

    ```powershell
    Disable-MMAgent -MemoryCompression
    ```

## Configure the Network Adapter

- Open ``Network Connections`` by typing ``ncpa.cpl`` in ``Win+R``

- Disable any unused network adapters then right-click your main one and select ``Properties``

- Disable all items you don't require which typically is everything except ``QoS Packet Scheduler`` and ``Internet Protocol Version 4 (TCP/IPv4)`` for most consumers

- Disable ``NetBIOS over TCP/IP`` for all network adapters in ``Internet Protocol Version 4 (TCP/IPv4) -> Properties -> General -> Advanced -> WINS`` to prevent unnecessary system listening ([1](https://github.com/djdallmann/GamingPCSetup/blob/master/CONTENT/DOCS/NETWORK/README.md))

## Configure Audio Devices

- The sound control panel can be opened by typing ``mmsys.cpl`` in ``Win+R``

- Disable unused Playback and Recording devices

- Disable audio enhancements as they waste resources ([1](/media/audio%20enhancements-benchmark.png))

- Optionally set the option in the communications tab to ``Do nothing`` to prevent automatic adjustment of audio levels between audio sources as this is an annoyance for the majority of users ([1](https://multimedia.easeus.com/ai-article/windows-audio-ducking.html), [2](https://superuser.com/questions/1147371/how-can-i-disable-automatic-windows-7-8-10-audio-ducking))

- Minimize the size of the audio buffer with [REAL](https://github.com/miniant-git/REAL)/[LowAudioLatency](https://github.com/spddl/LowAudioLatency) or on your DAC ([1](https://www.youtube.com/watch?v=JTuZvRF-OgE&t=464s)). Beware of audio dropouts due to the CPU not being able to keep up under load

    - Be warned regarding CPUs being reserved or underutilized with the usage of the mentioned programs ([1](https://github.com/miniant-git/REAL/issues/9))

## Configure Services and Drivers

> [!WARNING]
> 💻 If you are configuring a system for general-purpose use such as for work or school, then skip this step as general compatibility is restricted.

> [!WARNING]
> 🔒 Using minimal services may negatively impact security. This is due to security related feature services (e.g. firewall) getting disabled although as mentioned below, this is a temporary state in which these features will only be unavailable for a limited amount of time. Users should assess the security risk involved with modifying the mentioned setting.

I'm not responsible if anything goes wrong or you BSOD. The idea is to disable services while using your real-time application and revert to default services for everything else.

- The list can be customized by editing ``C:\bin\minimal-services.ini`` in a text editor. There are several comments in the config file that you can read to check whether you need a given service or not. As an example, a user with Ethernet does not need the Wi-Fi services enabled. If you plan on editing ``minimal-services.ini``, then learn the [syntax of the config file](https://github.com/amitxv/service-list-builder#usage-and-program-logic)

- [Configure a Static IP address](https://www.youtube.com/watch?t=36&v=5iRp1Nug0PU). This is required as we will be disabling the services that waste resources which DHCP relies on

- The ``High precision event timer`` device in Device Manager uses IRQ 0 on the majority of AMD systems and consequently conflicts with the ``System timer`` device which also uses IRQ 0. The only way that I'm aware of to resolve this conflict is to disable the parent device of the ``System timer`` device which is ``PCI standard ISA bridge`` by disabling the ``msisadrv`` driver (edit the config)

- Use the command below to prevent the Software Protection service attempting to register a restart every 30s while services are disabled ([1](/media/software-protection-error.png)). I'm not sure what the problematic service is, but online sources point to Task Scheduler ([1](https://learn.microsoft.com/en-us/troubleshoot/windows-server/deployment/failed-schedule-software-protection), [2](https://superuser.com/questions/1501559/failed-to-schedule-software-protection-service-for-re-start-at-2119-10-19t1807))

    ```bat
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" /v "InactivityShutdownDelay" /t REG_DWORD /d "4294967295" /f
    ```

- On Win10 1503 - 1703, delete the ``ErrorControl`` registry key in ``HKLM\SYSTEM\CurrentControlSet\Services\Schedule`` to prevent an unresponsive explorer shell after disabling the Task Scheduler service

- Download and extract the latest [service-list-builder](https://github.com/amitxv/service-list-builder/releases) release. Open CMD and CD to the extracted folder where the executable is located

- Use the command below to build the scripts in the ``build`` folder. Move the build folder somewhere safe such as ``C:\`` and do not share it with other people as it is specific to your system. Note that NSudo with the ``Enable All Privileges`` option is required to run the batch scripts

    ```bat
    service-list-builder.exe --config C:\bin\minimal-services.ini
    ```

    - If you would like to rebuild the scripts, ensure to run the generated ``Services-Enable.bat`` script beforehand as the tool relies on the current state of services for building future scripts

- If desired, you can use [ServiWin](https://www.nirsoft.net/utils/serviwin.html) to check for residual drivers after disabling services then possibly create an issue on the repository so that it can be reviewed

### Debugging Services

For future reference, if something doesn't work after disabling services but works once services are re-enabled:

- **Short-term/Temporary Solution**: Run ``Services-Enable.bat``, do whatever you are trying to do, then run ``Services-Disable.bat`` again (that's the idea of having toggle scripts!). If the functionality is still broken after enabling services then the problem is not related to services

- **Long-term/Permanent Solution**: If you absolutely need some functionality while services are disabled, then see [docs/debug-services.md](/docs/debug-services.md) to determine what services are required for it. Note that this is only an option if that functionality works while services are enabled but breaks with services disabled

## Configure Device Manager

> [!WARNING]
> 💻 If you are configuring a system for general-purpose use such as for work or school, then skip the steps that involve disabling devices as general compatibility is restricted.

The section is directly related to the [Configure Services and Drivers](#configure-services-and-drivers) section. The methodology below will ensure maximum compatibility while services are enabled because devices with an associated driver will be toggled in the ``Services-Disable.bat`` script which means we do not need to permanently disable them.

1. If you haven't disabled services at this stage, run the ``Services-Disable.bat`` script

1. Open Device Manager by typing ``devmgmt.msc`` in ``Win+R``

1. **DO NOT** disable any devices with a yellow icon because these are the devices that are being handled by the ``Services-Disable.bat`` script

1. Navigate to ``View -> Devices by type``

    - In the ``Disk drives`` category, disable write-cache buffer flushing on all drives in the ``Properties -> Policies`` section

    - In the ``Network adapters`` category, navigate to ``Properties -> Advanced`` and disable any power-saving features

1. Navigate to ``View -> Devices by connection``

    - Disable any PCIe, SATA, NVMe and XHCI controllers and USB hubs with nothing connected to them

    - Disable everything that isn't the GPU on the same PCIe port

1. Navigate to ``View -> Resources by connection``

    - Disable any unneeded devices that are using an IRQ or I/O resources, always ask if unsure and take your time on this step

    - If there are multiple of the same devices, and you are unsure which one is in use, refer back to the tree structure in ``View -> Devices by connection``. Remember that a single device can use many resources. You can also use [MSI Utility](https://forums.guru3d.com/threads/windows-line-based-vs-message-signaled-based-interrupts-msi-tool.378044) to check for duplicate and unneeded devices in case you accidentally miss any with the confusing Device Manager tree structure

1. Run the ``Services-Enable.bat`` script to continue with the rest of the guide. Remember to run the ``Services-Disable.bat`` script before running your real-time application for future reference

1. Optionally use [DeviceCleanup](https://www.uwe-sieber.de/files/DeviceCleanup.zip) to remove hidden devices

## Disable Driver Power-Saving

Open PowerShell and enter the command below to disable the ``Allow the computer to turn off this device to save power`` option for all applicable devices in Device Manager. Re-plugging devices may cause this option to re-enable so either avoid doing so, run this command again or create a script to execute the command each time at startup by creating a shortcut in ``shell:startup`` as a precautionary measure.

```powershell
Get-WmiObject MSPower_DeviceEnable -Namespace root\wmi | ForEach-Object { $_.enable = $false; $_.psbase.put(); }
```

## Configure Event Trace Sessions

> [!WARNING]
> 💻 If you are configuring a system for general-purpose use such as for work or school, then skip this step as general compatibility is restricted.

Create registry files to toggle [event trace sessions](https://learn.microsoft.com/en-us/windows/win32/etw/event-tracing-sessions). Programs that rely on event tracers will not be able to log data until the required sessions are restored which is the purpose of creating two registry files to toggle between them (identical concept to the service scripts). Open CMD and enter the commands below to build the registry files in the ``C:\`` directory. As with the services scripts these registry files must be run with NSudo. The sessions can be viewed by typing ``perfmon`` in ``Win+R`` then navigating to ``Data Collector Sets -> Event Trace Sessions``.

- ets-enable

    ```bat
    reg export "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger" "C:\ets-enable.reg"
    ```

- ets-disable

    ```bat
    >> "C:\ets-disable.reg" echo Windows Registry Editor Version 5.00 && >> "C:\ets-disable.reg" echo. && >> "C:\ets-disable.reg" echo [-HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\WMI\Autologger]
    ```

- Disable SleepStudy (UserNotPresentSession)

    ```bat
    for %a in ("SleepStudy" "Kernel-Processor-Power" "UserModePowerService") do (wevtutil sl Microsoft-Windows-%~a/Diagnostic /e:false)
    ```

## Optimize the File System

Open CMD and enter the commands below.

- Disables the creation of 8.3 character-length file names on FAT- and NTFS-formatted volumes

    - See [Should you disable 8dot3 for performance and security? | TCAT Shelbyville](https://web.archive.org/web/20200217151754/https://ttcshelbyville.wordpress.com/2018/12/02/should-you-disable-8dot3-for-performance-and-security)

    - See [Windows Short (8.3) Filenames – A Security Nightmare? | Bogdan Calin](https://www.acunetix.com/blog/articles/windows-short-8-3-filenames-web-security-problem)

        ```bat
        fsutil behavior set disable8dot3 1
        ```

- Disable updates to the Last Access Time stamp on each directory when directories are listed on an NTFS volume. Disabling the Last Access Time feature improves the speed of file and directory access ([1](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/fsutil-behavior#remarks))

    ```bat
    fsutil behavior set disablelastaccess 1
    ```

## Message Signaled Interrupts

Message signaled interrupts are faster than traditional line-based interrupts and may also resolve the issue of shared interrupts which are often the cause of high interrupt latency and stability ([1](https://repo.zenk-security.com/Linux%20et%20systemes%20d.exploitations/Windows%20Internals%20Part%201_6th%20Edition.pdf)).

- Download and open [MSI Utility](https://forums.guru3d.com/threads/windows-line-based-vs-message-signaled-based-interrupts-msi-tool.378044) or [GoInterruptPolicy](https://github.com/spddl/GoInterruptPolicy)

- Enable Message Signaled Interrupts on all devices that support it

    - You will BSOD if you enable MSIs for the stock Windows 7 SATA driver which you should have already updated as mentioned in the [Install Drivers](#install-drivers) section

- Be careful as to what you choose to prioritize. As an example, an I/O bound application may suffer a performance loss including an open-world game that utilizes texture streaming if the GPU IRQ priority is set higher than the storage controller priority. For this reason, you can set all devices to undefined/normal priority

- Restart your PC, you can verify whether a device is utilizing MSIs by checking if it has a negative IRQ in MSI Utility

- Although this was carried out in the [Physical Setup](/docs/physical-setup.md) section, confirm that there is no IRQ sharing on your system by typing ``msinfo32`` in ``Win+R`` then navigating to the ``Conflicts/Sharing`` section

    - If ``System timer`` and ``High precision event timer`` are sharing IRQ 0, See the [Configure Services and Drivers](#configure-services-and-drivers) section for a solution

## XHCI Interrupt Moderation (IMOD)

> [!WARNING]
> 💻 If you are configuring a system for general-purpose use such as for work or school, then skip this step as it is not required.

On most systems, Windows 7 uses an IMOD interval of 1ms whereas recent versions of Windows use 0.05ms (50us) unless specified by the installed USB driver. This means that after an interrupt has been generated, the XHCI controller waits for the specified interval for more data to arrive before generating another interrupt which reduces CPU utilization but potentially results in data from a given device being supplied at an inconsistent rate in the event of expecting data from other devices within the waiting period that are connected to the same XHCI controller.

For example, a mouse with a 1kHz polling rate will report data every 1ms. While only moving the mouse with an IMOD interval of 1ms, interrupt moderation will not be taking place because interrupts are being generated at a rate less than or equal to the specified interval. Realistically while playing a fast-paced game, you will easily surpass 1000 interrupts/s with keyboard and audio interaction while moving the mouse hence there will be a loss of information because you will be expecting data within the waiting period from either devices. Although this is unlikely with an IMOD interval of 0.05ms (50us), it can still happen.

As an example, 1ms IMOD interval with an 8kHz mouse is already problematic because you are expecting data every 0.125ms which is significantly greater than the specified interval and of course, results in a major bottleneck ([1](https://www.overclock.net/threads/usb-polling-precision.1550666/page-61#post-28576466)).

- See [How to persistently disable XHCI Interrupt Moderation | BoringBoredom](https://github.com/BoringBoredom/PC-Optimization-Hub/blob/main/content/xhci%20imod/xhci%20imod.md)

- Microsoft Vulnerable Driver Blocklist may need to be disabled with the command below in order to load the [RWEverything](http://rweverything.com) driver however a handful of in-game anticheats do not adhere to disabling the blocklist (e.g. CS2, THE FINALS)

    ```bat
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\CI\Config" /v "VulnerableDriverBlocklistEnable" /t REG_DWORD /d "0" /f
    ```

- In some cases, the interrupter index can change after a reboot meaning the address will become invalid if it is hard-coded. To work around this, you can simply disable IMOD for all interrupters by placing the [XHCI-IMOD-Interval.ps1](https://gist.github.com/amitxv/4fe34e139f0aec681a6122f39757d86e) script somewhere safe and creating a shortcut in ``shell:startup`` with the target below. Set the window style of the shortcut to minimized

    ```
    PowerShell C:\XHCI-IMOD-Interval.ps1
    ```

- To determine whether changing the IMOD interval is taking effect, you can temporarily set the interval to ``0xFA00`` (62.5Hz). If the mouse cursor is visibly stuttering upon movement, then the changes are successfully taking effect

## Configure Control Panel

It isn't a bad idea to skim through both the legacy and immersive control panel to ensure nothing is misconfigured.

## Configuring Applications

- Install any programs and configure your real-time applications to prepare us for the final steps

- If applicable, favor portable editions of programs as installers tend to leave bloatware behind even after uninstalling them

### NVIDIA Reflex

Consider using [NVIDIA Reflex](https://www.nvidia.com/en-us/geforce/news/reflex-low-latency-platform).

- See [NVIDIA Reflex Low Latency - How It Works & Why You Want To Use It | Battle(non)sense](https://www.youtube.com/watch?v=QzmoLJwS6eQ)

### Framerate Limit

- Cap your framerate at a multiple of your monitor refresh rate to prevent [frame mistiming](https://www.youtube.com/watch?v=_73gFgNrYVQ)

    - See [FPS Cap Calculator](https://boringboredom.github.io/tools/fpscapcalculator)

- Choose a value that is close to the minimum fps threshold for increased smoothness

- Ensure that the GPU isn't fully utilized as lower GPU utilization reduces system latency ([1](https://www.youtube.com/watch?v=8ZRuFaFZh5M&t=859s), [2](https://www.youtube.com/watch?v=7CKnJ5ujL_Q))

- Capping your framerate with [RTSS](https://www.guru3d.com/files-details/rtss-rivatuner-statistics-server-download.html) instead of the in-game limiter will result in consistent frame pacing and a smoother experience as it utilizes busy-wait which offers higher precision than 100% passive-waiting but at the cost of noticeably higher latency and potentially greater CPU overhead ([1](https://www.youtube.com/watch?t=377&v=T2ENf9cigSk). [2](https://en.wikipedia.org/wiki/Busy_waiting)). Disabling the ``Enable dedicated encoder server service`` setting prevents ``EncoderServer.exe`` from running

### Presentation Mode

- Always verify whether your real-time application is using the desired presentation mode with PresentMon

- You can experiment and benchmark different presentation modes to assess which you prefer

    - See [Presentation Model | Special K Wiki](https://wiki.special-k.info/en/Presentation_Model)

- If there are no results after searching for the application's binary name in ``HKCU\SYSTEM\GameConfigStore`` within registry, you may need to temporarily enable Xbox Game Bar in settings then tick the ``Remember this is a game`` option. Check whether the entry has been created under the aforementioned registry key

- If you want to use the ``Hardware: Legacy Flip`` presentation mode, tick the ``Disable fullscreen optimizations`` checkbox. If that doesn't work, try running the commands below in CMD and reboot. These registry keys are typically accessed by the game and Windows upon launch

    ```bat
    reg add "HKCU\SYSTEM\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatible" /t REG_DWORD /d "1" /f
    ```

    ```bat
    reg add "HKCU\SYSTEM\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d "2" /f
    ```

- If you are stuck with ``Hardware Composed: Independent Flip`` and would like to use another presentation mode, try running the command below to disable MPOs in CMD and reboot

    ```bat
    reg add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "OverlayTestMode" /t REG_DWORD /d "5" /f
    ```

### QoS Policies

Allows Windows to prioritize packets of an application.

- See [media/dscp-46-qos-policy.png](/media/dscp-46-qos-policy.png)

    - See [DSCP and Precedence Values | Cisco](https://www.cisco.com/c/en/us/td/docs/switches/datacenter/nexus1000/sw/4_0/qos/configuration/guide/nexus1000v_qos/qos_6dscp_val.pdf)

    - See [The QoS Expedited Forwarding (EF) Model | Network World](https://www.networkworld.com/article/761413/the-qos-expedited-forwarding-ef-model.html)

- See [How can you verify if a DSCP QoS policy is working?](research.md#how-can-you-verify-if-a-dscp-policy-is-working)

## Per-CPU Scheduling

> [!WARNING]
> 💻 If you are configuring a system for general-purpose use such as for work or school, then skip this step as it is not required.

### Kernel-Mode (Interrupts, DPCs and more)

Windows schedules interrupts and DPCs on CPU 0 for several modules by default. In any case, scheduling many tasks on a single CPU can introduce additional overhead and increased jitter due to them competing for CPU time. To alleviate this, affinities can be configured to isolate given modules from disturbances including servicing time-sensitive modules on underutilized CPUs instead of clumping everything on a single CPU.

- Use the xperf DPC/ISR report generated by the [xperf-dpcisr.bat](https://gist.github.com/amitxv/896a68330d037684fee5b933102f24f2) script to analyze which CPUs kernel-mode modules are being serviced on. You can not manage affinities if you do not know what is running and which CPU(s) they are running on, the same applies to user-mode threads. Additionally, verify whether interrupt affinity policies are performing as expected by analyzing per-CPU usage for the module in question while the device is busy

- Additionally, core-to-core-latency benchmarks can assist with decision-making in terms of affinity management

    - See [CXWorld/MicroBenchX](https://github.com/CXWorld/MicroBenchX)

- Ensure that the [corresponding DPC for an ISR is processed on the same CPU](/media/isr-dpc-same-core.png). Additional overhead can be introduced if they are processed on different CPUs due to increased inter-processor communication and interfering with cache coherence

- Use [Microsoft Interrupt Affinity Tool](https://www.techpowerup.com/download/microsoft-interrupt-affinity-tool) or [GoInterruptPolicy](https://github.com/spddl/GoInterruptPolicy) to configure driver affinities. The device can be identified by cross-checking the ``Location`` in the ``Properties -> General`` section of a device in Device Manager

#### GPU and DirectX Graphics Kernel

[AutoGpuAffinity](https://github.com/amitxv/AutoGpuAffinity) can be used to benchmark the most performant CPUs that the GPU-related modules are assigned to.

#### XHCI and Audio Controller

The XHCI and audio controller related modules generate a substantial amount of interrupts upon interaction respective of the relevant device. Isolating the related modules to an underutilized CPU is beneficial for reducing contention.

#### Network Interface Card

The NIC must support MSI-X for Receive Side Scaling to function properly ([1](https://www.reddit.com/r/intel/comments/9uc03d/the_i219v_nic_on_your_new_z390_motherboard_and)). In most cases, RSS base CPU is enough to migrate DPCs and ISRs for the NIC driver which eliminates the need for an interrupt affinity policy. However, if you are having trouble migrating either to other CPUs, try configuring both simultaneously.

The command below can be used to configure RSS base CPU. Ensure to change the driver key to the one that corresponds to the correct NIC. Keep in mind that the amount of RSS queues determines the amount of consecutive CPUs that the network driver is scheduled on. For example, the driver will be scheduled on CPU 2/3/4/5 (2/4/6/8 with HT/SMT enabled) if RSS base CPU is set to 2 along with 4 RSS queues configured.

- See [How many RSS Queues do you need?](research.md#how-many-rss-queues-do-you-need)

- See [media/find-driver-key-example.png](/media/find-driver-key-example.png) to obtain the correct driver key in Device Manager

    ```bat
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0000" /v "*RssBaseProcNumber" /t REG_SZ /d "2" /f
    ```

- If RSS is not functioning as expected, see [this](https://github.com/djdallmann/GamingPCSetup/blob/master/CONTENT/RESEARCH/NETWORK/README.md#q-my-onboard-network-adapter-i225-v-supports-rss-msi-and-msi-x-but-why-is-my-indirection-table-missing-that-gives-proper-support-for-rss-in-microsoft-windows) for a potential workaround

### User-Mode (Processes, Threads)

There are several methods to set affinities for processes. One of which is Task Manager but only persists until the process is closed. A more popular and permanent solution is [Process Lasso](https://bitsum.com) which allows the configuration to be saved, however a process must run continually in the background which introduces minor overhead. To work around this, you can simply launch the application with a specified CPU affinity which eliminates the requirement of programs such as Process Lasso for affinity management.

- Use the [CPU Affinity Mask Calculator](https://bitsum.com/tools/cpu-affinity-calculator) to determine the desired hexal affinity bitmask

- In some cases, process can be protected so specifying the affinity may fail. To work around this, you can try specifying the affinity for the parent processes which will cause the child process to inherit the affinity when spawned. As an example, a game launcher is usually the parent process of a game. [Process Explorer's](https://learn.microsoft.com/en-us/sysinternals/downloads/process-explorer) process tree can be used to identify parent and child processes

    - [Process Hacker](https://processhacker.sourceforge.io) and [WindowsD](https://github.com/katlogic/WindowsD) can bypass several process-level protections through exploits but is not advised as they interfere with anticheats

- For modern Intel and AMD (3D V-Cache) systems, this step is especially required so read carefully. The points regarding manually managing per-CPU load in the [Install Drivers](#install-drivers) and [Configure Power Options](#configure-power-options) sections will be discussed in the current and next section. [ReservedCpuSets](#use-cases) will be used as a technique to manually accomplish what the chipset drivers and default power options try to do out of the box. The advantages of manual management have already been discussed in the mentioned sections (minimizing overhead)

- It may be worth benchmarking the performance scaling of your real-time application against core count as it may behave differently due to poor scheduling implementations from the application and/or OS. In some cases, it is possible that the application may perform better with fewer cores assigned to it via an affinity mask for several reasons. This will also give you a rough idea as to how many cores you can reserve in the [Reserved CPU Sets](#reserved-cpu-sets-windows-10) step

#### Starting a Process with a Specified Affinity Mask

The command below starts ``notepad.exe`` with an affinity of CPU 1 and CPU 2 as an example which will reflect in Task Manager. This command can be placed in a batch script for easy access and must be used each time to start the desired application with the specified affinity.

```bat
start /affinity 0x6 notepad.exe
```

#### Specifying an Affinity Mask for Running Processes

Sometimes, the processes that you would like to set an affinity mask to are already running, so the previous command is not applicable here. As a random example, the command below sets the affinity mask of the ``svchost.exe`` and ``audiodg.exe`` processes to CPU 3. Use this example to create a PowerShell script then have it run at startup by placing a shortcut in ``shell:startup`` by typing ``shell:startup`` in ``Win+R``. Set the window style of the shortcut to minimized.

```powershell
Get-Process @("svchost", "audiodg") -ErrorAction SilentlyContinue | ForEach-Object {$_.ProcessorAffinity=0x8}
```

### Reserved CPU Sets (Windows 10+)

[ReservedCpuSets](https://github.com/amitxv/ReservedCpuSets) can be used to prevent Windows routing interrupts and scheduling tasks on specific CPUs. As mentioned previously, isolating modules from user and kernel-level disturbances helps reduce contention, jitter and allows time-sensitive modules to get the CPU time they require.

- As mentioned in the [User-Mode (Processes, Threads)](#user-mode-processes-threads) step, you should determine how well or poorly your application's performance scales with core count to give you a rough idea as to how many cores you can afford to reserve

- As interrupt affinity policies, process and thread affinities have higher precedence, you can use this hand in hand with user-defined affinities to go a step further and ensure that nothing except what you assigned to specific CPUs will be scheduled on those CPUs

- Ensure that you have enough cores to run your real-time application on and aren't reserving too many CPUs to the point where isolating modules does not yield real-time performance

- As CPU sets are considered soft policies, the configuration isn't guaranteed. A CPU-intensive process such as a stress-test will utilize the reserved cores if required

> [!IMPORTANT]
> Unexpected behavior occurs when a process affinity is set to reserved and unreserved CPUs. Ensure to set the affinity to either reserved or unreserved CPUs, not a combination of both. See [here](https://github.com/amitxv/ReservedCpuSets/issues/2#issuecomment-1805837921) for more information.

#### Use Cases

- Hinting to the OS to schedule tasks on a group of CPUs. An example of this with modern platforms could be reserving E-Cores (efficiency cores) or either CCX/CCDs so that tasks are scheduled on P-Cores (performance cores) or other CCX/CCDs by default. With this approach, you can explicitly enforce background and unimportant tasks to be scheduled on the reserved CPUs. Note that this is purely an example and the logic can be flipped, but some latency-sensitive processes and modules are protected so affinity policies may fail which is a major limitation. See the [User-Mode (Processes, Threads)](#user-mode-processes-threads) section for more information. There are several possibilities and trade-offs to consider

- Reserving CPUs that have specific modules assigned to be scheduled on them. For example, isolating the CPU that the GPU and XHCI driver is serviced on improved frame pacing ([1](/media/isolate-heavy-modules-core.png))

## Raise the Clock Interrupt Frequency (Timer Resolution)

Raising the timer resolution helps with precision where constant sleeping or pacing is required such as multimedia applications, framerate limiters and more. In an ideal world when relying on sleep-related functions to pace events, Sleep(n) should sleep for n milliseconds, not n plus an arbitrary number. If the delta between n and what you expect to sleep for in reality is large, events won't be paced as you would expect which can result in unexpected or undesirable behavior. This is especially apparent in sleep-based framerate limiters. Below is a list of bullet points highlighting key information regarding the topic.

- Applications that require a high resolution already call for 1ms (1kHz) most of the time. In the context of a multimedia application, this means that it can maintain the pace of events within a resolution of 1ms, but we can take advantage of 0.5ms (2kHz) being the maximum resolution supported on most systems

- The implementation of timer resolution changed in Windows 10 2004+ so that the calling process does not affect the system on a global level but can be restored on Windows Server and Windows 11+ with the registry key below as explained in depth [here](/docs/research.md#fixing-timing-precision-in-windows-after-the-great-rule-change). In terms of the global behavior, you should have already chosen an appropriate Windows version after going through the [What Version of Windows Should You Use?](/docs/pre-install.md#what-version-of-windows-should-you-use) section. As long as the process that requires high precision is calling for a higher resolution, this does not matter. Although, it limits us from raising the resolution beyond 1ms (unless you have a kernel-mode driver or inject a DLL into the process which is a topic for another day)

    ```
    [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\kernel]
    "GlobalTimerResolutionRequests"=dword:00000001
    ```

- Even if you do not want to raise the timer resolution beyond 1ms, it is useful to call for it nonetheless as old applications do not raise the resolution which results in unexpected behavior

- Higher resolution results in higher precision, but in some cases 0.5ms provides less precision than something slightly lower such as 0.507ms. You should benchmark what calling resolution provides the highest precision (the lowest deltas) in the [MeasureSleep](https://github.com/amitxv/TimerResolution) program while requesting different resolutions with the [SetTimerResolution](https://github.com/amitxv/TimerResolution) program. This should be carried out under load as idle benchmarks may be misleading. The [micro-adjust-benchmark.ps1](https://github.com/amitxv/TimerResolution/blob/main/micro-adjust-benchmark.ps1) script can be used to automate the process

    - See [Micro-adjusting timer resolution for higher precision](/docs/research.md#micro-adjusting-timer-resolution-for-higher-precision) for a detailed explanation

## Disable Desktop Composition (DWM)

> [!WARNING]
> 💻 If you are configuring a system for general-purpose use such as for work or school, then skip this step as general compatibility is restricted.

Windows 7 had the ability to disable DWM natively within the operating system through the ``Advanced -> Performance -> Settings`` menu by typing ``sysdm.cpl`` in ``Win+R`` but the option was removed in Windows 8 and later. Although it is not necessarily recommended doing so anymore, it can still be achieved.

If you take responsibility for damage caused to your operating system, the PowerShell script below can be used to toggle DWM. Ensure that there aren't any UWP processes running and preferably run the ``Services-Disable.bat`` script that was generated in the [Configure Services and Drivers](#configure-services-and-drivers) section before disabling DWM. Beware of the UI breaking and some games/programs will not be able to launch (you may need to disable hardware acceleration). To clarify, this is more of a note that it is possible to disable DWM in modern editions of Windows rather than a recommendation.

<details>

<summary>toggle-dwm.ps1</summary>

- Save the source code below to a file named ``toggle-dwm.ps1`` in a text editor

    ```powershell
    function Take-Ownership($filePath) {
        $takeown_res = (Start-Process "takeown.exe" -ArgumentList "/F $($filePath) /A" -PassThru -WindowStyle Hidden).ExitCode
        $icacls_res = (Start-Process "icacls.exe" -ArgumentList "$($filePath) /grant Administrators:F" -PassThru -Wait -WindowStyle Hidden).ExitCode -ne 0

        return $takeown_res -bor $icacls_res
    }

    function main() {
        $current_principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
        $isAdmin = $current_principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

        if (-not $isAdmin) {
            Write-Host "error: administrator privileges required"
            return 1
        }

        $renameFiles = @(
            "C:\Windows\System32\UIRibbon.dll"
            "C:\Windows\System32\UIRibbonRes.dll"
            "C:\Windows\System32\Windows.UI.Logon.dll"
            "C:\Windows\System32\DWMInit.dll"
            "C:\Windows\System32\WSClient.dll"
            "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\TextInputHost.exe"
        )

        $dwmIfeoPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dwm.exe"
        $isDwmDisabled = $null -ne (Get-ItemProperty -Path $dwmIfeoPath -Name "Debugger" -ErrorAction SilentlyContinue)

        if ($isDwmDisabled) {
            Write-Host "info: enabling dwm"
            Remove-ItemProperty -Path $dwmIfeoPath -Name "Debugger" -Force
        } else {
            Write-Host "info: disabling dwm"
            New-Item -Path $dwmIfeoPath -Force > $null
            Set-ItemProperty -Path $dwmIfeoPath -Name "Debugger" -Type String -Value "\`"C:\Windows\System32\rundll32.exe\`"" -Force
        }

        $error_count = 0

        foreach ($filePath in $renameFiles) {
            $lastChar = $filePath[-1]
            $renamedFile = "$($filePath)$($lastChar)"
            $isOriginalFileExists = Test-Path $filePath
            $isRenamedFileExists = Test-Path $renamedFile

            if (-not ($isRenamedFileExists -or $isOriginalFileExists)) {
                # if neither exist then the binary never existed in the first place
                continue
            }

            if ($isRenamedFileExists) {
                Rename-Item $renamedFile $filePath -Force
            } else {
                Write-Host "info: renaming $($filePath)"
                $res = Take-Ownership -filePath $filePath

                if ($res -ne 0) {
                    Write-Host "error: failed to take ownership of $($filePath)"
                    $error_count++
                }

                $fileExtension = [System.IO.Path]::GetExtension($filePath)

                if ($fileExtension -eq ".exe") {
                    $fileNameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($filePath)

                    Get-Process -Name $fileNameWithoutExtension -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
                }

                Rename-Item $filePath $renamedFile -Force
            }
        }

        if ($error_count -eq 0) { Restart-Computer -Force }
    }

    $_exit_code = main
    Write-Host # new line
    exit $_exit_code
    ```

</details>

## Analyze Event Viewer

> [!WARNING]
> 💻 If you are configuring a system for general-purpose use such as for work or school, then skip this step as it is not required.

This step isn't required, but can help to justify unexplained performance issues. From a developer's perspective, we have certainly broken the operating system as we are running minimal services, debloated Windows and more. Code that naturally depends on something that is disabled or removed will throw errors or get stuck in an error loop. We can use event viewer to inspect whether everything is running as it should be. This is the method that was used to identify that the [Software Protection service was attempting to register a restart every 30s](/media/software-protection-error.png) as explained in the [Configure Services and Drivers](#configure-services-and-drivers) section along with a Google search that lead me to the solution.

- Depending on your configuration, the ``Services-Disable.bat`` script that was generated in the [Configure Services and Drivers](#configure-services-and-drivers) section may have disabled logging, so the start values for ``Wecsvc`` and ``EventLog`` must be changed to their default values which can be found in the ``Services-Enable.bat`` script. Make a note of what the values currently are so that you can restore them later

- Merge the ``ets-enable.reg`` file that was generated in the [Configure Event Trace Sessions](#configure-event-trace-sessions) section as it is required for event logging

- After running the script, use your PC normally for a while then open event viewer by typing ``eventvwr.msc`` in ``Win+R``. Inspect each section for errors and investigate how they can be solved

- Once finished, set the ``Wecsvc`` and ``EventLog`` start values back to their previous value in the ``Services-Disable.bat`` script

## CPU Idle States/C-State 0

Disabling idle states force C-State 0, which can be seen in [HWiNFO](https://www.hwinfo.com), and is in Microsoft's recommendations for configuring devices for real-time performance ([1](https://learn.microsoft.com/en-us/windows/iot/iot-enterprise/soft-real-time/soft-real-time-device)). Forcing C-State 0 mitigates the undesirable delay to execute new instructions on a CPU that has entered a deeper power-saving state at the expense of higher idle temperatures and power consumption. The CPU temperature should not increase to the point of thermal throttling because you should have already assessed that in [docs/physical-setup.md](/docs/physical-setup.md). If a static CPU frequency is not set, the effects of forcing C-State 0 should be assessed in terms of frequency boosting behavior (e.g. Precision Boost Overdrive, Turbo Boost). Avoid disabling idle states with Hyper-Threading/Simultaneous Multithreading enabled as single-threaded performance is usually negatively impacted. The commands below can be used to toggle idle states.

### Disable Idle States

```bat
powercfg /setacvalueindex scheme_current sub_processor 5d76a2ca-e8c0-402f-a133-2158492d58ad 1 && powercfg /setactive scheme_current
```

### Enable Idle States (default)

```bat
powercfg /setacvalueindex scheme_current sub_processor 5d76a2ca-e8c0-402f-a133-2158492d58ad 0 && powercfg /setactive scheme_current
```

## Cleanup

- Use [Autoruns](https://learn.microsoft.com/en-us/sysinternals/downloads/autoruns) to remove any unwanted programs from launching at startup

- Some locations you may want to review for residual files

    - ``"C:\"``

    - ``"C:\Windows\Prefetch"``

    - ``"C:\Windows\Temp"``

    - ``"%userprofile%\AppData\Local\Temp"``

    - ``"%userprofile%\Downloads"``

- Configure Disk Cleanup

    - Open CMD and enter the command below, tick all the boxes except ``DirectX Shader Cache``, press ``OK``

        ```bat
        cleanmgr /sageset:0
        ```

    - Run Disk Cleanup

        ```bat
        cleanmgr /sagerun:0
        ```

- For reference, the ``ScheduledDefrag`` task that was disabled in the [Disable Residual Scheduled Tasks](#disable-residual-scheduled-tasks) section executes the command below

    ```bat
    defrag -c -h -o -$
    ```

## Final Thoughts and Tips

- Favor tools such as [Bulk-Crap-Uninstaller](https://github.com/Klocman/Bulk-Crap-Uninstaller) to uninstall programs as the regular control panel does not remove residual files

- Kill processes that waste resources such as clients, ``explorer.exe`` and more

    - Use ``Ctrl+Shift+Esc`` to open process explorer then use ``File -> Run`` to start the ``explorer.exe`` shell again
