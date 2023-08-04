# Debug Services

## The problem

With the scripts build in the [Configure Services and Drivers](/docs/post-install.md#configure-services-and-drivers) section using [service-list-builder](https://github.com/amitxv/service-list-builder), some specific functionality is broken after running the ``Services-Disable.bat`` script but works as intended after running the ``Services-Enable.bat`` script.

## The solution

Determine what services are dependencies of the functionality that is broken, then contribute by posting an [issue](https://github.com/amitxv/PC-Tuning/issues) describing what functionality was fixed so that the services can be added to the config for the future.

## Methodology

1. If you haven't disabled services at this stage, run the ``Services-Disable.bat`` script

1. Open the ``Services-Enable.bat`` script in a text editor

1. Create a new script named ``Debug-Services.bat``

1. If you have any lines that change the ``LowerFilters`` and/or ``UpperFilters`` registry keys, you will need to handle those first, otherwise, you can continue to step 5. Copy those lines and the line that changes the ``Start`` value for the driver in the filter to the ``Debug-Services.bat`` script

    <details>

    <summary>Example</summary>

    - An example of what the beginning of the ``Services-Enable.bat`` script could look like:

        ```bat
        reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e967-e325-11ce-bfc1-08002be10318}" /v "LowerFilters" /t REG_MULTI_SZ /d "EhStorClass" /f
        reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "LowerFilters" /t REG_MULTI_SZ /d "fvevol\0iorate\0rdyboost" /f
        reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\AarSvc" /v "Start" /t REG_DWORD /d "3" /f
        reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\acpipagr" /v "Start" /t REG_DWORD /d "3" /f
        reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\afunix" /v "Start" /t REG_DWORD /d "1" /f
        reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\ahcache" /v "Start" /t REG_DWORD /d "1" /f
        ...
        ```

    - The lines that must be copied to the ``Debug-Services.bat`` script:

        ```bat
        reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e967-e325-11ce-bfc1-08002be10318}" /v "LowerFilters" /t REG_MULTI_SZ /d "EhStorClass" /f
        reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "LowerFilters" /t REG_MULTI_SZ /d "fvevol\0iorate\0rdyboost" /f
        reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\EhStorClass" /v "Start" /t REG_DWORD /d "0" /f
        reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\fvevol" /v "Start" /t REG_DWORD /d "0" /f
        reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\iorate" /v "Start" /t REG_DWORD /d "0" /f
        reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\rdyboost" /v "Start" /t REG_DWORD /d "0" /f
        ```

    </details>

1. Copy the lines that enable the next 10 services from the ``Services-Enable.bat`` script to the ``Debug-Services.bat`` script

1. Run the ``Debug-Services.bat`` script with NSudo and restart your PC

1. Test the functionality. If it is **NOT** working then return to step 5, otherwise, continue to step 8

1. Disable the last 10 services in the ``Debug-Services.bat`` individually by changing the start value to 4 then restart your PC. Keep repeating until the functionality breaks again

1. Now that you have identified which service breaks the functionality, try to re-enable it. If you can reproduce the functionality breaking while the service is disabled and works with it enabled, make a note of this service and continue to the next step

1. Delete ``Debug-Services.bat`` as it is no longer required

1. The service's dependencies must also be enabled if there are any. For user-mode services, you can use the dependency tree by typing ``services.msc`` in ``Win+R`` then navigating to ``Properties -> Dependencies`` of a service. Kernel-mode services are a bit more tedious as a dependency tree is not available. You will have to manually search for them. Note down all the dependencies

1. Get the default start value for each service that you noted down from the ``Services-Enable.bat`` script then edit the start value in the ``Services-Disable.bat`` script for the corresponding service. Run the ``Services-Disable.bat`` script with NSudo to check whether the functionality is working. If it is not working, return to step 1 and repeat the entire process with the newly edited/latest ``Services-Disable.bat`` script. This is because a service that is required for the functionality might not have any service dependencies

1. Report all the services that you noted down by posting an [issue](https://github.com/amitxv/PC-Tuning/issues) describing what functionality was fixed by enabling the noted services
