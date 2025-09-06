<!-- panvimdoc-ignore-start -->
<h1 align="center">
  🖇️ edgy-group.nvim
</h1>

https://github.com/lucobellic/edgy-group.nvim/assets/6067072/6bee2762-9cc7-46d8-82a7-17b4e0f64cf7

<p align="center">
  <img src="https://img.shields.io/github/v/tag/lucobellic/edgy-group.nvim?label=version&style=for-the-badge" alt="Version">
  <img src="https://img.shields.io/github/license/lucobellic/edgy-group.nvim?style=for-the-badge" alt="License">
  <img src="https://img.shields.io/github/issues/lucobellic/edgy-group.nvim?style=for-the-badge" alt="Issues">
  <img src="https://img.shields.io/github/last-commit/lucobellic/edgy-group.nvim?style=for-the-badge" alt="Last Commit">
</p>

<!--toc:start-->
- [✨ Features](#features)
- [⚠️ Limitations](#️-limitations)
- [⚡️ Requirements](#️-requirements)
- [📦️ Installation](#📦️-installation)
- [🚀️ Usage](#🚀️-usage)
  - [🎛️ Options](#🎛️-options)
    - [Groups](#groups)
  - [🔌 API](#🔌-api)
- [🌈 Highlights](#🌈-highlights)
- [Example Setup](#example-setup)
  - [Custom Picker Behavior](#custom-picker-behavior)
  - [Statusline](#statusline)
    - [Bufferline](#bufferline)
    - [Lualine](#lualine)
    - [Heirline](#heirline)
    - [Tabby](#tabby)
    - [Picking](#picking)
<!--toc:end-->

<!-- panvimdoc-ignore-end -->

[edgy-group.nvim](https://github.com/lucobellic/edgy-group.nvim) extends [edgy.nvim](https://github.com/folke/edgy.nvim) by providing a simple method for organizing windows within **edgebar** based on their title.

## ✨ Features

- Switch between groups of windows within **edgebar**.
- Add a command to navigate through groups of windows.
- Allow the creation of custom icon indicators in statusline, bufferline, etc.
- Pick mode to select group from statusline

## ⚠️ Limitations

**edgy-group.nvim** does not introduce a new **edgebar** for each position.
It is a simple wrapper around **edgy.nvim** that is used
to open and close windows within the same **edgebar**.

- All **edgy** windows require a unique **title** in order to create groups.
- Opening a window with a function or command call will not automatically
  switch to the corresponding group.

## ⚡️ Requirements

[edgy.nvim](https://github.com/folke/edgy.nvim)

## 📦️ Installation

Install the plugin using your preferred package manager.

[lazy.nvim]("https://github.com/folke/lazy.nvim"):

```lua
{
  "lucobellic/edgy-group.nvim",
  dependencies = {"folke/edgy.nvim"}
  event = "VeryLazy",
  opts = {},
}
```

## 🚀️ Usage

You can open and close groups of windows using keymaps, commands, or APIs.

### 🎛️ Options

```lua
local default_options = {
  groups = {
    right = {}, -- { icon = '',  titles = { 'Neo-Tree', 'Neo-Tree Buffers' } }
    left = {},
    bottom = {},
    top = {},
  },
  -- configuration for `require('edgy-group.stl').get_statusline(pos)`
  statusline = {
    -- suffix and prefix separators between icons
    separators = { ' ', ' ' },
    clickable = false, -- open group on click
    colored = false, -- enable highlight support
    colors = { -- highlight group links (see Highlight Groups section)
      active = 'Normal', -- set EdgyGroupActive highlight
      inactive = 'Normal', -- set EdgyGroupInactive highlight
      pick_active = 'PmenuSel', -- set EdgyGroupPickActive highlight
      pick_inactive = 'PmenuSel', -- set EdgyGroupPickInactive highlight
      separator_active = 'Normal', -- set EdgyGroupSeparatorActive highlight
      separator_inactive = 'Normal', -- set EdgyGroupSeparatorInactive highlight
    },
    -- pick key position: left, right, left_separator, right_separator, icon
    -- left: before left separator
    -- right: after right separator
    -- left_separator, right_separator and icon: replace the corresponding element
    pick_key_pose = 'left',
    pick_function = nil, -- optional function to override default behavior
  },
  toggle = true, -- toggle group when at least one window is already open
}
```

#### Groups

```lua
groups = {
  right = { -- group position (right, left, bottom, top)
    {
      icon = '', -- icon used in statusline and vim.ui.select
      titles = { 'Neo-Tree', 'Neo-Tree Buffers' }, -- list of titles from edgy.nvim
      pick_key = 'f' -- key to pick a group in statusline
    },
  },
}
```

Groups without pick_key will be assigned to the first available key in alphabetical order.

### 🔌 API

- **EdgyGroupSelect** select group to open with **vim.ui.select**.
- **EdgyGroupNext position** open next group at given position.
- **EdgyGroupPrev position** open previous group at given position.
- **require('edgy-group').open_group_offset(position, offset)**  
  open group with offset relative to the current group.
- **require('edgy-group').open_group_index(position, index)**  
  open group with index relative to the current position.
- **require('edgy-group').open_groups_by_key(key, opts?)**  
  open one or multiple groups with this key, with optional table {position, toggle}.
- **require('edgy-group.stl').get_statusline(position)**  
  get a list of string in statusline format for each group icons with optional  
  highlight and click support.
- **require('edgy-group.stl').pick(callback)**
  enable picking mode to select group from statusline.

## 🌈 Highlights

**edgy-group.nvim** offers a flexible highlighting system that allows you to
customize the appearance of group icons, separators, and pick icons.

The following highlights are created and set based on the configuration:

- `EdgyGroupActive` / `EdgyGroupInactive`
- `EdgyGroupPickActive` / `EdgyGroupPickInactive`
- `EdgyGroupSeparatorActive` / `EdgyGroupSeparatorInactive`

For more granular control, groups specific to both position and index are also
created, following the format `EdgyGroup<Category><Status><Position><Index>`:

- `EdgyGroupActiveLeft1`, `EdgyGroupSeparatorInactiveRight2`, etc.

By default, highlight groups are linked hierarchically by their level of specificity:

- `EdgyGroupActiveLeft1` → `EdgyGroupActiveLeft` → `EdgyGroupActive` → (configuration)

This allows you to style individual group based on their position and order in
the statusline, enabling dynamic rainbow sliding effects or other
customizations.

## Example Setup

> [!WARNING]
> Only groups with a provided title will be displayed.  
> A default group will not be created if titles from edgy are missing.

Usage of **edgy-group.nvim** to create three groups for the left **edgebar**:

```lua
{
  "lucobellic/edgy-group.nvim",
  event = "VeryLazy"
  dependencies = { "folke/edgy.nvim" },
  keys = {
    {
      '<leader>el',
      function() require('edgy-group').open_group_offset('left', 1) end,
      desc = 'Edgy Group Next Left',
    },
    {
      '<leader>eh',
      function() require('edgy-group').open_group_offset('left', -1) end,
      desc = 'Edgy Group Prev Left',
    },
    {
      '<c-,>',
      function()
        require('edgy-group.stl').pick()
      end,
      desc = 'Edgy Group Pick',
    },
  },
  opts = {
    groups = {
      left = {
        { icon = '',  titles = { 'Neo-Tree', 'Neo-Tree Buffers' } },
        { icon = '',  titles = { 'Neo-Tree Git' } },
        { icon = '',  titles = { 'Outline' } },
      },
    },
    statusline = {
      separators = { ' ', ' ' },
      clickable = true,
      colored = true,
      colors = {
        active = 'PmenuSel',
        inactive = 'Pmenu',
      },
    },
  }
}

-- edgy configuration (simplified)
{
  "folke/edgy.nvim",
  -- ...
  opts = {
    -- ...
    left = {
      {
        title = "Neo-Tree",
        ft = "neo-tree",
        filter = function(buf) return vim.b[buf].neo_tree_source == "filesystem" end,
        size = { height = 0.5 },
        open = "Neotree position=left filesystem",
      },
      {
        title = "Neo-Tree Buffers",
        ft = "neo-tree",
        filter = function(buf) return vim.b[buf].neo_tree_source == "buffers" end,
        open = "Neotree position=top buffers",
      },
      {
        title = "Neo-Tree Git",
        ft = "neo-tree",
        filter = function(buf) return vim.b[buf].neo_tree_source == "git_status" end,
        open = "Neotree position=right git_status",
      },
      {
        ft = "Outline",
        open = "SymbolsOutlineOpen",
      },
    },
  },
}
```

### Custom Picker Behavior

Optionally create a custom picker function to define
your own behavior when selecting a group by key.

- Default behavior call `open_group_index` for each group with the same key

```lua
opts = {
  pick_function = function(key)
    local edgy_group = require('edgy-group')
    for _, group in ipairs(edgy_group.get_groups_by_key(key)) do
      pcall(edgy_group.open_group_index, group.position, group.index)
    end
  end,
}
```

- Use upper case key to focus all element instead of toggling

```lua
opts = {
  pick_function = function(key)
    local toggle = not key:match('%u')
    local edgy_group = require('edgy-group')
    for _, group in ipairs(edgy_group.get_groups_by_key(key:lower())) do
      pcall(edgy_group.open_group_index, group.position, group.index, toggle)
    end
  end,
}
```

### Statusline

Examples of how to use **edgy-group.nvim** with
[bufferline.nvim](https://github.com/akinsho/bufferline.nvim),
[lualine.nvim](https://github.com/nvim-lualine/lualine.nvim),
[heirline.nvim](https://github.com/rebelot/heirline.nvim),
[tabby.nvim](https://github.com/nanozuki/tabby.nvim)
to add group icons with highlight and click support.

#### Bufferline

```lua
{
  "akinsho/bufferline.nvim",
  -- ...
  opts = {
    options = {
      custom_areas = {
        left = function()
          return vim.tbl_map(
            function(item) return { text = item } end,
            require('edgy-group.stl').get_statusline('left')
          )
        end,
      },
    },
  }
}
```

#### Lualine

```lua
{
  'nvim-lualine/lualine.nvim',
  -- ...
  opts = {
    sections = {
      lualine_c = {
        '%=',
        {
          function()
            local stl = require('edgy-group.stl')
            local bottom_line = stl.get_statusline('bottom')
            return table.concat(bottom_line)
          end,
        },
      },
    },
  },
}
```

#### Heirline

```lua
local EdgyGroup = {
  provider = function()
    local stl = require('edgy-group.stl')
    local bottom_line = stl.get_statusline('bottom')
    return table.concat(bottom_line)
  end
}
```

#### Tabby

```lua
return {
  'nanozuki/tabby.nvim',
  --- ...
  opts = {
    line = function(line)
      return {
        require('edgy-group.stl').get_statusline('left'),
        -- ...
        line.spacer(),
        -- ...
        require('edgy-group.stl').get_statusline('right'),
      }
    end,
  },
}
```

#### Picking

```lua
-- default
require('edgy-group.stl').pick()

-- with lualine add a refresh callback
require('edgy-group.stl').pick(function() require('lualine').refresh() end)
```
