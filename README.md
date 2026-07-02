# kioku-skills

Agent Skills for the [`kioku` CLI](https://github.com/kioku-org/kioku) — so your AI coding
assistant already knows how to install, sign in to, and drive `kioku` (search, meetings,
docs, calendar, workspaces) without you having to explain it every time.

## Supported harnesses

`skills/kioku/SKILL.md` uses the [Agent Skills](https://code.claude.com/docs/en/skills) format,
which both **Claude Code** and **OpenCode** read natively from the same path — no conversion or
per-tool copies needed.

## Install

### Claude Code — as a plugin (recommended)

This repo is also a Claude Code plugin marketplace (`.claude-plugin/marketplace.json`):

```
/plugin marketplace add kioku-org/kioku-skills
/plugin install kioku@kioku-skills
```

Gets you automatic updates and shows up in `/plugin`. Requires a `/reload-plugins` (or restart)
after installing.

### Manual copy — Claude Code or OpenCode, any scope

Works identically for both tools; pick a scope:

**Global** (available in every project):
```bash
git clone https://github.com/kioku-org/kioku-skills.git /tmp/kioku-skills
mkdir -p ~/.claude/skills
cp -r /tmp/kioku-skills/skills/kioku ~/.claude/skills/kioku
```

**Project-level** (current repo only):
```bash
mkdir -p .claude/skills
git clone https://github.com/kioku-org/kioku-skills.git /tmp/kioku-skills
cp -r /tmp/kioku-skills/skills/kioku .claude/skills/kioku
```

OpenCode reads the same `.claude/skills/<name>/SKILL.md` path (also `.opencode/skills/` and
`.agents/skills/`, project or `~/.config/opencode/` global) — `~/.claude/skills/kioku` or
`.claude/skills/kioku` work for both tools as-is. The plugin/marketplace install path above is
Claude Code–only; OpenCode users should use manual copy.

Once installed, just ask your agent to install/use kioku (e.g. "install the kioku CLI and sign
me in", "search my meeting notes for X") — the skill triggers automatically.

## License

MIT — see [LICENSE](LICENSE).
