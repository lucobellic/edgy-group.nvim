local Config = require('edgy.config')
local Util = require('edgy.util')

-- Define groups of edgebar views by title
---@class EdgyGroup
---@field icon string
---@field pos Edgy.Pos
---@field titles string[]

---@class EdgyGroup.Opts
---@field groups EdgyGroup[]

---@class EdgyGroups: EdgyGroup.Opts
---@field current_group_index table<string, number> Index of the current group for each position
local M = {}
M.groups = {}
M.current_group_index = { bottom = 1, left = 1, right = 1, top = 1 }

---@param opts EdgyGroup.Opts
function M.setup(opts)
  M.groups = opts.groups or {}
  M.current_group_index = { bottom = 1, left = 1, right = 1, top = 1 }
  require('edgy-group.commands').setup()
end

-- Filter views by title
---@param views Edgy.View[]
---@param titles string[]
---@return Edgy.View[]
local function filter_by_titles(views, titles)
  return vim.tbl_filter(function(view) return vim.tbl_contains(titles, view.title) end, views)
end

-- Open window from open function
---@param view Edgy.View
local function open(view)
  if type(view.open) == 'function' then
    Util.try(view.open)
  elseif type(view.open) == 'string' then
    Util.try(function() vim.cmd(view.open) end)
  else
    Util.error('View is pinned and has no open function')
  end
end

-- Get groups for the given position
---@param pos Edgy.Pos
---@return EdgyGroup[]
local function groups_by_pos(pos)
  return vim.tbl_filter(function(group) return group.pos == pos end, M.groups)
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
        if win:is_valid() then
          win:close()
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

---@param pos Edgy.Pos
---@param offset number
function M.open_group(pos, offset)
  local group_index = M.current_group_index[pos]
  group_index = (M.current_group_index[pos] + offset - 1) % #M.groups + 1

  local selected_group = groups_by_pos(pos)[group_index]
  local other_groups = vim.tbl_filter(function(group) return group.icon ~= selected_group.icon end, M.groups)
  local other_groups_titles = vim.tbl_map(function(group) return group.titles end, other_groups)

  -- Save previous window position
  local window = vim.api.nvim_get_current_win()
  local cursor = vim.api.nvim_win_get_cursor(0)

  -- vim.notify(vim.inspect(selected_group.titles))
  M.open_edgebar_views_by_titles(pos, selected_group.titles)
  M.close_edgebar_views_by_titles(pos, vim.tbl_flatten(other_groups_titles))

  -- Restore focus to the first window
  if vim.api.nvim_win_is_valid(window) then
    vim.api.nvim_win_set_cursor(window, cursor)
  end

  M.current_group_index[pos] = group_index
end

return M
