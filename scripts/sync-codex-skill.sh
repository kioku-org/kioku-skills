#!/bin/sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_root=$(CDPATH= cd -- "$script_dir/.." && pwd)
source_skill="$repo_root/skills/kioku/SKILL.md"
plugin_skill="$repo_root/plugins/kioku/skills/kioku/SKILL.md"

case "${1:-}" in
  "")
    cp "$source_skill" "$plugin_skill"
    printf '%s\n' "Synced $plugin_skill"
    ;;
  --check)
    if ! cmp -s "$source_skill" "$plugin_skill"; then
      printf '%s\n' "Codex plugin skill is stale; run scripts/sync-codex-skill.sh" >&2
      exit 1
    fi
    printf '%s\n' "Codex plugin skill is in sync"
    ;;
  *)
    printf '%s\n' "Usage: $0 [--check]" >&2
    exit 2
    ;;
esac
