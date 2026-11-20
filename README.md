# Christian Orrala's agents

A catalog for coding agents and the tools around them: skills, plugins and
mods for Claude Code, Codex and Orca and, as they arrive, OpenCode and Herdr.
Big products live in their own repositories; this one lists them so you can
install them by name. Small skills and plugins live here.

| Plugin | What it does | Repository |
|---|---|---|
| `upspec` | Fifteen skills for specification-first development with use cases, for any stack | [ChristianOrrala/upspec](https://github.com/ChristianOrrala/upspec) |
| `a-files` | Five files every coding agent reads first, with the skill that keeps them, their check and a git hook | [ChristianOrrala/a-files](https://github.com/ChristianOrrala/a-files) |
| `christianorrala.workflow-watch-orca` (Orca) | Workflow Watch for Orca: Open Dynamic Workflows and AgentPrism Workflows runs live in Orca's right sidebar. A community plugin, not made or endorsed by Orca or Stably | [ChristianOrrala/orca-workflow-watch](https://github.com/ChristianOrrala/orca-workflow-watch) |

## Install

Add the marketplace once, then install the plugins you want.

Claude Code:

```text
/plugin marketplace add ChristianOrrala/agents
/plugin install upspec@christianorrala
/plugin install a-files@christianorrala
```

On Claude Code 2.1.275 or later, one line does both:
`/plugin install upspec --marketplace ChristianOrrala/agents`.

Codex:

```text
codex plugin marketplace add ChristianOrrala/agents
codex plugin add upspec@christianorrala
codex plugin add a-files@christianorrala
```

Orca (1.4.248 or later for Workflow Watch). Adding the catalog and
installing a plugin that runs code each ask once for `--approve` with the
fingerprint Orca prints:

```text
orca plugin catalog add ChristianOrrala/agents
orca plugin install christianorrala.workflow-watch-orca
```

### Moving from `christian-orrala`

The marketplace used to be called `christian-orrala`, in a repository named
`plugins`. If you added it under that name, remove it and add it again. This
uninstalls its plugins, so install them again afterwards:

```text
/plugin marketplace remove christian-orrala
/plugin marketplace add ChristianOrrala/agents
/plugin install upspec@christianorrala
/plugin install a-files@christianorrala
```

## Using them together

Each plugin works alone. In one project they work together: the A-files
track the work, and each ability in `ABILITIES.md` links to the upspec use
cases that specify it.
Each plugin's README explains how to start.

## How this repository is organized

[AGENTS.md](AGENTS.md) holds the layout and its rules: what goes where, how a
new skill, plugin or host joins, and how each one is released.

## License

MIT. Copyright (c) 2026 Christian Orrala.
