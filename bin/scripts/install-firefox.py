import ctypes
import hashlib
import io
import json
import os
import subprocess
from typing import Union

import requests


def is_valid_connection() -> bool:
    try:
        requests.get("https://archlinux.org", timeout=5)
    except OSError:
        return False
    return True


def fetch_SHA256(version: str) -> Union[str, None]:
    response = requests.get(
        f"https://mediacdn.prod.productdelivery.prod.webservices.mozgcp.net/pub/firefox/releases/{version}/SHA256SUMS",
        timeout=5,
    )

    for line in io.StringIO(response.text):
        checksum, file_name = line.strip("\n").split(" ", 1)

        if file_name.strip() == f"win64/en-US/Firefox Setup {version}.exe":
            return checksum

    return None


def main() -> None:
    if not ctypes.windll.shell32.IsUserAnAdmin():
        print("error: administrator privileges required")
        return

    print("info: checking for an internet connection")
    if not is_valid_connection():
        print("error: no internet connection")
        return

    stdnull = {"stdout": subprocess.DEVNULL, "stderr": subprocess.DEVNULL}
    setup = f"{os.environ['TEMP']}\\FirefoxSetup.exe"
    install_dir = "C:\\Program Files\\Mozilla Firefox"

    latest_version = (
        requests.get("https://product-details.mozilla.org/1.0/firefox_versions.json")
        .json()
        .get("LATEST_FIREFOX_VERSION")
    )

    if latest_version is None:
        print("error: unable to get latest version number")
        return

    # if firefox is already installed, exit if it is already the latest
    if os.path.exists(f"{install_dir}\\firefox.exe"):
        process = subprocess.run(
            [f"{install_dir}\\firefox.exe", "--version", "|", "more"],
            capture_output=True,
            check=False,
            universal_newlines=True,
        )
        local_version = process.stdout.split()[-1]

        if local_version == latest_version:
            print(f"info: latest version ({latest_version}) already installed")
            return

    print(f"info: downloading firefox {latest_version} setup")

    response = requests.get("https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US")

    # check SHA256
    SHA256 = hashlib.sha256(response.content).hexdigest()

    if SHA256 != fetch_SHA256(latest_version):
        print("error: hash mismatch")
        return

    with open(setup, "wb") as file:
        file.write(response.content)

    subprocess.run(["taskkill", "/F", "/IM", "firefox.exe"], **stdnull, check=False)

    print("info: installing")
    subprocess.run([setup, "/S", "/MaintenanceService=false"], check=False)

    if os.path.exists(setup):
        os.remove(setup)

    # remove bloatware
    for file in (
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
        "update-settings.ini",
    ):
        file = f"{install_dir}\\{file}"
        if os.path.exists(file):
            os.remove(file)

    # create policies.json
    os.makedirs(f"{install_dir}\\distribution", exist_ok=True)

    with open(f"{install_dir}\\distribution\\policies.json", "w", encoding="utf-8") as file:
        json.dump(
            {
                "policies": {
                    "DisableAppUpdate": True,
                    "OverrideFirstRunPage": "",
                    "Extensions": {
                        "Install": [
                            "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/11423598-latest.xpi",
                            "https://addons.mozilla.org/firefox/downloads/latest/fastforwardteam/17032224-latest.xpi",
                        ]
                    },
                }
            },
            file,
            indent=4,
        )

    # create autoconfig.js to load firefox.cfg
    with open(f"{install_dir}\\defaults\\pref\\autoconfig.js", "w", encoding="utf-8", newline="\n") as file:
        file.write('pref("general.config.filename", "firefox.cfg");\n')
        file.write('pref("general.config.obscure_value", 0);\n')

    # write prefs to firefox.cfg
    with open(f"{install_dir}\\firefox.cfg", "w", encoding="utf-8") as file:
        file.write('\ndefaultPref("app.shield.optoutstudies.enabled", false)\n')
        file.write('defaultPref("datareporting.healthreport.uploadEnabled", false)\n')
        file.write('defaultPref("browser.newtabpage.activity-stream.feeds.section.topstories", false)\n')
        file.write('defaultPref("browser.newtabpage.activity-stream.feeds.topsites", false)\n')
        file.write('defaultPref("dom.security.https_only_mode", true)\n')
        file.write('defaultPref("browser.uidensity", 1)\n')
        file.write('defaultPref("full-screen-api.transition-duration.enter", "0 0")\n')
        file.write('defaultPref("full-screen-api.transition-duration.leave", "0 0")\n')
        file.write('defaultPref("full-screen-api.warning.timeout", 0)\n')
        file.write('defaultPref("nglayout.enable_drag_images", false)\n')
        file.write('defaultPref("reader.parse-on-load.enabled", false)\n')
        file.write('defaultPref("browser.tabs.firefox-view", false)\n')
        file.write('defaultPref("browser.tabs.tabmanager.enabled", false)\n')

    print(f"info: release notes: https://www.mozilla.org/en-US/firefox/{latest_version}/releasenotes")


if __name__ == "__main__":
    main()
