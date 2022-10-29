# Pre-Install Instructions

## Configure Partitions

Configure a [dual-boot](https://en.wikipedia.org/wiki/Multi-booting) to separate work/bloatware and gaming environments. This way you will not be forced to install bloatware on your gaming partition (such as mouse software as previously mentioned) and full functionality of the operating system will be guaranteed for when you need it. You can do this by [shrinking a volume](https://docs.microsoft.com/en-us/windows-server/storage/disk-management/shrink-a-basic-volume) in disk management.

## Create the Base ISO

Generally, Windows 7 is superior for real-time tasks compared to its successors but lacks driver support for modern hardware so drivers must be integrated manually. In some cases, you may not be able to find USB drivers at all on newer platforms (it is recommended to check if you can get hold of them 
in advance of building the ISO, see the [Integrate and Obtain Drivers](./building.md#integrate-and-obtain-drivers) section for details on finding drivers). Earlier versions of Windows lack GPU driver and anticheat support so some users are forced on newer builds. Microsoft implemented a fixed 10mHz QueryPerformanceFrequency on Windows 10 1809+ which was intended to make developing applications easier but many users reported worse performance. Windows 10 1903+ has an [updated scheduler for multi CCX Ryzen CPUs](https://i.redd.it/y8nxtm08um331.png) (which you should sell). Microsoft changed how timer resolution functions as explained in [this article](https://randomascii.wordpress.com/2020/10/04/windows-timer-resolution-the-great-rule-change/) on Windows 10 2004+ and was [further developed in Windows 11](../media/windows11-timeapi-changes.png) which is an attempt to improve power efficiency.

- See [docs/building.md](../docs/building.md)

## Prepare the USB

- Download [Ventoy](https://github.com/ventoy/Ventoy/releases) and [Linux Mint Xfce Edition](https://www.linuxmint.com/download.php)

- Plug in your USB storage and launch **Ventoy2Disk.exe**. Go to **Option > Partition Style** and select GPT (UEFI) or MBR (Legacy) then select your USB storage and click install

    - See [media/identify-bios-mode.png](../media/identify-bios-mode.png)

- Move the Linux Mint ISO file into the USB storage in file explorer

## Boot Into the ISO

For the next steps, it is imperative that you unplug your Ethernet cable and are not connected to the Internet. This will allow us to bypass the forced Microsoft login during OOBE and will prevent Windows from fetching updates. Moving onward, you will need to open [docs/post-install.md](./post-install.md) on another device (phone) to follow up until a web browser is installed. After that you can open the guide on the same operating system you are configuring.

- Install using a USB storage device:

    - Place the ISO into the same location where the Linux Mint ISO is and select the USB storage device in the boot options in BIOS
    - When installing Windows 8 with a USB, you may be required to enter a key. Use the generic key ``GCRJD-8NW9H-F2CDX-CCM8D-9D6T9`` to get past this step
    - When installing Windows 11 with a USB, you may encounter system requirement issues. To bypass the checks, press **Shift + F10** to open CMD then type **regedit**. Go to **File -> Import...** and import the **bypass-windows11-checks.reg** registry file

- Install using DISM Apply-Image (without a USB storage device):

    - Create a new partition by [shrinking a volume](https://docs.microsoft.com/en-us/windows-server/storage/disk-management/shrink-a-basic-volume) and assign it a drive letter. Extract the ISO if required and launch **install.bat**