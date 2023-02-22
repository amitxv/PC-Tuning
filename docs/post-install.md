# Post-Install Instructions

## OOBE Setup

Do not connect to the internet until the [Merge the Registry Files](#merge-the-registry-files) section. Avoid using a password as the service list used will break user password functionality after the ``Services-Disable.bat`` script is run.

If you are configuring Windows 11, press ``Shift+F10`` to open CMD and execute the following command ``oobe\BypassNRO.cmd``. This will allow us to continue without an internet connection demonstrated in the video examples below.

- See [media/oobe-windows7-example.mp4](https://raw.githubusercontent.com/amitxv/PC-Tuning/main/media/oobe-windows7-example.mp4)

- See [media/oobe-windows8-example.mp4](https://raw.githubusercontent.com/amitxv/PC-Tuning/main/media/oobe-windows8-example.mp4)

- See [media/oobe-windows10+-example.mp4](https://raw.githubusercontent.com/amitxv/PC-Tuning/main/media/oobe-windows10+-example.mp4)

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

- See [media/visual-cleanup-windows7-example.mp4](https://raw.githubusercontent.com/amitxv/PC-Tuning/main/media/visual-cleanup-windows7-example.mp4)

- See [media/visual-cleanup-windows8-example.mp4](https://raw.githubusercontent.com/amitxv/PC-Tuning/main/media/visual-cleanup-windows8-example.mp4)

- See [media/visual-cleanup-windows10+-example.mp4](https://raw.githubusercontent.com/amitxv/PC-Tuning/main/media/visual-cleanup-windows10+-example.mp4)

## Miscellaneous

Open CMD as administrator and enter the command below. The commands are placed in a script instead of this document as it will be tedious to copy and paste each command at this stage.

```bat
C:\bin\scripts\miscellaneous.bat
```

- Disable Enhance pointer precision by typing ``main.cpl`` in ``Win+R``

- Disable all messages in ``System and Security -> Action Center -> Change Action Center settings -> Change Security and Maintenance settings`` by typing ``control`` in ``Win+R``

    - This section is named ``Security and Maintenance`` on Windows 10+

- Disable Scheduled optimization by typing ``dfrgui`` in ``Win+R`` More details on doing maintenance tasks ourselves in [Final Thoughts and Tips](#final-thoughts-and-tips)

- Configure the following by typing ``sysdm.cpl`` in ``Win+R``:

    - ``Advanced -> Performance -> Settings`` - configure ``Adjust for best performance`` and preferably disable the paging file for all drives to avoid unnecessary I/O

    - ``System Protection`` - disable and delete system restore points. It has been proven to be very unreliable

- Allow users full control of the ``C:\`` directory to resolve xperf etl processing

    - See [media/full-control-example.png](../media/full-control-example.png), continue and ignore errors

- Windows 10+ Only:

    - Disable the following by pressing ``Win+I``:

        - Everything in ``System -> Notifications and actions``

        - All permissions in ``Privacy`` Allow microphone access if desired

## Remove Bloatware Natively

- Open CMD as administrator and enter the command below to remove the chromium version of Microsoft Edge (if present) and OneDrive

    ```bat
    C:\bin\scripts\remove-edge-onedrive.bat
    ```

- Although nothing should appear, as a precautionary measure check and uninstall any bloatware that exists by typing ``appwiz.cpl`` in ``Win+R``

- Disable everything except for the following by typing ``OptionalFeatures`` in ``Win+R``:

    - See [media/windows7-features-example.png](../media/windows7-features-example.png)

    - See [media/windows8+-features-example.png](../media/windows8+-features-example.png)

- Windows 10+ Only:

    - Windows 10:

        - Uninstall bloatware in ``Apps -> Apps and Features`` by pressing ``Win+I``

        - In the ``Optional features`` section, uninstall everything apart from ``Microsoft Paint``, ``Notepad`` and ``WordPad`` if applicable (these do not exist in earlier Windows 10 versions)

    - Windows 11:

        - Uninstall bloatware in ``Apps -> Installed apps`` by pressing ``Win+I``

        - In the ``Apps -> Optional features`` section, uninstall everything apart from ``WMIC``, ``Notepad (system)`` and ``WordPad``

- Restart your PC once to apply the changes above (do not boot into Linux without a full restart beforehand)

## Removing Bloatware with Linux

As mentioned previously, the instructions below are specific to Linux Mint. If you are using another distro, interpret the steps below and follow along accordingly.

- Boot into Ventoy on your USB in BIOS and select the Linux ISO

- Open file explorer which is pinned to the taskbar and navigate to the volume Windows is installed on. You can identify this by finding the volume that has the ``win-debloat.sh`` script in

- Right-click an empty space and select ``Open in Terminal`` to open a terminal window in the current directory. Use the command below to run the script

    ```bash
    sudo bash win-debloat.sh
    ```

- Once finished, use the command below to reboot

    ```bash
    reboot
    ```

## Install [Visual C++ Redistributable Runtimes](https://github.com/abbodi1406/vcredist)

Run the package below to install the redistributables.

```txt
C:\bin\VisualCppRedist_AIO_x86_x64.exe
```

## Disable Residual Scheduled Tasks

Open CMD as administrator and enter the command below. To launch with administrator privileges, type ``cmd`` in ``Win+R`` then simultaneously press ``Ctrl+Shift+Enter``

```bat
C:\bin\python\python.exe C:\bin\scripts\disable-tasks.py
```

## Merge the Registry Files

Open CMD as administrator and enter the command below. Replace ``<winver>`` with the Windows version you are configuring (e.g. 7, 8, 10, 11).

```bat
C:\bin\python\python.exe C:\bin\scripts\apply-registry.py --winver <winver>
```

- Ensure that the program prints a "done" message to the console, if it has not then CMD was probably not opened with administrator privileges and the registry files were not successfully merged

- Restart your PC through ``Ctrl+Alt+Delete``. After and only after a restart, you can establish an internet connection as the Windows update policies will take effect

## [Spectre and Meltdown](https://www.grc.com/inspectre.htm)

Ensure Spectre and Meltdown protected is disabled with the program below. A minority of anticheats (FACEIT) require them to be enabled, so this step can be skipped. AMD is unaffected by Meltdown and apparently [performs better with Spectre enabled](https://www.phoronix.com/review/amd-zen4-spectrev2). Check the status after a reboot.

```txt
C:\bin\inspectre.exe
```

- See [media/meltdown-spectre-example.png](../media/meltdown-spectre-example.png)

## User Preference

Go through the ``C:\bin\preference`` folder to configure common user settings.

## Install Drivers

Avoid installing chipset drivers. I would recommend updating and installing NIC, USB, NVMe, SATA (required on Windows 7 as enabling MSI on the stock SATA driver will result in a BSOD). See the [Integrate and Obtain Drivers](/docs/building.md#integrate-and-obtain-drivers) section for details on finding drivers (download them on another operating system or PC). GPU drivers will be installed in the [Configure the Graphics Driver](#configure-the-graphics-driver) step later on.

Try to obtain the driver in its INF form so that it can be installed in device manager as executable installers usually install other bloatware along with the driver itself. Most of the time, you can extract the installer's executable with 7-Zip to obtain the driver.

## Install [.NET 4.8 Runtimes](https://dotnet.microsoft.com/en-us/download/dotnet-framework/net48)

Run the package below to install the runtimes.

```txt
C:\bin\ndp48-web.exe
```

## Configure a [Web Browser](https://privacytests.org)

A standard Firefox installation is recommended. I have created a script used to update/install the latest Firefox version. Open CMD and enter the command below.

```bat
C:\bin\python\python.exe C:\bin\scripts\install-firefox.py
```

- On Firefox, after configuring extensions, I usually customize/cleanup the interface further in ``Menu Settings -> More tools -> Customize toolbar`` then skim through ``about:preferences``. The [Arkenfox user.js](https://github.com/arkenfox/user.js) can also be imported, see the [wiki](https://github.com/arkenfox/user.js/wiki)

## Install Open-Shell (Windows 8+)

- Download and install [Open-Shell](https://github.com/Open-Shell/Open-Shell-Menu). Only install the ``Open-Shell Menu``

- Settings I personally use as per section:

    - Skin

        - Midnight

        - Show user picture - Disable

        - Transparency level - Opaque

    - Main Menu

        - Show recent or frequent programs - Don't show

        - Enable hybrid shutdown - Disable

    - General Behavior

        - Check for Windows updates on shutdown - Disable

- Windows 8 Only:

    - Open ``"C:\Program Files\Open-Shell\Start Menu Settings.lnk"``, enable ``Show all settings`` then navigate to the Windows 8 Settings section and set ``Disable active corners`` to ``All``

## Install 7-Zip

Download and install [7-Zip](https://www.7-zip.org). Open ``C:\Program Files\7-Zip\7zFM.exe`` then navigate ``Tools -> Options`` and associate 7-Zip with all file extensions by clicking the ``+`` button. You may need to click it twice to override existing associated extensions.

## Install DirectX Runtimes

Download and install the [DirectX runtimes](https://www.microsoft.com/en-us/download/details.aspx?id=35). Ensure to uncheck the Bing bar option.

## Install a Media Player

- [mpv](https://mpv.io) or [mpv.net](https://github.com/stax76/mpv.net)

- [mpc-hc](https://mpc-hc.org) ([alternative link](https://github.com/clsid2/mpc-hc))

- [VLC](https://www.videolan.org)

## Configure Power Options

Open CMD and enter the commands below.

- Set active power scheme to High performance

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

- Turn off display after - 0 minutes

    ```bat
    powercfg /setacvalueindex scheme_current 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0
    ```

- Set the active scheme as the current scheme

    ```bat
    powercfg /setactive scheme_current
    ```

## Configure the BCD Store

Open CMD and enter the commands below.

- Disable the boot manager timeout when dual booting (does not affect single boot times)

    ```bat
    bcdedit /timeout 0
    ```

- [Data Execution Prevention](https://docs.microsoft.com/en-us/windows/win32/memory/data-execution-prevention) is set to ``Turn on for essential Windows programs and services only`` by default. However, DEP can be completely disabled with the command below but a minority of anticheats require DEP to be left on the default setting. Do not change if unsure

    ```bat
    bcdedit /set nx AlwaysOff
    ```

- Configure the operating system name, I usually name it to whatever Windows version I am using e.g. Windows 10 1803

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

- To automatically load profile 1 (as an example) and exit,
type ``shell:startup`` in ``Win+R`` then create a shortcut with a target of ``"C:\Program Files (x86)\MSI Afterburner\MSIAfterburner.exe" /Profile1 /Q``

## Configure CRU

If you usually use [Custom Resolution Utility](https://www.monitortests.com/forum/Thread-Custom-Resolution-Utility-CRU) to configure display resolutions, download and extract it.

- See [How to set up Display Scaling, works with all games | KajzerD](https://www.youtube.com/watch?v=50itBs-sz1w)

- Use the exact timing for an integer refresh rate

- Try to delete every resolution and the other bloatware (audio blocks) apart from your native resolution, this may be a workaround for the 1-second black screen when alt-tabbing in FSE, feel free to skip this step if you are not comfortable risking a black screen

- Restart your PC instead of using ``restart64.exe`` as it may result in a black screen

- Ensure your resolution is configured properly in Display Adapter Settings

## Replace Task Manager with Process Explorer

This step is not optional as the performance counter driver will be disabled which breaks the stock Task Manager functionality.

<details>

<summary>Reasons not to use Task Manager</summary>

- It relies on a kernel mode driver to operate (additional overhead)

- Does not display process tree

- On Windows 8+, [Task Manager reports CPU utility in %](https://aaron-margosis.medium.com/task-managers-cpu-numbers-are-all-but-meaningless-2d165b421e43) which provides misleading CPU utilization details, on the other hand, Windows 7's Task Manager and Process Explorer report time-based busy utilization. This also explains why the disable idle power setting results in 100% CPU utilization on Windows 8+

</details>

- Download and extract [Process Explorer](https://learn.microsoft.com/en-us/sysinternals/downloads/process-explorer)

- Copy ``procexp64.exe`` into ``C:\Windows`` and open it

- Navigate to ``Options`` and select ``Replace Task Manager`` I also configure the following:

    - Confirm Kill

    - Allow Only One Instance

    - Always On Top (helpful for when applications crash and UI becomes unresponsive)

## Disable Process Mitigations (Windows 10 1709+)

Open CMD and enter the command below to disable [process mitigations](https://docs.microsoft.com/en-us/powershell/module/processmitigations/set-processmitigation?view=windowsserver2019-ps). Effects can be viewed with ``Get-ProcessMitigation -System`` in PowerShell.

```bat
C:\bin\scripts\disable-process-mitigations.bat
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

Microsoft fixed the standby list memory management issues in a later version of Windows, but some modern games still have memory leaks. Memory Cleaner ([official reference](https://github.com/danskee/MemoryCleaner), [source code](https://git.zusier.xyz/Zusier/MemoryCleaner), [download](https://www.majorgeeks.com/files/details/memory_cleaner_danskee.html)) also allows us to raise the clock interrupt frequency on a global level. However, the behavior of processes that are affected significantly changed in Windows 10 2004+ in a way that potentially breaks real-time applications as explained in [this article](https://randomascii.wordpress.com/2020/10/04/windows-timer-resolution-the-great-rule-change) rendering this *trick* obsolete. The old implementation can be mimicked in Windows 11+ and Windows 10 Server (not applicable to client editions) with a registry entry.

- Memory Cleaner can be started by default by typing ``shell:startup`` in ``Win+R`` and placing the binary in the opened folder

- Navigate to ``File -> Settings`` and configure the following:

    - The hotkey to clean the standby list and working set

    - Desired timer-resolution - 10000 (1ms) recommended

    - Enable timer - Disable

    - Start minimized - Enable

    - Start timer resolution automatically - Enable

- Avoid using auto cleaning apps like ISLC/MemReduct, they consume a lot of resources due to a frequent polling timer interval and cause stuttering due to autocleaning memory

## Configure the Network Adapter

- Open ``Network and Sharing Center -> Change adapter settings`` by typing ``control`` in ``Win+R``

- Disable any unused network adapters then right-click your main one and select properties

- Disable all items except ``QoS Packet Scheduler`` and ``Internet Protocol Version 4 (TCP/IPv4)``

- [Configure a Static IP address](https://www.youtube.com/watch?t=36&v=5iRp1Nug0PU). This is required as we will be disabling the network services that waste resources

- Disable ``NetBIOS over TCP/IP`` in ``General -> Advanced -> WINS`` to [prevent unnecessary system listening](https://github.com/djdallmann/GamingPCSetup/blob/master/CONTENT/DOCS/NETWORK/README.md)

## Configure Audio Devices

- The sound control panel can be opened by typing ``mmsys.cpl`` in ``Win+R``

- Disable unused Playback and Recording devices

- Disable audio enhancements as they waste resources

    - See [media/audio enhancements-benchmark.png](../media/audio%20enhancements-benchmark.png)

- Disable Exclusive Mode in the Advanced section

- Set the option in the communications tab to Do nothing

- I also like to set the sound scheme to no sounds in the sounds tab

- Consider using [REAL](https://github.com/miniant-git/REAL) or [LowAudioLatency](https://github.com/spddl/LowAudioLatency) to minimize the size of the audio buffer. Beware of audio dropouts due to CPU not being able to keep up under load

    - Be warned regarding CPU 0 being reserved/underutilized with the usage of the mentioned programs

## Configure Services and Drivers

I am not responsible if anything goes wrong or you BSOD. The idea is to disable services while gaming and use default services for everything else. Feel free to customize the lists by editing ``C:\bin\bare-services.ini`` in a text editor. There are several comments in the config file you can read to check if you need a given service. As an example, a user with Ethernet does not need the Wi-Fi services enabled.

- On 1607 and 1703, delete the ``ErrorControl`` registry key in ``HKLM\SYSTEM\CurrentControlSet\Services\Schedule`` to prevent an unresponsive explorer shell after disabling the task scheduler service

- Download and extract the latest [service-list-builder](https://github.com/amitxv/service-list-builder/releases) release. Open CMD and CD to the extracted folder where the executable is located

- Use the command below to build the scripts in the ``build`` folder. NSudo is required to run the batch scripts

    ```bat
    service-list-builder.exe --config C:\bin\bare-services.ini
    ```

- Move the batch scripts and ``NSudo.exe`` somewhere safe such as in the ``C:\`` drive and do not share it with other people as it is specific to your system

- To prepare us for the next steps, run ``Services-Disable.bat`` with NSudo, ensure ``Enable All Privileges`` is enabled as mentioned

## Configure Device Manager

Many devices in device manager will appear with a yellow icon as we ran the script to disable services, **DO NOT** disable any device with a yellow icon as this will completely defeat the purpose of building toggle scripts. My method for configuring services and device manager will ensure maximum compatibility while services are enabled.

- Open device manager by typing ``devmgmt.msc`` in ``Win+R`` then navigate to ``View -> Devices by connection``

    - Disable any PCI, SATA, NVMe and USB controllers with nothing connected to them

    - Unnecessary HID devices can be disabled, but mouse software will not work

        - See [media/hid-devices-example.png](/media/hid-devices-example.png)

    - Disable write-cache buffer flushing on all drives in the ``Properties -> Policies`` section

    - Navigate to your ``Network adapter -> Properties -> Advanced``, disable any power saving and wake features

        - Related: [research.md - How many RSS Queues do you need?](research.md#how-many-rss-queues-do-you-need)

    - Disable ``High Definition Audio Controller`` and the USB controller on the same PCI port as your GPU

- Navigate to ``View -> Resources by connection``

    - Disable any unneeded devices that are using an IRQ or I/O resources, always ask if unsure, take your time on this step. Windows should not allow you to disable any required devices but ensure you do not accidentally disable another important device such as your main USB controller or similar. Once again, **DO NOT** disable any device with a yellow icon

        - If there are multiple of the same devices, and you are unsure which one is in use, refer back to the tree structure in ``View -> Devices by connection``. Remember that a single device can use many resources. You can also use [MSI Utility](https://forums.guru3d.com/threads/windows-line-based-vs-message-signaled-based-interrupts-msi-tool.378044) to check for duplicate, unneeded devices in case you accidentally miss any with the confusing device manager tree structure

- To prepare us for the next steps, run ``Services-Enable.bat`` with NSudo, ensure ``Enable All Privileges`` is enabled as mentioned

- Download and extract [DeviceCleanup](https://www.uwe-sieber.de/files/DeviceCleanup.zip)

- Open the program, select all devices and press the delete key to clean-up hidden devices

## Disable Driver Power Saving

Open CMD and enter the commands below to disable power saving on various devices in device manager and registry entries present in modern drivers.

```bat
C:\bin\scripts\disable-pnp-powersaving.ps1
```

```bat
C:\bin\scripts\disable-driver-powersaving.bat
```

## Configure Event Trace Sessions

Create registry files to toggle event trace sessions. Programs that rely on event tracers such will not be able to log data until the required sessions are restored which is the purpose of creating two registry files to toggle between them (identical concept to the service scripts). Open CMD and enter the commands below to build the registry files in the ``C:\`` directory. As with the services scripts these registry files must be run with NSudo. The sessions can be viewed by typing ``perfmon`` in ``Win+R`` then navigating to ``Data Collector Sets -> Event Trace Sessions``.

- ets-enable

    ```bat
    reg export "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\WMI\Autologger" "C:\ets-enable.reg"
    ```

- ets-disable

    ```bat
    >> "C:\ets-disable.reg" echo Windows Registry Editor Version 5.00
    >> "C:\ets-disable.reg" echo.
    >> "C:\ets-disable.reg" echo [-HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\WMI\Autologger]
    ```

## Optimize the File System

Open CMD and enter the commands below.

- Disables the creation of 8.3 character-length file names on FAT- and NTFS-formatted volumes

    ```bat
    fsutil behavior set disable8dot3 1
    ```

- Disable updates to the Last Access Time stamp on each directory when directories are listed on an NTFS volume

    ```bat
    fsutil behavior set disablelastaccess 1
    ```

- Enables delete notifications (also known as trim or unmap), should be enabled by default, but it is here for safe measure

    ```bat
    fsutil behavior set disabledeletenotify 0
    ```

## Configure Control Panel

It is not a bad idea to skim through both the legacy and immersive control panel to ensure nothing is misconfigured.

## Message Signaled Interrupts

[Message signaled interrupts are faster than traditional line-based interrupts and may also resolve the issue of shared interrupts which are often the cause of high interrupt latency and stability](https://repo.zenk-security.com/Linux%20et%20systemes%20d.exploitations/Windows%20Internals%20Part%201_6th%20Edition.pdf).

- Download and open [MSI Utility](https://forums.guru3d.com/threads/windows-line-based-vs-message-signaled-based-interrupts-msi-tool.378044) or [GoInterruptPolicy](https://github.com/spddl/GoInterruptPolicy)

    - Enable Message Signaled Interrupts on all devices that support it

        - You will BSOD if you enable MSIs for the stock Windows 7 SATA driver which you should have already updated as mentioned in the [Install Drivers](#install-drivers) section

    - Be careful as to what you choose to prioritize. As an example, you will likely stutter in an open-world game that utilizes texture streaming if the GPU IRQ priority is set higher than the storage controller priority. For this reason, you can set all devices to undefined/normal priority

- Restart your PC, you can verify if a device is utilizing MSIs by checking if it has a negative IRQ in MSI Utility

- Although this carried out in the [Physical Setup](/docs/physical-setup.md) section, confirm that there is no IRQ sharing on your system by typing ``msinfo32`` in ``Win+R`` then navigating to the ``Conflicts/Sharing`` section

## Interrupt Affinity

By default, CPU 0 handles the majority of DPCs and ISRs for several devices which can be viewed in a xperf dpcisr trace. This is not desirable as there will be a latency penalty because many processes and system activities are scheduled on the same core competing for CPU time. We can set an interrupt affinity policy to the USB, GPU and NIC driver, which are few of many devices responsible for the most DPCs/ISRs, to offload them onto another core. The device can be identified by cross-checking the ``Location Info`` with the ``Location`` in the ``Properties -> General`` section of a device in device manager. Restart your PC instead of the driver to avoid issues.

- Use [Microsoft Interrupt Affinity Tool](https://www.techpowerup.com/download/microsoft-interrupt-affinity-tool) or [GoInterruptPolicy](https://github.com/spddl/GoInterruptPolicy) to configure driver affinities

- You can ensure interrupt affinity policies have been configured correctly by analyzing a xperf trace while the device is busy

- Use [AutoGpuAffinity](https://github.com/amitxv/AutoGpuAffinity) to benchmark the GPU affinity

- Use [Mouse Tester](https://github.com/microe1/MouseTester) to compare polling variation between the USB controller on different cores

    - Use the ``Interval vs Time`` graph (frequency = 1000 / interval)

    - Ideally this should be benchmarked during realistic load such as a game running in the background as idle benchmarks are misleading but as we do not have any games installed yet, you can and benchmark this later

- Open CMD and enter the command below to configure what CPU handles DPCs/ISRs for the network driver. Ensure to change the driver key to suit your needs. Keep in mind that RSS queues determine the amount of consecutive cores ndis.sys is processed on. For example, ndis.sys will be processed on CPU 2/3/4/5 if RssBaseProcNumber is set to 2 with 4 RSS queues configured. In some cases, ndis.sys will not budge from being processed on CPU 0 which is why it is important to verify the expected behavior in a DPC/ISR trace

    - Run ``C:\bin\scripts\query-driver-key.bat Win32_NetworkAdapter`` in CMD to get the NIC driver keys on your system

        ```bat
        reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0000" /v "*RssBaseProcNumber" /t REG_SZ /d "2" /f
        ```

## Configuring Games and Applications

Install any programs and game launchers you commonly use to prepare us for the next steps.

- Consider [NVIDIA Reflex](https://www.nvidia.com/en-us/geforce/news/reflex-low-latency-platform) if your game has support for it

- Cap your frame rate at a multiple of your monitor refresh rate to prevent [frame mistiming](https://www.youtube.com/watch?v=_73gFgNrYVQ). E.g. possible frame rate caps with a 144Hz monitor include 72, 144, 288, 432. Consider capping at your minimum fps threshold for increased smoothness and ensure the GPU is not maxed out as [lower GPU utilization reduces system latency](https://www.youtube.com/watch?v=8ZRuFaFZh5M&t=859s)

    - Capping your frame rate with [RTSS](https://www.guru3d.com/files-details/rtss-rivatuner-statistics-server-download.html) instead of the in-game limiter will result in consistent frame pacing and a smoother experience but at the cost of [noticeably higher latency](https://www.youtube.com/watch?t=377&v=T2ENf9cigSk) but disabling ``passive waiting`` in the settings page marginally helps with that. Disabling the ``Enable dedicated encoder server service`` setting also prevents ``EncoderServer.exe`` running which wastes resources

- Configure FSE and QoS

    - Microsoft has claimed FSO/independent flip has improved in later Windows versions which has also been verified by members in the community with [Reflex Latency Analyzer](https://www.nvidia.com/en-us/geforce/news/reflex-latency-analyzer-360hz-g-sync-monitors). However, other users have claimed otherwise.

    - Always check if the game is using the desired presentmode with PresentMon. ``Hardware: Legacy Flip`` and ``Hardware: Independent Flip`` are optimal.

        - If you are having trouble with using legacy flip, try to run the command below in CMD and reboot

            ```bat
            reg.exe add "HKEY_CURRENT_USER\System\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatible " /t REG_DWORD /d "1" /f
            ```

        - If you are stuck with ``Hardware Composed: Independent Flip``, try to run the command below in CMD and reboot

            ```bat
            reg.exe add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Dwm" /v "OverlayTestMode" /t REG_DWORD /d "5" /f
            ```

    - Configuring a QoS Policy will allow Windows to prioritize packets of an application over other devices on your network and PC

        - Related: [research.md - How can you verify if a DSCP QoS policy is working?](research.md#how-can-you-verify-if-a-dscp-policy-is-working)

    - Run the ``C:\bin\scripts\fse-qos-for-game-exes.bat`` script and follow the instructions in the console output

## Configure Default Programs

Configure default programs in ``Apps`` by pressing ``Win+I``.

## Cleanup

- Download and extract [Autoruns](https://learn.microsoft.com/en-us/sysinternals/downloads/autoruns) then remove any unwanted programs such as game launchers. Remove all obsolete entries with a yellow label and run with ``C:\bin\NSudo.exe`` if you encounter any permission errors

- Some locations you may want to review for leftover bloatware and unwanted shortcuts

    - ``"C:\"``

    - ``"C:\Windows\Prefetch"``

    - ``"C:\Windows\SoftwareDistribution\download"``

    - ``"C:\Windows\Temp"``

    - ``"%userprofile%\AppData\Local\Temp"``

    - ``"%userprofile%\Downloads"``

- Clear the PATH user environment variable of locations pointing to Windows bloatware folders

- Configure Disk Cleanup

    - Open CMD and enter the command below, tick all the boxes, press ``OK``

        ```bat
        cleanmgr /sageset:50
        ```

    - Run Disk Cleanup

        ```bat
        cleanmgr /sagerun:50
        ```

- Reset Firewall rules

    - Open CMD and enter the commands below

        ```bat
        reg.exe delete "HKLM\System\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /f
        reg.exe add "HKLM\System\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /f
        ```

## Final Thoughts and Tips

- Avoid applying random tweaks, using tweaking programs or fall for the "fps boost" marketing nonsense. If you have a question about a specific option or setting, just ask

- Try to favor free and open source software. Stay away from proprietary software where you can and ensure to scan files with [VirusTotal](https://www.virustotal.com/gui/home/upload) before running them

- Consider removing your game off the GPU core by setting an affinity to the game process to prevent them being serviced on the same CPU as [this improves frame pacing](../media/isolate-gpu-core.png). Your mileage may vary, but it is definitely something worth mentioning

- Favor tools such as [Bulk-Crap-Uninstaller](https://github.com/Klocman/Bulk-Crap-Uninstaller) to uninstall programs as the regular control panel does not remove residual files  

- Kill processes that waste resources such as game clients and ``explorer.exe``

    - Use ``Ctrl+Shift+Esc`` to open process explorer then use ``File -> Run`` to start the ``explorer.exe`` shell again

- Consider using the scripts in ``C:\bin\scripts\idle-scripts`` (place on desktop for easy access) to disable idle and force C-State 0 before launching a game and enable idle after you close your game. This will mitigate jitter due to the process of state transition. Beware of higher temperatures and power consumption. The CPU temperature should not increase to the point of thermal throttling because you should have already dealt with that in [docs/physical-setup.md](/docs/physical-setup.md)

- If you are using Windows 8.1+ and [FSE/Hardware: Legacy Flip](https://github.com/GameTechDev/PresentMon#csv-columns) with your game, you *can* disable DWM using the scripts in ``C:\bin\scripts\dwm-scripts`` as the process wastes resources despite there being no composition. Beware of the UI breaking and some games/programs will not be able to launch (you may need to disable hardware acceleration)

- Carry out maintenance tasks yourself on a weekly basis. This includes:

    - Trimming your SSD

    - Using a [lint roller](https://www.ikea.com/us/en/p/baestis-lint-roller-gray-90425626) to remove dirt and debris from the mouse pad

    - Using a small [air dust blower](https://www.amazon.com/s?k=air+dust+blower) to remove dirt and debris from the mouse sensor lens

    - Removing dust from components often
