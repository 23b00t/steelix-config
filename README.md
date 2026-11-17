# steelix-config

Helix config for [steelix](https://github.com/mattwparas/helix) (Helix with Steel plugins).
Plugin management: [smith.hx](https://github.com/kn66/smith.hx).

| File | Purpose |
|---|---|
| `config.toml`, `languages.toml` | regular Helix config (taken over from hIDE) |
| `init.scm` | plugin declarations via smith |
| `helix.scm` | exposes `:smith-*` commands and `:update-named` (Esc saves the buffer, skips scratch buffers) |

## Plugins

| Plugin | Purpose | Usage |
|---|---|---|
| [forest.hx](https://github.com/Ra77a3l3-jar/forest.hx) | file tree | `Space e` / `:forest-open` |
| [zj-navigator.hx](https://github.com/dmyyy/zj-navigator.hx) | Helix splits ↔ Zellij panes | `A-h/j/k/l` |
| [notify.hx](https://github.com/chuwy/notify.hx) | notification popups | `:notify "…"` |
| [glyph.hx](https://github.com/Ra77a3l3-jar/glyph.hx) | Nerd Font icon library | – |

Without Steel plugins (plain bindings in `config.toml`, local leader `\`):

| Tool | Purpose | Usage |
|---|---|---|
| [scooter](https://github.com/thomasschafer/scooter) (CLI) | find & replace | `\ r` |
| yazi | file picker | `\ y` |
| lazygit | git | `\ g l` |

## Setup (NoX)

Everything outside this repo comes from the NixOS config (NoX `services.ide.steelix`):

- packages: `steelix` (provides `hx`), `steel` (provides `forge`, which smith uses to install
  the plugins), the CLIs `scooter`, `yazi`, `lazygit`
- smith.hx itself: pinned in Nix and found through `STEEL_SEARCH_PATHS`, no
  `forge pkg install` needed
- this repo: `services.ide.steelix.configRepo = "<url>";` clones it into `~/.config/helix`
  at boot and fast-forwards it on every boot (no pull while there are local changes)
- the Zellij side of zj-navigator, see below

Then:

1. Start `hx` → `(smith-init)` installs all plugins with forge (network needed on the first
   start). Check with `:smith-list`.
2. Pin versions: `:smith-lock` → commit `steel/plugins/smith-lock.scm`.

Don't run `:smith-self-update`: it installs a forge copy of smith into `$STEEL_HOME/cogs`,
which then wins over the pinned one from Nix.

Language servers from `languages.toml` (`marksman`, `codebook-lsp`, `rust-analyzer`) are used
where they are installed; where one is missing Helix starts normally without it
(`hx --health <language>` shows what is there).

## Zellij side for zj-navigator

The `hx-navigator` WASM plugin is built with Nix and installed as
`/etc/zellij/plugins/hx-navigator.wasm` (NoX `services.zellij-env.plugins`). `config.kdl`
loads it and binds `Alt h/j/k/l` in `shared_among "normal" "locked"` (the default mode is
`locked`, so `shared_except "locked"` from the upstream README would never fire):

```kdl
load_plugins {
    "file:/etc/zellij/plugins/hx-navigator.wasm"
}

keybinds {
    shared_among "normal" "locked" {
        bind "Alt h" { MessagePlugin "file:/etc/zellij/plugins/hx-navigator.wasm" { name "focus_left"; }; }
        bind "Alt j" { MessagePlugin "file:/etc/zellij/plugins/hx-navigator.wasm" { name "focus_down"; }; }
        bind "Alt k" { MessagePlugin "file:/etc/zellij/plugins/hx-navigator.wasm" { name "focus_up"; }; }
        bind "Alt l" { MessagePlugin "file:/etc/zellij/plugins/hx-navigator.wasm" { name "focus_right"; }; }
    }
}
```

In an `hx` pane the plugin passes `Alt h/j/k/l` on to Helix (split navigation first, then
`zellij action move-focus`); elsewhere it moves the Zellij focus. While yazi, lazygit or
scooter run inside hx, the `external_tui_enter`/`external_tui_exit` pipes in `config.toml`
tell the plugin to move the Zellij focus instead.

Grant the plugin permissions when Zellij asks (once per plugin path).
