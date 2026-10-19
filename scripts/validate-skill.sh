#!/usr/bin/env bash
# Validates the structure and contract of the comite-evaluador skill.
# Runs in CI and locally. Exits non-zero on any failure.

set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_DIR="$REPO_ROOT/skills/comite-evaluador"
SKILL_MD="$SKILL_DIR/SKILL.md"
REFS_DIR="$SKILL_DIR/references"

pass=0
fail=0
ok()   { printf '  \033[0;32mpass\033[0m %s\n' "$1"; pass=$((pass + 1)); }
bad()  { printf '  \033[0;31mFAIL\033[0m %s\n' "$1"; fail=$((fail + 1)); }

echo "Validating comite-evaluador skill"

# --- 1. Structure ------------------------------------------------------------
echo "[1/5] Structure"
[ -f "$SKILL_MD" ] && ok "SKILL.md exists" || { bad "SKILL.md missing"; exit 1; }
[ -d "$REFS_DIR" ] && ok "references/ exists" || bad "references/ missing"

dir_name="$(basename "$SKILL_DIR")"
if printf '%s' "$dir_name" | grep -Eq '^[a-z0-9]+(-[a-z0-9]+)*$'; then
  ok "directory id is kebab-case: $dir_name"
else
  bad "directory id is not kebab-case: $dir_name"
fi

# --- 2. Frontmatter ----------------------------------------------------------
echo "[2/5] Frontmatter"
fm="$(awk '/^---$/{n++; next} n==1' "$SKILL_MD")"

if printf '%s' "$fm" | grep -qE '^name:'; then
  ok "frontmatter has name"
else
  bad "frontmatter missing name"
fi

if printf '%s' "$fm" | grep -qE '^description:'; then
  ok "frontmatter has description"
else
  bad "frontmatter missing description"
fi

if printf '%s' "$fm" | grep -qE '^license:'; then
  ok "frontmatter has license"
else
  bad "frontmatter missing license"
fi

if printf '%s' "$fm" | grep -qE '^metadata:'; then
  ok "frontmatter has metadata"
else
  bad "frontmatter missing metadata"
fi

desc_line="$(printf '%s' "$fm" | grep -E '^description:' | head -1)"
if printf '%s' "$desc_line" | grep -qE '^description:[[:space:]]*".*"$'; then
  ok "description is a single quoted line"
else
  bad "description must be one quoted physical line"
fi

desc_len="${desc_line#description: }"
desc_len="${desc_len%\"}"; desc_len="${desc_len#\"}"
if [ "${#desc_len}" -le 250 ]; then
  ok "description length ${#desc_len} <= 250"
else
  bad "description length ${#desc_len} > 250"
fi

if printf '%s' "$desc_line" | grep -qiE '^description:[[:space:]]*"?trigger:'; then
  ok "description starts with trigger words"
else
  bad "description should start with 'Trigger:'"
fi

# --- 3. Required sections ----------------------------------------------------
echo "[3/5] Required sections"
for section in "## Activation Contract" "## Hard Rules" "## Decision Gates" "## Execution Steps" "## Output Contract" "## References"; do
  if grep -qF "$section" "$SKILL_MD"; then
    ok "section present: $section"
  else
    bad "missing section: $section"
  fi
done

# --- 4. Reference links resolve ----------------------------------------------
echo "[4/5] Reference links"
while IFS= read -r link; do
  target="$SKILL_DIR/$link"
  if [ -f "$target" ]; then
    ok "link resolves: $link"
  else
    bad "broken link: $link"
  fi
done < <(grep -oE '\(references/[a-zA-Z0-9._-]+\)' "$SKILL_MD" | tr -d '()' | sort -u)

ref_count="$(find "$REFS_DIR" -name '*.md' -type f 2>/dev/null | wc -l | tr -d ' ')"
if [ "$ref_count" -ge 1 ]; then
  ok "references present: $ref_count file(s)"
else
  bad "no reference files found"
fi

# --- 5. Body budget ----------------------------------------------------------
echo "[5/5] Body budget"
words="$(wc -w < "$SKILL_MD" | tr -d ' ')"
if [ "$words" -le 900 ]; then
  ok "SKILL.md body $words words (<= 900, ~1200 token ceiling)"
else
  bad "SKILL.md body $words words exceeds the 900-word budget"
fi

echo
if [ "$fail" -eq 0 ]; then
  printf '\033[0;32mAll %d checks passed.\033[0m\n' "$pass"
  exit 0
else
  printf '\033[0;31m%d passed, %d failed.\033[0m\n' "$pass" "$fail"
  exit 1
fi
