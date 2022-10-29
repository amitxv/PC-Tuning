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
    "mobsync"
    "smartscreen"
    "wsclient"
    "wscollect"
    "comppkgsrv"
    "upfc"
    # "applocker"
    # "autologger"
    # "devicecensus"
    # "dmclient"
    # "enhancedstorage"
    # "hotspot"
    # "invagent"
    "sihclient"
    # "startupscan"
    # "waas"
    # "wsqmcons"
    "onedrive"
    "mcupdate_authenticamd"
    "mcupdate_genuineintel"
    "skype"
    "edge"
    "securitycenter"
)

rm -rf Program\ Files/WindowsApps/*
rm -rf ProgramData/Packages/!("MicrosoftWindows.Client.CBS_cw5n1h2txyewy")
rm -rf Users/*/AppData/Local/Microsoft/WindowsApps/!("MicrosoftWindows.Client.CBS_cw5n1h2txyewy")
rm -rf Users/*/AppData/Local/Packages/!("Microsoft.Windows.ShellExperienceHost_cw5n1h2txyewy"|"windows.immersivecontrolpanel_cw5n1h2txyewy"|"MicrosoftWindows.Client.CBS_cw5n1h2txyewy")
rm -rf Windows/SystemApps/!("ShellExperienceHost_cw5n1h2txyewy"|"Microsoft.UI.Xaml.CBS_8wekyb3d8bbwe"|"MicrosoftWindows.Client.CBS_cw5n1h2txyewy"|"MicrosoftWindows.Client.Core_cw5n1h2txyewy")
rm -rf "Program Files/Windows Defender"
rm -rf "Program Files (x86)/Windows Defender"
rm -rf "Program Files/Windows Defender Advanced Threat Protection"
rm -rf "Windows/System32/SecurityHealthAgent.dll"
rm -rf "Windows/System32/SecurityHealthService.exe"
rm -rf "Windows/System32/SecurityHealthSystray.exe"

for i in "${wildcard_names[@]}"
do
    echo info: removing $i
    find . -ipath "*$i*" -not -ipath "./prerequisites/*" -delete
done

# echo info: searching for files that are supposed to be removed...
# echo info: if any file paths appear below any searching message, it is likely that the process failed

# for i in "${wildcard_names[@]}"
# do
#     echo info: searching for $i
#     find . -ipath "*$i*" -not -ipath "./prerequisites/*"
# done

echo info: done
exit 0
