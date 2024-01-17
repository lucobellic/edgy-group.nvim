local Group = require('edgy-group')

local M = {}

---@class SelectionItem
---@field pos Edgy.Pos Position of the group
---@field index number Relative index in the group
---@field group EdgyGroup

-- Get a list of groups with relative index and position
---@return SelectionItem[]
local function create_selectable_groups()
  ---@type SelectionItem[]
  local items = {}
  for pos, indexed_groups in pairs(Group.groups_by_pos or {}) do
    for index, group in ipairs(indexed_groups.groups or {}) do
      table.insert(items, {
        pos = pos,
        index = index,
        group = group,
      })
    end
  end
  return items
end

function M.setup()
  -- Convenient list of item to select a group to open with position and relative index
  local selectable_groups = create_selectable_groups()

  local user_command_opts = {
    nargs = 1,
    complete = function() return { 'right', 'left', 'top', 'bottom' } end,
  }

  vim.api.nvim_create_user_command(
    'EdgyGroupNext',
    function(opts) require('edgy-group').open_group_offset(opts.args, 1) end,
    user_command_opts
  )

  vim.api.nvim_create_user_command(
    'EdgyGroupPrev',
    function(opts) require('edgy-group').open_group_offset(opts.args, -1) end,
    user_command_opts
  )

  -- Select a group to open from args or with vim.ui.select
  vim.api.nvim_create_user_command('EdgyGroupSelect', function(opts)
    if #opts.args == 0 then
      vim.ui.select(
        selectable_groups,
        {
          prompt = 'Select Edgy Group:',
          ---@param item? SelectionItem
          format_item = function(item)
            if item then
              return item.pos .. ': ' .. item.group.icon .. ' - ' .. table.concat(item.group.titles, ', ')
            end
          end,
          kind = 'edgy-group',
        },
        ---@param item? SelectionItem
        function(item)
          if item then
            require('edgy-group').open_group_index(item.pos, item.index)
          end
        end
      )
    end
  end, {})
end

return M
