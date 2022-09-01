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


def is_admin() -> bool:
    """check if script is ran with admin privileges"""
    return ctypes.windll.shell32.IsUserAnAdmin() != 0


def main() -> int:
    """cli entrypoint"""

    if not is_admin():
        print("error: administrator privileges are required")
        return 1

    registry_dir = "C:\\prerequisites\\scripts\\registry"

    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--winver",
        choices=[7, 8, 10],
        help="specify windows version to be configured",
        required=True,
        type=int,
        metavar="<winver>"
    )
    args = parser.parse_args()

    if not os.path.exists(nsudo_path):
        print(f"error: {nsudo_path} not exists")
        return 1

    registry_files = [
        "windows7+.reg",
        "windows8.reg",
        "windows8+.reg",
        "windows10+.reg"
    ]

    if not all(os.path.exists(f"{registry_dir}\\{x}") for x in registry_files):
        print("error: registry files not found")
        return 1

    print(f"info: applying registry file for Windows {args.winver}")

    if args.winver == 7:
        apply_registry(f"{registry_dir}\\windows7+.reg")
    elif args.winver == 8:
        apply_registry(f"{registry_dir}\\windows7+.reg")
        apply_registry(f"{registry_dir}\\windows8.reg")
        apply_registry(f"{registry_dir}\\windows8+.reg")
    elif args.winver == 10:
        apply_registry(f"{registry_dir}\\windows7+.reg")
        apply_registry(f"{registry_dir}\\windows8+.reg")
        apply_registry(f"{registry_dir}\\windows10+.reg")

    print("info: done")

    return 0


if __name__ == "__main__":
    sys.exit(main())
