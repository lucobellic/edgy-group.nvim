local M = {}

local Groups = require('edgy-group.groups')

---@class EdgyGroup
---@field icon string icon used in statusline and vim.ui.select
---@field titles string[] list of titles from edgy.nvim
---@field pick_key? string Key to use for group pick.

---@class EdgyGroup.Statusline.Opts
---@field separators { [1]: string, [2]: string } suffix and prefix separators between icons
---@field clickable boolean enable `open_group` on click
---@field colored boolean enable highlighting support
---@field colors EdgyGroup.Statusline.Colors highlight colors for icon and pick key

---@class EdgyGroup.Statusline.Colors
---@field active string highlight color for open group
---@field inactive string highlight color for closed group
---@field pick_active string highlight color for pick key for open group
---@field pick_inactive string highlight color for pick key for closed group

---@class EdgyGroup.Opts
---@field groups table<Edgy.Pos, EdgyGroup[]> list of groups for each position
---@field statusline EdgyGroup.Statusline.Opts statusline options

---@type EdgyGroup.Opts
local default_options = {
  groups = {
    right = {},
    left = {},
    bottom = {},
    top = {},
  },
  statusline = {
    separators = { ' ', ' ' },
    clickable = false,
    colored = false,
    colors = {
      active = 'Normal',
      inactive = 'Normal',
      pick_active = 'PmenuSel',
      pick_inactive = 'PmenuSel',
    },
  },
}

---@class EdgyGroups.Opts.Parsed
---@field groups table<Edgy.Pos, EdgyGroup.IndexedGroups>
---@field statusline EdgyGroup.Statusline.Opts

---@param opts EdgyGroup.Opts?
---@return EdgyGroups.Opts.Parsed
function M.setup(opts)
  ---@type EdgyGroups.Opts.Parsed
  ---@diagnostic disable-next-line: assign-type-mismatch
  local options = default_options

  local default_groups = default_options.groups
  for _, pos in ipairs({ 'right', 'left', 'bottom', 'top' }) do
    local groups = opts and opts.groups[pos] or default_groups[pos]
    options.groups[pos] = Groups.new({
      selected_index = 1,
      groups = groups or {},
    })
  end
  ---@diagnostic disable-next-line: assign-type-mismatch
  options.statusline = vim.tbl_deep_extend('force', default_options.statusline, opts and opts.statusline or {})
  return options
end

return M
