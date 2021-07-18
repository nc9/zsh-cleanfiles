# cleanfiles plugin

A plugin for oh-my-zsh that finds and optionally cleans up large files and caches.

## Quick Install

The following script will clone the repo and install the plugin

```sh
curl -s https://raw.githubusercontent.com/nc9/zsh-cleanfiles/main/install.sh | sh
```

## Manual Install

Clone the repository to your local `oh-my-zsh` plugins folder

```sh
git clone --depth=1 --quiet https://github.com/nc9/zsh-cleanfiles.git ~/.local/share/oh-my-zsh/custom/plugins/cleanfiles
```

To use, add `copyfile` to your plugins array in your `.zshrc`:

```zsh
plugins=(... cleanfiles)
```

## Commands

Available commands are:

- `largefiles DIR` - find top large files in specified folder
