param(
    [string]$get_option_keys
)

$entries = @{
    "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\EOSNotify"                                                                 = @{
        "DiscontinueEOS" = @{
            "max_version" = 9600
            "value"       = 1
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable PC is out of support message")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"                                                                  = @{
        "WUServer"                                     = @{
            "value"    = " "
            "type"     = "REG_SZ"
            "apply_if" = @("disable windows update")
        }
        "WUStatusServer"                               = @{
            "value"    = " "
            "type"     = "REG_SZ"
            "apply_if" = @("disable windows update")
        }
        "UpdateServiceUrlAlternate"                    = @{
            "value"    = " "
            "type"     = "REG_SZ"
            "apply_if" = @("disable windows update")
        }
        "DisableWindowsUpdateAccess"                   = @{
            "value"    = 1
            "type"     = "REG_DWORD"
            "apply_if" = @("disable windows update")
        }
        "DoNotConnectToWindowsUpdateInternetLocations" = @{
            "min_version" = 9600
            "value"       = 1
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows update")
        }
        "DisableOSUpgrade"                             = @{
            "min_version" = 9200
            "value"       = 1
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows update")
        }
        "SetDisableUXWUAccess"                         = @{
            "min_version" = 10240
            "value"       = 1
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows update")
        }
        "ExcludeWUDriversInQualityUpdate"              = @{
            "min_version" = 10240
            "value"       = 1
            "type"        = "REG_DWORD"
            "apply_if"    = @(
                "disable windows update"
                "disable driver installation via windows update"
            )
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"                                                               = @{
        "NoAutoUpdate" = @{
            "value"    = 1
            "type"     = "REG_DWORD"
            "apply_if" = @(
                "disable windows update"
                "disable automatic windows updates"
            )
        }
        "UseWUServer"  = @{
            "value"    = 1
            "type"     = "REG_DWORD"
            "apply_if" = @("disable windows update")
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wuauserv"                                                                         = @{
        "Start" = @{
            "value"    = 4
            "type"     = "REG_DWORD"
            "apply_if" = @("disable windows update")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update"                                                = @{
        # not the same as "Configure Automatic Updates" policy. this key seems to be exclusive to Windows 7/8
        "AUOptions"                  = @{
            "max_version" = 9600
            "value"       = 1
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows update")
        }
        "SetupWizardLaunchTime"      = @{
            "max_version" = 9600
            "type"        = "REG_DELETE"
            "apply_if"    = @("disable windows update")
        }
        "AcceleratedInstallRequired" = @{
            "max_version" = 9600
            "type"        = "REG_DELETE"
            "apply_if"    = @("disable windows update")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching"                                                          = @{
        "SearchOrderConfig" = @{
            "value"    = 0
            "type"     = "REG_DWORD"
            "apply_if" = @(
                "disable windows update"
                "disable driver installation via windows update"
            )
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata"                                                          = @{
        "PreventDeviceMetadataFromNetwork" = @{
            "value"    = 1
            "type"     = "REG_DWORD"
            "apply_if" = @(
                "disable windows update"
                "disable driver installation via windows update"
            )
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DriverSearching"                                                                = @{
        "SearchOrderConfig"       = @{
            "value"    = 0
            "type"     = "REG_DWORD"
            "apply_if" = @(
                "disable windows update"
                "disable driver installation via windows update"
            )
        }
        "DontSearchWindowsUpdate" = @{
            "value"    = 1
            "type"     = "REG_DWORD"
            "apply_if" = @(
                "disable windows update"
                "disable driver installation via windows update"
            )
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings"                                                                       = @{
        "ExcludeWUDriversInQualityUpdate" = @{
            "value"    = 1
            "type"     = "REG_DWORD"
            "apply_if" = @(
                "disable windows update"
                "disable driver installation via windows update"
            )
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"                                                          = @{
        "EnableLUA"                     = @{
            "value"    = 0
            "type"     = "REG_DWORD"
            "apply_if" = @("disable user account control")
        }
        "DisableAutomaticRestartSignOn" = @{
            "min_version" = 18362
            "value"       = 1
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable sign-in and lock last interactive user after a restart")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance"                                                  = @{
        "MaintenanceDisabled" = @{
            "value"    = 1
            "type"     = "REG_DWORD"
            "apply_if" = @("disable automatic maintenance")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Attachments"                                                      = @{
        "SaveZoneInformation" = @{
            "value"    = 1
            "type"     = "REG_DWORD"
            "apply_if" = @(
                "disable windows marking file attachments with information about their zone of origin"
            )
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WSearch"                                                                          = @{
        "Start" = @{
            "value"    = 4
            "type"     = "REG_DWORD"
            "apply_if" = @("disable search indexing")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\AppCompat"                                                                       = @{
        "DisablePCA" = @{
            "value"    = 1
            "type"     = "REG_DWORD"
            "apply_if" = @("disable program compatibility assistant")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\SQMClient\Windows"                                                                               = @{
        "CEIPEnable" = @{
            "value"    = 0
            "type"     = "REG_DWORD"
            "apply_if" = @("disable customer experience improvement program")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\SQMClient\Windows"                                                                      = @{
        "CEIPEnable" = @{
            "value"    = 0
            "type"     = "REG_DWORD"
            "apply_if" = @("disable customer experience improvement program")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\VSCommon\15.0\SQM"                                                                   = @{
        "OptIn" = @{
            "value"    = 0
            "type"     = "REG_DWORD"
            "apply_if" = @("disable customer experience improvement program")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\FTH"                                                                                             = @{
        "Enabled" = @{
            "value"    = 0
            "type"     = "REG_DWORD"
            "apply_if" = @("disable fault tolerant heap")
        }
    }
    "HKEY_CURRENT_USER\Control Panel\Accessibility\StickyKeys"                                                                              = @{
        "Flags" = @{
            "value"    = "506"
            "type"     = "REG_SZ"
            "apply_if" = @("disable sticky keys")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender"                                                                       = @{
        "DisableAntiSpyware" = @{
            "value"    = 1
            "type"     = "REG_DWORD"
            "apply_if" = @("disable windows defender")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Microsoft Antimalware\Real-Time Protection"                                             = @{
        "DisableScanOnRealtimeEnable" = @{
            "value"    = 1
            "type"     = "REG_DWORD"
            "apply_if" = @("disable windows defender")
        }
        "DisableOnAccessProtection"   = @{
            "value"    = 1
            "type"     = "REG_DWORD"
            "apply_if" = @("disable windows defender")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection"                                                  = @{
        "DisableScanOnRealtimeEnable" = @{
            "value"    = 1
            "type"     = "REG_DWORD"
            "apply_if" = @("disable windows defender")
        }
        "DisableBehaviorMonitoring"   = @{
            "min_version" = 9200
            "value"       = 1
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows defender")
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WinDefend"                                                                        = @{
        "Start" = @{
            "value"    = 4
            "type"     = "REG_DWORD"
            "apply_if" = @("disable windows defender")
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wscsvc"                                                                           = @{
        "Start" = @{
            "value"    = 4
            "type"     = "REG_DWORD"
            "apply_if" = @("disable windows defender")
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"                                                       = @{
        "POWERSHELL_TELEMETRY_OPTOUT" = @{
            "value"    = "1"
            "type"     = "REG_SZ"
            "apply_if" = @("disable telemetry")
        }
    }
    "HKEY_CURRENT_USER\Control Panel\Mouse"                                                                                                 = @{
        "MouseSpeed"      = @{
            "value"    = "0"
            "type"     = "REG_SZ"
            "apply_if" = @("disable pointer acceleration")
        }
        "MouseThreshold1" = @{
            "value"    = "0"
            "type"     = "REG_SZ"
            "apply_if" = @("disable pointer acceleration")
        }
        "MouseThreshold2" = @{
            "value"    = "0"
            "type"     = "REG_SZ"
            "apply_if" = @("disable pointer acceleration")
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power"                                                                             = @{
        "HibernateEnabled" = @{
            "value"    = 0
            "type"     = "REG_DWORD"
            "apply_if" = @(
                "disable hibernation"
                "disable fast startup"
            )
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power"                                                             = @{
        "HiberbootEnabled" = @{
            "value"    = 0
            "type"     = "REG_DWORD"
            "apply_if" = @("disable fast startup")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting"                                                                = @{
        "DoReport" = @{
            "value"    = 0
            "type"     = "REG_DWORD"
            "apply_if" = @("disable windows error reporting")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting"                                                        = @{
        "Disabled" = @{
            "value"    = 1
            "type"     = "REG_DWORD"
            "apply_if" = @("disable windows error reporting")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"                                              = @{
        "SystemResponsiveness" = @{
            "value"    = 10
            "type"     = "REG_DWORD"
            "apply_if" = @(
                "reserve 10% of CPU resources for low-priority tasks instead of the default 20%"
            )
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Remote Assistance"                                                                 = @{
        "fAllowToGetHelp" = @{
            "value"    = 0
            "type"     = "REG_DWORD"
            "apply_if" = @("disable remote assistance")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"                                                         = @{
        "HideFileExt" = @{
            "value"    = 0
            "type"     = "REG_DWORD"
            "apply_if" = @("show file extensions")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell\EdgeUi"                                                     = @{
        "DisableTLCorner" = @{
            "min_version" = 9200
            "max_version" = 9600
            "value"       = 1
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable corner navigation")
        }
        "DisableTRCorner" = @{
            "min_version" = 9200
            "max_version" = 9600
            "value"       = 1
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable corner navigation")
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WdFilter"                                                                         = @{
        "Start" = @{
            "min_version" = 9200
            "value"       = 4
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows defender")
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WdBoot"                                                                           = @{
        "Start" = @{
            "min_version" = 9200
            "value"       = 4
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows defender")
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WdNisSvc"                                                                         = @{
        "Start" = @{
            "min_version" = 9200
            "value"       = 4
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows defender")
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WdNisDrv"                                                                         = @{
        "Start" = @{
            "min_version" = 9200
            "value"       = 4
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows defender")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search"                                                                 = @{
        "ConnectedSearchUseWeb" = @{
            "min_version" = 9600
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable search the web or display web results in search")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications"                                               = @{
        "NoCloudApplicationNotification" = @{
            "min_version" = 9200
            "value"       = 1
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable notifications network usage")
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc"                                                                     = @{
        "Start" = @{
            "min_version" = 10240
            "value"       = 4
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows update")
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\UsoSvc"                                                                           = @{
        "Start" = @{
            "min_version" = 10240
            "value"       = 4
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows update")
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SecurityHealthService"                                                            = @{
        "Start" = @{
            "min_version" = 10240
            "value"       = 4
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows defender")
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Sense"                                                                            = @{
        "Start" = @{
            "min_version" = 10240
            "value"       = 4
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows defender")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"                                                                      = @{
        "SecurityHealth"  = @{
            "min_version" = 10240
            "type"        = "REG_DELETE"
            "apply_if"    = @("disable windows defender")
        }
        "WindowsDefender" = @{
            "min_version" = 10240
            "type"        = "REG_DELETE"
            "apply_if"    = @("disable windows defender")
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity"                             = @{
        "Enabled" = @{
            "min_version" = 10240
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows defender")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender\Spynet"                                                                         = @{
        "SpyNetReporting"      = @{
            "min_version" = 10240
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows defender")
        }
        "SubmitSamplesConsent" = @{
            "min_version" = 10240
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows defender")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"                                                                 = @{
        "SmartScreenEnabled" = @{
            "min_version" = 10240
            "value"       = "Off"
            "type"        = "REG_SZ"
            "apply_if"    = @("disable windows defender")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost"                                                                   = @{
        "EnableWebContentEvaluation" = @{
            "min_version" = 10240
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows defender")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Edge\SmartScreenEnabled"                                                                          = @{
        "@" = @{
            "min_version" = 10240
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows defender")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsRuntime\ActivatableClassId\Windows.Gaming.GameBar.PresenceServer.Internal.PresenceWriter" = @{
        "ActivationType" = @{
            "min_version" = 10240
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable gamebarpresencewriter")
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DiagTrack"                                                                        = @{
        "Start" = @{
            "min_version" = 10240
            "value"       = 4
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable telemetry")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection"                                                                 = @{
        "AllowTelemetry" = @{
            "min_version" = 10240
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable telemetry")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"                                                        = @{
        "AllowOnlineTips" = @{
            "min_version" = 16299
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @(
                "disable retrieval of online tips and help in the immersive control panel"
            )
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations"                                              = @{
        ".tif"  = @{
            "min_version" = 10240
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
        ".tiff" = @{
            "min_version" = 10240
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
        ".bmp"  = @{
            "min_version" = 10240
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
        ".dib"  = @{
            "min_version" = 10240
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
        ".gif"  = @{
            "min_version" = 10240
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
        ".jfif" = @{
            "min_version" = 10240
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
        ".jpe"  = @{
            "min_version" = 10240
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
        ".jpeg" = @{
            "min_version" = 10240
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
        ".jpg"  = @{
            "min_version" = 10240
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
        ".jxr"  = @{
            "min_version" = 10240
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
        ".png"  = @{
            "min_version" = 10240
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Classes\.jpg"                                                                                               = @{
        "@" = @{
            "min_version" = 10240
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Classes\.jpeg"                                                                                              = @{
        "@" = @{
            "min_version" = 10240
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Classes\.gif"                                                                                               = @{
        "@" = @{
            "min_version" = 10240
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Classes\.png"                                                                                               = @{
        "@" = @{
            "min_version" = 10240
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Classes\.bmp"                                                                                               = @{
        "@" = @{
            "min_version" = 10240
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Classes\.tiff"                                                                                              = @{
        "@" = @{
            "min_version" = 10240
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Classes\.ico"                                                                                               = @{
        "@" = @{
            "min_version" = 10240
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Classes\.tif"                                                                                               = @{
        "@" = @{
            "min_version" = 10240
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Classes\.wdp"                                                                                               = @{
        "@" = @{
            "min_version" = 10240
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Classes\.jfif"                                                                                              = @{
        "@" = @{
            "min_version" = 10240
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Classes\.dib"                                                                                               = @{
        "@" = @{
            "min_version" = 10240
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Classes\.jpe"                                                                                               = @{
        "@" = @{
            "min_version" = 10240
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Classes\.jxr"                                                                                               = @{
        "@" = @{
            "min_version" = 10240
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Microsoft\input\Settings"                                                                                   = @{
        "InsightsEnabled" = @{
            "min_version" = 10240
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable typing insights")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"                                                        = @{
        "EnableTransparency" = @{
            "min_version" = 10240
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable transparency")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"                                                                     = @{
        "LetAppsRunInBackground" = @{
            "min_version" = 10240
            "value"       = 2
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable background apps")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings"                                                            = @{
        "IsDynamicSearchBoxEnabled" = @{
            "min_version" = 22000
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable suggestions in the search box and in search home")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WTDS\Components"                                                          = @{
        "ServiceEnabled" = @{
            "min_version" = 22000
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows defender")
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CI\Policy"                                                                         = @{
        "VerifiedAndReputablePolicyState" = @{
            "min_version" = 22000
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows defender")
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\PriorityControl"                                                                   = @{
        "Win32PrioritySeparation" = @{
            "value"    = 38
            "type"     = "REG_DWORD"
            "apply_if" = @("allocate processor resources primarily to programs")
        }
    }
}

function Is-Admin() {
    $current_principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $current_principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Apply-Registry($file_path) {
    if (-not (Test-Path $file_path)) {
        return 1
    }

    $user_merge_result = (Start-Process "reg.exe" -ArgumentList "import $($file_path)" -PassThru -Wait -WindowStyle Hidden).ExitCode
    $trustedinstaller_merge_result = [int](.\MinSudo.exe --NoLogo --TrustedInstaller --Privileged cmd /c "reg import $($file_path) > nul 2>&1 && echo 0 || echo 1")

    return $user_merge_result -band $trustedinstaller_merge_result
}

function main() {
    $windows_build = [System.Environment]::OSVersion.Version.Build

    switch ($windows_build) {
        { $_ -ge 22000 } { $major_build = 11; break }
        { $_ -ge 10240 } { $major_build = 10; break }
        { $_ -ge 9600 } { $major_build = 8.1; break }
        { $_ -ge 9200 } { $major_build = 8; break }
        { $_ -ge 7600 } { $major_build = 7; break }
        default {
            Write-Host "error: unrecognized windows build $($windows_build)"
        }
    }

    if ($get_option_keys) {
        Write-Host "info: showing entries associated with option `"$($get_option_keys)`" on windows $($major_build)`n"

        foreach ($path in $entries.Keys) {
            foreach ($key_name in $entries[$path].Keys) {
                $key = $entries[$path][$key_name]

                # unspecified versions implies that they key should be applied to all versions
                $min_version = if ($key.Contains("min_version")) { $key["min_version"] } else { $windows_build }
                $max_version = if ($key.Contains("max_version")) { $key["max_version"] } else { $windows_build }

                if (-not ($windows_build -ge $min_version -and $windows_build -le $max_version)) { continue }

                if ($key["apply_if"].Contains($get_option_keys)) {
                    Write-Host "`"$($path)`" `"$($key_name)`" $($key["type"]) $($key["value"])"
                }
            }
        }

        return 0
    }

    if (-not (Is-Admin)) {
        Write-Host "error: administrator privileges required"
        return 1
    }

    Set-Location $PSScriptRoot

    if (-not (Test-Path "registry-options.json")) {
        Write-Host "error: registry-options.json not found"
        return 1
    }

    if (-not (Test-Path "MinSudo.exe")) {
        Write-Host "error: MinSudo.exe not found"
        return 1
    }



    # contains keys to apply after all version filtering and config validation
    $filtered_entries = @{}

    $config = Get-Content -Path "registry-options.json" -Raw | ConvertFrom-Json

    # track seen options to find unrecognized options in registry-options.json
    $seen_options = New-Object System.Collections.Generic.HashSet[string]
    $undefined_options = New-Object System.Collections.Generic.HashSet[string]

    Write-Host "info: parsing config"

    foreach ($path in $entries.Keys) {
        foreach ($key_name in $entries[$path].Keys) {
            $key = $entries[$path][$key_name]

            $apply_key = $false

            foreach ($apply_if_option in $key["apply_if"]) {
                # add option to set in order to keep track of what options have been seen so far
                $seen_options.Add($apply_if_option)

                $is_option_defined = $config.options.PSObject.Properties.Match($apply_if_option).Count -gt 0

                if (-not $is_option_defined) {
                    $undefined_options.Add($apply_if_option)
                } else {
                    $apply_key = $config.options.$apply_if_option
                }
            }

            # unspecified versions implies that they key should be applied to all versions
            $min_version = if ($key.Contains("min_version")) { $key["min_version"] } else { $windows_build }
            $max_version = if ($key.Contains("max_version")) { $key["max_version"] } else { $windows_build }

            # check if key meets the version criteria
            $apply_key = $apply_key -and ($windows_build -ge $min_version -and $windows_build -le $max_version)

            if ($apply_key) {
                if (-not $filtered_entries.Contains($path)) {
                    $filtered_entries.Add($path, @{ $key_name = $key })
                } else {
                    $filtered_entries[$path].Add($key_name, $key)
                }
            }
        }
    }

    $config_errors = 0

    foreach ($option in $undefined_options) {
        Write-Host "error: `"$($option)`" option missing in config"
        $config_errors++
    }

    foreach ($option in $config.options.PSObject.Properties) {
        if (-not ($seen_options.Contains($option.Name))) {
            Write-Host "error: `"$($option.Name)`" unrecognized in config"
            $config_errors++
        }
    }

    if ($config_errors -gt 0) {
        Write-Host "error: resolve $($config_errors) errors in config"
        return 1
    }

    Write-Host "info: creating registry file"

    $has_error = $false
    $registry_file = "$($env:temp)\tmp.reg"

    # registry file header and clear previous contents
    Set-Content -Path $registry_file -Value "Windows Registry Editor Version 5.00`n"

    foreach ($path in $filtered_entries.Keys) {
        Add-Content -Path $registry_file -Value "[$($path)]"

        foreach ($key_name in $filtered_entries[$path].Keys) {
            $key = $filtered_entries[$path][$key_name]

            $line = "`"$($key_name)`""

            switch ($key["type"]) {
                "REG_DWORD" {
                    $hex_value = "{0:X8}" -f $key["value"]
                    $line += "=dword:$($hex_value)"
                }
                "REG_SZ" {
                    $line += "=`"$($key["value"])`""
                }
                "REG_DELETE" {
                    $line += "-"
                }
                default {
                    Write-Host "error: unrecognized type $($key["type"]) for key $($key_name)"
                    $has_error = $true
                }
            }

            Add-Content -Path $registry_file -Value $line
        }

        # new line between paths
        Add-Content -Path $registry_file -Value ""
    }

    if ($has_error) {
        return 1
    }

    $merge_result = Apply-Registry -file_path $registry_file

    Write-Host "$(if ($merge_result) {"error: failed"} else {"info: succeeded"}) merging registry settings for windows $($major_build)"
    return $merge_result
}

$_exit_code = main
Write-Host # new line
exit $_exit_code
