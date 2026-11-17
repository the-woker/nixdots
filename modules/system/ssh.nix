{
  config,
  settings,
  ...
}: {
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

  services.self-deploy.sshKeyFile = config.sops.secrets.ssh-private.path;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    settings.publish = {
      "disable-publishing" = false;
      "publish-addresses" = true;
    };
  };
}
