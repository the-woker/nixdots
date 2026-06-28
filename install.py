import os
import subprocess
import sys
import shutil
from pathlib import Path



if os.geteuid() != 0:
    sys.exit("This script must be run as root")

script_dir = Path(__file__).resolve().parent

disko_config = script_dir / "modules/system/disko-config.nix"

subprocess.run([ "nix", "--experimental-features", "nix-command flakes", "run", "github:nix-community/disko/latest", "--", "--mode", "destroy,format,mount",     str(disko_config) ], check=True)

backup_path = "/dev/disk/by-id/usb-Kingston_DataTraveler_3.0_E0D55EA574BA15A0990D1003A-0:0-part1"
mountpoint = "/media"

if not os.path.exists(backup_path):
    sys.exit("Please insert backup usb with age key")

os.makedirs(mountpoint, exist_ok=True)


subprocess.run(
    ["mount", backup_path, mountpoint],
    check = True
)

if not os.path.exists("/media/keys.txt"):
    sys.exit("Please put the age key on the usb root and name it keys.txt")


os.makedirs("/mnt/var/lib/sops-nix/", exist_ok=True)

shutil.copy("/media/keys.txt", "/mnt/var/lib/sops-nix/keys.txt")


subprocess.run(["umount", mountpoint], check=True)
subprocess.run(["nixos-install", "--flake", ".#nixos", "--root", "/mnt"], cwd=script_dir, check=True)

print("Done, you can reboot into nixos")
