#!/usr/bin/env bash
# Checks the catalog before every push and in CI. See AGENTS.md, "Checks".
set -euo pipefail
cd "$(dirname "$0")/.."

python3 - <<'PY'
import json, pathlib, re, sys

root = pathlib.Path(".")
errors = []

# 1. Every JSON manifest parses.
for path in sorted(root.rglob("*.json")):
    if any(part in {"node_modules", ".git"} for part in path.parts):
        continue
    try:
        json.loads(path.read_text())
    except Exception as exc:
        errors.append(f"{path}: invalid JSON ({exc})")

# 2. Each skill's folder matches its frontmatter name.
for skill in sorted(root.glob("skills/*/SKILL.md")):
    text = skill.read_text()
    match = re.search(r"^---\s*\n(.*?)\n---", text, re.S)
    name = re.search(r"^name:\s*['\"]?([^'\"\n]+)", match.group(1), re.M) if match else None
    if not name:
        errors.append(f"{skill}: no name in the frontmatter")
    elif name.group(1).strip() != skill.parent.name:
        errors.append(f"{skill}: name '{name.group(1).strip()}' differs from the folder '{skill.parent.name}'")
    if not re.match(r"^[a-z0-9]+(-[a-z0-9]+)*$", skill.parent.name):
        errors.append(f"{skill.parent}: skill folders are kebab-case")

# 3. The two catalogs list the same plugins (Claude Code mods are Claude-only).
claude = json.loads((root / ".claude-plugin/marketplace.json").read_text())
codex = json.loads((root / ".agents/plugins/marketplace.json").read_text())
if claude["name"] != codex["name"]:
    errors.append(f"catalog names differ: {claude['name']} vs {codex['name']}")
def is_mod(entry):
    source = entry.get("source")
    return isinstance(source, str) and source.startswith("./claude/mods/")
claude_names = {p["name"] for p in claude["plugins"] if not is_mod(p)}
codex_names = {p["name"] for p in codex["plugins"]}
for name in sorted(claude_names - codex_names):
    errors.append(f"'{name}' is in the Claude catalog but not in the Codex one")
for name in sorted(codex_names - claude_names):
    errors.append(f"'{name}' is in the Codex catalog but not in the Claude one")

# 4. The bundle is listed once it has a skill, and not before.
has_skills = any(root.glob("skills/*/SKILL.md"))
listed = any(p.get("source") == "./" for p in claude["plugins"])
if has_skills and not listed:
    errors.append("skills/ has skills but the bundle isn't in the catalogs (AGENTS.md, Adding a skill)")
if listed and not has_skills:
    errors.append("the bundle is in the catalogs but skills/ is empty")

for error in errors:
    print(f"FAIL {error}")
if errors:
    sys.exit(1)
print("OK   manifests, skill names and catalogs")
PY

if command -v claude >/dev/null 2>&1; then
  claude plugin validate .
else
  echo "SKIP claude plugin validate (no claude CLI)"
fi
