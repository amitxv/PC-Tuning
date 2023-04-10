# Pre-Install Instructions

## Configure Partitions

Configure a [dual-boot](https://en.wikipedia.org/wiki/Multi-booting) to separate work/bloatware and gaming environments. This way you will not be forced to install bloatware on your gaming partition (such as mouse software as previously mentioned) and full functionality of the operating system will be guaranteed for when you need it. You can do this by [shrinking a volume](https://docs.microsoft.com/en-us/windows-server/storage/disk-management/shrink-a-basic-volume) in disk management which will create unallocated space for the new operating system to be installed to. This will be completely independent of the current operating system.

## What Version of Windows Should You Use?

- Generally, older versions of Windows are superior for real-time tasks as the concern for power efficiency and security is heightened after each edition release. For this reason, Windows 7 is the preferable choice but lacks driver support for modern hardware and developers are increasingly dropping support for legacy operating systems

- Earlier versions of Windows lack anticheat (due to lack of security updates) and driver support (commonly GPU, NIC), so some users are forced to use newer builds. See a table below of the minimum version required to install drivers for a given GPU as of March 2023

    |GPU|Minimum Windows Version|
    |---|---|
    |NVIDIA 10 series and lower|Supported by almost all Windows versions|
    |NVIDIA 16, 20 series|Win7, Win8, Win10 1709+|
    |NVIDIA 30 series|Win7, Win10 1803+|
    |NVIDIA 40 series|Win10 1803+|
    |AMD|Newer drivers supposedly require 1709?|

- NVIDIA DCH drivers are [supported on Windows 10 1803+](https://nvidia.custhelp.com/app/answers/detail/a_id/4777/~/nvidia-dch%2Fstandard-display-drivers-for-windows-10-faq)

- Microsoft implemented a fixed 10MHz QueryPerformanceFrequency on Windows 10 1809+ which was intended to make developing applications easier, but many users across the internet reported worse performance

- Windows 10 1903+ has an [updated scheduler for multi CCX Ryzen CPUs](https://i.redd.it/y8nxtm08um331.png)

- Windows 11+ has an updated scheduler for Intel 12th Gen CPUs

    - See [Thread Director: Windows 11 Does It Best](https://www.anandtech.com/show/16959/intel-innovation-alder-lake-november-4th/3)

- The implementation of ``Hardware: Independent Flip`` (fullscreen optimizations) improved in around Windows 10 2004+ (approximation as it is unclear) which can potentially result in better performance compared to ``Hardware: Legacy Flip`` (exclusive fullscreen)

    - See the [Configuring Games and Applications](/docs/post-install.md#configuring-games-and-applications) section for more information

- The behavior of processes that are affected by a single process raising the clock interrupt frequency significantly changed in Windows 10 2004+, and was [further developed in Windows 11](/media/windows11-timeapi-changes.png), to increase power efficiency but consequently breaks real-time applications and causes incredibly imprecise timing across the operating system. However, the old implementation can be restored in server 2022+ and Windows 11+ [with a registry entry](/docs/research.md#fixing-timing-precision-in-windows-after-the-great-rule-change). For this reason, it would be appropriate to avoid builds released after Windows 10 2004 which are not Windows 11+ or server 2022+

- [AllowTelemetry](https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.DataCollection::AllowTelemetry) can *actually* be set to 0 on Windows Server editions

## Create the Base ISO

- See [docs/building.md](/docs/building.md)

## Prepare the USB

- Plug in your USB storage and backup any important files. Download [Ventoy](https://github.com/ventoy/Ventoy/releases) and launch ``Ventoy2Disk.exe``. Navigate to the option menu and select the correct partition style and disable secure boot support if it is not enabled in BIOS, then select your USB storage and click install

    - See [media/identify-bios-mode.png](/media/identify-bios-mode.png)

- Download a live Linux distribution of your choice and move the ISO into the USB storage in file explorer. I will be using [Linux Mint Xfce Edition](https://www.linuxmint.com/download.php)

## Boot Into the ISO

For the next steps, it is mandatory to disconnect the Ethernet cable and not be connected to the internet. This will allow us to bypass the forced Microsoft login during OOBE and will prevent Windows from fetching updates.

As some commands in [docs/post-install.md](/docs/post-install.md) are tedious to manually type in the console, you can keep a copy of the document locally and open it in notepad when you find yourself having to execute a long command.

- Install using a USB storage device:

    - Move your Windows ISO into the USB storage in file explorer (where the Linux ISO is also located)

    - Boot into Ventoy on your USB in BIOS and select your Windows ISO. Continue with setup as per usual

    - When installing Windows 8 with a USB, you may be required to enter a key. Use the generic key ``GCRJD-8NW9H-F2CDX-CCM8D-9D6T9`` to bypass this step (this does not activate Windows)

    - When installing Win11 with a USB, you may encounter system requirement issues. To bypass the checks, press ``Shift+F10`` to open CMD then type ``regedit`` and add the relevant registry keys listed below

        ```
        [HKEY_LOCAL_MACHINE\SYSTEM\Setup\LabConfig]
        "BypassTPMCheck"=dword:00000001
        "BypassRAMCheck"=dword:00000001
        "BypassSecureBootCheck"=dword:00000001
        ```

- Install using DISM Apply-Image (without a USB storage device):

    - Create a new partition by [shrinking a volume](https://docs.microsoft.com/en-us/windows-server/storage/disk-management/shrink-a-basic-volume) and assign the newly created unallocated space a drive letter

    - Extract the ISO if required then run the command below to apply the image. Replace ``<path\to\wim>`` with the path to the ``install.wim`` or ``install.esd`` and replace ``<drive letter>`` with the drive letter you assigned in the previous step. For example, ``C:\en_windows_8_1_x64_dvd_2707217\sources\install.wim`` and ``D:``

        ```bat
        DISM /Apply-Image /ImageFile:<path\to\wim> /Index:1 /ApplyDir:<drive letter>
        ```

    - Create the boot entry with the command below. Replace ``<windir>`` with the path to the mounted ``Windows`` directory. For example ``D:\Windows``

        ```bat
        bcdboot <windir>
        ```
