<h1 align="center">
  🖇️ edgy-group.nvim
</h1>

<p align="center"><b>edgy-group.nvim</b> provides a straightforward approach to arranging windows within <b>edgebar</b> according to their title.</p>

---

> [!IMPORTANT]
> This plugin is intended for personal and demonstration purposes only and have a lot of limitations
> It is not recommended to use this plugin.

---

Usage of **edgy-group** with icons in bufferline top left corner.

![edgy-group](https://github.com/lucobellic/edgy-group.nvim/assets/6067072/a47a6e7f-17fb-4f2a-8116-904c89fa8da3)

---

## ✨ Features

- Switch between groups of windows within **edgebar**.
- Add command to navigate throw groups of windows.
- Allow to create custom icon indicators in statusline, bufferline, etc.

## ⚠️ Limitations

**edgy-group.nvim** do not introduce new **edgebar** per position it's a simple wrapper around **edgy.nvim** used to open and close windows within the same **edgebar**.

- All **edgy** windows require an unique **title** to create groups.
- All **edgy** windows require an **open** command to open each window.
- Opening a window with function or command call will not automatically switch to the corresponding group.
- Switching between groups always set the cursor to one of the **edgbar** window and do not restore the previous cursor position.

### Advice

- Prefer to use at least one **pinned** window with **close_when_all_hidden** set to **true** to avoid **edgebar** _"blinking"_ when switching between groups.
  A fix would be to wait for at least one window to be opened before closing existing ones.

## ⚡️ Requirements

[edgy.nvim](https://github.com/folke/edgy.nvim)

## 📦️ Installation

Install the plugin with your preferred package manager:

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

Open and close groups of windows with keymaps, command or API.

### 🔌 API

- **EdgyGroupSelect** select group to open with **vim.ui.select**
- **EdgyGroupNext position** open next group at given position
- **EdgyGroupPrev position** open previous group at given position
- **require('edgy-group').open_group_offset(position, offset)** open group with offset relative to the current group
- **require('edgy-group').open_group_index(position, index)** open group with index relative to the current position

## Example Setup

> [!WARNING]
> Only groups with provided title are displayed.
> No default group is created if titles from edgy are not provided.

The following example use **edgy-group.nvim** to create three groups for the left **edgebar**:

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
      { icon = '', pos = 'left', titles = { 'Neo-Tree', 'Neo-Tree Buffers' } },
      { icon = '', pos = 'left', titles = { 'Neo-Tree Git' } },
      { icon = '', pos = 'left', titles = { 'Outline' } },
  }
}
```

### Example with bufferline

Here is an example of how to use **edgy-group.nvim** with [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) to add group icons on the left section of bufferline.

```lua
{
  "akinsho/bufferline.nvim",
  -- ...
  opts = {
    options = {
      custom_areas = {
        left = function()
          local result = {}
          local position = 'left'
          local edgy_group = require('edgy-group')
          local edgebar = require('edgy.config').layout[position]
          if edgebar and edgebar.visible ~= 0 then
            local groups = vim.tbl_filter(function(group) return group.pos == position end, edgy_group.groups)
            for i, group in ipairs(groups) do
              local title = ' ' .. group.icon .. '  '
              local is_current = edgy_group.current_group_index[position] == i
              local highlight = is_current and 'BufferLineTabSelected' or 'BufferLineTab'
              table.insert(result, { text = title, link = highlight })
            end
          end
          return result
        end,
      },
    },
  }
}
```
