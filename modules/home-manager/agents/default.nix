{
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    inputs.hermes-agent.homeManagerModules.default
  ];

  programs = {
    # https://claude.ai/
    claude-code = {
      enable = true;
      package = pkgs.claude-code;
      enableMcpIntegration = true;
      settings = {
        includeCoAuthoredBy = false;
      };
    };

    # https://github.com/github/copilot-cli
    github-copilot-cli = {
      enable = true;
      enableMcpIntegration = true;
    };

    # https://opencode.ai/
    opencode = {
      enable = true;
      enableMcpIntegration = true;
    };

    # https://hermes-agent.nousresearch.com/
    hermes-agent = {
      enable = true; # the hermes CLI on your PATH
      desktop.enable = true; # the Electron application and a launcher
      desktop.package = pkgs.hermes-desktop-patched;
    };
  };

  services.hermes-agent = {
    enable = true;
    gateway.enable = true;
    settings.model.default = "deepseek-official/deepseek-v4-flash";
  };
}
