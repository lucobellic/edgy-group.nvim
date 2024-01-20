local Group = require('edgy-group')

-- TODO: Extend cache to not recompute highlight if selected_group didn't change
-- Otherwise update the statusline directly after group change

---@class EdgyGroup.Statusline.Cache
---@field opts EdgyGroup.Statusline.Opts
---@field status_lines table<Edgy.Pos, string[]>
local Cache = {}

---@param groups table<Edgy.Pos, EdgyGroup.IndexedGroups>
---@param opts EdgyGroup.Statusline.Opts
function Cache.new(groups, opts)
  local self = setmetatable({}, { __index = Cache })
  self.opts = opts
  self.status_lines = self:build_cache(groups)
  return self
end

-- Create callback function on click if clickable
---@private
---@param position Edgy.Pos
---@param index number
---@return string
function Cache:get_callback(position, index)
  local clickable = '%' .. index .. "@v:lua.require'edgy-group.stl.click'.on_" .. position .. '_click@'
  return self.opts.clickable and clickable or ''
end

---@private
---@param group EdgyGroup
function Cache:get_text(group)
  return self.opts.separators[1] .. group.icon .. self.opts.separators[2]
end

---@private
---@param position Edgy.Pos
---@param groups EdgyGroup[]
---@return string[]
function Cache:build_statusline(position, groups)
  local elements = {}
  for index, group in ipairs(groups or {}) do
    local callback = self:get_callback(position, index)
    local end_callback = self.opts.clickable and '%T' or ''
    local text = self:get_text(group)
    table.insert(elements, callback .. text .. end_callback)
  end
  return elements
end

---@private
---@param groups table<Edgy.Pos, EdgyGroup.IndexedGroups>
---@return table<Edgy.Pos, string[]>
function Cache:build_cache(groups)
  local status_lines = {}
  for _, pos in ipairs({ 'right', 'left', 'bottom', 'top' }) do
    status_lines[pos] = self:build_statusline(pos, groups[pos] and groups[pos].groups or {})
  end
  return status_lines
end

return Cache
