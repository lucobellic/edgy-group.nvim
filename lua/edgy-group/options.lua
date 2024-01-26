local M = {}

local Groups = require('edgy-group.groups')

---@class EdgyGroup
---@field icon number
---@field titles string[]
---@field pick_key? string Key to use for group pick.

---@class EdgyGroup.Statusline.Opts
---@field separators string[]
---@field clickable boolean
---@field colored boolean
---@field colors EdgyGroup.Statusline.Colors

---@class EdgyGroup.Statusline.Colors
---@field active string
---@field inactive string

---@class EdgyGroup.Opts
---@field groups table<Edgy.Pos, EdgyGroup[]>
---@field statusline EdgyGroup.Statusline.Opts

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
