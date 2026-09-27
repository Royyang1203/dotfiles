#!/bin/sh
# Run one GPT (Codex) writing round through the codex@openai-codex plugin runtime.
# usage: codex-write.sh [--resume] <prompt-file>
#   --resume  continue the latest Codex task thread of this workspace (round 2+)
set -eu
PLUGIN_ROOT=$(jq -r '.plugins["codex@openai-codex"][0].installPath' "$HOME/.claude/plugins/installed_plugins.json")
COMPANION="$PLUGIN_ROOT/scripts/codex-companion.mjs"
[ -f "$COMPANION" ] || { echo "codex plugin runtime not found: $COMPANION" >&2; exit 1; }
RESUME=""
if [ "${1:-}" = "--resume" ]; then RESUME="--resume-last"; shift; fi
PROMPT="${1:?prompt file required}"
[ -f "$PROMPT" ] || { echo "prompt file not found: $PROMPT" >&2; exit 1; }
# shellcheck disable=SC2086
exec node "$COMPANION" task --write --model gpt-5.6-sol --effort medium $RESUME --prompt-file "$PROMPT"
