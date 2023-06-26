{
  pkgs,
  inputs,
  ...
}: {
  # Set the default installed packages. Replaces nano with vi.
  environment.defaultPackages = with pkgs; [
    vi
    curl
    w3m
    inputs.agenix.packages.${pkgs.system}.default
  ];
  environment.variables.EDITOR = "vi";
}
