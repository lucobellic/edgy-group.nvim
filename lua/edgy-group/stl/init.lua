local Config = require('edgy.config')
local Group = require('edgy-group')

---@class EdgyGroup.Statusline
---@field private cache EdgyGroup.Statusline.Cache
---@field private pick_mode boolean true when pick is active, false otherwise
---@field private pick_key_pose EdgyGroup.PickKeyPose
---@diagnostic disable-next-line: missing-fields
local M = {}

---@param groups table<Edgy.Pos, EdgyGroup.IndexedGroups>
---@param opts EdgyGroup.Statusline.Opts
function M.setup(groups, opts)
  M.cache = require('edgy-group.stl.cache').new(groups, opts)
  M.pick_key_pose = opts.pick_key_pose
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
    local character = M.cache.pick_keys[position] and M.cache.pick_keys[position][index] or ''
    local highlight = is_visible and M.cache.opts.colors.pick_active or M.cache.opts.colors.pick_inactive
    local pick_highlight = M.cache.opts.colored and '%#' .. highlight .. '#' or ''
    pick = pick_highlight .. character
  end
  return pick
end

---@alias EdgyGroup.PickStatusLine function(pick: string, highlight: string, line: EdgyGroup.Statusline.Cache.Elements): string

-- Table of statusline with pick key at different position
---@private
---@type table<EdgyGroup.PickKeyPose, EdgyGroup.PickStatusLine>
local line_with_pick = {
  left = function(pick, highlight, line)
    return pick .. highlight .. line.left_sep .. line.icon .. line.right_sep
  end,
  left_separator = function(pick, highlight, line)
    return pick .. highlight .. line.icon .. line.right_sep
  end,
  icon = function(pick, highlight, line)
    return highlight .. line.left_sep .. pick .. highlight .. line.right_sep
  end,
  right_separator = function(pick, highlight, line)
    return highlight .. line.left_sep .. line.icon .. pick
  end,
  right = function(pick, highlight, line)
    return highlight .. line.left_sep .. line.icon .. line.right_sep .. pick
  end,
}

-- Get the statusline icon with optional pick key at different position
---@private
---@param pick string
---@param highlight string
---@param line EdgyGroup.Statusline.Cache.Elements
---@return string statusline_icon
function M.get_statusline_icon(pick, highlight, line)
  -- PERF: build in cache for all possible pick modes
  if not M.pick_mode then
    return highlight .. line.callback .. line.left_sep .. line.icon .. line.right_sep .. line.end_callback
  end
  -- Get the statusline for the pick key position, default to left
  local get_line_with_pick = line_with_pick[M.pick_key_pose] or line_with_pick['left']
  return get_line_with_pick(pick, highlight, line)
end

-- Get a list of statusline at the given position for each group icons
-- Also provide optional highlight and click support
---@public
---@param position Edgy.Pos The position to get the statusline for
---@return table<string>
function M.get_statusline(position)
  local statusline = {}
  local edgebar = Config and Config.layout and Config.layout[position]
  local indexed_groups = Group.groups_by_pos and Group.groups_by_pos[position]
  if edgebar and indexed_groups then
    for index, line in ipairs(M.cache.statuslines[position]) do
      local is_visible = edgebar.visible ~= 0 and index == indexed_groups.selected_index
      local highlight = M.get_highlight(is_visible)
      local pick = M.get_pick_text(is_visible, position, index)
      -- if pick is enabled, replace the left separator by the pick key
      table.insert(statusline, M.get_statusline_icon(pick, highlight, line))
    end
  end
  return statusline
end

-- Find one or multiple group positions and indices for the given key.
---@private
---@param key string
---@return EdgyGroup.Statusline.Cache.GroupIndex[]?
function M.find_pos_index(key)
  return M.cache.key_to_group[key] or {}
end

-- Enable pick mode and wait for a key to be pressed
-- Redraw statusline and tabline before and after pick
-- Optional callback could be used to trigger external plugin refresh/update
---@public
---@param callback? function Callback function to call after pick mode have been enabled
function M.pick(callback)
  M.pick_mode = true

  -- callback function before redraw
  if callback then pcall(callback) end
  vim.schedule(function()
    vim.cmd.redrawtabline()
    vim.cmd.redrawstatus()
  end)

  -- Wait for key and open the corresponding group
  local key = vim.fn.getcharstr()
  if type(Group.pick_function) == 'function' then
    Group.pick_function(key)
  elseif key then
    for _, group_index in ipairs(M.find_pos_index(key) or {}) do
      pcall(Group.open_group_index, group_index.position, group_index.index)
    end
  end

  -- Disable pick mode and redraw
  M.pick_mode = false
  vim.schedule(function()
    vim.cmd.redrawtabline()
    vim.cmd.redrawstatus()
  end)
end

return M
