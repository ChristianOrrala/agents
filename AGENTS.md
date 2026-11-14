# AGENTS.md

This repository is Christian Orrala's public catalog for coding agents and the
tools around them: skills, Claude Code plugins and mods, OpenCode, Orca and
Herdr plugins, npm packages, agent profiles and prompts. Big products keep
their own repositories and the catalogs point to them. Read this file before
changing anything here: it is the structure every session follows.

## The names

One name everywhere: **`christianorrala`**, the GitHub handle in lowercase,
with no dash (a dash only separates the handle from an added word).

| Where | Name |
|---|---|
| Claude Code and Codex marketplace | `christianorrala` |
| Root bundle plugin (the loose skills) | `christianorrala` → `/christianorrala:<skill>` |
| npm scope | `@christianorrala` |
| Orca plugin ids | `christianorrala.<id>` (Orca takes the publisher from the repository owner) |

The marketplace name doesn't change again: a rename breaks `name@christianorrala`
for everyone who installed.

## The layout rule

What works in every agent sits at the top. What belongs to one host sits in
that host's folder. A folder is created with its first item, never empty.

```text
agents/
├── .claude-plugin/
│   ├── marketplace.json        # Claude Code catalog "christianorrala"
│   └── plugin.json             # the root bundle "christianorrala" (the skills in skills/)
├── .codex-plugin/plugin.json   # the same bundle for Codex
├── .agents/plugins/marketplace.json   # Codex catalog, the same entries where Codex can run them
├── orca-catalog.json           # Orca catalog (with the first Orca plugin)
├── package.json                # private npm workspace root (with the first npm package)
├── .changeset/                 # npm versions (with the first npm package)
│
├── skills/<skill>/SKILL.md     # CROSS-AGENT · Agent Skills standard; the root bundle
├── profiles/<role>.md          # CROSS-AGENT · agent profiles (subagent definitions)
├── prompts/<prompt>.md         # CROSS-AGENT · reusable prompts that are not skills
│
├── claude/plugins/<name>/      # Claude Code plugins: commands, hooks, MCP, subagents
├── claude/mods/<name>/         # Claude Code mods: themes, panes, bands, status line
├── opencode/<name>/            # OpenCode plugins (JS/TS packages)
├── orca/<id>/                  # Orca plugins (orca-plugin.json)
├── herdr/<name>/               # Herdr plugins (herdr-plugin.toml)
├── packages/<name>/            # npm only: CLIs, MCP servers, libraries
│
├── scripts/validate.sh         # run before every push
└── .github/workflows/          # validate.yml; release.yml with the first npm package
```

## What goes where

| You have | It goes in | People install it with |
|---|---|---|
| A skill, one folder, no hooks | `skills/<name>/` | `/plugin install christianorrala@christianorrala` · `npx skills add ChristianOrrala/agents --skill <name>` |
| A Claude Code plugin (commands, hooks, MCP) | `claude/plugins/<name>/` + both catalogs | `/plugin install <name>@christianorrala` |
| A Claude Code mod (theme, pane, status line) | `claude/mods/<name>/` + the Claude catalog only | `/plugin install <name>@christianorrala` |
| An OpenCode plugin | `opencode/<name>/` | `opencode plugin add 'github:ChristianOrrala/agents#main::path:opencode/<name>'`; npm (`@christianorrala/opencode-<name>`) once it has users |
| An Orca plugin | `orca/<id>/` + `orca-catalog.json` | `orca plugin catalog add ChristianOrrala/agents`, then `orca plugin install christianorrala.<id>` |
| A Herdr plugin | `herdr/<name>/` | `herdr plugin install ChristianOrrala/agents/herdr/<name>` |
| A CLI or an MCP server | `packages/<name>/` | `npx @christianorrala/<name>` |
| A subagent role worth reusing | `profiles/<role>.md` | copied, or shipped inside a plugin's `agents/` |
| A prompt worth keeping | `prompts/<name>.md` | read or copied |
| Anything that needs its own releases, issues and tests | its own repository + an entry in the right catalog | the same name as before |

## Rules

1. **The repository root is the bundle plugin `christianorrala`.** Claude Code
   auto-loads `agents/`, `commands/`, `skills/` and `hooks/` at a plugin's root,
   so the root has no `agents/`, `commands/` or `hooks/` folder. Profiles live
   in `profiles/` for that reason.
