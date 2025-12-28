---@class EdgyGroup.IndexedGroups
---@field selected_index number index of the selected group
---@field active_indices table<number, boolean> set of active group indices
---@field groups EdgyGroup[] list of groups
local M = {}

---@param opts EdgyGroup.IndexedGroups?
---@return EdgyGroup.IndexedGroups
function M.new(opts)
  return setmetatable(
    vim.tbl_extend('force', { selected_index = 1, active_indices = {}, groups = {} }, opts or {}),
    { __index = M }
  )
end

function M:get_offset_index(offset)
  return (self.selected_index + offset - 1) % #self.groups + 1
end

--- Check if a group at the given index is active
---@param index number
---@return boolean
function M:is_active(index)
  return self.active_indices[index]
end

--- Set a group as active or inactive
---@param index number
---@param active boolean
function M:set_active(index, active)
  self.active_indices[index] = active
end

--- Clear all active indices
function M:clear_active()
  self.active_indices = {}
end

return M
