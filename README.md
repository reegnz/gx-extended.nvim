# ⭐ gx-extended.nvim

A Neovim plugin that extends the functionality of the gx mapping.
In Neovim, the `gx` mapping in normal mode allows you to navigate to the url under the cursor. This plugin extends that behaviour to more than just urls.

## 🎉 Built-in Features
- `package.json` - `gx` when cursor is under an npm dependency, nagivates to _https://www.npmjs.com/package/[packageName]_
- `plugins.lua` - In packer.nvim's convention `plugins.lua` file, `gx` when cursor is under an npm dependency, nagivates to _https://github.com/[user/org]/[repo]_
- `*.tf` - In a [terraform](https://www.terraform.io/) file, `gx` when cursor is under a [terraform resource definition](https://developer.hashicorp.com/terraform/language/resources) nagivates to _https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/[resourceName]_
- `*` - In any file, `gx` navigates to no-protocol-urls like `google.com`, `docs.google.com`, etc.

## 🚀 Showcase
Opening the registry docs for aws terraform resources

https://user-images.githubusercontent.com/2881382/230259520-c2e84260-4e79-47ff-9c40-62a5162b15c0.mov

## 📦 Installation

```lua
use {
  'rmagatti/gx-extended.nvim',
  config = function()
    require('gx-extended').setup {}
  end
}
```

## ⚙️  Configuring
You can pass custom extensions to the `extensions` table. Each extension should have at least two properties:
1. `patterns`, a list of file glob patterns to run the autocomands for.
    Important: the plugin matches the glob on the file path of the current file now; meaning for example that setting `plugins.lua` won't match correctly but `*plugins.lua` will.
2. `match_to_url`, a function to run the match and return the composed url to be used by the `gx` command

The following is an example of hitting `gx` on a terraform file on a line where an aws resource is defined and opening your browser directly on the terraform registry documentation for the specific resource.
```lua
use {
  'rmagatti/gx-extended.nvim',
  config = function()
    require("gx-extended").setup {
      extensions = {
        { -- match github repos in lazy.nvim plugin specs 
          patterns = { '*/plugins/**/*.lua' },
          match_to_url = function(line_string)
            local line = string.match(line_string, '["|\'].*/.*["|\']')
            local repo = vim.split(line, ':')[1]:gsub('["|\']', '')
            local url = 'https://github.com/' .. repo
            return line and repo and url or nil
          end,
        }
      },
    }
  end
```

By default, gx-extended uses netrw to open urls. You can pass a custom open 
function to config to change this behaviour. For example, if you use 
`lazy.nvim`, you can  configure gx-extended to use it's `open` function:

```lua
return { 'rmagatti/gx-extended.nvim',
  keys = { 'gx' },
  opts = {
    open_fn = require'lazy.util'.open,
    }
  }
}
```

## TODOs
- Implement `visual` mode

### Inspiration/Alternatives
https://github.com/stsewd/gx-extended.vim
