# Build Instructions

## Build Requirements

- [7-Zip](https://www.7-zip.org)
- [win-wallpaper](https://github.com/amitxv/win-wallpaper/releases) - place the program in ``C:\Windows``
- Deployment Tools from the [Windows ADK](https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install)

## Download Stock ISOs

Ensure to cross-check the hashes for the ISO to verify that it is genuine and not corrupted (not required when building an ISO from UUP dump). Use the command ``certutil -hashfile <path\to\file>`` to get the hash of the ISO file.

- Recommended ISOs:

    - Windows 7: **en_windows_7_professional_with_sp1_x64_dvd_u_676939.iso** - [Adguard ISO hashes](https://files.rg-adguard.net/file/11ad6502-c2aa-261c-8c3f-c81477b21dd2)
    - Windows 8: **en_windows_8.1_with_update_x64_dvd_6051480.iso** - [Adguard ISO hashes](https://files.rg-adguard.net/file/feeb8cae-fb0b-42b9-6f69-50c71f0e5415)
    - Windows 10+: Try to obtain an ISO with minimal updates

- ISO Sources:

    - [MVS Collection](https://isofiles.bd581e55.workers.dev)
    - [New Download Links](https://docs.google.com/spreadsheets/d/1zTF5uRJKfZ3ziLxAZHh47kF85ja34_OFB5C5bVSPumk/edit)
    - [UUP dump](https://uupdump.net)

## Prepare the Build Environment

- Extract the contents of the ISO to a directory of your choice with 7-Zip, In the examples below, I am using ``C:\en_windows_7_professional_with_sp1_x64_dvd_u_676939``

    ```bat
    set "EXTRACTED_ISO=C:\en_windows_7_professional_with_sp1_x64_dvd_u_676939"
    set "MOUNT_DIR=%temp%\MOUNT_DIR"
    set "OSCDIMG=C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\oscdimg.exe"

    if exist "%MOUNT_DIR%" (rd /s /q "%MOUNT_DIR%")
    mkdir "%MOUNT_DIR%"
    ```

- If the environment variables are configured correctly, the commands below should return **true**

    ```bat
    if exist "%EXTRACTED_ISO%\sources\install.wim" (echo true) else (echo false)
    if exist "%MOUNT_DIR%" (echo true) else (echo false)
    if exist "%OSCDIMG%" (echo true) else (echo false)
    where win-wallpaper.exe > nul 2>&1 && echo true || echo false
    ```

## Remove Non-Essential Editions

Remove every edition except the desired edition (professional edition recommended) by retrieving the indexes of every other edition and removing them with the commands below. Once completed, the only edition to exist should be the desired edition at index 1.

- Get all available editions and indexes

    ```bat
    DISM /Get-WimInfo /WimFile:"%EXTRACTED_ISO%\sources\install.wim"
    ```
- Remove edition by index

    ```bat
    DISM /Delete-Image /ImageFile:"%EXTRACTED_ISO%\sources\install.wim" /Index:<index>
    ```

## Mount the ISO

```bat
DISM /Mount-Wim /WimFile:"%EXTRACTED_ISO%\sources\install.wim" /Index:1 /MountDir:"%MOUNT_DIR%"
```

## Integrate Updates

- Windows 7 recommended updates:

    ```
    KB4490628 - Servicing Stack Update
    KB4474419 - SHA-2 Code Signing Update
    KB2670838 - Platform Update and DirectX 11.1
    KB2990941 - NVME Support (https://files.soupcan.tech/KB2990941-NVMe-Hotfix/Windows6.1-KB2990941-x64.msu)
    KB3087873 - NVME Support and Language Pack Hotfix
    KB2864202 - KMDF Update (required for USB 3/XHCI driver stack)
    KB4534314 - Easy Anti-Cheat Support
    ```

- Windows 8+ recommended updates:

    - Download the latest non-security cumulative update along with the servicing stack for that specific update (specified in the update page). The update page should also specify if the update is non-security or a security update, if it does not, then download the latest update. Use the official update history page ([Windows 8](https://support.microsoft.com/en-us/topic/july-21-2016-kb3172614-dcf9bea5-47b0-b574-2929-4f9e130f5192), [Windows 10](https://support.microsoft.com/en-us/topic/windows-10-update-history-93345c32-4ae1-6d1c-f885-6c0b718adf3b))

- Download the updates from the [Microsoft update catalog](https://www.catalog.update.microsoft.com/Home.aspx) by searching for the KB identifier. Place the updates somewhere easily accessible such as ``C:\updates``

- Integrate the updates into the mounted ISO with the command below. The servicing stack must be installed before installing the cumulative updates

    ```bat
    DISM /Image:"%MOUNT_DIR%" /Add-Package /PackagePath=<path\to\update>
    ```

## Enable .NET 3.5 (Windows 8+)

```bat
DISM /Image:"%MOUNT_DIR%" /Enable-Feature /FeatureName:NetFx3 /All /LimitAccess /Source:"%EXTRACTED_ISO%\sources\sxs"
```

## Enable Legacy Components for Older Games (Windows 8+)


```bat
DISM /Image:"%MOUNT_DIR%" /Enable-Feature /FeatureName:DirectPlay /All
 ```

## Remove Provisioned Appx Bloatware (Windows 8+)

This command removes the majority of Windows apps that nobody uses and potentially jeopardizes privacy such as Microsoft Store, maps, camera.

```bat
for /f "tokens=3" %i in ('DISM /Image:"%MOUNT_DIR%" /Get-ProvisionedAppxPackages ^| findstr "PackageName"') do (DISM /Image:"%MOUNT_DIR%" /Remove-ProvisionedAppxPackage /PackageName:%i)
```

## Integrate and Obtain Drivers

As mentioned previously, this step is generally only required for users configuring Windows 7 so that the ISO can be equipped with modern hardware support. Typically, only NVME and USB drivers are required to boot into the desktop, other drivers can be installed later in the [post-installation instructions](./post-install.md#install-drivers).

- You can usually find drivers by searching or asking others for drivers that are compatible with your device HWID

    - See [media/device-hwid-example.png](../media/device-hwid-example.png)

- [Win-Raid USB driver collection](https://winraid.level1techs.com/t/usb-3-0-3-1-drivers-original-and-modded/30871)

    - If you can not find a USB driver, try using the [generic USB driver](https://forums.mydigitallife.net/threads/usb-3-xhci-driver-stack-for-windows-7.81934)

- [Win-Raid AHCI and NVME driver collection](https://winraid.level1techs.com/t/recommended-ahci-raid-and-nvme-drivers/28310)

- Place all of the drivers to be integrated somewhere easily accessible such as ``C:\drivers`` and use the command below to integrate them into the mounted ISO

    ```bat
    DISM /Image:"%MOUNT_DIR%" /Add-Driver /Driver:"C:\drivers" /Recurse /ForceUnsigned
    ```

## Replace Wallpapers

Run the command below to replace all backgrounds and user profile pictures with solid black images. Use the **--win7** argument if building Windows 7.

```bat
win-wallpaper.exe --dir "%MOUNT_DIR%" --rgb #000000
```

## Integrating Required Files

Clone the repository and place the **prerequisites** folder and **win-debloat.sh** script in the mounted directory. Open the mounted directory with the command below.

```bat
explorer "%MOUNT_DIR%"
```

## Unmount and Commit

Run the command below twice to commit our changes to the ISO.

```bat
DISM /Unmount-Wim /MountDir:"%MOUNT_DIR%" /Commit && rd /s /q "%MOUNT_DIR%"
```

## Replace Windows 7 Boot Wim (Windows 7)

This step is not required if you are [installing using DISM Apply-Image](./pre-install.md#booting-into-the-iso). As you are aware, Windows 7 lacks driver support for modern hardware and you should have already integrated drivers into the **install.wim** however we have not yet touched the **boot.wim** (installer). We could integrate the same drivers into the **boot.wim** as we did before however this may still lead to a problematic installation. Instead, we can use the Windows 10 **boot.wim** which already has modern hardware support to install our Windows 7 **install.wim**. For this to work properly, you should only have one edition of Windows 7 in your **install.wim** which should already have been done in the [Stripping Non-Essential Editions](#stripping-non-essential-editions) section.

- Download the [latest Windows 10 ISO that matches your Windows 7 ISO's language](https://www.microsoft.com/en-gb/software-download/windows10) and extract it, I would recommend renaming the extracted folder to avoid confusion. In the examples below, I have extracted it to ``C:\W10_ISO``

- Replace ``sources\install.wim`` or ``sources\install.esd`` in the extracted Windows 10 ISO with the Windows 7 **install.wim**

- We need to update a variable since our extracted directory has changed. Enter the path of your new extracted directory, mine is ``C:\W10_ISO``

    ```bat
    set "EXTRACTED_ISO=C:\W10_ISO"
    ```
## Insert DISM Apply-Image Script

Use the command below to open the extracted directory, place the **install.bat** script and the **bypass-windows11-checks.reg** registry file in the directory.

```bat
explorer "%EXTRACTED_ISO%"
```

## ISO Compression (Optional)

Use the command below to compress the ISO, this may take a while.

```bat
DISM /Export-Image /SourceImageFile:"%EXTRACTED_ISO%\sources\install.wim" /SourceIndex:1 /DestinationImageFile:"%EXTRACTED_ISO%\sources\install.esd" /Compress:recovery /CheckIntegrity && del /f /q "%EXTRACTED_ISO%\sources\install.wim"
```

## Convert to ISO

This step is not required if you are [installing using DISM Apply-Image](./pre-install.md#boot-into-the-iso). Use the command below to convert the extracted ISO to an ISO file which will be created on the desktop.

```bat
"%OSCDIMG%" -m -o -u2 -udfver102 -l"FINAL" -bootdata:2#p0,e,b"%EXTRACTED_ISO%\boot\etfsboot.com"#pEF,e,b"%EXTRACTED_ISO%\efi\microsoft\boot\efisys.bin" "%EXTRACTED_ISO%" "%userprofile%\Desktop\FINAL.iso"
```
