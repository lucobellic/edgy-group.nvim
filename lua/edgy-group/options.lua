local M = {}

local Groups = require('edgy-group.groups')

---@class EdgyGroup
---@field icon number
---@field titles string[]

---@class EdgyGroup.Opts
---@field groups table<Edgy.Pos, EdgyGroup[]>

---@type table<Edgy.Pos, EdgyGroup.IndexedGroups>
local default_groups = {
  right = Groups.new({
    selected_index = 1,
    groups = {},
  }),
  left = Groups.new({
    selected_index = 1,
    groups = {},
  }),
  bottom = Groups.new({
    selected_index = 1,
    groups = {},
  }),
  top = Groups.new({
    selected_index = 1,
    groups = {},
  }),
}

---@param opts EdgyGroup.Opts?
---@return EdgyGroup.Opts
function M.setup(opts)
  local options = default_groups
  for pos, groups in pairs(opts and opts.groups or {}) do
    options[pos].groups = groups or {}
  end
  return options
end

return M
