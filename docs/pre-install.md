# Pre-Installation Instructions

## Activation

Consider activating before configuring the image as the key will be permanently linked to your motherboard. This can be done with a legitimate key

## Configure Partitions

It is recommended to configure at least a [dual-boot](https://en.wikipedia.org/wiki/Multi-booting) to separate work & gaming environments. This way you will not be forced to install bloatware on your gaming partition & full functionality of the operating system will be guaranteed for when you need it. You can do this by [shrinking a volume](https://docs.microsoft.com/en-us/windows-server/storage/disk-management/shrink-a-basic-volume) in disk management

## Obtaining a Base Image

The post-installation instructions are based on configuring a stock Windows image along a few modifications made to the image beforehand

- See [docs/building.md](../docs/building.md) to create the base image

## Preparing the USB

- Download [Ventoy](https://github.com/ventoy/Ventoy/releases) & [Linux Mint Xfce Edition](https://www.linuxmint.com/download.php) if you have not already

- Insert your USB stick into a USB port & extract Ventoy

- Open **Ventoy2Disk.exe**,  go to **Option > Partition Style** & select GPT (UEFI) or MBR (Legacy)

    - See [media/identify-bios-mode.png](../media/identify-bios-mode.png)

- Select your USB storage & press install

- Once Ventoy has installed on your USB storage device, simply drag & drop the Linux Mint ISO file into the USB in file explorer

## Booting Into the Image

For the next steps, it is **vital** that you unplug your ethernet cable & are not connected to the internet. This will allow us to bypass the forced Microsoft login during OOBE & will prevent Windows from fetching updates

You can either:

- Use a USB:

    - Drag & drop the ISO into the same location where Linux Mint is & select the USB storage device in the boot options in BIOS

    - When installing Windows 8 with a USB, you may be required to enter a key. Use the generic key ``GCRJD-8NW9H-F2CDX-CCM8D-9D6T9`` to get past this step

- Use DISM Apply-Image:

    - Create a new partition by [shrinking a volume](https://docs.microsoft.com/en-us/windows-server/storage/disk-management/shrink-a-basic-volume) & assign it a drive letter. Extract the image & run **install.bat**
