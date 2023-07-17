# Build Instructions

## Build Requirements

- Extraction tool - [7-Zip](https://www.7-zip.org) recommended

- [Windows ADK](https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install) - Install Deployment Tools

- [win-wallpaper](https://github.com/amitxv/win-wallpaper/releases) - Place the binary in PATH (e.g. ``C:\Windows``)

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

    - [New Download Links](https://docs.google.com/spreadsheets/d/1zTF5uRJKfZ3ziLxAZHh47kF85ja34_OFB5C5bVSPumk)

    - [Adguard File List](https://files.rg-adguard.net)

    - [Microsoft Software Download Listing](https://ave9858.github.io/msdl)

    - [Fido](https://github.com/pbatard/Fido)

    - [UUP dump](https://uupdump.net) (Windows 10 1709+)
        <details>
        <summary>Instructions</summary>

        - Search for the Windows version you desire and download the latest feature update instance

            <img src="/media/uupdump-search-image.png" width="750">

        - Choose the desired language and click next

            <img src="/media/uupdump-choose-language.png" width="750">

        - Uncheck all editions except the professional edition and click next

            <img src="/media/uupdump-choose-edition.png" width="750">

        - Copy the configuration below, ensure that ``Include updates`` is ticked and click ``Create download package``

            <img src="/media/uupdump-download-options.png" width="750">

        - Extract the downloaded package and run ``uup_download_windows.cmd``. The final ISO file will be created in the same directory as the script

        </details>

## Prepare the Build Environment

- Open CMD as administrator and do not close the window as we will be setting temporary environment variables which will be unbound when the session is ended

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
    where win-wallpaper.exe > nul 2>&1 && echo true || echo false
    ```

## Remove Non-Essential Editions

Remove every edition except the desired edition by retrieving the indexes of every other edition and removing them with the commands below. Once completed, the only edition to exist should be the desired edition at index 1.

- Recommended editions:

    - Client editions: Professional

    - Server editions: Standard (Desktop Experience)

- Get all available editions and indexes

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

## Replace Wallpapers

Run the command below to replace all backgrounds and user profile pictures with solid black images. Use the ``--win7`` argument if building a Windows 7 ISO.

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

    - Download the latest non-security cumulative update along with the servicing stack for that specific update (specified in the update page). The update page should also specify whether the update is non-security or a security update, if it does not, then download the latest update. Most of the time you can search for *"security"* for each update. Use the official update history page ([Windows 10](https://support.microsoft.com/en-us/topic/windows-10-update-history-93345c32-4ae1-6d1c-f885-6c0b718adf3b), [Windows 11](https://support.microsoft.com/en-us/topic/october-12-2021-kb5006674-os-build-22000-258-32255bb8-6b25-4265-934c-74fdb25f4d35)). Search for the server update history manually as it gets moved to a separate page when the client equivalent reaches end-of-life

- Download the updates from the [Microsoft update catalog](https://www.catalog.update.microsoft.com/Home.aspx) by searching for the KB identifier. Ensure to download the correct variant that corresponds to the correct edition (server/client) and architecture

- Integrate the updates into the mounted ISO with the command below. The servicing stack must be installed before installing the cumulative updates

    ```bat
    DISM /Image:"%MOUNT_DIR%" /Add-Package /PackagePath=<path\to\update>
    ```

## Enable .NET 3.5 (Windows 8+)

```bat
DISM /Image:"%MOUNT_DIR%" /Enable-Feature /FeatureName:NetFx3 /All /LimitAccess /Source:"%EXTRACTED_ISO%\sources\sxs"
```

## Enable Legacy Components for Older Applications (Windows 8+)

```bat
DISM /Image:"%MOUNT_DIR%" /Enable-Feature /FeatureName:DirectPlay /All
```

## Integrating Required Files

[Clone the repository](https://github.com/amitxv/PC-Tuning/archive/refs/heads/main.zip) and place the ``bin`` folder and ``win-debloat.sh`` script in the mounted directory. Open the directory with the command below.

```bat
explorer "%MOUNT_DIR%"
```

## Unmount and Commit

Run the command below to commit our changes to the ISO. If you get an error, check if the directory is empty to ensure the ISO is unmounted by typing ``explorer "%MOUNT_DIR%"``. If it is empty, you can likely ignore the error, otherwise try closing all open folders and running the command again.

```bat
DISM /Unmount-Wim /MountDir:"%MOUNT_DIR%" /Commit && rd /s /q "%MOUNT_DIR%"
```

## Replace Windows 7 Boot Wim (Windows 7)

This step isn't required if you are [installing using DISM Apply-Image](/docs/pre-install.md#boot-into-the-iso). As you are aware, Windows 7 lacks driver support for modern hardware, and you should have already integrated drivers into the ``install.wim``. However, we haven't yet touched the ``boot.wim`` (installer). We could integrate the same drivers into the ``boot.wim`` as we did before. However, this may still lead to a problematic installation. Instead, we can use the Windows 10 ``boot.wim`` which already has modern hardware support to install our Windows 7 ``install.wim``. For this to work properly, you should only have one edition of Windows 7 in your ``install.wim`` which should already be done in the [Remove Non-Essential Editions](#remove-non-essential-editions) section.

- Download the [latest Windows 10 ISO that matches your Windows 7 ISO's language](https://www.microsoft.com/en-us/software-download/windows10) and extract it, It is recommended to rename the extracted folder to avoid confusion. In the examples below, I have extracted it to ``C:\Win10_ISO``

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

This step isn't required if you are [installing using DISM Apply-Image](/docs/pre-install.md#boot-into-the-iso). Use the command below to pack the extracted contents back to a single ISO which will be created on the desktop.

```bat
"%OSCDIMG%" -m -o -u2 -udfver102 -l"FINAL" -bootdata:2#p0,e,b"%EXTRACTED_ISO%\boot\etfsboot.com"#pEF,e,b"%EXTRACTED_ISO%\efi\microsoft\boot\efisys.bin" "%EXTRACTED_ISO%" "%userprofile%\Desktop\FINAL.iso"
```

## Cleanup

Optionally uninstall the programs and remove the binaries installed in the [Build Requirements](#build-requirements) section if you do not plan on building another ISO anytime soon.

---

Continue to [docs/pre-install.md](/docs/pre-install.md#prepare-the-usb).
