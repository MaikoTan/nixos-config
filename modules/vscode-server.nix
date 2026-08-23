{
  config,
  lib,
  inputs,
  ...
}:

let
  cfg = config.maiko.vscode-server;
in

{
  imports = [ inputs.vscode-server.nixosModules.default ];

  options.maiko.vscode-server.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable the VS Code remote server";
  };

  config = lib.mkIf cfg.enable {
    services.vscode-server.enable = true;
  };
}
