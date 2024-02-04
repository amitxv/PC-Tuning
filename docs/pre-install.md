# Table of Contents

- [Configure Partitions](#configure-partitions)
- [What Version of Windows Should You Use?](#what-version-of-windows-should-you-use)
- [Build Requirements](#build-requirements)
- [Download Stock ISOs](#download-stock-isos)
- [Prepare the Build Environment](#prepare-the-build-environment)
- [Remove Non-Essential Editions](#remove-non-essential-editions)
- [Mount the ISO](#mount-the-iso)
- [Replace Wallpapers (Optional)](#replace-wallpapers-optional)
- [Integrate and Obtain Drivers (Windows 7)](#integrate-and-obtain-drivers-windows-7)
- [Integrate Updates](#integrate-updates)
- [Enable .NET 3.5 (Windows 8+)](#enable-net-35-windows-8)
- [Integrating Required Files](#integrating-required-files)
- [Unmount and Commit](#unmount-and-commit)
- [Replace Windows 7 Boot Wim (Windows 7)](#replace-windows-7-boot-wim-windows-7)
- [ISO Compression](#iso-compression)
- [Convert to ISO](#convert-to-iso)
- [Boot Into the ISO](#boot-into-the-iso)
    - [Install using a USB storage device](#install-using-a-usb-storage-device)
    - [Install using DISM Apply-Image (without a USB storage device)](#install-using-dism-apply-image-without-a-usb-storage-device)

# Pre-Install Instructions

## Configure Partitions

Configure a [dual-boot](https://en.wikipedia.org/wiki/Multi-booting) to separate environments for work/bloatware and your real-time application. This way you will not be forced to install bloatware on the same partition where you will be using your real-time application. You can do this by [shrinking a volume](https://docs.microsoft.com/en-us/windows-server/storage/disk-management/shrink-a-basic-volume) in Disk Management which will create unallocated space for installing the new operating system.

## What Version of Windows Should You Use?

- Earlier versions of Windows lack anti-cheat (due to lack of security updates), driver support (commonly GPU, NIC) and application support in general, so some users are forced to use newer builds. See the table below of the minimum version required to install drivers for a given GPU as of November 2023

    |GPU|Minimum Windows Version|
    |---|---|
    |NVIDIA 10 series and lower|Supported by almost all Windows versions|
    |NVIDIA 16, 20 series|Win7, Win8, Win10 1709+|
    |NVIDIA 30 series|Win7, Win10 1803+|
    |NVIDIA 40 series|Win10 1803+|
    |AMD|Refer to driver support page|

- NVIDIA DCH drivers are supported on Windows 10 1803+ ([1](https://nvidia.custhelp.com/app/answers/detail/a_id/4777/~/nvidia-dch%2Fstandard-display-drivers-for-windows-10-faq))

- During media playback exclusively on Windows 10 1709, the [Multimedia Class Scheduler Service](https://learn.microsoft.com/en-us/windows/win32/procthread/multimedia-class-scheduler-service) raises the timer resolution to 0.5ms. As explained in the article below, this resolution is suboptimal for many people in terms of precision hence it would be appropriate to avoid this Windows version

    - See [Micro-adjusting timer resolution for higher precision](/docs/research.md#micro-adjusting-timer-resolution-for-higher-precision)

- Windows 10 1809+ is required for Ray Tracing on NVIDIA GPUs

- Microsoft implemented a fixed 10MHz QueryPerformanceFrequency on Windows 10 1809+ which was intended to make developing applications easier, but many users across the internet reported worse performance

- Windows 10 1903+ has an updated scheduler for multi CCX Ryzen CPUs ([1](https://i.redd.it/y8nxtm08um331.png))

- DirectStorage requires Windows 10 1909+ but according to an article, games running on Windows 11 benefit further from new storage stack optimizations ([1](https://devblogs.microsoft.com/directx/directstorage-developer-preview-now-available))

- Windows 10 2004+ is required for Hardware Accelerated GPU Scheduling which is necessary for DLSS Frame Generation ([1](https://developer.nvidia.com/rtx/streamline/get-started))

    - See [Hardware Accelerated GPU Scheduling](https://devblogs.microsoft.com/directx/hardware-accelerated-gpu-scheduling)

- Windows 11+ has an updated scheduler for Intel 12th Gen CPUs and above but the behavior can easily be replicated manually on any Windows version ([1](https://www.anandtech.com/show/16959/intel-innovation-alder-lake-november-4th/3)). See the [Per-CPU Scheduling](/docs/post-install.md#per-cpu-scheduling) section for more information

- The behavior of processes that are affected by a single process raising the clock interrupt frequency significantly changed in Windows 10 2004+ and was further developed in Windows 11 to increase power efficiency but consequently breaks real-time applications and causes incredibly imprecise timing across the operating system ([1](/media/windows11-timeapi-changes.png)). However, the old implementation can be restored in server 2022+ and Windows 11+ with a registry entry ([1](/docs/research.md#fixing-timing-precision-in-windows-after-the-great-rule-change)). For this reason, it would be appropriate to avoid builds starting from Windows 10 2004 which aren't Windows 11+ or Server 2022+

- As of May 2023, Windows 11 limits the message rate of background raw input listeners ([1](https://blogs.windows.com/windowsdeveloper/2023/05/26/delivering-delightful-performance-for-more-than-one-billion-users-worldwide))

- AllowTelemetry can be set to 0 on Windows Server editions ([1](https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.DataCollection::AllowTelemetry))

## Build Requirements

- Extraction tool - [7-Zip](https://www.7-zip.org) recommended

- [Windows ADK](https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install) - Install Deployment Tools

## Download Stock ISOs

Ensure to cross-check the hashes for the ISO to verify that it is genuine and not corrupted (not required when building an ISO from UUP dump). Use the command ``certutil -hashfile <file>`` to get the hash of the ISO.

- Recommended ISOs:

    - Windows 7: ``en_windows_7_professional_with_sp1_x64_dvd_u_676939.iso`` - [Adguard hashes](https://files.rg-adguard.net/file/11ad6502-c2aa-261c-8c3f-c81477b21dd2?lang=en-us)

    - Windows 8: ``en_windows_8_1_x64_dvd_2707217.iso`` - [Adguard hashes](https://files.rg-adguard.net/file/406e60db-4275-7bf8-616f-56e88d9e0a4a?lang=en-us)

    - Windows 10+: Try to obtain an ISO with minimal updates as we will be integrating those of our choice. ISOs built with UUP dump typically ship with the latest updates which is fine

        <details>
        <summary>How to check integrated updates</summary>

        - Extract and mount the ISO by following the steps from [Prepare the Build Environment](#prepare-the-build-environment) to [Mount the ISO](#mount-the-iso)

        - View installed updates

            ```bat
            DISM /Image:"%MOUNT_DIR%" /Get-Packages
            ```

        - If you are satisfied with the update list, you can continue and proceed to the next steps. Otherwise, unmount with the command below to discard the ISO

            ```bat
            DISM /Unmount-Wim /MountDir:"%MOUNT_DIR%" /Discard && rd /s /q "%MOUNT_DIR%"
            ```

        </details>

- ISO Sources:

    - [os.click](https://os.click)
    - [New Download Links](https://docs.google.com/spreadsheets/d/1zTF5uRJKfZ3ziLxAZHh47kF85ja34_OFB5C5bVSPumk)
    - [Adguard File List](https://files.rg-adguard.net)
    - [Microsoft Software Download Listing](https://massgrave.dev/msdl)
    - [Fido](https://github.com/pbatard/Fido)
    - [UUP dump](https://uupdump.net)

## Prepare the Build Environment

- If Windows Defender is enabled, then consider disabling real-time protection as it can slow the mounting and unmounting process or cause issues in some cases

- Open CMD as administrator and do not close the window as we will be setting temporary environment variables which will be unbound when the session is ended

- Run the command below. If an error occurs, re-open CMD with administrator privileges however if nothing is shown in the output, continue as normal

    ```bat
    DISM > nul 2>&1 || echo error: administrator privileges required
    ```

- Extract the contents of the ISO to a directory of your choice then assign it to the ``EXTRACTED_ISO`` variable. In the example below, I'm using ``C:\en_windows_7_professional_with_sp1_x64_dvd_u_676939``

    ```bat
    set "EXTRACTED_ISO=C:\en_windows_7_professional_with_sp1_x64_dvd_u_676939"
    ```

- Set the path where the ISO will be mounted for servicing to the ``MOUNT_DIR`` variable. Changing the value below isn't necessary

    ```bat
    set "MOUNT_DIR=%temp%\MOUNT_DIR"
    ```

- Set the path to the ``oscdimg.exe`` binary to the ``OSCDIMG`` variable. Unless you installed deployment tools to a location other than the default, changing the value below isn't necessary

    ```bat
    set "OSCDIMG=C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\oscdimg.exe"
    ```

- Prepare the ``MOUNT_DIR`` directory for mounting

    ```bat
    > nul 2>&1 (DISM /Unmount-Wim /MountDir:"%MOUNT_DIR%" /Discard & rd /s /q "%MOUNT_DIR%" & mkdir "%MOUNT_DIR%")
    ```

- If the environment variables are configured correctly, the commands below should display ``true``

    ```bat
    if exist "%EXTRACTED_ISO%\sources\install.wim" (echo true) else (echo false)
    if exist "%MOUNT_DIR%" (echo true) else (echo false)
    if exist "%OSCDIMG%" (echo true) else (echo false)
    ```

## Remove Non-Essential Editions

Remove every edition except the desired edition by retrieving the indexes of every other edition and removing them with the commands below. Once completed, the only edition to exist should be the desired edition at index 1. Ensure that the chosen edition has group policy support as several policies are configured in later steps.

- Recommended editions:

    - Client editions: Professional

    - Server editions: Standard (Desktop Experience)

- Get all available editions and their corresponding indexes

    ```bat
    DISM /Get-WimInfo /WimFile:"%EXTRACTED_ISO%\sources\install.wim"
    ```

- Remove edition by index. Replace ``<index>`` with the index number

    ```bat
    DISM /Delete-Image /ImageFile:"%EXTRACTED_ISO%\sources\install.wim" /Index:<index>
    ```

## Mount the ISO

Mount the ISO with the command below.

```bat
DISM /Mount-Wim /WimFile:"%EXTRACTED_ISO%\sources\install.wim" /Index:1 /MountDir:"%MOUNT_DIR%"
```

## Replace Wallpapers (Optional)

To replace all backgrounds and user profile pictures with solid black images, download [win-wallpaper](https://github.com/amitxv/win-wallpaper/releases) and place the binary in PATH (e.g. ``C:\Windows``) then run the command below. Append ``--win7`` if you are building a Windows 7 ISO.

```bat
win-wallpaper.exe --dir "%MOUNT_DIR%" --rgb #000000 --offline
```

## Integrate and Obtain Drivers (Windows 7)

This step is only required for users configuring Windows 7 so that typically only [NVMe](https://winraid.level1techs.com/t/recommended-ahci-raid-and-nvme-drivers/28310) and [USB](https://winraid.level1techs.com/t/usb-3-0-3-1-drivers-original-and-modded/30871) drivers can be integrated into the ISO to enable us to even physically boot into the ISO. If you are unable to find a USB driver for your HWID, try to integrate the [generic USB driver](https://forums.mydigitallife.net/threads/usb-3-xhci-driver-stack-for-windows-7.81934). Ensure to integrate ``KB2864202`` into the ISO if you use this driver.

You can find drivers by searching for drivers that are compatible with your device's HWID. See [media/device-hwid-example.png](/media/device-hwid-example.png) in regard to finding your HWID in Device Manager for a given device.

Once you have obtained the relevant drivers, place all the drivers to be integrated in a folder such as ``C:\drivers`` and use the command below to integrate them into the mounted ISO.

```bat
DISM /Image:"%MOUNT_DIR%" /Add-Driver /Driver:"C:\drivers" /Recurse /ForceUnsigned
```

## Integrate Updates

- Windows 7 recommended updates:

    ```
    KB4490628 - Servicing Stack Update
    KB4474419 - SHA-2 Code Signing Update
    KB2670838 - Platform Update and DirectX 11.1
    KB2990941 - NVMe Support (https://files.soupcan.tech/KB2990941-NVMe-Hotfix/Windows6.1-KB2990941-x64.msu)
    KB3087873 - NVMe Support and Language Pack Hotfix
    KB2864202 - KMDF Update (required for USB 3/XHCI driver stack)
    KB4534314 - Easy Anti-Cheat Support
    ```

- Windows 8 recommended updates:

    ```
    KB2919442 - Servicing Stack Update
    KB2999226 - Universal C Runtime
    KB2919355 - Cumulative Update
    ```

- Windows 10+ recommended updates:

    - ISOs built with UUP dump already contain the latest updates (assuming the latest version was built) so this step (integrating updates) can be skipped

    - Download the latest update along with the servicing stack for that specific update which is specified in the update page. On Windows 11+, the SSU is included with the ``.msu`` package which can be extracted with 7-Zip as it is not offered separately. Use the official update history page ([Windows 10](https://support.microsoft.com/en-us/topic/windows-10-update-history-93345c32-4ae1-6d1c-f885-6c0b718adf3b), [Windows 11](https://support.microsoft.com/en-us/topic/october-12-2021-kb5006674-os-build-22000-258-32255bb8-6b25-4265-934c-74fdb25f4d35)). Search for the Windows Server update history manually. If using an unsupported Windows version, use the update in which support for the desired edition was dropped as Microsoft still release updates for enterprise editions which are not meant to be installed on client editions as an example

- Download the updates from the [Microsoft update catalog](https://www.catalog.update.microsoft.com/Home.aspx) by searching for the KB identifier. Ensure to download the correct variant that corresponds to the correct edition (server/client) and architecture

- Integrate the updates into the mounted ISO with the command below. The servicing stack must be installed before installing the cumulative updates

    ```bat
    DISM /Image:"%MOUNT_DIR%" /Add-Package /PackagePath=<path\to\update>
    ```

## Enable .NET 3.5 (Windows 8+)

```bat
DISM /Image:"%MOUNT_DIR%" /Enable-Feature /FeatureName:NetFx3 /All /LimitAccess /Source:"%EXTRACTED_ISO%\sources\sxs"
```

## Integrating Required Files

[Clone the repository](https://github.com/amitxv/PC-Tuning/archive/refs/heads/main.zip) and place the ``bin`` folder in the mounted directory. Open the directory with the command below.

```bat
explorer "%MOUNT_DIR%"
```

## Unmount and Commit

Run the command below to commit our changes to the ISO. If you get an error, check if the directory is empty to ensure the ISO is unmounted by typing ``explorer "%MOUNT_DIR%"``. If it is empty, you can likely ignore the error, otherwise try closing all open folders and running the command again.

```bat
DISM /Unmount-Wim /MountDir:"%MOUNT_DIR%" /Commit && rd /s /q "%MOUNT_DIR%"
```

## Replace Windows 7 Boot Wim (Windows 7)

> [!NOTE]
> This step isn't required if you are [installing using DISM Apply-Image (without a USB storage device)](#install-using-dism-apply-image-without-a-usb-storage-device).

 As you are aware, Windows 7 lacks driver support for modern hardware, and you should have already integrated drivers into the ``install.wim``. However, we haven't yet touched the ``boot.wim`` (installer). We could integrate the same drivers into the ``boot.wim`` as we did before. However, this may still lead to a problematic installation. Instead, we can use the Windows 10 ``boot.wim`` which already has modern hardware support to install our Windows 7 ``install.wim``. For this to work properly, you should only have one edition of Windows 7 in your ``install.wim`` which should already be done in the [Remove Non-Essential Editions](#remove-non-essential-editions) section.

- Download the [latest Windows 10 ISO that matches your Windows 7 ISO's language](https://www.microsoft.com/en-us/software-download/windows10) and extract it, It is recommended to rename the extracted folder to avoid confusion. In the examples below, it is extracted it to ``C:\Win10_ISO``

- Replace ``sources\install.wim`` or ``sources\install.esd`` in the extracted Windows 10 ISO with the Windows 7 ``install.wim``

- We need to update a variable since our extracted directory has changed. Enter the path of your new extracted directory, mine is ``C:\Win10_ISO``

    ```bat
    set "EXTRACTED_ISO=C:\Win10_ISO"
    ```

## ISO Compression

Compressing has no advantage other than reducing the size. Keep in mind that Windows setup must decompress the ISO upon installation which takes time. Use the command below to compress the ISO.

```bat
DISM /Export-Image /SourceImageFile:"%EXTRACTED_ISO%\sources\install.wim" /SourceIndex:1 /DestinationImageFile:"%EXTRACTED_ISO%\sources\install.esd" /Compress:recovery /CheckIntegrity && del /f /q "%EXTRACTED_ISO%\sources\install.wim"
```

## Convert to ISO

> [!NOTE]
> This step isn't required if you are [installing using DISM Apply-Image (without a USB storage device)](#install-using-dism-apply-image-without-a-usb-storage-device).

 Use the command below to pack the extracted contents back to a single ISO which will be created in the ``C:\`` drive.

```bat
"%OSCDIMG%" -m -o -u2 -udfver102 -l"Final" -bootdata:2#p0,e,b"%EXTRACTED_ISO%\boot\etfsboot.com"#pEF,e,b"%EXTRACTED_ISO%\efi\microsoft\boot\efisys.bin" "%EXTRACTED_ISO%" "C:\Final.iso"
```

## Boot Into the ISO

For the next steps, you are required to disconnect the Ethernet cable and not be connected to the internet. This will allow us to bypass the forced Microsoft login during OOBE and will prevent Windows from installing unwanted updates and drivers.

As a reminder, your NIC driver may not be packaged with Windows so either download them now and store it offline on the USB or be prepared to download them from another device or dual-boot.

### Install using a USB storage device

- Download [Ventoy](https://github.com/ventoy/Ventoy/releases) and launch ``Ventoy2Disk.exe``. Navigate to the option menu and select the correct partition style and disable secure boot support if it isn't enabled in BIOS, then select your USB storage and click install

    - See [media/identify-bios-mode.png](/media/identify-bios-mode.png)

- Move your Windows ISO into the USB storage in File Explorer

- Boot into Ventoy on your USB in BIOS and select your Windows ISO. Continue with setup as per usual. You may need to enroll a key if secure boot is enabled ([1](https://www.ventoy.net/en/doc_secure.html))

- When installing Windows 8 with a USB, you may be required to enter a key. Use the generic key ``GCRJD-8NW9H-F2CDX-CCM8D-9D6T9`` to bypass this step (this does not activate Windows)

- When installing Win11 with a USB, you may encounter system requirement issues. To bypass the checks, press ``Shift+F10`` to open CMD then type ``regedit`` and add the relevant registry keys listed below

    ```
    [HKEY_LOCAL_MACHINE\SYSTEM\Setup\LabConfig]
    "BypassTPMCheck"=dword:00000001
    "BypassRAMCheck"=dword:00000001
    "BypassSecureBootCheck"=dword:00000001
    ```

### Install using DISM Apply-Image (without a USB storage device)

- Create a new partition by [shrinking a volume](https://docs.microsoft.com/en-us/windows-server/storage/disk-management/shrink-a-basic-volume) if you haven't already, then assign the newly created unallocated space a drive letter

- Extract the ISO if required then run the command below to apply the image. Replace ``<path\to\wim>`` with the path to the ``install.wim`` or ``install.esd``

    - Get all available editions and their corresponding indexes

        ```bat
        DISM /Get-WimInfo /WimFile:<path\to\wim>
        ```

    - Apply image.  Replace ``<index>`` with the index of the desired edition and ``<drive letter>`` with the drive letter you assigned in the previous step for the image to be mounted on (e.g. ``1`` and ``D:``)

        ```bat
        DISM /Apply-Image /ImageFile:<path\to\wim> /Index:<index> /ApplyDir:<drive letter>
        ```

- Create the boot entry with the command below. Replace ``<windir>`` with the path to the mounted ``Windows`` directory (e.g. ``D:\Windows``)

    ```bat
    bcdboot <windir>
    ```

- The installation process will begin after a system restart

---

Continue to [docs/post-install.md](/docs/post-install.md).
