NixOS with sops-nix, age, mangowc, nvf, and more.
![](./screenshot.png)

DO NOT USE install.py IT'S SPECIFIC TO MY USB DRIVE AND SETUP

Install instructions:

<details>
<summary><b>1. Setup Secrets</b></summary>

First run
```
mkdir -p ~/.config/sops/age
nix-shell -p age
```

Once the shell is open
```
age-keygen -o ~/.config/sops/age/keys.txt
```

Then run 
```
age-keygen -y ~/.config/sops/age/keys.txt >> secrets/.sops.yaml
```

and replace
```
age1utxgjv7utydqz2kx0rvnkmnw3rrcvrg92tk7jpe5mgpcyxekhpesznvg6d
```
with your key, which should be on the bottom of the file. Also replace "nick" with your username, but keep the "&" symbol before the first, and the *before the second. So, it should look like this after you're done:
```
keys:
  - &yourName yourKey
creation_rules:
  - path_regex: secrets.yaml$
    key_groups:
      - age:
          - *yourName

```

Next, we will create your sops file (this stores passwords). First, delete mine:
```
rm ./secrets/secrets.yaml
```
then make yours
```
nix-shell -p sops --run "sops secrets/secrets.yaml"
```
Put in your private ssh key (this will get encrypted) with 4 spaces like so:
```
ssh-private: |
    -----BEGIN OPENSSH PRIVATE KEY-----
    REDACTED
    -----END OPENSSH PRIVATE KEY-----
```
Now we need your password. Exit the file, and run 
```
mkpasswd INSERT_PASSWORD_HERE >> secrets/secrets.yaml
```
then in secrets.yaml, insert "passwd: " before the new password. It should look like:
```
ssh-private: |
    -----BEGIN OPENSSH PRIVATE KEY-----
    REDACTED
    -----END OPENSSH PRIVATE KEY-----
unhashed-passwd: 1234
passwd: $y$j9T$gdontKMxmti/8okqOcc/z1$rQUOqN4MuqzMuIZILY.0euPSxlRLY4xMMAhYr6iXWmA
```
Then save and exit.
</details>


<details>
<summary><b>2. Setup hardware</b></summary>
First, pick which drive to install to. To do so, run lsblk, and pick from those drives.

Then, edit modules/default.nix and modules/system/default.nix and input your drive in all instances of 
```
  [ "/dev/nvme0n1" ];
```
instead of
"/dev/nvme0n1"
Now, run 
```
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount ./modules/system/disko-config.nix
```
THIS WILL ERASE THE DRIVE YOU PUT IN THOSE FILES, ENSURE THAT YOU SELECTED THE RIGHT ONE

Next,  the GPU. If you have an Nvidia GPU, skip to the next step. If you have an amd GPU, edit modules/system/hardware.nix, replace
```
  services.xserver.videoDrivers = [ "nvidia" ];
```
with

```
  services.xserver.videoDrivers = [ "amdgpu" ];
```

and delete lines 12 through 19
</details>

<details>
<summary><b>3. Install</b></summary>
Before you do this, it is recommended  to back up everything to a usb, otherwise you will have to do everything again, except running 
```
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount ./modules/system/disko-config.nix
```
To back everything up, mount a usb (pick which one via running ```lsblk``` then running ```mount /dev/sdxx```) and move everything to that usb, including ~/.config/sops/age/keys.txt and ~/nixdots.


Once you have done that or if you skipped it, run 
```
sudo nixos-install --flake .#nixos --root /mnt
```
</details>

For help, make an issue on github.
