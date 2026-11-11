{
  inputs,
  settings,
  pkgs,
  ...
}:
{
  "${settings.name}" = inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = {
      inherit
        inputs
        settings
        ;
    };
    modules = [
      ./home.nix
    ];
  };
}
