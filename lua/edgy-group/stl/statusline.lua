local Config = require('edgy.config')
local Group = require('edgy-group')

---@class EdgyGroup.Statusline
---@field private cache EdgyGroup.Statusline.Cache
---@field private pick_mode boolean true when pick is active, false otherwise
------@diagnostic disable-next-line: missing-fields
local M = {}

---@param groups table<Edgy.Pos, EdgyGroup.IndexedGroups>
---@param opts EdgyGroup.Statusline.Opts
function M.setup(groups, opts)
  M.cache = require('edgy-group.stl.cache').new(groups, opts)
  M.pick_mode = false
end

---@package
---@param is_visible boolean
---@return string
function M.get_highlight(is_visible)
  local highlight = is_visible and M.cache.opts.colors.active or M.cache.opts.colors.inactive
  return M.cache.opts.colored and '%#' .. highlight .. '#' or ''
end

---@package
---@param is_visible boolean
---@param position Edgy.Pos
---@param index number
function M.get_pick_text(is_visible, position, index)
  local pick = ''
  if M.pick_mode then
    local pick_per_pos = M.cache.pick_keys[position]
    local character = pick_per_pos[index] or ''
    local highlight = is_visible and M.cache.opts.colors.pick_active or M.cache.opts.colors.pick_inactive
    local pick_highlight = M.cache.opts.colored and '%#' .. highlight .. '#' or ''
    pick = pick_highlight .. character
  end
  return pick
end

-- Get a list of statusline at the given position for each group icons
-- Also provide optional highlight and click support
---@public
---@param position Edgy.Pos The position to get the statusline for
---@return table<string>
function M.get_statusline(position)
  local statusline = {}
  local edgebar = Config and Config.layout and Config.layout[position]
  local g = Group.groups_by_pos
  if edgebar then
    local indexed_groups = g and g[position] or 1
    for index, group_line in ipairs(M.cache.status_lines[position]) do
      local is_visible = edgebar.visible ~= 0 and index == indexed_groups.selected_index
      local highlight = M.get_highlight(is_visible)
      local pick = M.get_pick_text(is_visible, position, index)
      table.insert(statusline, pick .. highlight .. group_line)
    end
  end
  return statusline
end

-- Find the group position and index for the given key
---@private
---@param key string
---@return EdgyGroup.Statusline.Cache.GroupIndex?
function M.find_pos_index(key)
  return M.cache.key_to_group[key] or {}
end

-- Enable pick mode and wait for a key to be pressed
-- Redraw statusline and tabline before and after pick
-- Optional callback could be used to trigger external plugin refresh/update
---@public
---@param callback? function Callback function to call after pick mode have been enabled
M.pick = function(callback)
  M.pick_mode = true

  -- callback function before redraw
  if callback then pcall(callback) end
  vim.schedule(function()
    vim.cmd.redrawtabline()
    vim.cmd.redrawstatus()
  end)

  -- Wait for key and open the corresponding group
  local key = vim.fn.getcharstr()
  if key then
    local group_index = M.find_pos_index(key)
    if group_index then pcall(Group.open_group_index, group_index.position, group_index.index) end
  end

  -- Disable pick mode and redraw
  M.pick_mode = false
  vim.schedule(function()
    vim.cmd.redrawtabline()
    vim.cmd.redrawstatus()
  end)
end

return M
