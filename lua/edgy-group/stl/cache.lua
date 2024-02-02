-- TODO: Extend cache to not recompute highlight if selected_group didn't change
-- Otherwise update the statusline directly after group change

---@class EdgyGroup.Statusline.Cache.GroupIndex
---@field position Edgy.Pos
---@field index number

---@class EdgyGroup.Statusline.Cache
---@field opts EdgyGroup.Statusline.Opts
---@field status_lines table<Edgy.Pos, string[]>
---@field pick_keys table<Edgy.Pos, string[]> pick keys for each position and group
---@field key_to_group table<string, EdgyGroup.Statusline.Cache.GroupIndex[]> associates a key with one or multiple groups
local Cache = {}

---@param groups table<Edgy.Pos, EdgyGroup.IndexedGroups>
---@param opts EdgyGroup.Statusline.Opts
function Cache.new(groups, opts)
  local self = setmetatable({}, { __index = Cache })
  self.opts = opts
  self.status_lines = self:build_status_lines(groups)
  self:build_keys(groups)
  return self
end

-- Get a list of all keys not used by the user
---@private
---@param groups table<Edgy.Pos, EdgyGroup.IndexedGroups>
---@return string[] available_keys keys not used by the user
function Cache:get_available_keys(groups)
  local user_keys = {}
  for _, group in ipairs(groups) do
    if group.pick_key then table.insert(user_keys, group.pick_key) end
  end

  local pick_keys = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
  local keys_table = {}
  for i = 1, #pick_keys do
    keys_table[i] = pick_keys:sub(i, i)
  end

  return vim.tbl_filter(function(key)
    return not vim.tbl_contains(user_keys, key)
  end, keys_table)
end

-- Build picking keys for each positions and group and associate them to the group
---@private
---@param groups table<Edgy.Pos, EdgyGroup.IndexedGroups>
function Cache:build_keys(groups)
  local available_keys = self:get_available_keys(groups)
  self.pick_keys = {}
  self.key_to_group = {}

  -- Iterate over each position and group
  for _, pos in ipairs({ 'right', 'left', 'bottom', 'top' }) do
    self.pick_keys[pos] = {}
    for i, group in ipairs(groups[pos] and groups[pos].groups or {}) do
      -- Get the next available key or use the user defined one
      local key = group.pick_key or table.remove(available_keys, 1)

      -- Save the key for the group position and index
      self.pick_keys[pos][i] = key

      -- Associate the key to one or multiple group
      if not self.key_to_group[key] then self.key_to_group[key] = {} end
      table.insert(self.key_to_group[key], { position = pos, index = i })
    end
  end
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
function Cache:build_status_lines(groups)
  local status_lines = {}
  for _, pos in ipairs({ 'right', 'left', 'bottom', 'top' }) do
    status_lines[pos] = self:build_statusline(pos, groups[pos] and groups[pos].groups or {})
  end
  return status_lines
end

return Cache
