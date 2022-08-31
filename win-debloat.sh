# inspired by the AME bash script
# https://ameliorated.info/

cd "$(dirname "$0")"
shopt -s extglob

if [[ -d "Program Files" ]] && [[ -d "Windows/System32" ]]
then
    echo info: valid windows installation detected, continuing
else
    echo error: directory does not appear to be the root directory of a windows installation
    exit 1
fi

wildcard_names=(
    "flashplayer"
    "backgroundtaskhost"
    "gamebarpresencewriter"
    "mobsync"
    "smartscreen"
    "wsclient"
    "wscollect"
    "searchui"
    "comppkgsrv"
    "upfc"
    "applocker"
    "autologger"
    "clipsvc"
    "clipup"
    "DeliveryOptimization"
    "DeviceCensus"
    "diagtrack"
    "dmclient"
    "dosvc"
    "EnhancedStorage"
    "hotspot"
    "invagent"
    "msra"
    "sihclient"
    "slui"
    "startupscan"
    "storsvc"
    "usoapi"
    "usoclient"
    "usosvc"
    "WaaS"
    "windowsmaps"
    "windowsupdate"
    "wsqmcons"
    "wua"
    "wus"
    "defender"
    "onedrive"
    "mcupdate_AuthenticAMD"
    "mcupdate_GenuineIntel"
    "skype"
    "microsoftedge"
    "edge"
    "usocore"
    "usocoreworker"
    "securitycenter"
)

rm -rf "Program Files/WindowsApps"
rm -rf "ProgramData/Packages"
rm -rf Users/*/AppData/Local/Microsoft/WindowsApps
rm -rf Users/*/AppData/Local/Packages/!("Microsoft.Windows.ShellExperienceHost_cw5n1h2txyewy"|"windows.immersivecontrolpanel_cw5n1h2txyewy")
rm -rf Windows/SystemApps/!("ShellExperienceHost_cw5n1h2txyewy")
rm -rf "Program Files/Windows Defender"
rm -rf "Program Files (x86)/Microsoft"
rm -rf "Program Files (x86)/Windows Defender"
rm -rf "Program Files/Windows Defender Advanced Threat Protection"
rm -rf Windows/System32/wua*
rm -rf Windows/System32/wups*
rm -rf "Windows/diagnostics/system/Apps"
rm -rf "Windows/diagnostics/system/WindowsUpdate"
rm -rf "Windows/System32/smartscreenps.dll"
rm -rf "Windows/System32/SecurityHealthAgent.dll"
rm -rf "Windows/System32/SecurityHealthService.exe"
rm -rf "Windows/System32/SecurityHealthSystray.exe"
rm -rf Windows/WinSxS/Temp/PendingDeletes/*

for i in "${wildcard_names[@]}"
do
    echo info: removing $i
    find . -ipath "*$i*" -delete
done

echo info: searching for files that are supposed to be removed...
echo info: if any file paths appear below any searching message, it is likely that the process failed

for i in "${wildcard_names[@]}"
do
    echo info: searching for $i
    find . -iname *$i*
done

echo info: done
exit 0
