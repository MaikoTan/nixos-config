{
  inputs,
  config,
  pkgs,
  ...
}:

{
  imports = [
    inputs.hermes-agent.homeManagerModules.default
    ./agents
    ./magpie.nix
    ./dsh.nix
  ];

  programs = {
    # https://claude.ai/
    claude-code = {
      enable = true;
      package = pkgs.claude-code;
      enableMcpIntegration = true;
      # settings 交给 Magpie 托管（它需要写 ~/.claude/settings.json）
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
      # The Electron desktop app is only useful on a full desktop (company).
      desktop.enable = config.maiko.hm.desktop;
    };

    # dsh (DeepSeek Agent CLI) - follows hermes-agent pattern
    dsh = {
      enable = true;
    };
  };

  services = {
    hermes-agent = {
      enable = true;
      gateway.enable = true;
      settings.model.default = "deepseek-official/deepseek-v4-flash";
    };
    dsh = {
      enable = true;
      profile = "web";
      autoInstallBundles = true;
      # 服务常驻时不需要每次启动都把浏览器拉起来。
      # 这是 web profile app 自己的 flag（dsh --profile web --help 可见，顶层
      # dsh --help 里没有），所以放在 extraArgs 而不是模块默认值里。
      extraArgs = [ "--no-open" ];
    };
  };

  home.packages = with pkgs; [
    obscura # Minimal browser for agents
    github-copilot-app
  ];
}
