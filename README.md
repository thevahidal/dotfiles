# Dotfiles

This repository manages my configuration files (dotfiles) across various machines using **GNU Stow**.

The directory structure is simple: each program has its own folder (a "package") containing the files and directories that should be symlinked into the home directory (`~`).

## Installation

### Prerequisites

* **GNU Stow**

### Steps

1. **Navigate to the Stow directory:**

    ```bash
    cd ~/dev/personal/dotfiles
    ```

2. **Install (Stow) a package:**
    Use the `-t ~` flag to set your **home directory** (`~`) as the target for the symbolic links.

    *To install a single package:*

    ```bash
    stow -t ~ zsh
    stow -t ~ nvim
    stow -t ~ tmux
    stow -t ~ bin
    ```

    Packages:
    | Package | Links into `~` |
    |---|---|
    | `zsh` | `.zshrc` |
    | `nvim` | `.config/nvim` |
    | `git` | `.gitconfig` |
    | `fontconfig` | `.config/fontconfig` |
    | `tmux` | `.tmux.conf` |
    | `bin` | `.local/bin/dev-tmux`, `.local/share/dev-tmux/` |

### `dev-tmux` — backend + frontend tmux env

Shared 2×2 layout (`agent | empty` / `backend | frontend`). Project-specific paths and commands come from `$ROOT/.dev-tmux` or `DEV_TMUX_*` env (thin wrappers).

```bash
# In a project with .dev-tmux:
dev-tmux
dev-tmux --kill

# Or point at a root:
dev-tmux ~/code/myapp
```

See `~/.local/share/dev-tmux/dev-tmux.example` after stowing `bin`.

    *To install the all packages:*

    ```bash

    find . -mindepth 1 -maxdepth 1 -type d -printf '%f\0' | xargs -0 stow -t ~
    ```

## Maintenance

### Unstow / Remove Links

To remove all the symbolic links created for a package (e.g., if you are uninstalling it):

```bash
stow -D -t ~ zsh
```
