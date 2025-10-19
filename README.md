# Dotfiles

This repository manages my configuration files (dotfiles) across various machines using **GNU Stow**.

The directory structure is simple: each program has its own folder (a "package") containing the files and directories that should be symlinked into the home directory (`~`).

## Installation

### Prerequisites

* **GNU Stow**

### Steps

1. **Navigate to the Stow directory:**

    ```bash
    cd ~/dev/dotfiles
    ```

2. **Install (Stow) a package:**
    Use the `-t ~` flag to set your **home directory** (`~`) as the target for the symbolic links.

    *To install a single package:*

    ```bash
    stow -t ~ zsh
    stow -t ~ nvim
    ```

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
