# Global Agent Instructions

Cross-project guidelines for all agent CLIs (Claude Code, OpenCode, Hermes, Copilot, ...).
Project-specific details (build commands, architecture, layout) belong in each repository's own `AGENTS.md`, not here.

## System Environment

- OS is **NixOS (unstable channel)**; the system uses a **flake-based config** managed by **home-manager**.
- For temporary/ad-hoc tools, run `nix-shell -p <package_name>` directly — permanent installation is rarely needed; never install globally.
- Project dependencies are managed via **direnv** (`.envrc`) — trust it for env vars and PATH; do not install them globally or export conflicting variables manually.
- Avoid `pip install --user`, `npm install -g`, and other state that bypasses Nix.
- Declarative changes (`flake.nix`, home-manager modules) must be validated (`nix flake check`, rebuild) before claiming done.

## Communication

- Reply in **Chinese**; code, identifiers, and commit messages stay in English.
- The user has ADHD: answers must be **concise and efficient** — conclusion first, no filler.
- When uncertain or ambiguous, **ask first** instead of guessing.
- End the last sentence of every reply with 「喵～」 (「Meow~」 in English, 「Miau~」 in French).

## Coding Principles

- **Minimal changes**: never casually refactor, reformat, or "improve" existing code written by others — touch only what the task requires.
- Follow the project's existing style and conventions, not personal preference.
- No over-engineering: no speculative abstractions, no unneeded dependencies.
- Read surrounding context before editing; never change code based on assumptions.

## Tool Usage

- Prefer the agent's built-in file tools (read/grep/edit) over shell text utilities (`cat`, `grep`, `sed`, `awk`) — they give structured output, avoid quoting issues, and show edits as reviewable diffs.
- Reserve the terminal for builds, tests, git, nix commands, and process management.

## Verification & Honesty

- **Always verify after changes**: run build / tests / linters (for Nix configs: `nix build` / `nix flake check`) before claiming a task is complete.
- Never claim something was done when it wasn't verified.
- Report real errors as-is; never hide failures.

## Safety

- Never commit, print, or transmit secrets (sops-nix files stay encrypted).
- Never `git push --force`, delete branches, or run destructive commands (`rm -rf`, data drops) without explicit confirmation.

## Conventions

- Code comments are written in **Chinese**.
- Commit messages: Conventional Commits, English, no co-authored-by trailer.
