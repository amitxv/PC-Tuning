"""disable-tasks"""


import sys
import os
import subprocess
import io
import ctypes


def main() -> int:
    """program entrypoint"""

    if not ctypes.windll.shell32.IsUserAnAdmin():
        print("error: administrator privileges required")
        return 1

    nsudo_path = "C:\\prerequisites\\nsudo\\NSudo.exe"
    if not os.path.exists(nsudo_path):
        print(f"error: {nsudo_path} not exists")
        return 1

    subprocess_null = {"stdout": subprocess.DEVNULL, "stderr": subprocess.DEVNULL}
    sch_tasks = []

    to_disable = [
        "update",
        "maps",
        "helloface",
        "customer experience improvement program",
        "microsoft compatibility appraiser",
        "startupapptask",
        "dssvccleanup",
        "bitlocker",
        "chkdsk",
        "data integrity scan",
        "defrag",
        "diskcleanup",
        "diskfootprint",
        "languagecomponentsinstaller",
        "memorydiagnostic",
        "registry",
        "time synchronization",
        "time zone",
        "upnp",
        "windows filtering platform",
        "tpm",
        "systemrestore",
        "speech",
        "spacePort",
        "power efficiency",
        "cloudexperiencehost",
        "diagnosis",
        "file history",
        "bgtaskregistrationmaintenancetask",
        "autochk\\proxy",
        "siuf",
        "device information",
        "edp policy manager"
    ]

    process = subprocess.run(["schtasks", "/query", "/fo", "list"], capture_output=True, check=False, universal_newlines=True)

    for line in io.StringIO(process.stdout):
        if "TaskName:" in line:
            task_name = line.rpartition(":")[-1].strip("\n").strip().lower()
            sch_tasks.append(task_name)

    for wildcard in to_disable:
        print(f"info: disabling {wildcard}")
        for task in sch_tasks:
            if wildcard in task:
                schtasks_args = ["schtasks", "/change", "/disable", "/tn", task]
                subprocess.run(schtasks_args, check=False, **subprocess_null)
                subprocess.run([nsudo_path, "-U:T", "-P:E", "-ShowWindowMode:Hide", *schtasks_args], check=False, **subprocess_null)

    print("info: done")

    return 0


if __name__ == "__main__":
    sys.exit(main())
