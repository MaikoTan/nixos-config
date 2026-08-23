{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.github-runners = {
    maintenir = {
      enable = true;
      name = "company-nixos";
      tokenFile = config.sops.secrets.maintenirGitHubRunnerToken.path;
      url = "https://github.com/maintenir";
      nodeRuntimes = [ "node24" ];
    };
    nixos-config = {
      enable = true;
      name = "company-nixos";
      extraLabels = [ "nixos" ];
      user = "github-runner";
      group = "github-runner";
      extraPackages = with pkgs; [ nix ];
      tokenFile = config.sops.secrets.nixosGithubToken.path;
      url = "https://github.com/MaikoTan/nixos-config";
      nodeRuntimes = [ "node24" ];
    };
  };

  sops.secrets = {
    companyGitHubToken = {
      sopsFile = ../../secrets/github_tokens.yaml;
      key = "company";
      owner = "maiko";
    };
    maintenirGitHubRunnerToken = {
      sopsFile = ../../secrets/github_tokens.yaml;
      key = "maintenir_github_runner";
    };
    nixosGithubToken = {
      sopsFile = ../../secrets/github_tokens.yaml;
      key = "nixos_github_runner";
    };
  };

  users = {
    users.github-runner = {
      isSystemUser = true;
      group = "github-runner";
      extraGroups = [
        "networkmanager"
        "docker"
      ];
    };
    groups.github-runner = { };
  };

  nix.settings.trusted-users = lib.mkAfter [ "github-runner" ];
}
