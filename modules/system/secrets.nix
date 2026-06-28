{
  config,
  pkgs,
  name,
  ...
}:
{
  sops = {
    age = {
      keyFile = "/var/lib/sops-nix/keys.txt";
    };
    defaultSopsFile = ../../secrets/secrets.yaml;
  };

  sops.secrets.ssh-private = {
    owner = config.users.users.${name}.name;
  };

  sops.secrets.passwd = {
    neededForUsers = true;
  };

  users.users.${name} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPasswordFile = config.sops.secrets.passwd.path;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJkNivWdMTdBODE1BcY+APzPEoDQuMSEGnxsV3+92m7q nick@nixos"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOzS2qM64YO73TFGFDELJH4inW8RgWmRiJfkvMDJ25Zb ratjerky@nixos"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINNXCQYa6+plv8PPjUA9ot47rsqau0hQqEhrveLVpFJQ megan@Megans-Air"
    ];
  };

  programs.ssh.startAgent = true;

  systemd.user.services.add-nick-ssh-key = {
    description = "Load your SSH key on login";
    after = [ "default.target" ];
    wantedBy = [ "default.target" ];

    serviceConfig = {
      Type = "oneshot";
      Environment = "SSH_AUTH_SOCK=%t/ssh-agent";
      ExecStartPre = "${pkgs.coreutils}/bin/test -e ${config.sops.secrets.ssh-private.path}";
      ExecStart = "${pkgs.openssh}/bin/ssh-add ${config.sops.secrets.ssh-private.path}";
      RemainAfterExit = true;
    };
  };
}
