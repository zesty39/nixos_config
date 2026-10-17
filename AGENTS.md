# Documentation Changes

- Create or modify documentation only when explicitly requested by the user. This includes README.md files, usage guides, and changelogs.

# Directory Organization

- Place Nix configuration files in the corresponding host or module directory.
- Place non-Nix files in the `resources/` subdirectory of their owning directory and reference those paths from the Nix configuration.
- Keep files with repository-defined locations, such as `AGENTS.md` and `flake.lock`, in their original locations.

# Testing

- Do not create a `tests/` directory unless explicitly requested by the user. When testing is needed, use a temporary directory unless the user specifies otherwise.
