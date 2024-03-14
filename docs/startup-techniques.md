# Startup Techniques

This document outlines a technique to start applications at startup that is compatible with both [User Account Control (UAC)](https://learn.microsoft.com/en-us/windows/security/application-security/application-control/user-account-control/how-it-works#the-uac-user-experience) enabled and disabled.

## Table of Contents

- [Usage](#usage)
- [Why a Script?](#why-a-script)

## Usage

1. Save the script below somewhere safe such as ``C:\startup.bat``

    ```bat
    @echo off
    :: request administrator privileges
    DISM >nul 2>&1 || (
        PowerShell Start -Verb RunAs '%0' 2> nul || (
            echo error: right-click on the "%~f0" script and select "Run as administrator"
            pause
        )
        exit /b 1
    )

    :: start applications
    ```

2. Type ``shell:startup`` in ``Win+R`` and create a shortcut to the script. Optionally set the ``Run`` property on the shortcut to ``Minimized``

3. Under the *start applications* comment, use the [start](https://ss64.com/nt/start.html) command to start applications. For future reference, keep appending to this script to start applications at startup

    - As a random example, appending ``start C:\Windows\notepad.exe`` to this script will start notepad each time the system starts

    - For PowerShell commands and scripts, use ``PowerShell "<command>"`` or ``PowerShell "<script_path>"``

4. Verify whether the applications start at startup after restarting the system in case of unexpected behavior

## Why a Script?

The script above is compatible with configurations that either have UAC enabled or disabled. See the notes below.

- When UAC is enabled and an application that requests a higher execution level is placed in ``shell:startup``, Windows simply does not start the application. The UAC prompt does not even pop up so the application will never start. The script above requests elevation at runtime which circumvents this.

- Task Scheduler can be used to start applications at startup with administrator privileges silently but is excluded as a technique as the service may be disabled in the [Configure Services and Drivers](/docs/post-install.md#configure-services-and-drivers) section
