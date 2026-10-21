# CapCut MCP Windows setup

When the human asks to install this repository, read README.md first and follow its numbered Windows setup steps. The Word manual is in docs/ and repeats the same workflow for a human reader.

- Check prerequisites before running installers. Install Python/Git/FFmpeg only within the user's installation request; use the official download links in README.md. No paid API is needed.
- Do not change Windows permissions, disable security hooks, or change Execution Policy. If a downloaded script is blocked, use the individual documented Python commands.
- Use a new local .venv. Never copy a virtual environment from another machine.
- Run scripts/install-windows.ps1 with -ConfigureCodex only when installing/configuring this MCP is requested. scripts/configure_codex.py backs up config.toml before changes, preserves unrelated settings and validates TOML. Never replace the whole config with a sample.
- Never print credentials or upload local config, CapCut drafts, videos, caches, or .venv.
- Finish by checking the MCP handshake and capcut_probe. Do not edit/save real projects for an installation check. If CapCut is missing or drafts unreadable, report it clearly.
- Never use force save. Close CapCut before any later user-authorized project save.
- Do not say a clean-machine install was tested unless it actually ran on a clean machine. Read docs/VALIDATION.md for the exact scope of recorded checks.
