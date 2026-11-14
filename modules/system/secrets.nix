{
  config,
  pkgs,
  lib,
  settings,
  inputs,
  ...
}: let
  cfg = settings.systemSettings.sops;
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  config = lib.mkMerge [
    {
      programs.ssh.startAgent = true;

      users.users.${settings.name} = {
        hashedPasswordFile = config.sops.secrets.passwd.path;
        isNormalUser = true;
        extraGroups = ["wheel"];

        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJkNivWdMTdBODE1BcY+APzPEoDQuMSEGnxsV3+92m7q nick@nixos"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOzS2qM64YO73TFGFDELJH4inW8RgWmRiJfkvMDJ25Zb ratjerky@nixos"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMnetw6MT/9ISi05BrHo6pFW1j1BKuzvMr3whk7Y253V nicholasmilligan2019@outlook.com"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINNXCQYa6+plv8PPjUA9ot47rsqau0hQqEhrveLVpFJQ megan@Megans-Air"
        ];
      };
    }
    (lib.mkIf cfg.enable {
      systemd.user.services.add-nick-ssh-key = {
        description = "Load your SSH key on login";
        after = ["ssh-agent.service"];
        bindsTo = ["ssh-agent.service"];
        wantedBy = ["ssh-agent.service"];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          Environment = "SSH_AUTH_SOCK=%t/ssh-agent";
          ExecStartPre = "${pkgs.coreutils}/bin/test -e ${config.sops.secrets.ssh-private.path}";
          ExecStart = "${pkgs.openssh}/bin/ssh-add ${config.sops.secrets.ssh-private.path}";
        };
      };

      sops = {
        age = {
          keyFile = "/var/lib/sops-nix/key.txt";
        };
        defaultSopsFile = ../../secrets/secrets.yaml;
        secrets = {
          ssh-private = {
            owner = config.users.users.${settings.name}.name;
          };
          passwd = {
            neededForUsers = true;
          };
        };
      };
    })
  ];
}
