local Config = require('edgy.config')
local Util = require('edgy.util')

-- Define groups of edgebar views by title
---@class EdgyGroups
---@field groups_by_pos table<Edgy.Pos, EdgyGroup.IndexedGroups> list of groups for each position
local M = {}

---@param opts EdgyGroup.Opts
function M.setup(opts)
  local parsed_opts = require('edgy-group.config').setup(opts)
  M.groups_by_pos = parsed_opts.groups
  require('edgy-group.stl.statusline').setup(parsed_opts.groups, parsed_opts.statusline)
  require('edgy-group.commands').setup()
end

-- Filter views by title
---@param views Edgy.View[]
---@param titles string[]
---@return Edgy.View[]
local function filter_by_titles(views, titles)
  return vim.tbl_filter(function(view)
    return vim.tbl_contains(titles, view.title)
  end, views)
end

-- Open window from open function
---@param view Edgy.View
local function open(view)
  if type(view.open) == 'function' then
    Util.try(view.open)
  elseif type(view.open) == 'string' then
    Util.try(function()
      vim.cmd(view.open)
    end)
  else
    Util.error('View is pinned and has no open function')
  end
end

-- Close edgebar views for the given position and title
---@param pos Edgy.Pos
---@param titles string[]
function M.close_edgebar_views_by_titles(pos, titles)
  local edgebar = Config.layout[pos]
  if edgebar ~= nil then
    local views = filter_by_titles(edgebar.views, titles)
    for _, view in ipairs(views) do
      for _, win in ipairs(view.wins) do
        -- Hide pinned window
        if win:is_valid() then
          if win:is_pinned() then
            win:hide()
          else
            win:close()
          end
        end
      end
    end
  end
end

-- Open edgebar views for the given position and title
---@param pos Edgy.Pos
---@param titles string[]
function M.open_edgebar_views_by_titles(pos, titles)
  local edgebar = Config.layout[pos]
  if edgebar ~= nil then
    local views = filter_by_titles(edgebar.views, titles)
    for _, view in ipairs(views) do
      open(view)
    end
  end
end

-- Open group at index at given position
---@param pos Edgy.Pos
---@param index number Index relative to the group at given position
function M.open_group_index(pos, index)
  local g = M.groups_by_pos[pos]
  local indexed_group = g and g.groups[index]
  if indexed_group then
    local other_groups = vim.tbl_filter(function(group)
      return group.icon ~= indexed_group.icon
    end, g.groups)
    local other_groups_titles = vim.tbl_map(function(group)
      return group.titles
    end, other_groups)

    M.open_edgebar_views_by_titles(pos, indexed_group.titles)
    M.close_edgebar_views_by_titles(pos, vim.tbl_flatten(other_groups_titles))
    g.selected_index = index
  end
end

-- Open group relative to the currently selected group for the given position
---@param pos Edgy.Pos
---@param offset number
function M.open_group_offset(pos, offset)
  local g = M.groups_by_pos[pos]
  if g then M.open_group_index(pos, g:get_offset_index(offset)) end
end

-- Get the currently selected group for the given position
---@param pos Edgy.Pos
---@return EdgyGroup?
function M.selected(pos)
  local g = M.groups_by_pos[pos]
  return g and g:get_selected_group()
end

return M
