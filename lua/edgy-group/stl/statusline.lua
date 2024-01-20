local Config = require('edgy.config')
local Group = require('edgy-group')

---@class EdgyGroup.Statusline
---@field private cache EdgyGroup.Statusline.Cache
---@diagnostic disable-next-line: missing-fields
local M = {}

---@param groups table<Edgy.Pos, EdgyGroup.IndexedGroups>
---@param opts EdgyGroup.Statusline.Opts
function M.setup(groups, opts)
  M.cache = require('edgy-group.stl.cache').new(groups, opts)
end

---@private
---@param is_visible boolean
---@return string
function M.get_highlight(is_visible)
  local highlight = is_visible and M.cache.opts.colors.active or M.cache.opts.colors.inactive
  return M.cache.opts.colored and '%#' .. highlight .. '#' or ''
end

-- Get a list of statusline at the given position for each group icons
-- Also provide optional highlight and click support
---@param position Edgy.Pos The position to get the statusline for
---@return table<string>
M.get_statusline = function(position)
  local statusline = {}
  local edgebar = Config and Config.layout and Config.layout[position]
  local g = Group.groups_by_pos
  if edgebar then
    local indexed_groups = g and g[position] or 1
    for index, group_line in ipairs(M.cache.status_lines[position]) do
      local is_visible = edgebar.visible ~= 0 and index == indexed_groups.selected_index
      local highlight = M.get_highlight(is_visible)
      table.insert(statusline, highlight .. group_line)
    end
  end
  return statusline
end

return M
