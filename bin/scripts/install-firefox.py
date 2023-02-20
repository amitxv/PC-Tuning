import ctypes
import hashlib
import json
import os
import ssl
import subprocess
import textwrap
from urllib import error, request


def main() -> None:
    if not ctypes.windll.shell32.IsUserAnAdmin():
        print("error: administrator privileges required")
        return

    # https://stackoverflow.com/questions/50236117/scraping-ssl-certificate-verify-failed-error-for-http-en-wikipedia-org
    ssl._create_default_https_context = ssl._create_unverified_context

    print("info: checking for an internet connection")
    try:
        request.urlopen("https://archlinux.org")
    except error.URLError:
        print("error: no internet connection")
        return

    stdnull = {"stdout": subprocess.DEVNULL, "stderr": subprocess.DEVNULL}
    setup = f"{os.environ['TEMP']}\\FirefoxSetup.exe"
    download_link = "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US"
    install_dir = "C:\\Program Files\\Mozilla Firefox"
    policies = f"{install_dir}\\distribution\\policies.json"
    autoconfig = f"{install_dir}\\defaults\\pref\\autoconfig.js"
    firefox_cfg = f"{install_dir}\\firefox.cfg"

    with request.urlopen("https://product-details.mozilla.org/1.0/firefox_versions.json") as url:
        latest_firefox_version = json.loads(url.read().decode())["LATEST_FIREFOX_VERSION"]

    with request.urlopen(
        f"https://mediacdn.prod.productdelivery.prod.webservices.mozgcp.net/pub/firefox/releases/{latest_firefox_version}/SHA256SUMS"
    ) as url:
        setup_sha256 = url.read().decode("utf-8")

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
        "update-settings.ini",
    ]

    policies_content = {
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
    }

    autoconfig_content = """    pref("general.config.filename", "firefox.cfg");
    pref("general.config.obscure_value", 0);
    """

    firefox_cfg_content = """
    defaultPref("app.shield.optoutstudies.enabled", false);
    defaultPref("datareporting.healthreport.uploadEnabled", false); 
    defaultPref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
    defaultPref("browser.newtabpage.activity-stream.feeds.topsites", false); 
    defaultPref("dom.security.https_only_mode", true);
    defaultPref("browser.uidensity", 1);
    defaultPref("full-screen-api.transition-duration.enter", "0 0");
    defaultPref("full-screen-api.transition-duration.leave", "0 0");
    defaultPref("full-screen-api.warning.timeout", 0);
    defaultPref("nglayout.enable_drag_images", false);
    defaultPref("reader.parse-on-load.enabled", false);
    defaultPref("browser.tabs.firefox-view", false);
    defaultPref("browser.tabs.tabmanager.enabled", false);
    """

    if os.path.exists(f"{install_dir}\\firefox.exe"):
        process = subprocess.run(
            [f"{install_dir}\\firefox.exe", "--version", "|", "more"],
            capture_output=True,
            check=False,
            universal_newlines=True,
        )
        local_version = process.stdout.split()[-1]

        if local_version == latest_firefox_version:
            print(f"info: latest version {latest_firefox_version} already installed")
            return

    if os.path.exists(setup):
        os.remove(setup)

    print(f"info: downloading firefox {latest_firefox_version} setup")
    request.urlretrieve(download_link, setup)

    try:
        with open(setup, "rb") as file:
            file_bytes = file.read()
            sha256 = hashlib.sha256(file_bytes).hexdigest()

            if sha256 not in setup_sha256:
                print("error: hash mismatch, corrupted download")
                return
    except FileNotFoundError:
        print("error: download unsuccessful")
        return

    subprocess.run(["taskkill", "/F", "/IM", "firefox.exe"], **stdnull, check=False)

    print("info: installing firefox")
    subprocess.run([setup, "/S", "/MaintenanceService=false"], check=False)

    print("info: removing bloatware")
    for file in remove_files:
        file = f"{install_dir}\\{file}"
        if os.path.exists(file):
            os.remove(file)

    if os.path.exists(setup):
        os.remove(setup)

    print("info: importing policies.json")
    os.makedirs(f"{install_dir}\\distribution", exist_ok=True)

    with open(policies, "w", encoding="utf-8") as file:
        json.dump(policies_content, file, indent=4)

    print("info: importing autoconfig.js")
    with open(autoconfig, "w", encoding="utf-8", newline="\n") as file:
        file.writelines(textwrap.dedent(autoconfig_content))

    print("info: importing firefox.cfg")
    with open(firefox_cfg, "w", encoding="utf-8") as file:
        file.writelines(textwrap.dedent(firefox_cfg_content))

    print(
        f"info: version {latest_firefox_version} release notes: https://www.mozilla.org/en-US/firefox/{latest_firefox_version}/releasenotes"
    )
    print("info: done")

if __name__ == "__main__":
    main()
