# Post-Installation Instructions

## OOBE Setup

Once you have begun the OOBE process, follow the steps in the video.

- Note: Do not enter a password by simply pressing enter, the service list recommended will break user password functionality & you will not be able to login again.

- See [media/oobe-windows7-example.mp4](https://raw.githubusercontent.com/amitxv/EVA/main/media/oobe-windows7-example.mp4)
- See [media/oobe-windows10-example.mp4](https://raw.githubusercontent.com/amitxv/EVA/main/media/oobe-windows10-example.mp4)

## Miscellaneous

- Note: Do not connect to the internet until told to do so.

- Allow users full control of the ``C:\`` drive. This resolves an issue with xperf ETL processing on Windows 7.

    - See [media/full-control-example.png](../media/full-control-example.png)

    - Click continue & ignore errors

- Open CMD as Administrator & enter the commands below.

    - Set PowerShell ExecutionPolicy to unrestricted:

        ```bat
        PowerShell Set-ExecutionPolicy Unrestricted -force
        ```
    
    - Set the password to never expire, resolves some bugs despite no password being set:

        ```bat
        net accounts /maxpwage:unlimited
        ```

    - Disable Automatic Repair, does more harm than good:

        ```bat
        bcdedit /set {current} recoveryenabled no
        ```

    - Windows 10+ Only:

    	- Clean Up the WinSxS Folder:

            ```bat
            DISM /online /Cleanup-Image /StartComponentCleanup /ResetBase
            ```

    	- Disable [Reserved Storage](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/dism-storage-reserve?view=windows-11) on 1903+:

            ```bat
            DISM /Online /Set-ReservedStorageState /State:Disabled
            ```

    	- Uninstall Microsoft Edge:

            ```bat
            for /f "delims=" %a in ('where /r "C:\Program Files (x86)\Microsoft\Edge\Application" *setup.exe*') do (if exist "%a" (%a --uninstall --system-level --verbose-logging --force-uninstall))
            ```

    	- Uninstall OneDrive:

            ```bat
            "%windir%\SysWOW64\OneDriveSetup.exe" /uninstall
            ```

    - Enable ``Launching applications and unsafe files`` in ``Internet Options > security > Custom Level``. This prevents [this annoying warning](https://gearupwindows.com/how-to-disable-open-file-security-warning-in-windows-10/). Feel free to skip this step as security may be reduced.

    - In ``Advanced System Settings``, do the following:

        - In ``Computer Name > Change`` configure the PC name

        - In ``System Protection``, disable & delete System Restore points. It has been proven to be very unreliable

        - In ``Remote``, disable **Remote Assistance**

        - Windows 7 Only:

            - In ``Advanced > Environment Variables > System Variables``, create a new variable:

                ```
                Variable name: devmgr_show_nonpresent_devices
                Variable value: 1
                ```
    
    - In ``Defragment and Optimize Drives``, disable **Run on a schedule**. More details on doing maintenance tasks ourself in [Final Thoughts & Tips](#final-thoughts--tips).

    - Disable all messages in ``Control Panel> System and Security > Action Center > Change Action Center settings > Change Security and Maintenance settings``.

        - This section is named ``Security and Maintenance`` on Windows 10

## Merge the Registry Files

- The registry files should be applied once by double-clicking the registry file normally, & once in ``C:\prerequisites\nsudo\NSudo.exe`` with the ``Enable All Privileges`` option enabled to ensure all registry keys are applied properly.

- ``C:\prerequisites\registry\registry.reg`` must be merged regardless of the Windows version.

- ``C:\prerequisites\registry\W7.reg`` must also be applied only if on Windows 7.

- ``C:\prerequisites\registry\W10.reg`` must also be applied only if on Windows 10.

- Restart your PC.

- You may establish an internet connection after you have restarted as the Windows Update policies will take effect.

## Replace Task Manager with Process Explorer

<details>
<summary>What is wrong with Task Manager?</summary>

- It relies on a kernel mode driver (pcw.sys) to operate (additional overhead).

- Does not provide performance metrics such as cycles/ context switches delta & other useful details.

- On Windows 8+, [Task Manager reports CPU utility in %](https://aaron-margosis.medium.com/task-managers-cpu-numbers-are-all-but-meaningless-2d165b421e43) which provides misleading CPU utilization details, on the other hand, Windows 7's Task Manager & process explorer report time-based busy utilization. This also explains why the disable idle power plan option results in 100% CPU utilization on Windows 8+.
</details>

- Place ``C:\prerequisites\sysinternals\procexp.exe`` into ``C:\Windows`` & open it.

- Go to ``Options`` & select ``Replace Task Manager``. I also configure ``Confirm Kill`` & ``Allow Only One Instance``.

## Visual Cleanup

- Disable features on the taskbar, unpin shortcuts & tiles from the taskbar & start menu.

    - See [media/visual-cleanup-windows7-example.mp4](https://raw.githubusercontent.com/amitxv/EVA/main/media/visual-cleanup-windows7-example.mp4)

    - See [media/visual-cleanup-windows10-example.mp4](https://raw.githubusercontent.com/amitxv/EVA/main/media/visual-cleanup-windows10-example.mp4)

## Removing Bloatware

Windows 10 stores installed applications both in the legacy & immersive control panel. Before we remove bloatware via bruteforce on linux, we may as well uninstall what Windows allows us to.

- Uninstall bloatware in ``Control Panel > Programs > Programs and Features``.

    - In the ``Turn Windows features on or off`` section, disable everything **except** for:

        - Note: keep ``Windows Search`` enabled on Windows 7

        - See [media/windows7-features-example.png](../media/windows7-features-example.png)

        - See [media/windows10-features-example.png](../media/windows10-features-example.png)

	- Reboot once before following the next steps (important)

- Windows 10+ Only:

    - Uninstall bloatware in ``Settings > Apps > Apps & Features``

        - In the ``Optional features`` section, uninstall everything apart from ``Microsoft Paint``, ``Notepad`` & ``WordPad``

- ## Removing Bloatware with Linux

    - Boot into Ventoy on your USB in BIOS & select the Linux Mint image. Select ``Start Linux Mint`` when promted

    - Open the file explorer which is pinned to the taskbar & in the left pane, navigate to the volume Windows is installed on. You can identify this by finding the drive that has the ``debloat.sh`` script in

    - Right click an empty space & select ``Open in Terminal``. This will open the bash terminal in the directory of the script for us so we do not need to CD to it manually

    - Type ``sudo bash debloat.sh`` to run the script & wait for it to finish

    - Windows 10+ Only:

        - Change the view to list view to make the contents more readable by selecting ``View > List View``

        - Delete the following folders:

            - ``/Program Files/WindowsApps``

            - ``/ProgramData/Packages``

            - ``/Users/[USERNAME]/AppData/Local/Microsoft/WindowsApps``

        - Delete everything except ``immersivecontrolpanel`` & ``ShellExperienceHost`` (not their exact names) in the following folders:

            - ``/Users/[USERNAME]/AppData/Local/Packages``

            - ``/Windows/SystemApps``

    - Once finished, empty the ``Trash`` in the file explorer & restart to boot back into Windows


- Once back into the Windows desktop, open ``C:\prerequisites\sysinternals\Autoruns.exe`` & delete all obsolete entries with a yellow label. Run with NSudo if you encounter any permission errors.

- Open CMD & enter the command below to remove leftover scheduled tasks.

    ```bat
    C:\prerequisites\scripts\scheduled-tasks\disable-tasks.exe
    ```

## Installing Drivers

- Install any drivers your system requires, avoid installing chipset drivers.

- Try to obtain the bare driver so it can be installed in Device Manager as executable installers usually come with extra unnecessary bloatware. Most of the time, you can open the installer's executable in 7-Zip to obtain the driver.

- I would recommend updating & installing ethernet, USB, sata (required on Windows 7 as enabling MSI on the stock sata driver will result in a BSOD), NVME & potentially the audio controller drivers.

## Activating Windows

As previously mentioned, you should have linked a key to your motherboard but if you have not now would be a good time to enter it. Open CMD & enter the command below.

```bat
slmgr /ipk [YOUR 25 DIGIT KEY]
slmgr /ato
```

## Installing Recommended Packages

- Install [7-Zip](https://www.7-zip.org)

    - Run ``C:\prerequisites\7-Zip\7z2200-x64.exe``

        - Open ``C:\Program Files\7-Zip\7zFM.exe``, to go ``Tools > Options`` & associate 7-Zip with all file extensions by clicking the + button. You may need to click it twice to override existing associated extensions.

- [Visual C++ Redistributable Runtimes](https://github.com/abbodi1406/vcredist/releases)

    - Extract the zip file and run ``C:\prerequisites\visual-cpp-runtimes\VisualCppRedist_AIO_x86_x64.exe``

- Web Browser

    - See https://privacytests.org/

    - [Librewolf](https://librewolf.net) (fork of Firefox) recommended

        - Install ``C:\prerequisites\librewolf-99.0.1.2.en-US.win64-setup.exe``

        - Remove the following from ``C:\Program Files\LibreWolf``

            - ``pingsender.exe``
            - ``updater.exe``

        - If you would like to set the search engine to Google, open [this link](https://www.linuxmint.com/searchengines.php), scroll to the bottom, click the Google icon & right click the URL to add the search engine to settings.

        - Recommended ``about:config`` changes (enter about:config in the URL box)

            - **Enable Compact Mode**

                - browser.uidensity = 1

            - **Remove fullscreen transition animation & warning message**

                - full-screen-api.transition-duration.enter = 0

                - full-screen-api.transition-duration.leave = 0

                - full-screen-api.warning.timeout = 0

            - **Remove tab preview image when dragging**

                - nglayout.enable_drag_images = false

            - **Disable reader mode**

                - reader.parse-on-load.enabled = false

    - Install [uBlock Origin](https://github.com/gorhill/uBlock), Librewolf already ships with it
    
        - In the extension settings, use these [uBlock Origin filters by dreammjow](https://raw.githubusercontent.com/dreammjow/MyFilters/main/src/filters.txt)

- Install [.NET 4.8 Runtimes](https://dotnet.microsoft.com/en-us/download/dotnet-framework/net48)

    - Run ``C:\prerequisites\ndp48-web.exe``

- Install [DirectX Runtimes](https://www.microsoft.com/en-gb/download/details.aspx?id=35)

    - Run ``C:\prerequisites\dxwebsetup.exe``

        - Ensure to uncheck the bing bar option

- Media Player

    - [mpv](https://mpv.io) or [mpc-hc](https://mpc-hc.org) ([alternative link](https://github.com/clsid2/mpc-hc)) recommended

- Install [OpenShell](https://github.com/Open-Shell/Open-Shell-Menu)

    - Windows 10+ Only:

        - This is required as we removed the bloated stock start menu.

        - Run ``C:\prerequisites\open-shell\OpenShellSetup.exe``

            - Only install the ``Open-Shell Menu``. Disable everything else to prevent installing bloatware.

        - I have included a registry file that will apply a basic OpenShell skin along with a few other settings, feel free to use your own.

        - Create a shortcut in win + r, ``shell:startup`` pointing to ``C:\Program Files\Open-Shell\StartMenu.exe``

## Configure the BCD Store

- Open CMD & enter the commands below.

    - Disable the boot manager timeout when dual booting does not affect single boot times.

        ```bat
        bcdedit /timeout 0
        ```
    - Configure [Data Execution Prevention](https://docs.microsoft.com/en-us/windows/win32/memory/data-execution-prevention) for ``essential Windows programs and services only``

        ```bat
        bcdedit /set nx optin
        ```

    - Configure the operating system name, i usually name it to whatever Windows version i am using e.g ``Windows 10 1803``

        ```bat
        bcdedit /set {current} description "OSNAME"
        ```

    - Windows 8+ Only
        
        - Disable the dynamic timer tick feature, implemented as a power saving feature:

            ```bat
            bcdedit /set disabledynamictick yes
            ```

        - Forces the clock to be backed by a platform source, no synthetic timers are allowed. Have not been able to prove the benifits of this, feel free to skip or test yourself:

            ```bat
            bcdedit /set useplatformtick yes
            ```

        - Configure the TSC synchronization policy. Have not been able to prove the benifits of this, feel free to skip or test yourself:

            ```bat
            bcdedit /set tscsyncpolicy [legacy | enhanced]
            ```

            - Related: [research.md - What TscSyncPolicy does Windows use by default?](research.md#what-tscsyncpolicy-does-windows-use-by-default)

## Configure Memory Management Settings

- Windows 10+ Only:

    - Open Powershell & enter the following:

        ```powershell
        Get-MMAgent
        ```

    - If anything is set to True, use the following command as an example to disable a specific setting:

        ```powershell
        Disable-MMAgent -MemoryCompression
        ```

## Disable Process Mitigations

- Windows 10 1709+ Only:

    - Run the ``C:\prerequisites\scripts\disable-process-mitigations.bat`` script to disable [process mitigations](https://docs.microsoft.com/en-us/powershell/module/processmitigations/set-processmitigation?view=windowsserver2019-ps)

    - Effects can be viewed with the following command in Powershell:

        ```powershell
        Get-ProcessMitigation -System
        ```

## Configure the Network Adapter

- Open ``Network and Sharing Center > Change adapter settings``.

- Right click your main network adapter & select properties.

- Disable all items except the following:

    - ``QoS Packet Scheduler``

    - ``Internet Protocol Version 4 (TCP/IPv4)``

- [Configure a Static IP address](https://youtu.be/5iRp1Nug0PU?t=36), ths is required as we will be disabling the network services that waste cycles.

- Disable ``NetBIOS over TCP/IP`` in ``General > Advanced > WINS`` to [prevent unnecessary system listening](https://github.com/djdallmann/GamingPCSetup/blob/master/CONTENT/DOCS/NETWORK/README.md).

## Preferences

- Go through the preferences folder to configure the following:

    - Desktop Icon Settings

    - Region & language

    - Taskbar Settings

    - Visual Effects & Pagefile

        - I usually just hit ``Adjust for best performance``

        - Ensure Desktop Composition is disabled on Windows 7

## Configure the Graphics Card

- Select the dropdown for NVIDIA or AMD.

    <details>
    <summary>NVIDIA GPU</summary>

    - I recommend using the 472.12 ([W7/W8](https://www.nvidia.com/en-us/drivers/results/180551), [W10](https://www.nvidia.com/Download/driverResults.aspx/180557/en-us/)) as it is the latest non-DCH driver. This is the latest driver supported on Windows 7 & is required on Windows 10 as we have stripped the Microsoft Store, although, the appx package for the control panel can be reinstalled if you choose to install a DCH driver.

    - Extract the driver executable package with 7-Zip & remove all folders **except** the following:

        ```
        Display.Driver
        NVI2
        EULA.txt
        ListDevices.txt
        setup.cfg
        setup.exe
        ```
        
    - Remove the following lines from ``setup.cfg`` (near the bottom):

        ```
        <file name="${{EulaHtmlFile}}"/>
        <file name="${{FunctionalConsentFile}}"/>
        <file name="${{PrivacyPolicyFile}}"/>
        ```

    - In ``NVI2\presentations.cfg`` set the value for ``ProgressPresentationUrl`` & ``ProgressPresentationSelectedPackageUrl`` to an empty string: ``value=""``.

    - Run setup.exe to install the driver.

    - Open CMD & enter the commands below to remove & disable telemetry.

        ```bat
        for /f "delims=" %a in ('where /r C:\ *NvTelemetry*') do (if exist "%a" (del /f /q /s "%a"))

        reg.exe add "HKLM\SOFTWARE\NVIDIA Corporation\NvControlPanel2\Client" /v "OptInOrOutPreference" /t REG_DWORD /d 0 /f 

        reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup" /v "SendTelemetryData" /t REG_DWORD /d 0 /f

        rd /s /q "C:\Program Files\NVIDIA Corporation\Display.NvContainer\plugins\LocalSystem\DisplayDriverRAS"

        rd /s /q "C:\Program Files\NVIDIA Corporation\DisplayDriverRAS"

        rd /s /q "C:\ProgramData\NVIDIA Corporation\DisplayDriverRAS"
        ```

    - HDCP Can be disabled with the [following registry key](https://github.com/djdallmann/GamingPCSetup/blob/master/CONTENT/RESEARCH/WINDRIVERS/README.md#q-are-there-any-configuration-options-that-allow-you-to-disable-hdcp-when-using-nvidia-based-graphics-cards), ensure to change the driver key to suit your needs:

        - Run ``C:\prerequisites\scripts\get-driver-keys.bat`` to get the driver keys on your system
        
            ```bat
            reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMHdcpKeyglobZero" /t REG_DWORD /d "1" /f
            ```
    
    - Force P-State 0 with the [following registry key](https://github.com/djdallmann/GamingPCSetup/blob/master/CONTENT/RESEARCH/WINDRIVERS/README.md#q-is-there-a-registry-setting-that-can-force-your-display-adapter-to-remain-at-its-highest-performance-state-pstate-p0) to reduce render time & jitter caused by frequency transitions, ensure to change the driver key to suit your needs:

        - Run ``C:\prerequisites\scripts\get-driver-keys.bat`` to get the driver keys on your system

            ```bat
            reg.exe add "HKLM\System\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableDynamicPstate" /t REG_DWORD /d "1" /f
            ```

    - NVIDIA Control Panel

    - In the ``Adjust desktop size and position``, set the scaling mode to ``No Scaling`` & set perform scaling on to ``Display``. Configure your resolution & refresh rate.

        - Use these 3D settings:

            - See [media/nvidia-cp-settings.png](../media/nvidia-cp-settings.png)

            - [Threaded Optimization offloads GPU-related processing tasks on the CPU](https://tweakguides.pcgamingwiki.com/NVFORCE_8.html), it usually hurts frametime consistency but feel free to test it yourself. You should also consider whether or not you are already CPU bottlenecked if you do choose to enable the setting.

    - Disable Ansel with ``C:\prerequisites\nvidia-ansel-configurator\NvCameraConfiguration_v1.0.0.6.exe``

    - Nvidia Inspector

        - Disable [Cuda P2 States](https://babeltechreviews.com/nvidia-cuda-force-p2-state) in ``C:\prerequisites\nvidia-profile-inspector\nvidiaProfileInspector.exe``. Feel free to skip this step as i have not verified it affects anything as of yet but there should be no harm disabling it.

        - Disable [SILK Smoothness](https://www.avsim.com/forums/topic/552651-nvidia-setting-silk-smoothness), feel free to skip this step as many games reportedly do not utilize it but no harm should be done disabling it. This setting was removed in newer driver versions.

    </details>

    <details>
    <summary>AMD GPU</summary>

    - To be expanded in the future, follow [this guide](https://docs.google.com/document/d/1Vd5WKWhm77sG8o9xBoSNRuAWRTavLqynJ7aQhVrsa8Y/edit#heading=h.hgpjx6g7xmp6) for now.

    - Disable HDCP in the Display section under overrides in the radeonsoftware.
    </details>

- ## Related GPU Settings

    - configure [MSI Afterburner](https://www.msi.com/Landing/afterburner/graphics-cards) as you usually would

        - Disable update checks & the low-level IO driver in settings

        - I would recommend configuring a static fan speed as using the fan curve feature requires the program to run in the background all the time

        - To automatically load a profile at startup, create a batch script containing the following, edit to suit your needs:

            ```bat
            @echo off
            start "" "C:\Program Files (x86)\MSI Afterburner\MSIAfterburner.exe" -Profile1
            timeout -t 8 /nobreak
            taskkill /F /IM MSIAfterburner.exe
            exit /b 0
            ```
        - Save & place the batch script in win + r, ``shell:startup``

    - Configure ``C:\prerequisites\CRU\CRU.exe`` as you usually would.

        - Try to delete every resolution & the other bloatware (audio blocks) apart from your native resolution, this may be a work around for the 1 second black screen when alt-tabbing in FSE, feel free to skip this step if you do not want to risk a black screen or are not comfortable with doing this

        - Restart your PC

    - Ensure your resolution is configured properly in Display Adapter Settings.

        - Use the ``C:\prerequisites\Change Resolution.lnk`` shortcut on Windows 10

## Configure Device Manager

- Open the sound control panel, can be opened with win + r, ``mmsys.cpl``

    - Disable unused Plaback & Recording devices 
    
    - Disable audio enhancements for them as they increase audiodg.exe cycles/s
    
    - Disable Exclusive Mode in the Advanced section

    - I like to set the sound scheme to no sounds in the Sounds tab

- Open device manager, ``View > Devices by connection``. Also enable ``Show hidden devices``

- Disable write-Cache buffer flushing on all drives in the ``Properties > Policies`` section.

- Go to your ``network adapter > properties > advanced``, disable any power saving & wake features.

    - Related: [research.md - How many Rss Queues do you need?](research.md#how-many-rss-queues-do-you-need)

- Go to ``View > Resources by connection``

    - Disable any **unneeded** devices that are using an IRQ or I/O resources, always ask if unsure, take your time on this step. Windows should not allow you to disable any required devices but ensure you do not accidentally disable another important device such as your main USB controller or similar...

        - If there are multiple of the same devices & you are unsure which one is in use, refer back to the tree structure in ``View > Devices by connection``. Note that a single device can use many resources.

- Open CMD & enter the command below to disable power saving for various devices in device manager. 

    ```bat
    C:\prerequisites\scripts\disable-pnp-powersaving.ps1
    ```

- Open CMD & enter the command below to cleanup hidden & unused devices.
    
    ```bat
    C:\prerequisites\device-cleanup\DeviceCleanup.exe -s -n *
    ```

## Configure Services & Drivers

- The service list configuration is not intended for laptop, Wi-Fi & webcam functionality. I am not responsible if anything goes wrong or you BSOD.

- Download [Service-List-Builder](https://github.com/amitxv/Service-List-Builder/releases)

- In ``C:\prerequisites\bare_services.ini``...

    - Add ``nsi`` to the ``[Automatic_Services]`` section if you play Apex Legends or Black Ops Cold War

    - You can add volsnap to the ``[Drivers_To_Disable]`` on Windows 8+

    - You can remove ``AppXSvc`` & ``StateRepository`` on < Windows 10 1803

    - Remove ``pcw`` from ``[Drivers_To_Disable]`` if you did not replace task manager with process explorer

- Remove ``MMCSS`` from the ``DependOnService`` registry key in ``HKLM\SYSTEM\CurrentControlSet\Services\Audiosrv`` if configuring Windows 7

- Once configured, use the following command. The scripts will be built in the ``build`` folder & NSudo is required to run them.

    ```bat
    service-list-builder.exe --config bare_services.ini
    ```

- Results after running the services disable script on my system:
    
    - See [media/bare-services-windows7.png](../media/bare-services-windows7.png)
    - See [media/bare-services-windows10.png](../media/bare-services-windows10.png)

- Some devices in Device Manager may appear with a yellow icon after running the disable services script, do not disable these devices as this will defeat the purpose of building toggle scripts.

- Keep the scripts somewhere safe such as in the C drive & do not share it with other people as it is specific to your system.

- Enable services for now so we can continue with the rest of the steps.

## Configure Control Panel

- It is not a bad idea to skim through both the legacy control panel & immersive control panel to ensure nothing is misconfigured, only takes a few minutes to do this anyway.

## Configure Power Options

- Set the power plan to high performance in ``Control Panel > Hardware and Sound > Power Options`` (PBO users excluded).

- Open ``C:\prerequisites\PowerSettingsExplorer.exe`` & configure the following.

    - Allow Throttle States - Off

    - USB 3 Link Powermanagement - Off

	- USB Selective Suspend - Disabled

- Open CMD & enter the command below to remove every powerplan except the active power scheme.

    ```bat
	powercfg -delete 381b4222-f694-41f0-9685-ff5bb260df2e > NUL
	powercfg -delete 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c > NUL
	powercfg -delete a1841308-3541-4fab-bc81-f71556f20b4a > NUL
	powercfg -delete e9a42b02-d5df-448d-aa00-03f14749eb61 > NUL
	```

## Interrupt & IRQ Management

- ## Message Signaled Interrupts

    - MSIs are faster than traditional line-based interrupts & may also resolve the issue of shared interrupts which are often the cause of high interrupt latency & stability
issues [[1](https://repo.zenk-security.com/Linux%20et%20systemes%20d.exploitations/Windows%20Internals%20Part%201_6th%20Edition.pdf)].

    - Open ``C:\prerequisites\MSIUtil.exe``

        - Enable Message Signaled Interrupts (MSI) on devices that support it

            - You will BSOD if you enable MSI for the **stock** Windows 7 sata driver which you should have updated as mentioned in the [Installing Drivers](#installing-drivers) section
        
        - Be careful as to what you choose to prioritize as more harm than good may be done. E.g you will likely stutter in a open-world game that utilizes texture streaming if the GPU IRQ priority is set higher than the storage controller priority.

    - Ensure that there is no IRQ sharing on your system by checking win + r, ``msinfo32`` ``Hardware Resources > Conflicts/Sharing`` section.

- ## Interrupt Affinity

    - By default, CPU 0 handles the majority of DPCs & interrupts for several devices which can be viewed in a xperf dpcisr trace. We can use ``C:\prerequisites\Interrupt-Affinity-Tool.exe`` to set an interrupt affinity policy to the USB & GPU driver, which are two of many devices responsible for the most DPCs/ISRs, to offload them onto another core. They both require testing as you may do more harm than good if it is set to a weaker or equally as busy core. Feel free to skip this step if you are not comfortable with doing so.

        - The correct device can be identified by cross-checking the ``Location Info`` with the ``Location`` in the ``properties > general`` section of a device in device manager

        - Ideally you should use [AutoGpuAffinity](https://github.com/amitxv/AutoGpuAffinity) to benchmark the GPU affinity

        - Use [Mouse Tester](https://github.com/microe1/MouseTester) to compare polling stability between the USB controller on different cores

            - Ideally this should be done with some sort of realistic load such as a game running in the background as idle benchmarks may be misleading, but as we do not have any games installed yet, you can come back & test this later

    - Note: Restart your PC instead of an individual driver to avoid issues

    - Open CMD & enter the command below to configure what CPU handles DPCs/ISRs for the network driver. Ensure to change the driver key to suit your needs.

        - Run ``C:\prerequisites\scripts\get-driver-keys.bat`` to get the driver keys on your system

            ```bat
            reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0000" /v "*RssBaseProcNumber" /t REG_SZ /d "2" /f
            ```

    - You can ensure interrupt affinity policies have been configured correctly by analyzing a xperf trace while the device is busy

## Memory Cleaner

- Feel free to skip this step as it is not required, Microsoft fixed the standby list memory management issues in a later version of Windows. [Memory Cleaner](https://github.com/danskee/MemoryCleaner) ([alternative link](https://git.zusier.xyz/Zusier/MemoryCleaner)) also allows us to set the kernel timer-resolution globally however the behaviour of timer-resolution changed in 2004+ as explained in [this article](https://randomascii.wordpress.com/2020/10/04/windows-timer-resolution-the-great-rule-change/), rendering these methods useless.

- Place ``C:\prerequisites\Memory-Cleaner.exe`` in win + r, ``shell:startup`` & open it.

    - Go to ``File > Settings`` & configure:
    
        - The hotkey to clean the standby list & working set

        - The desired timer-resolution, 10000 (1ms) recommended

        - Uncheck ``Enable timer``

        - Check ``Start minimized`` & ``Start timer resolution automatically``

- Avoid using auto cleaning apps like ISLC/Memreduct, they consume alot of resources due to a frequent polling timer interval & cause stuttering due to autoclearing memory.

## Optimizing the File System

- Open CMD & enter the commands below.

    - Prevents characters from the extended character set (including diacritic characters) to be used in 8.3 character-length short file names on NTFS volumes

        ```bat
        fsutil behavior set allowextchar 0
        ```

    - Disable generation of a bug check when there is corruption on an NTFS volume. This feature can be used to prevent NTFS from silently deleting data

        ```bat
        fsutil behavior set Bugcheckoncorrupt 0
        ```

    - Disables the creation of 8.3 character-length file names on FAT- & NTFS-formatted volumes

        ```bat
        fsutil behavior set disable8dot3 1
        ```

    - Disable NTFS compression
    
        ```bat
        fsutil behavior set disablecompression 1
        ```

    - Disable the encryption of folders & files on NTFS volumes

        ```bat
        fsutil behavior set disableencryption 1
        ```

    - Disable updates to the Last Access Time stamp on each directory when directories are listed on an NTFS volume

        ```bat
        fsutil behavior set disablelastaccess 1
        ```
    
    - Disable spot corruption handling. It is better to debug manually as this feature does more harm than good

        ```bat
        fsutil behavior set disablespotcorruptionhandling 1
        ```

    - Disable memory paging file encryption

        ```bat
        fsutil behavior set encryptpagingfile 0
        ```

    - Configure NTFS quota violations to be reported in the system log every 3 hours instead of every hour

        ```bat
        fsutil behavior set quotanotify 10800
        ```

    - Enables delete notifications (also known as trim or unmap)

        ```bat
        fsutil behavior set disabledeletenotify 0
        ```

    - Disable NTFS self-healing repair operations on the current installation, does more harm than good

        ```bat
        fsutil repair set C: 0
        ```

## Disable Hidden Power Saving

- All hidden means is not visible to the user, many driver INF configuration files contain these registry entries that are clearly labeled power saving, however i have not been able to prove the benifit of this script so feel free to skip this step.

    - Run the ``C:\prerequisites\scripts\disable-hidden-powersaving.bat`` script

## Installing Games & Applications

- Now is a good time to install whatever programs you commonly use to prepare us for the next steps.

## Configure FSE & QoS for Games

- Microsoft has claimed FSO/independent flip has improved in later Windows versions which has also been verified by members in the community with [Reflex Latency Analyzer](https://www.nvidia.com/en-gb/geforce/news/reflex-latency-analyzer-360hz-g-sync-monitors), however other users have claimed otherwise, my suggestion would be to test both & use whatever feels acceptable.

- Configuring a QoS Policy will allow Windows to prioritize packets of an application over other devices on your network & PC.

    - Related: [research.md - How can you verify if a DSCP QoS policy is working?](research.md#how-can-you-verify-if-a-dscp-policy-is-working)

- Run the ``C:\prerequisites\scripts\fse-qos-for-game-exes.bat`` script & follow the instructions in the console output

## Cleanup

- Clear the PATH user environment variable of locations pointing to Windows bloatware folders

- Some locations you may want to review for leftover bloat & unwanted shortcuts

    - ``"%userprofile%\AppData"``
    - ``"%userprofile%\AppData\Local\Temp"``
    - ``"%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs"``
    - ``"%userprofile%\Downloads"``
    - ``"C:\"``
    - ``"C:\ProgramData\Microsoft\Windows\Start Menu\Programs"``
    - ``"C:\Program Files"``
    - ``"C:\ProgramData"``
    - ``"C:\Prefetch"``
    - ``"C:\Windows\SoftwareDistribution\download"``
    - ``"C:\Windows\Temp"``

- Reset Firewall rules:

    - Open CMD & enter the command below

        ```bat
        reg.exe delete "HKLM\System\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /f
        reg.exe add "HKLM\System\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /f
        ```

- Open ````C:\prerequisites\sysinternals\Autoruns.exe```` & remove any unwanted programs such as game launchers from starting automatically.

- Configure Disk Cleanup:

    - Open CMD & enter the command below, tick all of the boxes

        ```bat
        cleanmgr /sageset:50
        ```
    - Run Disk Cleanup:

        ```bat
        cleanmgr /sagerun:50
        ```

## Configure Default Programs

- Configure default programs in ``Settings > Apps``

## Final Thoughts & Tips

- Before launching a game consider:

    - Killing explorer.exe after you launch your game, it uses a ton of cycles.

        - Use ``ctrl + shift + esc`` to open task manager then use ``File > Run`` to start the ``explorer.exe`` shell again

    - Disabling idle states which will force C-State 0 & eliminate jitter due to the process of state transition. After all, C1 is still power saving [[1](https://www.dell.com/support/kbdoc/en-uk/000060621/what-is-the-c-state)].

        - Drag & drop the scripts in ``C:\prerequisites\scripts\idle-scripts`` to the desktop for easy access. This way you can disable idle before launching a game & re-enable it after you close your game

    - Kill other processes that waste CPU cycles such as game clients.

- Don't run random tweaks, tweaking programs or fall for the "fps boost" marketing nonsense. If you have a question about a specific option or setting, just ask.

- Try to favour FOSS (free & open source software). Stay away from proprietary software where you can.

- You do not need an antivirus. You need a brain & uBlock origin in your browser. I also recommend importing [ClearURL Filter List](https://raw.githubusercontent.com/DandelionSprout/adfilt/master/ClearURLs%20for%20uBo/clear_urls_uboified.txt) into uBlock origin & installing the [Skip Redirect](https://addons.mozilla.org/firefox/addon/skip-redirect/) extension. Ensure to scan files with [VirusTotal](https://www.virustotal.com/gui/home/upload) before running them.

- Cap your framerate at a multiple of your monitor refresh rate to prevent frame mistiming [[1](https://youtu.be/_73gFgNrYVQ)]. E.g possible framerate caps with a 144hz monitor include 72, 144, 288, 432 ...

- Carry out maintenance tasks yourself on a weekly basis. This includes:

    - Trimming your SSD

    - Using a [lint roller](https://www.ikea.com/gb/en/p/baestis-lint-roller-grey-90425626) to remove dirt & debris from the mousepad once in a while

    - Using a small [air dust blower](https://www.amazon.co.uk/s?k=air+dust+blower) to remove dirt & debris from the mouse sensor lens often

    - Removing dust from components often
