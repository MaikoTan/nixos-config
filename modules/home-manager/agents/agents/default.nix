# This module takes no arguments and does not declare `...`, so statix
# flags the empty pattern. `_` keeps the signature accepting (and ignoring)
# the arguments home-manager passes in, which is what `{ ... }` did here.
_:

{
  home.file = {
    ".agents/AGENTS.md".source = ./instructions.md;
    ".claude/CLAUDE.md".source = ./instructions.md;
    ".copilot/copilot-instructions.md".source = ./instructions.md;
  };
}
