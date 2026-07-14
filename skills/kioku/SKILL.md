---
name: kioku
description: Use when the user wants to install, set up, or use the kioku CLI — Kioku's context/knowledge infrastructure for meetings, docs, and AI agents. Triggers on requests to install kioku, sign in to kioku, search meeting notes/transcripts/knowledge base, join/list/kill meeting bots, check Google Calendar via kioku, upload/list/delete documents, manage workspaces or invite teammates, manage API keys, or connect Kioku's MCP server to an AI client (Claude, Cursor, etc.). Also triggers when troubleshooting a `kioku: command not found` or similar kioku CLI error.
---

# kioku

`kioku` is the CLI for Kioku, an open-source context/knowledge layer that ingests meeting
transcripts and documents into a searchable knowledge base per workspace, with an MCP server
so AI clients can query it directly.

Every subcommand supports `--json` for machine-readable output — prefer it over parsing the
formatted text output when scripting or when you (the agent) need to read the result back.

## Install

Use the installer — it resolves the latest GitHub release (only
`x86_64-unknown-linux-gnu` binaries are published as of v0.1.2):

```bash
curl -fsSL https://kioku.chat/install.sh | sh
kioku --version
```

Pin a specific release (including `cli/vX.Y.Z-dev.N` pre-releases) with
`KIOKU_VERSION=<tag>` before the command. Note: the v0.1.2 binary self-reports
`kioku 0.1.0` — known cosmetic issue, don't treat it as a failed install.

If the user is on macOS, Windows, or another architecture with no published binary, build from
source instead (needs a Rust toolchain):

```bash
git clone https://github.com/kioku-org/kioku.git
cd kioku/services/cli
cargo build --release -p kioku-cli
# binary at target/release/kioku
```

Shell completions: `kioku completions <bash|zsh|fish|powershell>` prints a completion script to
stdout — pipe it to wherever the user's shell loads completions from.

## First-time setup

```bash
kioku signin
```

Opens a browser for Google/GitHub OAuth against the Kioku dashboard, then stores a token at
`~/.config/kioku/auth.json`. This requires an interactive browser — don't attempt to script or
automate it; hand this step to the user and wait for them to complete it.

For non-interactive / CI use, sign in with a long-lived API key instead (create one first with
`kioku keys --create`, from an already-authenticated session):

```bash
kioku signin --api-key <key>
```

Verify signin worked: `kioku whoami` (or `kioku --json whoami` for structured output — name,
email, role, workspace_id/name/slug, server; deliberately excludes the token itself).

`kioku signout` clears the stored credentials.

Troubleshooting: if every authenticated command suddenly errors `404 Not Found`, the stored
session (`~/.config/kioku/auth.json`) likely points at a server that no longer exists — signin
records the server, and in CLI ≤ v0.1.2 that stored value silently wins over `--server`. Fix
with `kioku signout && kioku signin`.

## Core commands

All of these operate on the user's **active workspace** (see Workspaces below) unless noted.

- `kioku search "<query>" [--limit N]` — semantic search over the workspace's knowledge base
  (meeting transcripts, uploaded docs, indexed coding sessions). Default limit 5.
- `kioku docs [PATH]` — bare: list documents. With a file path: upload it (PDF, DOCX, PPTX,
  TXT, or MD) for indexing. `--delete <id-or-prefix>` removes one.
- `kioku meet [LINK]` — bare: list currently-running meeting bots. With a Google Meet/Teams/Zoom
  link: joins it (spins up a bot that records + transcribes). `--kill <id-or-prefix>` stops a
  running bot. `--transcript <meeting-id>` prints a finished meeting's transcript — the id is
  the knowledge-base meeting **UUID**, not the dashboard's numeric id or the meet code; find it
  in `kioku --json search "<something said>"` results under `meeting.id`.
  `--transcript <meet-code> --follow` (releases after v0.1.2) streams a **live** meeting's
  transcript to the terminal as segments confirm, exiting when the bot leaves — here the id is
  the meet code shown by bare `kioku meet` (e.g. `abc-defg-hij`), and `--json` emits NDJSON.
- `kioku cal [--week] [--date DD/MM/YYYY]` — lists Google Calendar meetings for today (default),
  the coming week, or a specific date. First run transparently walks the user through connecting
  Calendar access (separate consent from the main kioku signin) — again, interactive, hand off
  to the user.

## Workspaces

A user can belong to multiple workspaces (one might be personal, others shared with teammates).
Everything above — search, docs, meet — is scoped to whichever workspace is currently active.

- `kioku ws` — list the user's workspaces; the active one is marked with `*`.
- `kioku ws <name>` — switch the active workspace (matches by slug, name, or id). Instant, no
  re-authentication.
- `kioku ws --create <name>` — create a new workspace and switch to it. New workspaces start on
  the Free tier (capped at 1 member).
- `kioku ws <name> --invite <email>` — invite a teammate into a specific workspace (must be an
  admin of it; free-tier workspaces reject invites — the user needs to upgrade first).
- `kioku invite [email]` / `kioku invite --revoke <id>` — same invite mechanism, but always
  targets whichever workspace is currently active, instead of naming one explicitly.

## Other commands

- `kioku keys` — list, `--create --name <n>`, or `--delete <id-or-prefix>` long-lived API keys
  (used for `signin --api-key` or other programmatic access). A newly created key's raw secret
  is only ever shown once at creation time — tell the user to save it immediately.
- `kioku mcp` — prints an MCP server config block (JSON) wiring an AI client like Claude Desktop
  or Cursor directly to the user's Kioku knowledge base and meeting tools, using their current
  auth token. If the user asks to "connect kioku to Claude/Cursor", run this and help them paste
  the output into that client's MCP config file.
- `kioku upgrade` — checks GitHub releases and self-updates if a newer version exists.
- `kioku --token` — prints the stored auth token. **Never combine this with another subcommand**
  (`kioku --token search ...` is a hard error, by design — the flag is only valid on its own).
  Treat the printed value as a live credential: don't echo it into logs, chat transcripts, or
  anywhere else it could persist beyond the user's own terminal.

## Global flags (apply to every subcommand)

- `--json` — machine-readable output. Prefer this whenever you need to parse the result.
- `--server <url>` — point at a self-hosted Kioku server instead of the default
  `https://api.kioku.chat`.
- `-v`/`-vv` — increase log verbosity (stderr).
- `-h`/`--help` — every subcommand has its own `--help`; run it if a flag's exact shape is
  unclear rather than guessing.
