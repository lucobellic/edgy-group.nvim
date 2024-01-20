<h1 align="center">
  🖇️ edgy-group.nvim
</h1>

<p align="center"><b>edgy-group.nvim</b> extends <b><a href=https://github.com/folke/edgy.nvim>edgy.nvim</a></b> by providing a simple method for organizing windows within the <b>edgebar</b> based on their title.</p>

---

> [!IMPORTANT]
> This plugin is intended for personal and demonstration purposes only and have a lot of limitations.<br/>
> It is not recommended to use this plugin.

---

Using **edgy-group** with icons in the top left corner of the bufferline.

![edgy-group](https://github.com/lucobellic/edgy-group.nvim/assets/6067072/a47a6e7f-17fb-4f2a-8116-904c89fa8da3)

---

## ✨ Features

- Switch between groups of windows within the **edgebar**.
- Add a command to navigate through groups of windows.
- Allow the creation of custom icon indicators in the statusline, bufferline, etc.

## ⚠️ Limitations

**edgy-group.nvim** does not introduce a new **edgebar** for each position. It is a simple wrapper around **edgy.nvim** that is used to open and close windows within the same **edgebar**.

- All **edgy** windows require a unique **title** in order to create groups.
- All **edgy** windows require an **open** command to open each window.
- Opening a window with a function or command call will not automatically switch to the corresponding group.
- Switching between groups always sets the cursor to one of the **edgebar** windows and does not restore the previous cursor position.

### Advice

- It is preferable to use at least one **pinned** window with the **close_when_all_hidden** option set to **true** in order to prevent the **edgebar** from "blinking" when switching between groups.<br/>
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
      active = 'Normal',
      inactive = 'Normal',
    },
  },
}
```

### 🔌 API

- **EdgyGroupSelect** select group to open with **vim.ui.select**.
- **EdgyGroupNext position** open next group at given position.
- **EdgyGroupPrev position** open previous group at given position.
- **require('edgy-group').open_group_offset(position, offset)** open group with offset relative to the current group.
- **require('edgy-group').open_group_index(position, index)** open group with index relative to the current position.
- **require('edgy-group.stl.statusline').get_statusline(position)** get a list of string in statusline format for each group icons with optional highlight and click support.

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

### Example with statusline

Here are some examples of how to use **edgy-group.nvim** with [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) and [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) to add group icons with highlight and click support.

#### bufferline

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

#### lualine

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
