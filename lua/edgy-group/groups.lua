---@class EdgyGroup.IndexedGroups
---@field selected_index number index of the selected group
---@field groups EdgyGroup[] list of groups
local M = {}

---@param opts EdgyGroup.IndexedGroups?
---@return EdgyGroup.IndexedGroups
function M.new(opts)
  local self = setmetatable(opts or { selected_index = 1, groups = {} }, { __index = M })
  return self
end

function M:get_offset_index(offset)
  return (self.selected_index + offset - 1) % #self.groups + 1
end

---@return EdgyGroup
function M:get_selected_group()
  return self.groups[self.selected_index]
end

---@return EdgyGroup[]
function M:get_groups_before_selected()
  return vim.list_slice(self.groups, 1, self.selected_index - 1)
end

---@return EdgyGroup[]
function M:get_groups_after_selected()
  return vim.list_slice(self.groups, self.selected_index + 1)
end

return M
