# kioku-skills

Agent Skills for the [`kioku` CLI](https://github.com/kioku-org/kioku) — so your AI coding
assistant already knows how to install, sign in to, and drive `kioku` (search, meetings,
docs, calendar, workspaces) without you having to explain it every time.

## Supported harnesses

The `kioku/SKILL.md` file here uses the [Agent Skills](https://code.claude.com/docs/en/skills)
format, which both **Claude Code** and **OpenCode** read natively from the same path — no
conversion or per-tool copies needed.

## Install

Pick a scope:

**Global** (available in every project):
```bash
git clone https://github.com/kioku-org/kioku-skills.git /tmp/kioku-skills
mkdir -p ~/.claude/skills
cp -r /tmp/kioku-skills/kioku ~/.claude/skills/kioku
```

**Project-level** (this repo only):
```bash
mkdir -p .claude/skills
git clone https://github.com/kioku-org/kioku-skills.git /tmp/kioku-skills
cp -r /tmp/kioku-skills/kioku .claude/skills/kioku
```

OpenCode reads the same `.claude/skills/<name>/SKILL.md` path (also `.opencode/skills/` and
`.agents/skills/`, project or `~/.config/opencode/` global) — `~/.claude/skills/kioku` or
`.claude/skills/kioku` work for both tools as-is.

Once installed, just ask your agent to install/use kioku (e.g. "install the kioku CLI and sign
me in", "search my meeting notes for X") — the skill triggers automatically.

## License

MIT — see [LICENSE](LICENSE).
