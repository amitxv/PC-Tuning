param(
    [switch]$force
)

Add-Type -AssemblyName System.Web.Extensions
$web_client = New-Object System.Net.WebClient
$serializer = New-Object System.Web.Script.Serialization.JavaScriptSerializer

function is_admin() {
    $current_principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $current_principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (!(is_admin)) {
    Write-Host "error: administrator privileges required"
    exit
}

try {
    $response = $web_client.DownloadString("https://raw.githubusercontent.com/ScoopInstaller/Extras/master/bucket/firefox.json")
}
catch {
    Write-Host "error: failed to fetch json data, check internet connection and try again"
    exit
}

$firefox = $serializer.DeserializeObject($response)
$remote_version = $firefox["version"]
$setup_file = "$Env:temp\FirefoxSetup.exe"
$download_url = $firefox["architecture"]["64bit"]["url"]
$remote_SHA512 = $firefox["architecture"]["64bit"]["hash"].replace("sha512:", "")
$install_dir = "C:\Program Files\Mozilla Firefox"

# check if currently installed version is already latest
if (Test-Path "$install_dir\firefox.exe" -PathType Leaf) {
    $local_version = (& "$install_dir\firefox.exe" --version | more).Split()[2]
    
    if ($local_version -eq $remote_version) {
        Write-Host "info: latest version $remote_version already installed"
        
        if ($force) {
            Write-Host "warning: -force specified, proceeding anyway"
        }
        else {
            exit
        }
    }
}

Write-Host "info: downloading firefox $remote_version setup"
$web_client.DownloadFile($download_url, $setup_file)

$local_SHA512 = (Get-FileHash -Path $setup_file -Algorithm SHA512).Hash

if ($local_SHA512 -ne $remote_SHA512) {
    Write-Host "error: hash mismatch"
    exit
}

Write-Host "info: installing firefox"
Stop-Process -Name "firefox" -ErrorAction SilentlyContinue
Start-Process -FilePath $setup_file -ArgumentList "/S /MaintenanceService=false" -Wait

if (Test-Path $setup_file -PathType Leaf) {
    Remove-Item $setup_file
}

foreach ($file in @(
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
    )) {
    $file = "$install_dir\$file"
    if (Test-Path $file -PathType Leaf) {
        Remove-Item $file
    }
}

# create policies.json
New-Item -Path "$install_dir" -Name "distribution" -ItemType "directory" -Force | Out-Null

Set-Content -Path "$install_dir\distribution\policies.json" -Value (@{
        policies = @{
            DisableAppUpdate     = $true
            OverrideFirstRunPage = ""
            Extensions           = @{
                Install = @("https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/11423598-latest.xpi")
            }
        }
    } | ConvertTo-Json -Depth 100)

Set-Content -Path "$install_dir\defaults\pref\autoconfig.js" -Value (@(
        "pref(`"general.config.filename`", `"firefox.cfg`");",
        "pref(`"general.config.obscure_value`", 0);"
    ) -join "`n"
) -NoNewLine

Set-Content -Path "$install_dir\firefox.cfg" -Value (
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
defaultPref(`"browser.tabs.tabmanager.enabled`", false)" 
)

Write-Host "info: release notes: https:/www.mozilla.org/en-US/firefox/$latest_version/releasenotes"
