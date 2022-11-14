import sys
import ctypes
import os
import subprocess
import textwrap
import hashlib
import json
import requests

def main() -> int:
    """program entrypoint"""

    if not ctypes.windll.shell32.IsUserAnAdmin():
        print("error: administrator privileges required")
        return 1

    print("info: checking for an internet connection")
    try:
        requests.get("https://archlinux.org", timeout=3)
    except requests.ConnectionError:
        print("error: no internet connection")
        return 1

    subprocess_null = {"stdout": subprocess.DEVNULL, "stderr": subprocess.DEVNULL}
    setup = f"{os.environ['TEMP']}\\FirefoxSetup.exe"
    download_link = "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US"
    install_dir = "C:\\Program Files\\Mozilla Firefox"
    policies = f"{install_dir}\\distribution\\policies.json"
    autoconfig = f"{install_dir}\\defaults\\pref\\autoconfig.js"
    firefox_cfg = f"{install_dir}\\firefox.cfg"
    latest_firefox_version = requests.get("https://product-details.mozilla.org/1.0/firefox_versions.json", timeout=3).json()["LATEST_FIREFOX_VERSION"]
    setup_sha256 = requests.get(f"https://mediacdn.prod.productdelivery.prod.webservices.mozgcp.net/pub/firefox/releases/{latest_firefox_version}/SHA256SUMS", timeout=3).text

    remove_files = [
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
    ]

    policies_content = {
        "policies": {
            "DisableAppUpdate": True,
            "OverrideFirstRunPage": "",
            "Extensions": {
                "Install": [
                    "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"
                ]
            }
        }
    }

    autoconfig_content = """    pref("general.config.filename", "firefox.cfg");
    pref("general.config.obscure_value", 0);
    """

    firefox_cfg_content = """
    defaultPref("dom.security.https_only_mode", true);
    defaultPref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
    defaultPref("browser.newtabpage.activity-stream.feeds.topsites", false);
    defaultPref("browser.newtabpage.activity-stream.section.highlights.includeBookmarks", false);
    defaultPref("browser.newtabpage.activity-stream.section.highlights.includeDownloads", false);
    defaultPref("browser.newtabpage.activity-stream.section.highlights.includePocket", false);
    defaultPref("browser.newtabpage.activity-stream.section.highlights.includeVisited", false);
    defaultPref("browser.newtabpage.pinned", "[]");
    defaultPref("browser.newtabpage.activity-stream.showSponsored", false);
    defaultPref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
    defaultPref("browser.newtabpage.activity-stream.feeds.section.highlights", false);
    defaultPref("app.shield.optoutstudies.enabled", false);
    defaultPref("browser.discovery.enabled", false);
    defaultPref("datareporting.healthreport.uploadEnabled", false);
    defaultPref("browser.uidensity", 1);
    defaultPref("full-screen-api.transition-duration.enter", "0 0");
    defaultPref("full-screen-api.transition-duration.leave", "0 0");
    defaultPref("full-screen-api.warning.timeout", 0);
    defaultPref("nglayout.enable_drag_images", false);
    defaultPref("browser.search.suggest.enabled", false);
    defaultPref("reader.parse-on-load.enabled", false);
    defaultPref("beacon.enabled", false);
    defaultPref("datareporting.policy.dataSubmissionEnabled", false);
    """

    try:
        process = subprocess.run(["C:\\Program Files\\Mozilla Firefox\\firefox.exe", "--version", "|", "more"], capture_output=True, check=False, universal_newlines=True)
        local_version = process.stdout.split()[-1]

        if all([latest_firefox_version, local_version]) and local_version == latest_firefox_version:
            print(f"info: latest version {latest_firefox_version} already installed")
            return 0
    except FileNotFoundError:
        pass

    if os.path.exists(setup):
        os.remove(setup)

    print(f"info: downloading firefox {latest_firefox_version} setup")
    with open(setup, "wb") as f:
        f.write(requests.get(download_link, timeout=5).content)

    try:
        with open(setup, "rb") as f:
            file_bytes = f.read()
            sha256 = hashlib.sha256(file_bytes).hexdigest()

            if sha256 not in setup_sha256:
                print("error: hash mismatch, corrupted download")
                return 1
    except FileNotFoundError:
        print("error: download unsuccessful")
        return 1

    subprocess.run(["taskkill", "/F", "/IM", "Firefox.exe"], **subprocess_null, check=False)

    print("info: installing firefox")
    subprocess.run([setup, "/S", "/MaintenanceService=false"], check=False)

    print("info: removing bloatware")
    for file in remove_files:
        file = f"{install_dir}\\{file}"
        if os.path.exists(file):
            os.remove(file)

    # remove files before creating them again
    for file in [setup, policies, autoconfig, firefox_cfg]:
        if os.path.exists(file):
            os.remove(file)

    print("info: importing policies.json")
    os.makedirs(f"{install_dir}\\distribution", exist_ok=True)

    with open(policies, "a", encoding="UTF-8") as f:
        json.dump(policies_content, f, indent=4)

    print("info: importing autoconfig.js")
    with open(autoconfig, "a", encoding="UTF-8", newline="\n") as f:
        f.writelines(textwrap.dedent(autoconfig_content))

    print("info: importing firefox.cfg")
    with open(firefox_cfg, "a", encoding="UTF-8") as f:
        f.writelines(textwrap.dedent(firefox_cfg_content))

    print("info: done")

    return 0

if __name__ == "__main__":
    sys.exit(main())
