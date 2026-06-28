{ config, name, ... }:
{
  services.openssh = {
    enable = true;

    settings = {
      PasswordAuthentication = false;
      AllowUsers = [
        "${name}@*"
        "megan@*"
        "nick@*"
      ];
      X11Forwarding = false;
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 ];
  services.self-deploy.sshKeyFile = config.sops.secrets.ssh-private.path;
}
