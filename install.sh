#!/usr/bin/env bash
# Installer for the comite-evaluador skill for OpenCode.
#
# Usage:
#   bash install.sh
#
# It clones the repository to a stable location, registers the skills
# directory in the global OpenCode configuration, and verifies the result.

set -euo pipefail

REPO_URL="${COMITE_EVALUADOR_REPO:-https://github.com/bialyLT/comite-evaluador-skill.git}"
INSTALL_DIR="${COMITE_EVALUADOR_DIR:-$HOME/.local/share/comite-evaluador-skill}"
CONFIG="${OPENCODE_CONFIG:-$HOME/.config/opencode/opencode.jsonc}"
SKILL_ID="comite-evaluador"

info() { printf '\033[0;36m==>\033[0m %s\n' "$1"; }
ok()   { printf '\033[0;32m  ok\033[0m %s\n' "$1"; }
warn() { printf '\033[0;33m  !!\033[0m %s\n' "$1"; }
die()  { printf '\033[0;31m xx\033[0m %s\n' "$1" >&2; exit 1; }

# --- 1. Clone or update ------------------------------------------------------
if [ -d "$INSTALL_DIR/.git" ]; then
  info "Updating existing installation at $INSTALL_DIR"
  git -C "$INSTALL_DIR" pull --ff-only
else
  info "Cloning repository to $INSTALL_DIR"
  mkdir -p "$(dirname "$INSTALL_DIR")"
  git clone --depth 1 "$REPO_URL" "$INSTALL_DIR"
fi

[ -f "$INSTALL_DIR/skills/$SKILL_ID/SKILL.md" ] \
  || die "SKILL.md not found at skills/$SKILL_ID/SKILL.md inside the repository"
ok "skill files present"

# --- 2. Register in the OpenCode configuration -------------------------------
SKILLS_ENTRY="\"$INSTALL_DIR/skills\""

if [ ! -f "$CONFIG" ]; then
  info "Creating $CONFIG"
  mkdir -p "$(dirname "$CONFIG")"
  cat > "$CONFIG" <<EOF
{
  "\$schema": "https://opencode.ai/config.json",
  "skills": [
    $SKILLS_ENTRY
  ]
}
EOF
  ok "configuration created"
elif grep -q '"skills"' "$CONFIG"; then
  if grep -qF "$INSTALL_DIR/skills" "$CONFIG"; then
    ok "configuration already points to $INSTALL_DIR/skills"
  else
    warn "\"skills\" already exists in $CONFIG but does not point to this installation."
    warn "Add this entry manually to the existing array:"
    warn "    $SKILLS_ENTRY"
  fi
else
  info "Adding the skills entry to $CONFIG"
  node -e '
    const fs = require("fs");
    const file = process.argv[1];
    const entry = process.argv[2];
    const text = fs.readFileSync(file, "utf8");
    const idx = text.indexOf("{");
    if (idx === -1) { console.error("no JSON object found"); process.exit(1); }
    const insert = "\n  \"skills\": [\n    " + entry + "\n  ],";
    const out = text.slice(0, idx + 1) + insert + text.slice(idx + 1);
    fs.writeFileSync(file, out);
  ' "$CONFIG" "$SKILLS_ENTRY" || die "could not edit $CONFIG automatically"
  ok "skills entry added"
fi

# --- 3. Verify ---------------------------------------------------------------
if command -v opencode >/dev/null 2>&1; then
  info "Verifying discovery"
  if opencode run "list the available skills" 2>/dev/null | grep -qi "$SKILL_ID"; then
    ok "skill '$SKILL_ID' is discoverable"
  else
    warn "could not confirm discovery automatically. Open a new session and run:"
    warn "    opencode run \"list the available skills\""
  fi
else
  warn "opencode CLI not found on PATH; skipping verification"
fi

echo
ok "Installation complete"
echo "   Skill id: $SKILL_ID"
echo "   Update:   git -C $INSTALL_DIR pull"
echo
echo "   Attribution: the evaluation framework 'Ley del Rompecabezas' and the AQP/CCA"
echo "   method reproduced in the skill references are the work of Dra. Rosario Martinez"
echo "   and are used with explicit attribution. This distribution implies no"
echo "   endorsement, agreement or collaboration with the author."
echo "   See: https://github.com/bialyLT/comite-evaluador-skill#licencia"
