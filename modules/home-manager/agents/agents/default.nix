{ ... }:

{
  home.file = {
    ".agents/AGENTS.md".source = ./instructions.md;
    ".claude/CLAUDE.md".source = ./instructions.md;
    ".copilot/copilot-instructions.md".source = ./instructions.md;
  };
}
