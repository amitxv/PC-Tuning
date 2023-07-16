# Post-Install Instructions

## OOBE Setup

- Windows Server will force you to enter a complex password which we will remove in a few steps later

- See [media/oobe-windows7-example.mp4](https://raw.githubusercontent.com/amitxv/PC-Tuning/main/media/oobe-windows7-example.mp4)

- See [media/oobe-windows8-example.mp4](https://raw.githubusercontent.com/amitxv/PC-Tuning/main/media/oobe-windows8-example.mp4)

- See [media/oobe-windows10+-example.mp4](https://raw.githubusercontent.com/amitxv/PC-Tuning/main/media/oobe-windows10+-example.mp4)

## Visual Cleanup

Disable features on the taskbar, unpin shortcuts and tiles from the taskbar and start menu.

- See [media/visual-cleanup-windows7-example.mp4](https://raw.githubusercontent.com/amitxv/PC-Tuning/main/media/visual-cleanup-windows7-example.mp4)

- See [media/visual-cleanup-windows8-example.mp4](https://raw.githubusercontent.com/amitxv/PC-Tuning/main/media/visual-cleanup-windows8-example.mp4)

- See [media/visual-cleanup-windows10+-example.mp4](https://raw.githubusercontent.com/amitxv/PC-Tuning/main/media/visual-cleanup-windows10+-example.mp4)

## Disable Tamper Protection (Windows 10 1909+)

Disable Tamper protection through Windows Defender then restart your PC. This step is a prerequisite of the [Merge the Registry Files](#merge-the-registry-files) step to circumvent permission errors.

## Unrestricted PowerShell Execution Policy

This is required to execute the scripts within the repository. Open PowerShell as administrator and enter the command below.

```powershell
Set-ExecutionPolicy Unrestricted
```

## Merge the Registry Files

<details>
<br>
<summary>What do the registry files do and modify?</summary>

|Modification|Justification|
|---|---|
|Disable Retrieval of Online Tips and Help In The Immersive Control Panel|Telemetry|
|Disable Sticky Keys|Intrusive|
|Disable Search The Web or Display Web Results In Search|Telemetry|
|Disable Transparency|[Wastes resources](/media/transparency-effects-benchmark.png)|
|Disable Corner Navigation|Intrusive|
|Prevent Windows Marking File Attachments With Information About Their Zone of Origin|Intrusive|
|Disable Windows Defender|Security and performance are generally mutually exclusive|
|Disable Windows Update|Telemetry, intrusive and installs unwanted security updates along with potentially vulnerable drivers. Security and performance are generally mutually exclusive|
|Disable Customer Experience Improvement Program|Telemetry|
|Disable Automatic Maintenance|Intrusive|
|Remove 3D Objects from Explorer Pane|Intrusive|
|Disable UAC|Eliminates intrusive UAC prompt but reduces security as all processes are run with Administrator privileges by default|
|Disable Fast Startup|Interferes with shutting down and is required for making changes to the file system offline within the Linux debloating steps|
|Disable Sign-In and Lock Last Interactive User After a Restart|Intrusive|
|Disable Suggestions In The Search Box and In Search Home|Telemetry and intrusive|
|Disable Powershell Telemetry|Telemetry|
|Restore Old Context Menu|Intrusive|
|Disable Fault Tolerant Heap|Prevents Windows autonomously applying mitigations to prevent future crashes on a per-application basis|
|Disable GameBarPresenceWriter|Runs constantly and wastes resources despite disabling Game Bar|
|Disable Language Bar|Accidentally opens on occasions which is intrusive for most people|
|Disable Telemetry|Telemetry|
|Disable Notifications Network Usage|Polls constantly and wastes resources|
|Reserve 10% of CPU Resources for Low-Priority Tasks Instead of The Default 20%|On an optimized system with few background tasks, it is desirable to allocate most of the CPU time to the foreground process|
|Disable Your *PC Is Out of Support* Message|Intrusive|
|Disable Search Indexing|Runs constantly and wastes resources|
|Enable The Legacy Photo Viewer|Alternative option for viewing photos as the Windows Photos app is removed in the Appx removal step|
|Disable Hibernation|Eliminates the need for a hibernation file. It is recommended to shut down instead|
|Disable Remote Assistance|Security risk|
|Allocate Processor Resources Primarily To Programs|On client editions of Windows, this has no effect but is changed to ensure consistency between all editions including Windows Server|
|Disable Program Compatibility Assistant|Prevent Windows applying changes anonymously after running troubleshooters|
|Disable Pointer Acceleration|Ensures one-to-one mouse response for games that do not subscribe to raw input events|
|Disable Windows Error Reporting|Telemetry|
|Disable Typing Insights|Telemetry|

Changes made with ``-ui_cleanup``:

- Launch File Explorer To This PC
- Turn Off Display of Recent Search Entries In the File Explorer Search Box
- Remove Pin To Quick Access In Context Menu
- Disable Recent Items and Frequent Places In File Explorer and Quick Access
- Hide Recent Folders In Quick Access
- Clear History of Recently Opened Documents On Exit
- Hide Quick Access from File Explorer
- Hide Frequent Folders In Quick Access

</details>

Open PowerShell as administrator and enter the command below. Replace ``<option>`` with the Windows version you are configuring such as ``7``, ``8``, ``10`` or ``11``.

Append the ``-ui_cleanup`` argument to clean up the interface further.

```powershell
C:\bin\scripts\apply-registry.ps1 -winver <option>
```

- Ensure that the script prints a "successfully applied" message to the console, if it has not then PowerShell was probably not opened with administrator privileges and the registry files were not successfully merged

- After and only after a restart, you can establish an internet connection as the Windows update policies will take effect

## Install Drivers

- GPU drivers will be installed in a later step so do not install them at this stage

- You can find drivers by searching for drivers that are compatible with your device HWID. See [media/device-hwid-example.png](/media/device-hwid-example.png) in regard to finding your HWID in Device Manager for a given device

- Try to obtain the driver in its INF form so that it can be installed in Device Manager as executable installers usually install other bloatware along with the driver itself. Most of the time, you can extract the installer's executable with 7-Zip to obtain the driver

- It is recommended to update and install the following:

    - NIC

        - If you do not have internet access at this stage, you will need to download your NIC drivers from another device or dual boot as they may not be packaged at all in some versions of Windows

    - [USB](https://winraid.level1techs.com/t/usb-3-0-3-1-drivers-original-and-modded/30871) and [NVMe](https://winraid.level1techs.com/t/recommended-ahci-raid-and-nvme-drivers/28310) (both should already be installed if configuring Windows 7)

        - See [Microsoft USB driver latency penalty](/docs/research.md#microsoft-usb-driver-latency-penalty)

    - [SATA](https://winraid.level1techs.com/t/recommended-ahci-raid-and-nvme-drivers/28310) (required on Windows 7 as enabling MSI on the stock SATA driver will result in a BSOD)

## Time, Language and Region

- Configure settings by typing ``intl.cpl`` and ``timedate.cpl`` in ``Win+R``

- Windows 10+ Only

    - Configure settings in ``Time & Language`` by pressing ``Win+I``

## Activate Windows

Use the commands below to activate Windows using your license key if you do not have one linked to your HWID. Ensure that the activation process was successful by verifying the activation status in computer properties. Open CMD as administrator and enter the commands below.

```bat
slmgr /ipk <license key>
```

```bat
slmgr /ato
```

## Configure a [Web Browser](https://privacytests.org)

A standard Firefox installation is recommended. Open PowerShell and enter the command below. If you are having problems with the hash check, append ``-skip-hash-check`` to the end of the command.

```powershell
C:\bin\scripts\install-firefox.ps1
```

- Install [language dictionaries](https://addons.mozilla.org/en-GB/firefox/language-tools) for spell-checking

- Optionally configure and cleanup the interface further in ``Menu Settings -> More tools -> Customize toolbar`` then skim through ``about:preferences``. The [Arkenfox user.js](https://github.com/arkenfox/user.js) can also be imported, see the [wiki](https://github.com/arkenfox/user.js/wiki)

## Disable Residual Scheduled Tasks

Open PowerShell and enter the command below. Ignore any errors.

```powershell
C:\bin\scripts\disable-scheduled-tasks.ps1
```

## Miscellaneous

- Open CMD and enter the commands below

    - Set the maximum password age to never expire

        ```bat
        net accounts /maxpwage:unlimited
        ```

    - Clean the WinSxS folder

        ```bat
        DISM /Online /Cleanup-Image /StartComponentCleanup /ResetBase
        ```

    - Disable reserved storage (Windows 10 1903+)

        ```bat
        DISM /Online /Set-ReservedStorageState /State:Disabled
        ```

- Disable all messages in ``Change Security and Maintenance settings`` by typing ``wscui.cpl`` in ``Win+R``

- Configure the following by typing ``sysdm.cpl`` in ``Win+R``:

    - ``Advanced -> Performance -> Settings`` - configure ``Adjust for best performance`` and preferably disable the paging file for all drives to avoid unnecessary I/O

    - ``System Protection`` - disable and delete system restore points. It has been proven to be very unreliable

- Allow users full control of the ``C:\`` directory to resolve xperf ETL processing

    - See [media/full-control-example.png](/media/full-control-example.png), continue and ignore errors

- If an HDD isn't present in the system then Superfetch/Prefetch can be disabled with the command below

    ```bat
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\SysMain" /v "Start" /t REG_DWORD /d "4" /f
    ```

- Windows 8+ Only:

    - Disable the following by pressing ``Win+I``:

        - Everything in ``System -> Notifications and actions``

        - All permissions in ``Privacy``. Allow microphone access if desired

- Windows Server+ Only:

    - In Server Manager, navigate to ``Manage -> Server Manager Properties`` and enable the option to prevent Server Manager from starting automatically

    - Set the ``Windows Audio`` and ``Windows Audio Endpoint Builder`` services startup type to automatic by typing ``services.msc`` in ``Win+R``

    - Navigate to ``Computer Configuration -> Windows Settings -> Security Settings -> Account Policies -> Password Policy`` by typing ``gpedit.msc`` in ``Win+R`` and disable ``Password must meet complexity requirements``

        - Open CMD and type ``gpupdate /force`` to apply the changes immediately

    - Navigate to ``Computer Configuration -> Administrative Templates -> System`` by typing ``gpedit.msc`` in ``Win+R`` and disable ``Display Shutdown Event Tracker`` to disable the shutdown prompt

    - To remove the user password, enter your current password and leave the new/confirm password fields blank in ``User Accounts`` by typing ``control userpasswords`` in ``Win+R``

## Disable Features

Disable everything except for the following by typing ``OptionalFeatures`` in ``Win+R``. On Windows Server, this can be accessed via the Server Manager dashboard by navigating to ``Manage -> Remove Roles and Features``.

- See [media/windows7-features-example.png](/media/windows7-features-example.png)

- See [media/windows8+-features-example.png](/media/windows8+-features-example.png)

- See [media/windows-server-features-example.png](/media/windows-server-features-example.png)

    - To enable Wi-Fi, navigate to ``Manage -> Add Roles and Features`` and enable ``Wireless LAN Service``

## Remove Chromium Microsoft Edge and OneDrive

Open CMD and enter the commands below. The legacy version of Microsoft Edge will be removed in a later step if it is present.

- Microsoft Edge

    ```bat
    if exist "C:\Program Files (x86)\Microsoft\Edge\Application" (for /f "delims=" %a in ('where /r "C:\Program Files (x86)\Microsoft\Edge\Application" *setup.exe*') do ("%a" --uninstall --system-level --verbose-logging --force-uninstall))
    ```

- OneDrive

    ```bat
    for %a in ("SysWOW64" "System32") do (if exist "%windir%\%~a\OneDriveSetup.exe" ("%windir%\%~a\OneDriveSetup.exe" /uninstall)) && reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f > nul 2>&1
    ```

## Remove Bloatware Natively

- Open PowerShell and enter the command below to remove all Appx packages (Windows 8+)

    ```powershell
    Get-AppxPackage | Remove-AppxPackage -ErrorAction SilentlyContinue
    ```

- Uninstall any bloatware that exists by typing ``appwiz.cpl`` in ``Win+R``

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

- Open the File Explorer which is pinned to the taskbar and navigate to the volume Windows is installed on. You can identify this by finding the volume where the ``win-debloat.sh`` is located

- Right-click an empty space and select ``Open in Terminal`` to open a terminal window in the current directory. Use the command below to run the script

    ```bash
    sudo bash win-debloat.sh
    ```

- Once finished, use the command below to reboot

    ```bash
    reboot
    ```

- You can use Task Manager to check for residual bloatware that is running in the background and possibly create an issue on the repository to let me know that it should be removed

## Install 7-Zip

Download and install [7-Zip](https://www.7-zip.org). Open ``C:\Program Files\7-Zip\7zFM.exe`` then navigate ``Tools -> Options`` and associate 7-Zip with all file extensions by clicking the ``+`` button. You may need to click it twice to override existing associated extensions.

## Install Runtimes

These are runtimes that are dependencies of applications worldwide.

- [Visual C++ Redistributable](https://github.com/abbodi1406/vcredist)

- [.NET 4.8](https://dotnet.microsoft.com/en-us/download/dotnet-framework/net48) (ships with Windows 10 1909+)

- [WebView](https://developer.microsoft.com/en-us/microsoft-edge/webview2)

- [DirectX](https://www.microsoft.com/en-gb/download/details.aspx?id=8109)

## Configure the Graphics Driver

- See [docs/configure-nvidia.md](/docs/configure-nvidia.md)

- See [docs/configure-amd.md](/docs/configure-amd.md)

## Configure MSI Afterburner

If you use [MSI Afterburner](https://www.msi.com/Landing/afterburner/graphics-cards), download and install it.

- Set ``Check for available product updates`` to ``never`` in ``Settings -> General``

- It is recommended to configure a static fan speed as using the fan curve feature requires the program to run continually

- To automatically load profile 1 (as an example) and exit, type ``shell:startup`` in ``Win+R`` then create a shortcut with a target of ``"C:\Program Files (x86)\MSI Afterburner\MSIAfterburner.exe" /Profile1 /Q``

## Display Resolutions and Scaling Modes

You may have already found a stable overclock for your display in the [Physical Setup](/docs/physical-setup.md) section which you can configure in this section.

- Typically, you have the option of performing scaling on the GPU or display. Native resolution does not require scaling thus results in the identity scaling mode being used. Furthermore, identity scaling renders most of the scaling options in the GPU control panel obsolete. If you are using a non-native resolution, there is an argument for favoring display scaling due to less GPU processing

- Aim for a ``actual`` integer refresh rate such as 60.00/240.00 not 59.94/239.76. Using the exact timing can help achieve this in [Custom Resolution Utility](https://www.monitortests.com/forum/Thread-Custom-Resolution-Utility-CRU)

- There are many ways to achieve the same outcome regarding GPU and display scaling. See the table in the link below for example scenarios

    - See [What is identity scaling and how can you use it?](/docs/research.md#what-is-identity-scaling-and-how-can-you-use-it)

    - Optionally use [QueryDisplayScaling](https://github.com/amitxv/QueryDisplayScaling) to query the current scaling mode

- Try to delete every resolution and the other bloatware (audio blocks) apart from your native resolution in CRU. This may be a workaround for the ~1-second black screen when alt-tabbing while using the ``Hardware: Legacy Flip`` present mode

    - On systems with an NVIDIA GPU, ensure that the ``Display`` option for the ``Perform scaling on`` setting is still available. If it is not, then find out what change you made in CRU results in it not being accessible through trial and error. This can be accomplished by running ``reset.exe`` to reset the settings to default then re-configure CRU. After each change, run ``restart64.exe`` then check whether the option is still available

- Ensure your resolution is configured properly by typing ``rundll32.exe display.dll,ShowAdapterSettings`` in ``Win+R``

- On systems with an NVIDIA GPU, you can enable the ``override the scaling mode set by games and programs`` for consistent scaling behavior across applications and desktops

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

## Spectre, Meltdown and CPU Microcode

- Disable Spectre and Meltdown with [InSpectre](https://www.grc.com/inspectre.htm)

    - AMD is unaffected by Meltdown and apparently [performs better with Spectre enabled](https://www.phoronix.com/review/amd-zen4-spectrev2)

    - A minority of anti-cheats (FACEIT) require Meltdown to be enabled

- Open CMD with ``C:\bin\NSudo.exe`` and enter the commands below to remove the CPU microcode updates

    ```bat
    del /f /q C:\Windows\System32\mcupdate_GenuineIntel.dll
    ```

    ```bat
    del /f /q C:\Windows\System32\mcupdate_AuthenticAMD.dll
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

- [Data Execution Prevention](https://docs.microsoft.com/en-us/windows/win32/memory/data-execution-prevention) is set to ``Turn on for essential Windows programs and services only`` by default. However, DEP can be completely disabled with the command below but a minority of anti-cheats require DEP to be left on the default setting. Do not change if unsure

    ```bat
    bcdedit /set nx AlwaysOff
    ```

- Configure the operating system name, I usually name it to whatever Windows version I'm using such as ``Windows 10 1803``

    ```bat
    bcdedit /set {current} description "OS_NAME"
    ```

- Windows 8+ Only

    - A [tickless kernel](https://en.wikipedia.org/wiki/Tickless_kernel) is beneficial for battery-powered systems as [it allows CPUs to sleep for an extended duration](https://arstechnica.com/information-technology/2012/10/better-on-the-inside-under-the-hood-of-windows-8/2). ``disabledynamictick`` can be used to enable regular timer tick interrupts (polling) however many articles have conflicting information and opinions regarding whether doing so is beneficial for latency-sensitive tasks and reducing jitter

    - See [Reducing timer tick interrupts | Erik Rigtorp](https://rigtorp.se/low-latency-guide)

    - See [(Nearly) full tickless operation](https://lwn.net/Articles/549580)

    - See [Low Latency Performance Tuning for
Red Hat Enterprise Linux 7](https://access.redhat.com/sites/default/files/attachments/201501-perf-brief-low-latency-tuning-rhel7-v2.1.pdf)

        ```bat
        bcdedit /set disabledynamictick yes
        ```

## Replace Task Manager with Process Explorer

<details>

<summary>Reasons not to use Task Manager</summary>

- It relies on a kernel mode driver to operate which may introduce additional overhead

- Does not display the process tree

- On Windows 8+, [Task Manager reports CPU utility in %](https://aaron-margosis.medium.com/task-managers-cpu-numbers-are-all-but-meaningless-2d165b421e43) which provides misleading CPU utilization details, on the other hand, Windows 7's Task Manager and Process Explorer report time-based busy utilization. This also explains why the ``disable idle`` power setting results in 100% CPU utilization on Windows 8+

</details>

- Download and extract [Process Explorer](https://learn.microsoft.com/en-us/sysinternals/downloads/process-explorer)

- Copy ``procexp64.exe`` into ``C:\Windows`` and open it

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

Open CMD and enter the command below to disable [process mitigations](https://docs.microsoft.com/en-us/powershell/module/processmitigations/set-processmitigation?view=windowsserver2019-ps). Effects can be viewed with ``Get-ProcessMitigation -System`` in PowerShell.

```bat
C:\bin\scripts\disable-process-mitigations.bat
```

## Configure Memory Management Settings (Windows 8+)

- Open PowerShell and enter the command below

    ```powershell
    Get-MMAgent
    ```

- If anything is set to ``True``, use the command below as an example to disable a given setting

    ```powershell
    Disable-MMAgent -MemoryCompression
    ```

## Configure the Network Adapter

- Open ``Network Connections`` by typing ``ncpa.cpl`` in ``Win+R``

- Disable any unused network adapters then right-click your main one and select properties

- Disable all items except ``QoS Packet Scheduler`` and ``Internet Protocol Version 4 (TCP/IPv4)``

- [Configure a Static IP address](https://www.youtube.com/watch?t=36&v=5iRp1Nug0PU). This is required as we will be disabling the network services that waste resources

- Disable ``NetBIOS over TCP/IP`` in ``General -> Advanced -> WINS`` to [prevent unnecessary system listening](https://github.com/djdallmann/GamingPCSetup/blob/master/CONTENT/DOCS/NETWORK/README.md)

## Configure Audio Devices

- The sound control panel can be opened by typing ``mmsys.cpl`` in ``Win+R``

- Disable unused Playback and Recording devices

- Disable audio enhancements as they waste resources

    - See [media/audio enhancements-benchmark.png](/media/audio%20enhancements-benchmark.png)

- Disable Exclusive Mode in the Advanced section

- Set the option in the communications tab to Do nothing

- I also like to set the sound scheme to no sounds in the sounds tab

- Minimize the size of the audio buffer with [REAL](https://github.com/miniant-git/REAL)/[LowAudioLatency](https://github.com/spddl/LowAudioLatency) or on your DAC. Beware of audio dropouts due to the CPU not being able to keep up under load

    - Be warned regarding CPUs being reserved or underutilized with the usage of the mentioned programs

## Configure Services and Drivers

I'm not responsible if anything goes wrong or you BSOD. The idea is to disable services while using your real-time application and revert to default services for everything else. The list can be customized by editing ``C:\bin\minimal-services.ini`` in a text editor. There are several comments in the config file you can read to check if you need a given service. As an example, a user with Ethernet does not need the Wi-Fi services enabled.

- The ``High precision event timer`` device in Device Manager uses IRQ 0 on the majority of AMD systems and consequently conflicts with the ``System timer`` device which also uses IRQ 0. The only way that I'm aware of to resolve this conflict is to disable the parent device of the ``System timer`` device which is ``PCI standard ISA bridge`` by disabling the ``msisadrv`` driver (edit the config)

- Use the command below to prevent the [Software Protection service attempting to register a restart every 30s](/media/software-protection-error.png) while services are disabled. I'm not sure what the problematic service is, but online sources point to Task Scheduler

    ```bat
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" /v "InactivityShutdownDelay" /t REG_DWORD /d "4294967295" /f
    ```

- On Win10 1503 - 1703, delete the ``ErrorControl`` registry key in ``HKLM\SYSTEM\CurrentControlSet\Services\Schedule`` to prevent an unresponsive explorer shell after disabling the Task Scheduler service

- Use [Autoruns](https://learn.microsoft.com/en-us/sysinternals/downloads/autoruns) to remove entries with a yellow label in the ``Services`` section to prevent obsolete services from being added to the scripts that are going to be built in the next steps. Run with ``C:\bin\NSudo.exe`` if you encounter any permission errors

- Download and extract the latest [service-list-builder](https://github.com/amitxv/service-list-builder/releases) release. Open CMD and CD to the extracted folder where the executable is located

- Use the command below to build the scripts in the ``build`` folder. Move the build folder somewhere safe such as ``C:\`` and do not share it with other people as it is specific to your system. Note that NSudo with the ``Enable All Privileges`` option is required to run the batch scripts

    ```bat
    service-list-builder.exe --config C:\bin\minimal-services.ini
    ```

- If desired, you can use [ServiWin](https://www.nirsoft.net/utils/serviwin.html) to check for residual drivers and possibly create an issue on the repository to let me know that a given driver should be disabled

## Configure Device Manager

The section is directly related to the [Configure Services and Drivers](#configure-services-and-drivers) section. The methodology below will ensure maximum compatibility while services are enabled because devices with an associated driver will be toggled in the ``Services-Disable.bat`` script which means we do not need to permanently disable them.

1. If you haven't disabled services at this stage, run the ``Services-Disable.bat`` script

2. Open Device Manager by typing ``devmgmt.msc`` in ``Win+R``

3. **DO NOT** disable any devices with a yellow icon because these are the devices that are being handled by disabling services

4. Navigate to ``View -> Devices by connection``

    - Disable any PCIe, SATA, NVMe and XHCI controllers with nothing connected to them

    - Unnecessary HID devices can be disabled, but mouse software will not work

        - See [media/hid-devices-example.png](/media/hid-devices-example.png)

    - Disable write-cache buffer flushing on all drives in the ``Properties -> Policies`` section

    - Navigate to your ``Network adapter -> Properties -> Advanced`` and disable any power-saving features. Disable the power-saving option in the ``Power Management`` section

    - Disable everything that isn't the GPU on the same PCIe port

5. Navigate to ``View -> Resources by connection``

    - Disable any unneeded devices that are using an IRQ or I/O resources, always ask if unsure and take your time on this step

    - If there are multiple of the same devices, and you are unsure which one is in use, refer back to the tree structure in ``View -> Devices by connection``. Remember that a single device can use many resources. You can also use [MSI Utility](https://forums.guru3d.com/threads/windows-line-based-vs-message-signaled-based-interrupts-msi-tool.378044) to check for duplicate, unneeded devices in case you accidentally miss any with the confusing Device Manager tree structure

6. Run the ``Services-Enable.bat`` script

7. Open Device Manager by typing ``devmgmt.msc`` in ``Win+R``

8. Now you **CAN** disable devices with a yellow icon because these are devices that genuinely have errors and aren't due to services being disabled

9. Optionally use [DeviceCleanup](https://www.uwe-sieber.de/files/DeviceCleanup.zip) to remove hidden devices

## Disable Driver power-saving

Open PowerShell and enter the command below to disable power-saving on devices in Device Manager. Avoid re-plugging devices as the power-saving settings will get restored

```powershell
C:\bin\scripts\disable-pnp-powersaving.ps1
```

## Configure Event Trace Sessions

Create registry files to toggle event trace sessions. Programs that rely on event tracers such will not be able to log data until the required sessions are restored which is the purpose of creating two registry files to toggle between them (identical concept to the service scripts). Open CMD and enter the commands below to build the registry files in the ``C:\`` directory. As with the services scripts these registry files must be run with NSudo. The sessions can be viewed by typing ``perfmon`` in ``Win+R`` then navigating to ``Data Collector Sets -> Event Trace Sessions``.

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

    ```bat
    fsutil behavior set disable8dot3 1
    ```

- Disable updates to the Last Access Time stamp on each directory when directories are listed on an NTFS volume

    ```bat
    fsutil behavior set disablelastaccess 1
    ```

## Message Signaled Interrupts

[Message signaled interrupts are faster than traditional line-based interrupts and may also resolve the issue of shared interrupts which are often the cause of high interrupt latency and stability](https://repo.zenk-security.com/Linux%20et%20systemes%20d.exploitations/Windows%20Internals%20Part%201_6th%20Edition.pdf).

- Download and open [MSI Utility](https://forums.guru3d.com/threads/windows-line-based-vs-message-signaled-based-interrupts-msi-tool.378044) or [GoInterruptPolicy](https://github.com/spddl/GoInterruptPolicy)

- Enable Message Signaled Interrupts on all devices that support it

    - You will BSOD if you enable MSIs for the stock Windows 7 SATA driver which you should have already updated as mentioned in the [Install Drivers](#install-drivers) section

- Be careful as to what you choose to prioritize. As an example, an I/O bound application may suffer a performance loss including an open-world game that utilizes texture streaming if the GPU IRQ priority is set higher than the storage controller priority. For this reason, you can set all devices to undefined/normal priority

- Restart your PC, you can verify whether a device is utilizing MSIs by checking if it has a negative IRQ in MSI Utility

- Although this was carried out in the [Physical Setup](/docs/physical-setup.md) section, confirm that there is no IRQ sharing on your system by typing ``msinfo32`` in ``Win+R`` then navigating to the ``Conflicts/Sharing`` section

    - If ``System timer`` and ``High precision event timer`` are sharing IRQ 0, See the [Configure Services and Drivers](#configure-services-and-drivers) section for a solution

## Per-CPU Scheduling

Windows schedules interrupts, DPCs, threads and more on CPU 0 for several modules and processes by default. In any case, scheduling many tasks on a single CPU will have adverse effects including additional overhead and increased jitter due to them competing for CPU time. To alleviate this, users can configure affinities and other policies to isolate given modules from user and kernel-level disturbances such as servicing time-sensitive modules on other underutilized CPUs instead of clumping everything on a single CPU.

- Use the xperf DPC/ISR report to analyze which CPUs kernel-mode modules are being serviced on. You can not manage affinities if you do not know what is running and which CPU(s) they are running on, the same applies to user-mode threads. Additionally verify whether interrupt affinity policies are performing as expected by analyzing per-CPU usage for the module in question while the device is busy

    - See [bin/scripts/xperf-dpcisr.bat](/bin/scripts/xperf-dpcisr.bat)

- Ensure that the [corresponding DPC for an ISR are processed on the same CPU](/media/isr-dpc-same-core.png). Additional overhead can be introduced if they are processed on different CPUs due to increased inter-processor communication and interfering with cache coherence. This is usually not a problem with MSI-X devices

- Use [Microsoft Interrupt Affinity Tool](https://www.techpowerup.com/download/microsoft-interrupt-affinity-tool) or [GoInterruptPolicy](https://github.com/spddl/GoInterruptPolicy) to configure driver affinities. The device can be identified by cross-checking the ``Location`` in the ``Properties -> General`` section of a device in Device Manager

### XHCI Controller

[Mouse Tester](https://github.com/amitxv/MouseTester) can be used to compare polling variation with the XHCI controller assigned to different CPUs. Ideally this should be benchmarked under load as idle benchmarks may be misleading

### GPU and DirectX Graphics Kernel

[AutoGpuAffinity](https://github.com/amitxv/AutoGpuAffinity) can be used to benchmark the most performant CPUs that the GPU-related modules are assigned to

### Network Interface Card

[The NIC must support MSI-X for RSS to function properly](https://www.reddit.com/r/intel/comments/9uc03d/the_i219v_nic_on_your_new_z390_motherboard_and). In most cases, RSS base CPU is enough to migrate DPCs and ISRs for the NIC driver which eliminates the need for an interrupt affinity policy. However, if you are having trouble migrating either to other CPUs, try configuring both simultaneously.

The command below can be used to configure RSS base CPU. Ensure to change the driver key to the one that corresponds to the correct NIC. Keep in mind that the amount of RSS queues determine the amount of consecutive CPUs ``ndis.sys`` is scheduled on. For example, the driver will be scheduled on CPU 2/3/4/5 (2/4/6/8 with HT/SMT enabled) if RSS base CPU is set to 2 along with 4 RSS queues configured.

- See [How many RSS Queues do you need?](research.md#how-many-rss-queues-do-you-need)

- See [media/find-driver-key-example.png](/media/find-driver-key-example.png) to obtain the correct driver key in Device Manager

    ```bat
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0000" /v "*RssBaseProcNumber" /t REG_SZ /d "2" /f
    ```

### Reserved CPU Sets (Windows 10+)

[ReservedCpuSets](https://github.com/amitxv/ReservedCpuSets) can be used to prevent Windows routing interrupts and scheduling tasks on specific CPUs. As mentioned previously, isolating modules from user and kernel-level disturbances helps reduce contention, reduce jitter and allows time-sensitive modules to get the CPU time they require.

- As interrupt affinity policies, process and thread affinities have higher precedence, you can use this hand in hand with user-defined affinities to go a step further and ensure that nothing except what you assigned to specific CPUs will be scheduled on those CPUs.

- Ensure that you have enough cores to run your real-time application on and aren't reserving too many CPUs to the point where isolating modules does not yield real-time performance

- As CPU sets are considered soft policies, the configuration isn't guaranteed. A CPU-intensive process such as a stress-test will utilize the reserved cores if required

#### Potential Use Cases

- Reserving all CPUs except a few for time-insensitive processes such as background tasks. On modern Intel systems, this could mean reserving P-Cores (performance cores) so that Windows schedules tasks on E-Cores (efficiency cores) by default. Then the user may explicitly define what will be scheduled on the P-Cores

- Reserving hyper-threaded CPUs

- Reserving CPUs that have specific modules assigned to be scheduled on them. For example, isolating the CPU that the GPU driver is serviced on [improved frame pacing](/media/isolate-gpu-core.png)

## Raise the Clock Interrupt Frequency (Timer Resolution)

There is a lot of misleading and inaccurate information regarding this topic polluting the internet. Raising the timer resolution helps with precision where constant sleeping or pacing is required such as multimedia applications, frame rate limiters and more. Below is a list of bullet points highlighting key information regarding the topic.

- Applications that require a high resolution already call for 1ms (1kHz) most of the time. In the context of a multimedia application, this means that it can maintain the pace of events within a resolution of 1ms, but we can take advantage of 0.5ms (2kHz) being the maximum resolution supported on most systems

- The implementation of timer resolution changed in Windows 10 2004+ so that the calling process does not affect the system on a global level but can be restored on Windows Server and Windows 11+ with the registry key below as explained in depth [here](/docs/research.md#fixing-timing-precision-in-windows-after-the-great-rule-change). As long as the process that requires high precision is calling for a higher resolution, this does not matter. Although, it limits us from raising the resolution beyond 1ms (unless you have a kernel mode driver which is a topic for another day)

    ```
    [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\kernel]
    "GlobalTimerResolutionRequests"=dword:00000001
    ```

- Even if you do not want to raise the timer resolution beyond 1ms, it is useful to call for it nonetheless as old applications do not raise the resolution which results in unexpected behavior

- Higher resolution results in higher precision, but in some cases 0.5ms provides less precision than something slightly lower such as 0.507ms. You should benchmark what calling resolution provides the highest precision (the lowest deltas) in the [MeasureSleep](https://github.com/amitxv/TimerResolution) program while requesting different resolutions with the [SetTimerResolution](https://github.com/amitxv/TimerResolution) program. This should be carried out under load as idle benchmarks may be misleading

    - See [Micro-adjusting timer resolution for higher precision](/docs/research.md#micro-adjusting-timer-resolution-for-higher-precision) for a detailed explanation

## XHCI Interrupt Moderation (IMOD)

On most systems, Windows 7 uses an IMOD interval of 1ms whereas recent versions of Windows use 0.05ms (50us) unless specified by the installed USB driver. This means that after an interrupt has been generated, the XHCI controller waits for the specified interval for more data to arrive before generating another interrupt which reduces CPU utilization but potentially results in data from a given device being supplied at an inconsistent rate in the event of expecting data from other devices within the waiting period that are connected to the same XHCI controller.

For example, a mouse with an 1kHz polling rate will report data every 1ms. While only moving the mouse with an IMOD interval of 1ms, interrupt moderation will not be taking place because interrupts are being generated at a rate less than or equal to the specified interval. Realistically while playing a fast-paced game, you will easily surpass 1000 interrupts/s with keyboard and audio interaction while moving the mouse hence there will be a loss of information because you will be expecting data within the waiting period from either devices. Although this is unlikely with an IMOD interval of 0.05ms (50us), it can still happen. A 1ms IMOD interval with an 8kHz mouse is already problematic because you are expecting data every 0.125ms which is significantly greater than the specified interval and of course, results in a [major bottleneck](https://www.overclock.net/threads/usb-polling-precision.1550666/page-61#post-28576466).

- See [How to persistently disable XHCI Interrupt Moderation](https://github.com/BoringBoredom/PC-Optimization-Hub/blob/main/content/xhci%20imod/xhci%20imod.md)

- Microsoft Vulnerable Driver Blocklist may need to be disabled with the command below in order to use [RWEverything](http://rweverything.com) on Windows 11+

    ```bat
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\CI\Config" /v "VulnerableDriverBlocklistEnable" /t REG_DWORD /d "0" /f
    ```

## Configure Control Panel

It isn't a bad idea to skim through both the legacy and immersive control panel to ensure nothing is misconfigured.

## Analyze Event Viewer

This step isn't required, but can help to justify unexplained performance issues. From a developer's perspective, we have certainly broken the operating system as we are running minimal services, debloated Windows and more. Code that naturally depends on something that is disabled or removed will throw errors or get stuck in an error loop. We can use event viewer to inspect whether everything is running as it should be. This is the method I used to identify that the [Software Protection service was attempting to register a restart every 30s](/media/software-protection-error.png) as explained in the [Configure Services and Drivers](#configure-services-and-drivers) section (along with the solution).

- The ``Services-Disable.bat`` script disables logging, so the start values for ``Wecsvc`` and ``EventLog`` must be changed to 3 and 2 respectively

- After running the script, use your PC normally for a while then open event viewer by typing ``eventvwr.msc`` in ``Win+R``. Inspect each section for errors and investigate how they can be solved

- Once finished, set the ``Wecsvc`` and ``EventLog`` start values back to 4 in the ``Services-Disable.bat`` script

## Configuring Applications

Install any programs and configure your real-time applications to prepare us for the next steps.

- Use [NVIDIA Reflex](https://www.nvidia.com/en-us/geforce/news/reflex-low-latency-platform)

- Cap your frame rate at a multiple of your monitor refresh rate to prevent [frame mistiming](https://www.youtube.com/watch?v=_73gFgNrYVQ). Cap at your minimum fps threshold for increased smoothness and ensure the GPU isn't maxed out as [lower GPU utilization reduces system latency](https://www.youtube.com/watch?v=8ZRuFaFZh5M&t=859s)

    - See [FPS Cap Calculator](https://boringboredom.github.io/tools/#/FPSCap)

    - Capping your frame rate with [RTSS](https://www.guru3d.com/files-details/rtss-rivatuner-statistics-server-download.html) instead of the in-game limiter will result in consistent frame pacing and a smoother experience as it utilizes [busy-wait](https://en.wikipedia.org/wiki/Busy_waiting) which is offers higher precision than 100% passive-waiting but at the cost of [noticeably higher latency](https://www.youtube.com/watch?t=377&v=T2ENf9cigSk) and potentially greater CPU overhead. Disabling the ``Enable dedicated encoder server service`` setting prevents ``EncoderServer.exe`` running which wastes resources

- Configure present mode

    - Always check whether your real-time application is using the desired present mode with PresentMon. ``Hardware: Legacy Flip`` and ``Hardware: Independent Flip`` are optimal

    - Assuming the ``Disable fullscreen optimizations`` checkbox is ticked, and you are having trouble with using ``Hardware: Legacy Flip``, try to run the command below in CMD and reboot

        ```bat
        reg add "HKCU\SYSTEM\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatible" /t REG_DWORD /d "1" /f
        ```

    - If you are stuck with ``Hardware Composed: Independent Flip``, try to run the command below to disable MPOs in CMD and reboot

        ```bat
        reg add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "OverlayTestMode" /t REG_DWORD /d "5" /f
        ```

- Configuring QoS policies

    - This allows Windows to prioritize packets of an application

    - See [media/dscp-46-qos-policy.png](/media/dscp-46-qos-policy.png)

        - See [How can you verify if a DSCP QoS policy is working?](research.md#how-can-you-verify-if-a-dscp-policy-is-working)

## Cleanup

- Use [Autoruns](https://learn.microsoft.com/en-us/sysinternals/downloads/autoruns) to remove any unwanted programs from launching at startup. Remove all obsolete entries with a yellow label and run with ``C:\bin\NSudo.exe`` if you encounter any permission errors

- Some locations you may want to review for leftover bloatware and unwanted shortcuts

    - ``"C:\"``

    - ``"C:\Windows\Prefetch"``

    - ``"C:\Windows\SoftwareDistribution\download"``

    - ``"C:\Windows\Temp"``

    - ``"%userprofile%\AppData\Local\Temp"``

    - ``"%userprofile%\Downloads"``

- Clear the ``PATH`` user environment variable of locations pointing to Windows bloatware folders

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

- Reset Firewall rules

    - Open CMD and enter the commands below

        ```bat
        reg delete "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /f && reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /f
        ```

## Final Thoughts and Tips

- Avoid applying random changes and tweaks, using all-in-one solution programs or fall for the "fps boost" marketing nonsense. If you have a question about a specific option or setting, just ask

- Try to favor free and open source software. Stay away from proprietary software where you can and ensure to scan files with [VirusTotal](https://www.virustotal.com/gui/home/upload) before running them

- Favor tools such as [Bulk-Crap-Uninstaller](https://github.com/Klocman/Bulk-Crap-Uninstaller) to uninstall programs as the regular control panel does not remove residual files

- Kill processes that waste resources such as clients, ``explorer.exe`` and more

    - Use ``Ctrl+Shift+Esc`` to open process explorer then use ``File -> Run`` to start the ``explorer.exe`` shell again

- Consider disabling idle states to force C-State 0 with the commands below before using your real-time application then enable idle after closing it. Avoid disabling idle states with Hyper-Threading/Simultaneous Multithreading enabled as single-threaded performance is usually negatively impacted. Forcing C-State 0 will mitigate jitter due to the process of state transition. Beware of higher temperatures and power consumption, the CPU temperature should not increase to the point of thermal throttling because you should have already dealt with that in [docs/physical-setup.md](/docs/physical-setup.md). A value of 0 corresponds to idle enabled, 1 corresponds to idle disabled

    ```bat
    powercfg /setacvalueindex scheme_current sub_processor 5d76a2ca-e8c0-402f-a133-2158492d58ad 1 && powercfg /setactive scheme_current
    ```

- If you are using Windows 8.1+, the [Hardware: Legacy Flip](https://github.com/GameTechDev/PresentMon#csv-columns) presentation mode with your application, and take responsibility for damage caused to your operating system, you can disable DWM using the scripts in ``C:\bin\scripts\dwm-scripts`` as the process wastes resources despite there being no composition. Beware of the UI breaking and some games/programs will not be able to launch (you may need to disable hardware acceleration). Ensure that there aren't any UWP processes running and preferably run the ``Services-Disable.bat`` script that was generated in the [Configure Services and Drivers](#configure-services-and-drivers) section before disabling DWM
