# Neovim configuration

<!-- toc -->

- [Configuration overview](#configuration-overview)
  * [Acknowledgements](#acknowledgements)
  * [Structure of the configuration](#structure-of-the-configuration)
  * [Lazy loading](#lazy-loading)
  * [UI](#ui)
  * [colorscheme](#colorscheme)
  * [LSP](#lsp)

<!-- tocstop -->

## Configuration overview

### Acknowledgements

> [!NOTE]
> First configuration after using other Nvim distros. There's lots of rooms for improvements,
> but this is working for me so far

Taking great inspiration from Kickstart

### Structure of the configuration

```bash
 .
├──  lua
│  ├──  groups
│  ├──  keymaps
│  ├──  lazyvim
│  ├──  plugins
│  └──  vim_options
├──  init.lua
├──  lazy-lock.json
├──  README.md
```

### Lazy loading

I try to keep to lazy load as many plugins as possible.
Here's a breakdown of my current plugins:

### UI

- [ ] nvim-tree
- [ ] noice
- [ ] ufo
- [ ] mini.comments
- [ ] mini.files
- [ ] mini.ai

> [!NOTE]
> Now using more plugins from the `mini.nvim` and `snacks.nvim` plugin libraries.

### colorscheme

Using the `catppuccin` colorscheme. I love the `mocha` variant

### LSP

Formatting:

> formatting is only provided for the LSPs that don't have a built-in formatter

- conform.nvim
- nvim-lspconfig
- nvim-lint