2. **The bundle joins the catalogs with its first skill.** Until `skills/` holds
   one, the bundle's manifests exist but neither catalog lists it, so nobody
   can install an empty plugin.
3. **A skill's folder name is its `name`**, in kebab-case. Codex and OpenCode
   require it. Claude Code loads only `skills/<name>/SKILL.md`, one level deep.
4. **Portable frontmatter:** `name` and `description` always. Claude-only
   fields are optional; notes for one harness go at the bottom of the skill.
5. **Skills are tool-neutral.** Write against capabilities, not one harness.
6. **No paths outside a plugin's own folder.** Installed plugins are copied
   into a cache, and `../` stops resolving.
7. **Keep the repository light.** No images, videos, `node_modules`, `dist/`
   or binaries in git: every `marketplace add` clones the whole repository.
   A compiled tool ships through releases or npm.
8. **One npm scope, `@christianorrala`.** Each package has its own version
   through Changesets and is published only from CI, with npm trusted
   publishing; no npm token lives in the repository.
9. **Orca versions come from the catalog's per-commit release entries**
   (`orca plugin release-entry orca/<id>`), because git tags apply to the
   whole repository.
10. **Nothing private.** No personal setup, credentials, host names or
    machine-specific rules. Forks stay in their own repositories.
11. **Both catalogs stay in step.** Every plugin Codex can run is in both
    catalogs with the same name. Claude Code mods are in the Claude catalog only.

## Who edits what

- **This repository owns the catalogs**, the README and everything in the
  folders above.
- **Products with their own repository own their entry.** The workshop that
  builds `a-files` and `upspec` edits those two entries (in both catalogs, and
  their rows in the README) when a product changes. It doesn't rewrite the
  rest of the catalog.

## Graduation

Something moves to its own repository when it needs its own version line,
changelog, issues or tests, as `a-files` and `upspec` did. Its catalog entry
switches to a `github` source (Claude Code) and a `url` source on `main`
(Codex), and its install name stays the same, so nobody's install breaks.

## Adding a skill

1. Create `skills/<name>/SKILL.md` (`name` = the folder, plus `description`);
   `scripts/` and `references/` are optional.
2. With the first skill only: add the bundle to both catalogs, with
   `"source": "./"`, and the bundle's install line to the README.
3. Run `scripts/validate.sh`. After the push, check
   `npx skills add ChristianOrrala/agents --list` shows it.

## Adding a plugin or a mod

1. Create `claude/plugins/<name>/` or `claude/mods/<name>/` with its own
   `.claude-plugin/plugin.json` (and `.codex-plugin/plugin.json` when it works
   in Codex). Name the entry and the manifest the same.
2. Add an entry with `"source": "./claude/plugins/<name>"` (or `mods`) to the
   Claude catalog, and to the Codex catalog when Codex can run it.
3. Add its row to the README, run `scripts/validate.sh`.

## Adding a host for the first time

Each host's catalog arrives with its first plugin, never empty.

- **Orca:** create `orca-catalog.json`, add the entry printed by
  `orca plugin release-entry orca/<id>` (it includes `source.path`), run
  `orca plugin validate orca/<id>`, add the Orca install lines to the README.
- **Herdr:** add the GitHub topic `herdr-plugin` to this repository, then check
  the plugin appears on herdr.dev/plugins (the index refreshes every 30
  minutes); add the install line to the README.
- **npm:** create the root `package.json` (`"private": true`,
  `"workspaces": ["opencode/*", "packages/*"]`), set up Changesets and
  `.github/workflows/release.yml`, configure npm trusted publishing for the
  package, and publish the first version from CI.
- **OpenCode:** add the git subfolder install line to the README; move to npm
  once the plugin has users.
- **Claude Code mods:** add the entry to the Claude catalog only.

## Releasing

- **Claude Code and Codex:** a plugin's `version` in its manifest is what
  users update to; bump it with every change that should reach them. The
  bundle's version lives in `.claude-plugin/plugin.json` and
  `.codex-plugin/plugin.json`; keep both the same.
- **npm:** Changesets versions each package; CI publishes.
- **Orca:** a new release entry per plugin commit in `orca-catalog.json`.

## Checks

`scripts/validate.sh` runs before every push and in CI: it parses every JSON
manifest, checks each skill's folder against its `name`, checks the two
catalogs list the same plugins (mods aside), and runs
`claude plugin validate .` when the `claude` CLI is present.
