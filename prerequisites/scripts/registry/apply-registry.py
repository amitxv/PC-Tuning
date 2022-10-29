"""apply-registry"""


import sys
import os
import subprocess
import argparse
import ctypes


nsudo_path = "C:\\prerequisites\\nsudo\\NSudo.exe"
nsudo_args = [nsudo_path, "-U:T", "-P:E", "-Wait"]


def apply_registry(file_path: str) -> None:
    """function to merge registry files"""
    subprocess.run(["regedit.exe", "/s", file_path], check=False)
    subprocess.run([*nsudo_args, "regedit.exe", "/s", file_path], check=False)


def main() -> int:
    """program entrypoint"""

    if not ctypes.windll.shell32.IsUserAnAdmin():
        print("error: administrator privileges required")
        return 1

    registry_dir = "C:\\prerequisites\\scripts\\registry"
    registry_files = ["7+.reg", "8.reg", "8+.reg", "10+.reg", "11+.reg"]

    parser = argparse.ArgumentParser()
    parser.add_argument("--winver", choices=[7, 8, 10, 11], help="specify windows version to be configured", required=True, type=int, metavar="<winver>")
    args = parser.parse_args()

    if not os.path.exists(nsudo_path):
        print(f"error: {nsudo_path} not exists")
        return 1

    if not all(os.path.exists(f"{registry_dir}\\{x}") for x in registry_files):
        print("error: registry files not found")
        return 1

    print(f"info: applying registry file for windows {args.winver}")

    for file in registry_files:
        if "+" in file:
            if int(file.rpartition("+")[0]) <= args.winver:
                apply_registry(f"{registry_dir}\\{file}")
        elif int(file.rpartition(".reg")[0]) == args.winver:
            apply_registry(f"{registry_dir}\\{file}")

    print("info: done")

    return 0


if __name__ == "__main__":
    sys.exit(main())
