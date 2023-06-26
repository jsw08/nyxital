let
  # Users
  jsw = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILLsytAzzW/ZVmPl1jnQdlItwu4C696fr0Np+8FfP/1Z";
  users = [jsw];

  # .hosts
  jsw-laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMsK6iSbU6aiJTuDFx9NRPxip8jmeiwGPNhsWi1hCnQX";
  hosts = [jsw-laptop];
in {
  "jswPass.age".publicKeys = users ++ hosts;
}
