param(
    [switch]$force,
    [switch]$skip_hash_check,
    [string]$lang = "en-GB",
    [string]$version
)

Add-Type -AssemblyName System.Web.Extensions

$web_client = New-Object System.Net.WebClient
$serializer = New-Object System.Web.Script.Serialization.JavaScriptSerializer
$hash_algorithm = New-Object -TypeName System.Security.Cryptography.SHA512CryptoServiceProvider

function Convert-To-Json($item) {
    return $serializer.Serialize($item)
}

function Get-SHA512($file) {
    $hash = [System.BitConverter]::ToString($hash_algorithm.ComputeHash([System.IO.File]::ReadAllBytes($file)))
    $ret = @{"Algorithm" = "SHA512"
        "Path"           = $file
        "Hash"           = $hash.Replace("-", "")
    }

    return $ret
}

function Fetch-SHA512($source, $file_name) {
    try {
        $response = $web_client.DownloadString($source)
    } catch [System.Management.Automation.MethodInvocationException] {
        Write-Host "error: unable to fetch hash data, consider -skip_hash_check"
        exit 1
    }

    $response = $response.split("`n")

    foreach ($line in $response) {
        $split_line = $line.Split(" ", 2)
        $hash = $split_line[0]
        $current_file_name = $split_line[1].Trim()

        if ($null -ne $hash -and $null -ne $current_file_name) {
            if ($current_file_name -eq $file_name) {
                return $hash
            }
        }
    }
    return $null
}

function Is-Admin() {
    $current_principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $current_principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function main() {
    if (-not (Is-Admin)) {
        Write-Host "error: administrator privileges required"
        return 1
    }

    # silently try to enforce Tls

    try {
        # not available on Windows 7 by default
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls2
    } catch {
        try {
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls
        } catch {
            # ignore
        }
    }

    try {
        $response = $web_client.DownloadString("https://product-details.mozilla.org/1.0/firefox_versions.json")
    } catch [System.Management.Automation.MethodInvocationException] {
        Write-Host "error: failed to fetch json data, check internet connection and try again"
        return 1
    }

    $firefox = $serializer.DeserializeObject($response)
    $setup_file = "$($Env:temp)\FirefoxSetup.exe"

    $remote_version = if ($version) { $version } else { $firefox["LATEST_FIREFOX_VERSION"] }
    $download_url = "https://releases.mozilla.org/pub/firefox/releases/$($remote_version)/win64/$($lang)/Firefox%20Setup%20$($remote_version).exe"
    $install_dir = "C:\Program Files\Mozilla Firefox"
    $hash_source = "https://ftp.mozilla.org/pub/firefox/releases/$($remote_version)/SHA512SUMS"

    # check if currently installed version is already latest
    if (Test-Path "$($install_dir)\firefox.exe" -PathType Leaf) {
        $local_version = (Get-Item "$($install_dir)\firefox.exe").VersionInfo.ProductVersion

        if ($local_version -eq $remote_version) {
            Write-Host "info: Mozilla Firefox $($remote_version) already installed"

            if ($force) {
                Write-Host "warning: -force specified, proceeding anyway"
            } else {
                return 1
            }
        }
    }

    Write-Host "info: downloading firefox $($remote_version) setup"
    $web_client.DownloadFile($download_url, $setup_file)

    if (-not $skip_hash_check) {
        $local_SHA512 = (Get-SHA512 -file $setup_file).Hash
        $remote_SHA512 = Fetch-SHA512 -source $hash_source -file_name "win64/$($lang)/Firefox Setup $($remote_version).exe"

        if ($local_SHA512 -ne $remote_SHA512) {
            Write-Host "error: hash mismatch"
            return 1
        }
    }

    Write-Host "info: installing firefox"
    Stop-Process -Name "firefox" -ErrorAction SilentlyContinue

    try {
        Start-Process -FilePath $setup_file -ArgumentList "/S /MaintenanceService=false" -Wait
    } Catch [System.InvalidOperationException] {
        Write-Host "error: failed to download setup file"
        return 1
    }

    if (Test-Path $setup_file -PathType Leaf) {
        Remove-Item $setup_file
    }

    $remove_files = @(
        "crashreporter.exe",
        "crashreporter.ini",
        "defaultagent.ini",
        "defaultagent_localized.ini",
        "default-browser-agent.exe",
        "maintenanceservice.exe",
        "maintenanceservice_installer.exe",
        "pingsender.exe",
        "updater.exe",
        "updater.ini",
        "update-settings.ini"
    )

    foreach ($file in $remove_files) {
        $file = "$($install_dir)\$($file)"
        if (Test-Path $file -PathType Leaf) {
            Remove-Item $file
        }
    }

    # create policies.json
    (New-Item -Path "$($install_dir)" -Name "distribution" -ItemType "directory" -Force) 2>&1 > $null

    $policies = Convert-To-Json(@{
            policies = @{
                DisableAppUpdate     = $true
                OverrideFirstRunPage = ""
                Extensions           = @{
                    Install = @("https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/11423598-latest.xpi", "https://addons.mozilla.org/firefox/downloads/file/4177101/fastforwardteam-0.2334.xpi")
                }
            }
        })

    $autoconfig = @(
        "pref(`"general.config.filename`", `"firefox.cfg`");",
        "pref(`"general.config.obscure_value`", 0);"
    ) -join "`n"

    $firefox_config =
    "`r`ndefaultPref(`"app.shield.optoutstudies.enabled`", false)`
defaultPref(`"datareporting.healthreport.uploadEnabled`", false)`
defaultPref(`"browser.newtabpage.activity-stream.feeds.section.topstories`", false)`
defaultPref(`"browser.newtabpage.activity-stream.feeds.topsites`", false)`
defaultPref(`"dom.security.https_only_mode`", true)`
defaultPref(`"browser.uidensity`", 1)`
defaultPref(`"full-screen-api.transition-duration.enter`", `"0 0`")`
defaultPref(`"full-screen-api.transition-duration.leave`", `"0 0`")`
defaultPref(`"full-screen-api.warning.timeout`", 0)`
defaultPref(`"nglayout.enable_drag_images`", false)`
defaultPref(`"reader.parse-on-load.enabled`", false)`
defaultPref(`"browser.tabs.firefox-view`", false)`
defaultPref(`"browser.tabs.tabmanager.enabled`", false)`
lockPref(`"browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons`", false)`
lockPref(`"browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features`", false)"

    Set-Content -Path "$($install_dir)\distribution\policies.json" -Value $($policies)
    [System.IO.File]::WriteAllText("$($install_dir)\defaults\pref\autoconfig.js", $($autoconfig), [System.Text.Encoding]::ASCII)
    Set-Content -Path "$install_dir\firefox.cfg" -Value $($firefox_config)

    Write-Host "info: release notes: https:/www.mozilla.org/en-US/firefox/$($remote_version)/releasenotes"

    return 0
}

exit main
