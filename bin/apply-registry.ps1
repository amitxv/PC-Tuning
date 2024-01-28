param(
    [Parameter(Mandatory = $true)][ValidateSet(7, 8, 10, 11)]
    [int]$winver
)

$entries = @{
    "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\EOSNotify"                                                                 = @{
        "DiscontinueEOS" = @{
            "min_version" = 7
            "max_version" = 8
            "value"       = 1
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable PC is out of support message")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"                                                                  = @{
        "WUServer"                                     = @{
            "min_version" = 7
            "value"       = " "
            "type"        = "REG_SZ"
            "apply_if"    = @("disable windows update")
        }
        "WUStatusServer"                               = @{
            "min_version" = 7
            "value"       = " "
            "type"        = "REG_SZ"
            "apply_if"    = @("disable windows update")
        }
        "UpdateServiceUrlAlternate"                    = @{
            "min_version" = 7
            "value"       = " "
            "type"        = "REG_SZ"
            "apply_if"    = @("disable windows update")
        }
        "DisableWindowsUpdateAccess"                   = @{
            "min_version" = 7
            "value"       = 1
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows update")
        }
        "DoNotConnectToWindowsUpdateInternetLocations" = @{
            "min_version" = 8
            "value"       = 1
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows update")
        }
        "DisableOSUpgrade"                             = @{
            "min_version" = 8
            "value"       = 1
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows update")
        }
        "SetDisableUXWUAccess"                         = @{
            "min_version" = 10
            "value"       = 1
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows update")
        }
        "ExcludeWUDriversInQualityUpdate"              = @{
            "min_version" = 10
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
            "min_version" = 7
            "value"       = 1
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows update")
        }
        "UseWUServer"  = @{
            "min_version" = 7
            "value"       = 1
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows update")
        }
        "AUOptions"    = @{
            "min_version" = 7
            "value"       = 2
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows update")
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wuauserv"                                                                         = @{
        "Start" = @{
            "min_version" = 7
            "value"       = 4
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows update")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update"                                                = @{
        "IncludeRecommendedUpdates"  = @{
            "min_version" = 7
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows update")
        }
        "SetupWizardLaunchTime"      = @{
            "min_version" = 7
            "type"        = "REG_DELETE"
            "apply_if"    = @("disable windows update")
        }
        "AcceleratedInstallRequired" = @{
            "min_version" = 7
            "type"        = "REG_DELETE"
            "apply_if"    = @("disable windows update")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching"                                                          = @{
        "SearchOrderConfig" = @{
            "min_version" = 7
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @(
                "disable windows update"
                "disable driver installation via windows update"
            )
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata"                                                          = @{
        "PreventDeviceMetadataFromNetwork" = @{
            "min_version" = 7
            "value"       = 1
            "type"        = "REG_DWORD"
            "apply_if"    = @(
                "disable windows update"
                "disable driver installation via windows update"
            )
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DriverSearching"                                                                = @{
        "SearchOrderConfig"       = @{
            "min_version" = 7
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @(
                "disable windows update"
                "disable driver installation via windows update"
            )
        }
        "DontSearchWindowsUpdate" = @{
            "min_version" = 7
            "value"       = 1
            "type"        = "REG_DWORD"
            "apply_if"    = @(
                "disable windows update"
                "disable driver installation via windows update"
            )
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings"                                                                       = @{
        "ExcludeWUDriversInQualityUpdate" = @{
            "min_version" = 7
            "value"       = 1
            "type"        = "REG_DWORD"
            "apply_if"    = @(
                "disable windows update"
                "disable driver installation via windows update"
            )
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"                                                          = @{
        "EnableLUA"                     = @{
            "min_version" = 7
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable user account control")
        }
        "DisableAutomaticRestartSignOn" = @{
            "min_version" = 10
            "value"       = 1
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable sign-in and lock last interactive user after a restart")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance"                                                  = @{
        "MaintenanceDisabled" = @{
            "min_version" = 7
            "value"       = 1
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable automatic maintenance")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Attachments"                                                      = @{
        "SaveZoneInformation" = @{
            "min_version" = 7
            "value"       = 1
            "type"        = "REG_DWORD"
            "apply_if"    = @(
                "disable windows marking file attachments with information about their zone of origin"
            )
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WSearch"                                                                          = @{
        "Start" = @{
            "min_version" = 7
            "value"       = 4
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable search indexing")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\AppCompat"                                                                       = @{
        "DisablePCA" = @{
            "min_version" = 7
            "value"       = 1
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable program compatibility assistant")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\SQMClient\Windows"                                                                               = @{
        "CEIPEnable" = @{
            "min_version" = 7
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable customer experience improvement program")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\SQMClient\Windows"                                                                      = @{
        "CEIPEnable" = @{
            "min_version" = 7
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable customer experience improvement program")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\VSCommon\15.0\SQM"                                                                   = @{
        "OptIn" = @{
            "min_version" = 7
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable customer experience improvement program")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\FTH"                                                                                             = @{
        "Enabled" = @{
            "min_version" = 7
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable fault tolerant heap")
        }
    }
    "HKEY_CURRENT_USER\Control Panel\Accessibility\StickyKeys"                                                                              = @{
        "Flags" = @{
            "min_version" = 7
            "value"       = "506"
            "type"        = "REG_SZ"
            "apply_if"    = @("disable sticky keys")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender"                                                                       = @{
        "DisableAntiSpyware" = @{
            "min_version" = 7
            "value"       = 1
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows defender")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Microsoft Antimalware\Real-Time Protection"                                             = @{
        "DisableScanOnRealtimeEnable" = @{
            "min_version" = 7
            "value"       = 1
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows defender")
        }
        "DisableOnAccessProtection"   = @{
            "min_version" = 7
            "value"       = 1
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows defender")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection"                                                  = @{
        "DisableScanOnRealtimeEnable" = @{
            "min_version" = 7
            "value"       = 1
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows defender")
        }
        "DisableBehaviorMonitoring"   = @{
            "min_version" = 8
            "value"       = 1
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows defender")
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WinDefend"                                                                        = @{
        "Start" = @{
            "min_version" = 7
            "value"       = 4
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows defender")
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wscsvc"                                                                           = @{
        "Start" = @{
            "min_version" = 7
            "value"       = 4
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows defender")
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"                                                       = @{
        "POWERSHELL_TELEMETRY_OPTOUT" = @{
            "min_version" = 7
            "value"       = "1"
            "type"        = "REG_SZ"
            "apply_if"    = @("disable telemetry")
        }
    }
    "HKEY_CURRENT_USER\Control Panel\Mouse"                                                                                                 = @{
        "MouseSpeed"      = @{
            "min_version" = 7
            "value"       = "0"
            "type"        = "REG_SZ"
            "apply_if"    = @("disable pointer acceleration")
        }
        "MouseThreshold1" = @{
            "min_version" = 7
            "value"       = "0"
            "type"        = "REG_SZ"
            "apply_if"    = @("disable pointer acceleration")
        }
        "MouseThreshold2" = @{
            "min_version" = 7
            "value"       = "0"
            "type"        = "REG_SZ"
            "apply_if"    = @("disable pointer acceleration")
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power"                                                                             = @{
        "HibernateEnabled" = @{
            "min_version" = 7
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @(
                "disable hibernation"
                "disable fast startup"
            )
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power"                                                             = @{
        "HiberbootEnabled" = @{
            "min_version" = 7
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable fast startup")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting"                                                                = @{
        "DoReport" = @{
            "min_version" = 7
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows error reporting")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting"                                                        = @{
        "Disabled" = @{
            "min_version" = 7
            "value"       = 1
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows error reporting")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"                                              = @{
        "SystemResponsiveness" = @{
            "min_version" = 7
            "value"       = 10
            "type"        = "REG_DWORD"
            "apply_if"    = @(
                "reserve 10% of CPU resources for low-priority tasks instead of the default 20%"
            )
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Remote Assistance"                                                                 = @{
        "fAllowToGetHelp" = @{
            "min_version" = 7
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable remote assistance")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"                                                         = @{
        "HideFileExt" = @{
            "min_version" = 7
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("show file extensions")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell\EdgeUi"                                                     = @{
        "DisableTLCorner" = @{
            "min_version" = 8
            "max_version" = 8
            "value"       = 1
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable corner navigation")
        }
        "DisableTRCorner" = @{
            "min_version" = 8
            "max_version" = 8
            "value"       = 1
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable corner navigation")
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WdFilter"                                                                         = @{
        "Start" = @{
            "min_version" = 8
            "value"       = 4
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows defender")
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WdBoot"                                                                           = @{
        "Start" = @{
            "min_version" = 8
            "value"       = 4
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows defender")
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WdNisSvc"                                                                         = @{
        "Start" = @{
            "min_version" = 8
            "value"       = 4
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows defender")
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WdNisDrv"                                                                         = @{
        "Start" = @{
            "min_version" = 8
            "value"       = 4
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows defender")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search"                                                                 = @{
        "ConnectedSearchUseWeb" = @{
            "min_version" = 8
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable search the web or display web results in search")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications"                                               = @{
        "NoCloudApplicationNotification" = @{
            "min_version" = 8
            "value"       = 1
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable notifications network usage")
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc"                                                                     = @{
        "Start" = @{
            "min_version" = 10
            "value"       = 4
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows update")
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\UsoSvc"                                                                           = @{
        "Start" = @{
            "min_version" = 10
            "value"       = 4
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows update")
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SecurityHealthService"                                                            = @{
        "Start" = @{
            "min_version" = 10
            "value"       = 4
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows defender")
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Sense"                                                                            = @{
        "Start" = @{
            "min_version" = 10
            "value"       = 4
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows defender")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"                                                                      = @{
        "SecurityHealth"  = @{
            "min_version" = 10
            "type"        = "REG_DELETE"
            "apply_if"    = @("disable windows defender")
        }
        "WindowsDefender" = @{
            "min_version" = 10
            "type"        = "REG_DELETE"
            "apply_if"    = @("disable windows defender")
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity"                             = @{
        "Enabled" = @{
            "min_version" = 10
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows defender")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender\Spynet"                                                                         = @{
        "SpyNetReporting"      = @{
            "min_version" = 10
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows defender")
        }
        "SubmitSamplesConsent" = @{
            "min_version" = 10
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows defender")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"                                                                 = @{
        "SmartScreenEnabled" = @{
            "min_version" = 10
            "value"       = "Off"
            "type"        = "REG_SZ"
            "apply_if"    = @("disable windows defender")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost"                                                                   = @{
        "EnableWebContentEvaluation" = @{
            "min_version" = 10
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows defender")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Edge\SmartScreenEnabled"                                                                          = @{
        "@" = @{
            "min_version" = 10
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows defender")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsRuntime\ActivatableClassId\Windows.Gaming.GameBar.PresenceServer.Internal.PresenceWriter" = @{
        "ActivationType" = @{
            "min_version" = 10
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable gamebarpresencewriter")
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DiagTrack"                                                                        = @{
        "Start" = @{
            "min_version" = 10
            "value"       = 4
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable telemetry")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection"                                                                 = @{
        "AllowTelemetry" = @{
            "min_version" = 10
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable telemetry")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"                                                        = @{
        "AllowOnlineTips" = @{
            "min_version" = 10
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @(
                "disable retrieval of online tips and help in the immersive control panel"
            )
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations"                                              = @{
        ".tif"  = @{
            "min_version" = 10
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
        ".tiff" = @{
            "min_version" = 10
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
        ".bmp"  = @{
            "min_version" = 10
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
        ".dib"  = @{
            "min_version" = 10
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
        ".gif"  = @{
            "min_version" = 10
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
        ".jfif" = @{
            "min_version" = 10
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
        ".jpe"  = @{
            "min_version" = 10
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
        ".jpeg" = @{
            "min_version" = 10
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
        ".jpg"  = @{
            "min_version" = 10
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
        ".jxr"  = @{
            "min_version" = 10
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
        ".png"  = @{
            "min_version" = 10
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Classes\.jpg"                                                                                               = @{
        "@" = @{
            "min_version" = 10
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Classes\.jpeg"                                                                                              = @{
        "@" = @{
            "min_version" = 10
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Classes\.gif"                                                                                               = @{
        "@" = @{
            "min_version" = 10
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Classes\.png"                                                                                               = @{
        "@" = @{
            "min_version" = 10
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Classes\.bmp"                                                                                               = @{
        "@" = @{
            "min_version" = 10
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Classes\.tiff"                                                                                              = @{
        "@" = @{
            "min_version" = 10
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Classes\.ico"                                                                                               = @{
        "@" = @{
            "min_version" = 10
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Classes\.tif"                                                                                               = @{
        "@" = @{
            "min_version" = 10
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Classes\.wdp"                                                                                               = @{
        "@" = @{
            "min_version" = 10
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Classes\.jfif"                                                                                              = @{
        "@" = @{
            "min_version" = 10
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Classes\.dib"                                                                                               = @{
        "@" = @{
            "min_version" = 10
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Classes\.jpe"                                                                                               = @{
        "@" = @{
            "min_version" = 10
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Classes\.jxr"                                                                                               = @{
        "@" = @{
            "min_version" = 10
            "value"       = "PhotoViewer.FileAssoc.Tiff"
            "type"        = "REG_SZ"
            "apply_if"    = @("enable the legacy photo viewer")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Microsoft\input\Settings"                                                                                   = @{
        "InsightsEnabled" = @{
            "min_version" = 10
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable typing insights")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"                                                        = @{
        "EnableTransparency" = @{
            "min_version" = 10
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable transparency")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"                                                                     = @{
        "LetAppsRunInBackground" = @{
            "min_version" = 10
            "value"       = 2
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable background apps")
        }
    }
    "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings"                                                            = @{
        "IsDynamicSearchBoxEnabled" = @{
            "min_version" = 11
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable suggestions in the search box and in search home")
        }
    }
    "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WTDS\Components"                                                          = @{
        "ServiceEnabled" = @{
            "min_version" = 11
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows defender")
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CI\Policy"                                                                         = @{
        "VerifiedAndReputablePolicyState" = @{
            "min_version" = 11
            "value"       = 0
            "type"        = "REG_DWORD"
            "apply_if"    = @("disable windows defender")
        }
    }
    "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\PriorityControl"                                                                   = @{
        "Win32PrioritySeparation" = @{
            "min_version" = 7

            "value"       = 38
            "type"        = "REG_DWORD"
            "apply_if"    = @("allocate processor resources primarily to programs")
        }
    }
}

function Is-Admin() {
    $current_principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $current_principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Apply-Registry($file_path) {
    if (!(Test-Path $file_path)) {
        return 1
    }

    $user_merge_result = (Start-Process "reg.exe" -ArgumentList "import $($file_path)" -PassThru -Wait -WindowStyle Hidden).ExitCode
    $trustedinstaller_merge_result = [int](.\MinSudo.exe --NoLogo --TrustedInstaller --Privileged cmd /c "reg import $($file_path) > nul 2>&1 && echo 0 || echo 1")

    return $user_merge_result -band $trustedinstaller_merge_result
}

function main() {
    if (-not (Is-Admin)) {
        Write-Host "error: administrator privileges required"
        return 1
    }

    Set-Location $PSScriptRoot

    if (-not (Test-Path "reg-config.json")) {
        Write-Host "error: reg-config.json not found"
        return 1
    }

    if (-not (Test-Path "MinSudo.exe")) {
        Write-Host "error: MinSudo.exe not found"
        return 1
    }

    # contains keys to apply after all version filtering and config validation
    $filtered_entries = @{}

    $config = Get-Content -Path "reg-config.json" -Raw | ConvertFrom-Json

    # track seen options to find unrecognized options in reg-config.json
    $seen_options = New-Object System.Collections.Generic.HashSet[string]
    $missing_options = New-Object System.Collections.Generic.HashSet[string]

    $config_errors = 0

    Write-Host "info: parsing config"

    foreach ($path in $entries.Keys) {
        foreach ($key_name in $entries[$path].Keys) {
            $key = $entries[$path][$key_name]

            $apply_key = $false

            foreach ($apply_if_option in $key["apply_if"]) {
                # add option to set in order to keep track of what options have been seen so far
                $seen_options.Add($apply_if_option)

                $option_exists_in_config = $config.options.PSObject.Properties.Match($apply_if_option).Count -gt 0

                if (-not $option_exists_in_config) {
                    # prevents duplicate error messages
                    if (-not $missing_options.Contains($apply_if_option)) {
                        Write-Host "error: `"$($apply_if_option)`" option missing in config"
                        $config_errors++
                        $missing_options.Add($apply_if_option)
                    }
                } else {
                    if ($config.options.$apply_if_option) {
                        $apply_key = $true
                    }
                }
            }

            $min_version = $key["min_version"]
            # unspecified max_version implies unlimited
            $max_version = if ($key.Contains("max_version")) { $key["max_version"] } else { $winver + 1 }

            # skip if key doesn't meet the version criteria

            if ($apply_key -and ($winver -ge $min_version -and $winver -le $max_version)) {
                if (-not $filtered_entries.Contains($path)) {
                    $filtered_entries.Add($path, @{ $key_name = $key })
                } else {
                    $filtered_entries[$path].Add($key_name, $key)
                }
            }
        }
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

    # registry file header and clear previous contents
    Set-Content -Path "$($env:temp)\tmp.reg" -Value "Windows Registry Editor Version 5.00`n"

    foreach ($path in $filtered_entries.Keys) {
        Add-Content -Path "$($env:temp)\tmp.reg" -Value "[$($path)]"

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

            Add-Content -Path "$($env:temp)\tmp.reg" -Value $line
        }

        # new line between paths
        Add-Content -Path "$($env:temp)\tmp.reg" -Value ""
    }

    if ($has_error) {
        return 1
    }

    $merge_result = Apply-Registry -file_path "$($env:temp)\tmp.reg"

    Write-Host "$(if ($merge_result) {"error: failed"} else {"info: succeeded"}) merging registry settings for windows $($winver)"
    return $merge_result
}

exit main
