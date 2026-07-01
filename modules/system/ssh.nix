{ config, settings, ... }:
{
  services.openssh = {
    enable = true;

    settings = {
      PasswordAuthentication = false;
      AllowUsers = [
        "${settings.name}@*"
        "megan@*"
      ];
      X11Forwarding = false;
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 ];
  services.self-deploy.sshKeyFile = config.sops.secrets.ssh-private.path;
}
