 <!-- panvimdoc-ignore-start -->
<h1 align="center">
  🖇️ edgy-group.nvim
</h1>

> [!IMPORTANT]
> This plugin is mainly for personal and demonstration purposes and have a lot of limitations.<br/>
> Limited support will be provided for issues and pull requests.<br/>
> I would prefer to have this plugin integrated directly into edgy.nvim.

https://github.com/lucobellic/edgy-group.nvim/assets/6067072/00feeae1-6d6c-486c-a93c-25688ff37766

<p align="center">
  <img src="https://img.shields.io/github/v/tag/lucobellic/edgy-group.nvim?label=version&style=for-the-badge" alt="Version">
  <img src="https://img.shields.io/github/license/lucobellic/edgy-group.nvim?style=for-the-badge" alt="License">
  <img src="https://img.shields.io/github/issues/lucobellic/edgy-group.nvim?style=for-the-badge" alt="Issues">
  <img src="https://img.shields.io/github/last-commit/lucobellic/edgy-group.nvim?style=for-the-badge" alt="Last Commit">
</p>
 <!-- panvimdoc-ignore-end -->

[edgy-group.nvim](https://github.com/lucobellic/edgy-group.nvim) extends [edgy.nvim](https://github.com/folke/edgy.nvim)</b> by providing a simple method for organizing windows within **edgebar** based on their title.

## ✨ Features

- Switch between groups of windows within **edgebar**.
- Add a command to navigate through groups of windows.
- Allow the creation of custom icon indicators in statusline, bufferline, etc.
- Pick mode to select group from statusline

## ⚠️ Limitations

**edgy-group.nvim** does not introduce a new **edgebar** for each position. It is a simple wrapper around **edgy.nvim** that is used to open and close windows within the same **edgebar**.

- All **edgy** windows require a unique **title** in order to create groups.
- All **edgy** windows require an **open** command to open each window.
- Opening a window with a function or command call will not automatically switch to the corresponding group.
- Switching between groups always sets the cursor to one of the **edgebar** windows and does not restore the previous cursor position.

### Advice

- It is preferable to use at least one **pinned** window with the **close_when_all_hidden** option set to **false** in order to prevent the **edgebar** from "blinking" when switching between groups.<br/>
  A possible solution would be to wait until at least one window is opened before closing any existing ones.

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
  -- configuration for `require('edgy-group.stl.statusline').get_statusline(pos)`
  statusline = {
    -- suffix and prefix separators between icons
    separators = { ' ', ' ' },
    clickable = false, -- enable `open_group` on click
    colored = false, -- enable highlight support
    colors = { -- highlight colors
      active = 'Normal', -- highlight color for open group
      inactive = 'Normal', -- highlight color for closed group
      pick_active = 'PmenuSel', -- highlight color for pick key for open group
      pick_inactive = 'PmenuSel', -- highlight color for pick key for closed group
    },
  },
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
- **require('edgy-group').open_group_offset(position, offset)** open group with offset relative to the current group.
- **require('edgy-group').open_group_index(position, index)** open group with index relative to the current position.
- **require('edgy-group.stl.statusline').get_statusline(position)** get a list of string in statusline format for each group icons with optional highlight and click support.
- **require('edgy-group.stl.statusline').pick(callback)** enable picking mode to select group from statusline.

## Example Setup

> [!WARNING]
> Only groups with a provided title will be displayed.<br/>
> A default group will not be created if titles from edgy are missing.

Usage of **edgy-group.nvim** to create three groups for the left **edgebar**:

```lua
{
  "lucobellic/edgy-group.nvim",
  event = "VeryLazy"
  dependencies = {"folke/edgy.nvim"}
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
        require('edgy-group.stl.statusline').pick()
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
```

### Statusline

Examples of how to use **edgy-group.nvim** with [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) and [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) to add group icons with highlight and click support.

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
            require('edgy-group.stl.statusline').get_statusline('left')
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
          function() return table.concat(require('edgy-group.stl.statusline').get_statusline('bottom')) end,
        },
      },
    },
  },
}
```

##### Picking

```lua
require('edgy-group.stl.statusline').pick(function() require('lualine').refresh() end)
```
