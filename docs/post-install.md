# Post-Install Instructions

## OOBE Setup

Do not connect to the Internet until the [Merge the Registry Files](#merge-the-registry-files) section. Avoid using a password as the service list used will break user password functionality.

If you are configuring Windows 11, press **Shift + F10** to open CMD and run the following command ``oobe\BypassNRO.cmd``.  This will unlock the **I don't have internet** option demonstrated in the video examples below.

- See [media/oobe-windows7-example.mp4](https://raw.githubusercontent.com/amitxv/EVA/main/media/oobe-windows7-example.mp4)
- See [media/oobe-windows8-example.mp4](https://raw.githubusercontent.com/amitxv/EVA/main/media/oobe-windows8-example.mp4)
- See [media/oobe-windows10+-example.mp4](https://raw.githubusercontent.com/amitxv/EVA/main/media/oobe-windows10+-example.mp4)

## Activate Windows

Use the commands below to activate Windows using your license key if you do not have one linked to your HWID. Ensure that the activation process was successful by verifying the activation status in computer properties. Open CMD as administrator and enter the commands below.

```bat
slmgr /ipk <license key>
```

```bat
slmgr /ato
```

## Visual Cleanup

Disable features on the taskbar, unpin shortcuts and tiles from the taskbar and start menu.

- See [media/visual-cleanup-windows7-example.mp4](https://raw.githubusercontent.com/amitxv/EVA/main/media/visual-cleanup-windows7-example.mp4)
- See [media/visual-cleanup-windows8-example.mp4](https://raw.githubusercontent.com/amitxv/EVA/main/media/visual-cleanup-windows8-example.mp4)
- See [media/visual-cleanup-windows10+-example.mp4](https://raw.githubusercontent.com/amitxv/EVA/main/media/visual-cleanup-windows10+-example.mp4)

## Miscellaneous

Open CMD as administrator and enter the command below. The commands are placed in a script instead of this document as it will be tedious to copy and paste each command without a web browser installed.

```bat
C:\prerequisites\scripts\miscellaneous.bat
```

- Disable all messages in **Control Panel -> System and Security -> Action Center -> Change Action Center settings -> Change Security and Maintenance settings**

    - This section is named **Security and Maintenance** on Windows 10+

- Enable **Launching applications and unsafe files** in **Internet Options -> Security -> Custom Level**. This prevents the [ridiculous warning when opening files](https://gearupwindows.com/how-to-disable-open-file-security-warning-in-windows-10)

- In win + r, **dfrgui** disable **Run on a schedule**. More details on doing maintenance tasks ourselves in [Final Thoughts and Tips](#final-thoughts-and-tips)

- Disable **Turn on fast startup** in **Control Panel -> Hardware and Sound -> Power Options -> System Settings**

- In win + r, **sysdm.cpl** configure the following:

    - **Computer Name -> Change**- configure the PC name
    - **Advanced -> Performance -> Settings** - configure **Adjust for best performance** and optionally the page file
    - **System Protection** - disable and delete system restore points. It has been proven to be very unreliable

- Allow users full control of the ``C:\`` directory to resolve xperf etl processing

    - See [media/full-control-example.png](../media/full-control-example.png), continue and ignore errors

## Remove Bloatware Natively

- Although nothing should appear, as a precautionary measure check and uninstall any bloatware that exists in **Control Panel -> Programs -> Programs and Features**.

- In win + r, **OptionalFeatures**, disable everything except for the following:

    - See [media/windows7-features-example.png](../media/windows7-features-example.png)
    - See [media/windows8+-features-example.png](../media/windows8+-features-example.png)

- Windows 10+ Only:

    - Windows 10:

        - Uninstall bloatware in **Settings -> Apps -> Apps and Features**
        - In the **Optional features** section, uninstall everything apart from **Microsoft Paint**, **Notepad** and **WordPad**

    - Windows 11:

        - Uninstall bloatware in **Settings -> Apps -> Installed apps**
        - In the **Settings -> Apps -> Optional features** section, uninstall everything apart from **WMIC**, **Notepad (system)** and **WordPad**

- Restart your PC once to apply the changes above (do not boot into Linux Mint without a full restart beforehand)

## Removing Bloatware with Linux

- Boot into Ventoy on your USB in BIOS and select the Linux Mint ISO. Select **Start Linux Mint** when prompted

- Open file explorer which is pinned to the taskbar and navigate to the volume Windows is installed on. You can identify this by finding the volume that has the **win-debloat.sh** script in

- Right click an empty space and select **Open in Terminal**. Use the command below to run the script

    ```
    sudo bash win-debloat.sh
    ```

- Once finished, use the command below to reboot

    ```
    sudo reboot
    ```

- Open ```C:\prerequisites\sysinternals\Autoruns.exe``` and remove all obsolete entries with a yellow label, run with ``C:\prerequisites\nsudo\NSudo.exe`` if you encounter any permission errors

## Install [OpenShell](https://github.com/Open-Shell/Open-Shell-Menu) (Windows 8+)

- Run **OpenShellSetup.exe** in ``C:\prerequisites\open-shell``

    - Only install the **Open-Shell Menu**. Disable everything else to prevent installing bloatware

- I have included a registry file that will apply a basic OpenShell skin along with a few other settings, feel free to use your own

- Create a shortcut in win + r, **shell:startup** pointing to ``C:\Program Files\Open-Shell\StartMenu.exe``

- Windows 8 Only:

    - Open ``"C:\Program Files\Open-Shell\Start Menu Settings.lnk"``, enable **Show all settings** then go to the Windows 8 Settings section and set **Disable active corners** to **All**

## Install Xbox Game Bar (Windows 10+)

Some games such as Apex Legends require Game Bar to be installed for [FSE/Hardware: Legacy Flip](https://github.com/GameTechDev/PresentMon#csv-columns) to properly function. The Game Bar related processes will get disabled in the [Configure Services and Drivers](#configure-services-and-drivers) section to prevent it from running in the background. Open CMD as administrator and enter the command below.

```bat
C:\prerequisites\scripts\install-game-bar.bat
```

## Install [Visual C++ Redistributable Runtimes](https://github.com/abbodi1406/vcredist/releases)

Run the package below to install the redistributables.

```
C:\prerequisites\VisualCppRedist_AIO_x86_x64.exe
```

## Disable Residual Scheduled Tasks

Open CMD as administrator and enter the command below.

```bat
C:\prerequisites\scripts\scheduled-tasks\disable-tasks.exe
```

## Merge the Registry Files

Open CMD as administrator and enter the command below. Replace **<winver\>** with the Windows version you are configuring (e.g 7, 8, 10, 11).

```bat
C:\prerequisites\scripts\registry\apply-registry.exe --winver <winver>
```

- Ensure that the program prints a "done" message to the console, if it has not then command prompt was probably not opened with administrator privileges and the registry files were not successfully merged

- After a restart, you can establish an Internet connection as the Windows update policies will take effect

## [Spectre and Meltdown](https://www.grc.com/inspectre.htm)

Ensure **System is Spectre/Meltdown protected** is **NO** with the program below. AMD is unaffected by Meltdown and apparently [performs better with Spectre enabled](https://www.phoronix.com/review/amd-zen4-spectrev2), feel free to benchmark it on your own system.

```
C:\prerequisites\inspectre.exe
```

- See [media/meltdown-spectre-example.png](../media/meltdown-spectre-example.png)

## User Preference

Go through the ``C:\prerequisites\preference`` folder to configure the following:

- Configure Pointer Scheme
- Desktop Icon Settings
- Region and language
- Taskbar Settings

## Install Drivers

Install any drivers your system requires, avoid installing chipset drivers. I would recommend updating and installing Ethernet, USB, NVME, SATA (required on Windows 7 as enabling MSI on the stock SATA driver will result in a BSOD). See the [Integrate and Obtain Drivers](./building.md#integrate-and-obtain-drivers) section for details on finding drivers (download them on another operating system or PC).

Try to obtain the driver in its INF form so that it can be installed in device manager as executable installers usually install other bloatware along with the driver itself. Most of the time, you can extract the installer's executable with 7-Zip to obtain the driver.

[Snappy Driver Installer Origin](https://www.snappy-driver-installer.org) can also be used to install drivers on a live system. Use the program below.

```
C:\prerequisites\SDIO\SDIO_x64_R746.exe
```

## Installing Recommended Packages and Programs

- [.NET 4.8 Runtimes](https://dotnet.microsoft.com/en-us/download/dotnet-framework/net48)

    - Run ``C:\prerequisites\ndp48-web.exe``

- [DirectX Runtimes](https://www.microsoft.com/en-gb/download/details.aspx?id=35)

    - Run ``C:\prerequisites\dxwebsetup.exe``. ensure to uncheck the Bing bar option

- [7-Zip](https://www.7-zip.org)

    - Run ``C:\prerequisites\7-Zip\7z2201-x64.exe``
    - Open ``C:\Program Files\7-Zip\7zFM.exe`` then to go **Tools -> Options** and associate 7-Zip with all file extensions by clicking the **+** button. You may need to click it twice to override existing associated extensions

- Web Browser

    - [Librewolf](https://librewolf.net) (fork of Firefox) recommended

        - See https://privacytests.org

    - The [Arkenfox user.js](https://github.com/arkenfox/user.js) is an alternative for Librewolf and applicable to a default Firefox installation

    - Open CMD and enter the command below

        ```bat
        C:\prerequisites\scripts\librewolf-web-installer.bat
        ```

    - Remove the following from ``C:\Program Files\LibreWolf`` then open **Librewolf.exe**:

        - **pingsender.exe**

    - If you would like to set the search engine to Google, open [this link](https://www.linuxmint.com/searchengines.php), scroll to the bottom, click the Google icon and right click the URL to add the search engine to settings

    - Install [uBlock Origin](https://github.com/gorhill/uBlock), Librewolf already ships with it

        - I would also recommend importing [ClearURL's filter list](https://raw.githubusercontent.com/DandelionSprout/adfilt/master/ClearURLs%20for%20uBo/clear_urls_uboified.txt) along with [Dreammjow's filter list](https://raw.githubusercontent.com/dreammjow/MyFilters/main/src/filters.txt) and installing the [Skip Redirect](https://addons.mozilla.org/firefox/addon/skip-redirect/) extension

    - Recommended **about:config** changes (enter about:config in the URL box). Thanks to Dato for initially sharing these

        - **Enable Compact Mode**

            - browser.uidensity = 1

        - **Remove fullscreen transition animation and warning message**

            - full-screen-api.transition-duration.enter = 0
            - full-screen-api.transition-duration.leave = 0
            - full-screen-api.warning.timeout = 0

        - **Remove tab preview image when dragging**

            - nglayout.enable_drag_images = false

        - **Disable reader mode**

            - reader.parse-on-load.enabled = false

        - **Disable ResistFingerprinting** (not recommended but the browser can become sluggish)

            - privacy.resistFingerprinting = false

- Media Player

    - [mpv](https://mpv.io)/[mpv.net](https://github.com/stax76/mpv.net) or [mpc-hc](https://mpc-hc.org) ([alternative link](https://github.com/clsid2/mpc-hc)) recommended

## Configure Power Options

- Set the power plan to **High performance** in **Control Panel -> Hardware and Sound -> Power Options**

- Open CMD and enter the commands below to remove every power plan except the active power scheme, ignore errors

    ```bat
	powercfg -delete 381b4222-f694-41f0-9685-ff5bb260df2e
	powercfg -delete 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
	powercfg -delete a1841308-3541-4fab-bc81-f71556f20b4a
	powercfg -delete e9a42b02-d5df-448d-aa00-03f14749eb61
	```

- Open ``C:\prerequisites\PowerSettingsExplorer.exe`` and configure the following:

    - NVMe NOPPME - Off

    - Allow Throttle States - Off

    - USB 3 Link Power Management - Off

    - USB Selective Suspend - Disabled

    - Turn off display after - 0 minutes

    - Processor idle disable - Disable idle

        - If you do not want to run your CPU at C-State 0 all of the time, use the scripts in ``C:\prerequisites\scripts\idle-scripts`` (place on desktop for easy access) to disable idle before launching a game and enable idle after you close your game. This will mitigate jitter due to the process of state transition. Beware of higher temperatures, you should not be thermal throttling to begin with after following [docs/physical-setup.md](./physical-setup.md)

## Configure the BCD Store

Open CMD and enter the commands below.

- Disable the boot manager timeout when dual booting (does not affect single boot times)

    ```bat
    bcdedit /timeout 0
    ```

- Configure [Data Execution Prevention](https://docs.microsoft.com/en-us/windows/win32/memory/data-execution-prevention) for **essential Windows programs and services only**. DEP can be completely disabled with ``bcdedit /set nx AlwaysOff`` however the former is preferred due to compatibility with a minority of anticheats

    ```bat
    bcdedit /set nx Optin
    ```

- Configure the operating system name, I usually name it to whatever Windows version I am using e.g **Windows 10 1803**

    ```bat
    bcdedit /set {current} description "OSNAME"
    ```

- Windows 8+ Only

    - Implemented as a power saving feature for laptops and tablets, you absolutely do not want a [tickless kernel](https://en.wikipedia.org/wiki/Tickless_kernel) on a desktop

        ```bat
        bcdedit /set disabledynamictick yes
        ```
    
## Configure the Graphics Driver

- See [docs/configure-nvidia.md](../docs/configure-nvidia.md)
- See [docs/configure-amd.md](../docs/configure-amd.md)

## Configure MSI Afterburner

If you usually use [MSI Afterburner](https://www.msi.com/Landing/afterburner/graphics-cards) to configure the clock/memory frequency, fan speed and other settings, download and install it.

- Disable update checks in settings

- I would recommend configuring a static fan speed as using the fan curve feature requires the program to run continually

- To automatically load a profile at startup, create a batch script in win + r, **shell:startup** containing the following, edit to suit your needs:

    ```bat
    @echo off
    setlocal EnableDelayedExpansion

    set "afterburner_path=C:\Program Files (x86)\MSI Afterburner\MSIAfterburner.exe"
    set "profile=1"

    if not exist "!afterburner_path!" (
        echo error: afterburner path invalid
        pause
        exit /b 1
    )

    start "" "!afterburner_path!" -Profile!profile!
    timeout -t 8 /nobreak
    PowerShell -Command Stop-Process -Name "MSIAfterburner" -Force
    exit /b 0
    ```

## Configure CRU

If you usually use [Custom Resolution Utility](https://www.monitortests.com/forum/Thread-Custom-Resolution-Utility-CRU) to configure display resolutions, download and extract it.

- See [How to setup Display Scaling, works with all games | KajzerD](https://www.youtube.com/watch?v=50itBs-sz1w)

- Use the exact timing for an integer refresh rate

- Try to delete every resolution and the other bloatware (audio blocks) apart from your native resolution, this may be a work around for the 1 second black screen when alt-tabbing in FSE, feel free to skip this step if you are not comfortable risking a black screen

- Restart your PC instead of using **restart64.exe** as it may result in a black screen

- Ensure your resolution is configured properly in Display Adapter Settings

    - Use the ``C:\prerequisites\change-resolution.lnk`` shortcut on Windows 8+

## Replace Task Manager with Process Explorer

This step is not optional, pcw.sys will be disabled which breaks the stock Task Manager functionality.

<details>

<summary>Reasons not to use Task Manager</summary>

- It relies on a kernel mode driver to operate (additional overhead)
- Does not provide performance metrics such as cycles/context switches delta and other useful details
- On Windows 8+, [Task Manager reports CPU utility in %](https://aaron-margosis.medium.com/task-managers-cpu-numbers-are-all-but-meaningless-2d165b421e43) which provides misleading CPU utilization details, on the other hand, Windows 7's Task Manager and process explorer report time-based busy utilization. This also explains why the disable idle power plan option results in 100% CPU utilization on Windows 8+

</details>

- Copy **procexp.exe** from ``C:\prerequisites\sysinternals`` into ``C:\Windows`` and open it
- Go to **Options** and select **Replace Task Manager**. I also configure **Confirm Kill** and **Allow Only One Instance**

## Disable Process Mitigations (Windows 10 1709+)

Run the ``C:\prerequisites\scripts\disable-process-mitigations.bat`` script to disable [process mitigations](https://docs.microsoft.com/en-us/powershell/module/processmitigations/set-processmitigation?view=windowsserver2019-ps). Effects can be viewed with the command below in PowerShell

```powershell
Get-ProcessMitigation -System
```

## Configure Memory Management Settings (Windows 8+)

- Open PowerShell and enter the command below

    ```powershell
    Get-MMAgent
    ```

- If anything is set to True, use the command below as an example to disable a given setting

    ```powershell
    Disable-MMAgent -MemoryCompression
    ```

## Memory Cleaner and Timer Resolution (Windows 10 1909 and Under)

Feel free to skip this step as it is not required, Microsoft fixed the standby list memory management issues in a later version of Windows but some modern games still have memory leaks. [Memory Cleaner](https://github.com/danskee/MemoryCleaner) ([alternative link](https://git.zusier.xyz/Zusier/MemoryCleaner)) also allows us to set the kernel timer-resolution globally however the behavior of timer-resolution changed in 2004+ as explained in [this article](https://randomascii.wordpress.com/2020/10/04/windows-timer-resolution-the-great-rule-change/), rendering this "trick" useless.

- Place ``C:\prerequisites\Memory-Cleaner.exe`` in win + r, **shell:startup** and open it

    - Go to **File -> Settings** and configure the following:
    
        - The hotkey to clean the standby list and working set
        - The desired timer-resolution, 10000 (1MS) recommended
        - Uncheck **Enable timer**
        - Check **Start minimized** and **Start timer resolution automatically**

- Avoid using auto cleaning apps like ISLC/MemReduct, they consume a lot of resources due to a frequent polling timer interval and cause stuttering due to autocleaning memory

## Configure the Network Adapter

- Open **Network and Sharing Center -> Change adapter settings**
- Right click your main network adapter and select properties
- Disable all items except **QoS Packet Scheduler** and **Internet Protocol Version 4 (TCP/IPv4)**
- [Configure a Static IP address](https://youtu.be/5iRp1Nug0PU?t=36). this is required as we will be disabling the network services that waste CPU cycles
- Disable **NetBIOS over TCP/IP** in **General -> Advanced -> WINS** to [prevent unnecessary system listening](https://github.com/djdallmann/GamingPCSetup/blob/master/CONTENT/DOCS/NETWORK/README.md)

## Configure Audio Devices

- Open the sound control panel, can be opened with win + r, **mmsys.cpl**

- Disable unused Playback and Recording devices
    
- Disable audio enhancements as they waste CPU cycles

    - See [media/audio enhancements-benchmark.png](../media/audio%20enhancements-benchmark.png)
    
- Disable **Exclusive Mode** in the Advanced section

- I also like to set the sound scheme to no sounds in the Sounds tab

## Configure Services and Drivers

The service list configuration is not intended for Wi-Fi and webcam functionality. I am not responsible if anything goes wrong or you BSOD. The idea is to disable services while gaming and use default services for everything else. Feel free to customize the lists by editing  ``C:\prerequisites\bare-services.ini`` in a text editor.

- On Windows 7 and 8, remove **MMCSS** from the **DependOnService** registry key in ``HKLM\SYSTEM\CurrentControlSet\Services\Audiosrv``

- On 1607 and 1703, delete the **ErrorControl** registry key in ``HKLM\SYSTEM\CurrentControlSet\Services\Schedule`` to prevent an unresponsive explorer shell after disabling the task scheduler service

- Download and extract the latest [Service-List-Builder](https://github.com/amitxv/Service-List-Builder/releases) release. Open CMD and CD to the extracted folder where the executable is located

- Use the command below to build the scripts in the **build** folder. NSudo is required to run the batch scripts

    ```bat
    service-list-builder.exe --config C:\prerequisites\bare-services.ini
    ```

- Move the batch scripts and **NSudo.exe** somewhere safe such as in the ``C:\`` drive and do not share it with other people as it is specific to your system

- To prepare us for the next steps, run **Services-Disable.bat** with NSudo, ensure **Enable All Privileges** is enabled as mentioned

## Configure Device Manager

Many devices in device manager will appear with a yellow icon as we ran the disable services script, **DO NOT** disable any device with a yellow icon as this will completely defeat the purpose of building toggle scripts. My method for configuring services and device manager will ensure maximum compatibility while services are enabled.

- Open device manager then go to **View -> Devices by connection**

    - Disable write-cache buffer flushing on all drives in the **Properties -> Policies** section

    - Go to your **Network adapter -> properties -> Advanced**, disable any power saving and wake features

        - Related: [research.md - How many RSS Queues do you need?](research.md#how-many-rss-queues-do-you-need)

    - Disable **High Definition Audio Controller** and the USB controller on the same PCI port as your GPU

    - Disable any PCI, SATA, NVME and USB controllers with nothing connected to them

- Go to **View -> Resources by connection**

    - Disable any **unneeded** devices that are using an IRQ or I/O resources, always ask if unsure, take your time on this step. Windows should not allow you to disable any required devices but ensure you do not accidentally disable another important device such as your main USB controller or similar. Once again, **DO NOT** disable any device with a yellow icon

        - If there are multiple of the same devices and you are unsure which one is in use, refer back to the tree structure in **View -> Devices by connection**. Remember that a single device can use many resources. You can also use ``C:\prerequisites\MSIUtil.exe`` to check for duplicate, unneeded devices incase you accidently miss any with the confusing device manager tree structure

- To prepare us for the next steps, run **Services-Enable.bat** with NSudo, ensure **Enable All Privileges** is enabled as mentioned

- Open CMD and enter the command below to cleanup hidden and unused devices
    
    ```bat
    C:\prerequisites\device-cleanup\DeviceCleanup.exe -s -n *
    ```

## Disable Driver Power Saving

Open CMD and enter the commands below to disable power saving on various devices in device manager and registry entries present in modern drivers.

```bat
C:\prerequisites\scripts\disable-pnp-powersaving.ps1
```

```bat
C:\prerequisites\scripts\disable-driver-powersaving.bat
```

## Configure Event Trace Sessions

Create registry files to toggle event trace sessions. Programs that rely on event tracers such will not be able to log data until the required sessions are restored which is the purpose of creating two registry files to toggle between them (identical concept to the service scripts). Open CMD and enter the commands below to build the registry files in the ``C:\`` directory. As with the services scripts, these registry files must be ran with NSudo.

```bat
reg export "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\WMI\Autologger" "C:\ets-enable.reg"
>> "C:\ets-disable.reg" echo Windows Registry Editor Version 5.00
>> "C:\ets-disable.reg" echo.
>> "C:\ets-disable.reg" echo [-HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\WMI\Autologger]
```

## Optimize the File System

Open CMD & enter the commands below.

- Disables the creation of 8.3 character-length file names on FAT- & NTFS-formatted volumes

    ```bat
    fsutil behavior set disable8dot3 1
    ```

- Disable updates to the Last Access Time stamp on each directory when directories are listed on an NTFS volume

    ```bat
    fsutil behavior set disablelastaccess 1
    ```

- Enables delete notifications (also known as trim or unmap), should be enabled by default but here for safe measure

    ```bat
    fsutil behavior set disabledeletenotify 0
    ```

## Configure Control Panel

It is not a bad idea to skim through both the legacy and immersive control panel to ensure nothing is misconfigured.

## Message Signaled Interrupts

[Message signaled interrupts are faster than traditional line-based interrupts and may also resolve the issue of shared interrupts which are often the cause of high interrupt latency and stability](https://repo.zenk-security.com/Linux%20et%20systemes%20d.exploitations/Windows%20Internals%20Part%201_6th%20Edition.pdf).

- Open ``C:\prerequisites\MSIUtil.exe``

    - Enable Message Signaled Interrupts on all devices that support it

        - You will BSOD if you enable MSIs for the **stock** Windows 7 SATA driver which you should have updated as mentioned in the [Installing Drivers](#installing-drivers) section
        
    - Be careful as to what you choose to prioritize. As an example, you will likely stutter in a open-world game that utilizes texture streaming if the GPU IRQ priority is set higher than the storage controller priority. For this reason, you can set all devices to undefined/normal priority

- Restart your PC, you can verify if a device is utilizing MSIs by checking if it has a negative IRQ in MSIUtil

- Ensure that there is no IRQ sharing on your system by checking win + r, **msinfo32**, **Hardware Resources -> Conflicts/Sharing** section

## Interrupt Affinity

By default, CPU 0 handles the majority of DPCs and ISRs for several devices which can be viewed in a xperf dpcisr trace. This is not desirable as there will be a latency penalty because many processes and system activities are scheduled on the same core. We can use ``C:\prerequisites\Interrupt-Affinity-Tool.exe`` to set an interrupt affinity policy to the USB, GPU and NIC driver, which are few of many devices responsible for the most DPCs/ISRs, to offload them onto another core. They all require testing as you may do more harm than good if it is set to a weaker or equally as busy core. The device can be identified by cross-checking the **Location Info** with the **Location** in the **Properties -> General** section of a device in device manager. Restart your PC instead of the driver to avoid issues.

- Use [AutoGpuAffinity](https://github.com/amitxv/AutoGpuAffinity) to benchmark the GPU affinity

- Use [Mouse Tester](https://github.com/microe1/MouseTester) to compare polling variation between the USB controller on different cores

    - Ideally this should be done with some sort of realistic load such as a game running in the background as idle benchmarks are misleading but as we do not have any games installed yet, you can and benchmark this later

- Open CMD and enter the command below to configure what CPU handles DPCs/ISRs for the network driver. Ensure to change the driver key to suit your needs

    - Run ``C:\prerequisites\scripts\get-driver-keys.bat`` to get the driver keys on your system

        ```bat
        reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0000" /v "*RssBaseProcNumber" /t REG_SZ /d "2" /f
        ```

- You can ensure interrupt affinity policies have been configured correctly by analyzing a xperf trace while the device is busy

## Configuring Games and Applications

Install any programs and game launchers you commonly use to prepare us for the next steps.

- Consider [NVIDIA Reflex](https://www.nvidia.com/en-gb/geforce/news/reflex-low-latency-platform) if your game has support for it

- Cap your framerate at a multiple of your monitor refresh rate to prevent [frame mistiming](https://youtu.be/_73gFgNrYVQ). E.g possible framerate caps with a 144Hz monitor include 72, 144, 288, 432. Consider capping at your minimum fps threshold for increased smoothness and ensure the GPU is not maxed out as [lower GPU utilization reduces system latency](https://youtu.be/8ZRuFaFZh5M?t=859)

    - Capping your framerate with [RTSS](https://www.guru3d.com/files-details/rtss-rivatuner-statistics-server-download.html) instead of the in-game limiter will result in consistent frametimes and a smoother experience but at the cost of [noticeably higher latency](https://youtu.be/T2ENf9cigSk?t=377)

- Configure FSE and QoS

    - Microsoft has claimed FSO/independent flip has improved in later Windows versions which has also been verified by members in the community with [Reflex Latency Analyzer](https://www.nvidia.com/en-gb/geforce/news/reflex-latency-analyzer-360hz-g-sync-monitors). However, other users have claimed otherwise

    - Configuring a QoS Policy will allow Windows to prioritize packets of an application over other devices on your network and PC

        - Related: [research.md - How can you verify if a DSCP QoS policy is working?](research.md#how-can-you-verify-if-a-dscp-policy-is-working)

    - Run the ``C:\prerequisites\scripts\fse-qos-for-game-exes.bat`` script and follow the instructions in the console output

## Configure Default Programs

Configure default programs in **Settings -> Apps**.

## Cleanup

- Open ```C:\prerequisites\sysinternals\Autoruns.exe``` and remove any unwanted programs such as game launchers. Remove all obsolete entries with a yellow label, run with ``C:\prerequisites\nsudo\NSudo.exe`` if you encounter any permission errors

- Some locations you may want to review for leftover bloatware and unwanted shortcuts

    - ``"C:\"``
    - ``"C:\ProgramData\Microsoft\Windows\Start Menu\Programs"``
    - ``"C:\Program Files"``
    - ``"C:\ProgramData"``
    - ``"C:\Windows\Prefetch"``
    - ``"C:\Windows\SoftwareDistribution\download"``
    - ``"C:\Windows\Temp"``
    - ``"%userprofile%\AppData"``
    - ``"%userprofile%\AppData\Local\Temp"``
    - ``"%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs"``
    - ``"%userprofile%\Downloads"``

    OR

    - Open CMD and the command below to open all folders listed above at once

        ```bat
        for %a in ("C:\", "C:\ProgramData\Microsoft\Windows\Start Menu\Programs", "C:\Program Files", "C:\ProgramData", "C:\Windows\Prefetch", "C:\Windows\SoftwareDistribution\download", "C:\Windows\Temp", "%userprofile%\AppData", "%userprofile%\AppData\Local\Temp", "%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs", "%userprofile%\Downloads") do (explorer %a)
        ```

- Clear the PATH user environment variable of locations pointing to Windows bloatware folders

- Configure Disk Cleanup

    - Open CMD and enter the command below, tick all of the boxes, press **OK**

        ```bat
        cleanmgr /sageset:50
        ```
    - Run Disk Cleanup

        ```bat
        cleanmgr /sagerun:50
        ```

## Final Thoughts and Tips

- Avoid applying random tweaks, using tweaking programs or fall for the "fps boost" marketing nonsense. If you have a question about a specific option or setting, just ask

- Try to favor free and open source software. Stay away from proprietary software where you can and ensure to scan files with [VirusTotal](https://www.virustotal.com/gui/home/upload) before running them

- Consider removing your game off the GPU core by setting an affinity to the game process to prevent them being serviced on the same CPU as [this improves frametime stability](../media/isolate-gpu-core.png). Your mileage may vary but it is definitely something worth mentioning

- Kill processes that waste CPU cycles such as game clients and **explorer.exe**

    - Use **Ctrl + Shift + Esc** to open process explorer then use **File -> Run** to start the **explorer.exe** shell again

- If you are using Windows 8.1+ and [FSE/Hardware: Legacy Flip](https://github.com/GameTechDev/PresentMon#csv-columns) with your game, you *can* disable DWM using the scripts in ``C:\prerequisites\scripts\dwm-scripts`` as the process wastes CPU cycles despite there being no composition. Beware as elements of the UI will be broken and somes games/programs will not be able to launch (you may need to disable hardware acceleration)

- Carry out maintenance tasks yourself on a weekly basis. This includes:

    - Trimming your SSD

    - Using a [lint roller](https://www.ikea.com/gb/en/p/baestis-lint-roller-grey-90425626) to remove dirt and debris from the mousepad once in a while

    - Using a small [air dust blower](https://www.amazon.co.uk/s?k=air+dust+blower) to remove dirt and debris from the mouse sensor lens often

    - Removing dust from components often
