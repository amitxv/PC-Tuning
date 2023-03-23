import argparse
import ctypes
import os
import subprocess

nsudo_path = "C:\\bin\\NSudo.exe"
nsudo_args = [nsudo_path, "-U:T", "-P:E", "-Wait"]


def apply_registry(file_path: str) -> None:
    subprocess.run(["regedit.exe", "/s", file_path], check=False)
    subprocess.run([*nsudo_args, "regedit.exe", "/s", file_path], check=False)


def main() -> None:
    if not ctypes.windll.shell32.IsUserAnAdmin():
        print("error: administrator privileges required")
        return

    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--winver",
        choices=[7, 8, 10, 11],
        help="specify windows version to be configured",
        required=True,
        type=int,
        metavar="<winver>",
    )
    args = parser.parse_args()

    if not os.path.exists(nsudo_path):
        print(f"error: {nsudo_path} not exists")
        return

    for file in (
        "7.reg",
        "7+.reg",
        "7-8.reg",
        "8.reg",
        "8+.reg",
        "10+.reg",
        "11+.reg",
    ):
        file_name = file.replace(".reg", "")
        file = f"C:\\bin\\registry"\\{file}"

        if not os.path.exists(file):
            print("error: registry files not found")
            return

        if "+" in file_name:
            if int(file_name[:-1]) <= args.winver:
                apply_registry(file)
        elif "-" in file_name:
            lower, upper = [int(x) for x in file_name.split("-")]
            if lower <= args.winver <= upper:
                apply_registry(file)
        elif int(file_name) == args.winver:
            apply_registry(file)

    print(f"info: applied registry settings for windows {args.winver}")


if __name__ == "__main__":
    main()
