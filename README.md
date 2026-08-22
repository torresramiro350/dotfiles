# Personal dotfiles

<!--toc:start-->
- [Personal dotfiles](#personal-dotfiles)
  - [Installation](#installation)
    - [Requirements](#requirements)
<!--toc:end-->

> [!IMPORTANT]
> Repo to manage all my dotfiles

Use GNU [stow](https://www.gnu.org/software/stow) a small GNU tools cli that makes
the maintenance of configuration files more manageable.

## Installation

### Requirements

`stow` should be available from any Linux distribution repos.

To manage and deploy dotfiles to new system easily, simply:

- clone the repo

```bash
git clone https://github.com/torresramiro350/dotfiles.git
```

- navigate to repo
- install the dotfiles

Example:

```bash
stow kitty
```
