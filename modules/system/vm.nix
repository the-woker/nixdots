{
  name,
  ...
}:
{
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ "${name}" ];

  virtualisation.libvirtd.enable = true;

  virtualisation.spiceUSBRedirection.enable = true;
  services.spice-vdagentd.enable = true;

  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 8192;
      cores = 5;
      graphics = true;
    };
  };

}
