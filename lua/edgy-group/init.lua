local Config = require('edgy.config')
local Util = require('edgy.util')

-- Define groups of edgebar views by title
---@class EdgyGroups
---@field groups_by_pos table<Edgy.Pos, EdgyGroup.IndexedGroups> list of groups for each position
---@field toggle boolean close group if at least one window in the group is open
---@field pick_function? fun(key: string) override the behavior of the pick function when a key is pressed.
local M = {}

---@param opts EdgyGroup.Opts
function M.setup(opts)
  local parsed_opts = require('edgy-group.config').setup(opts)
  M.groups_by_pos = parsed_opts.groups
  M.toggle = parsed_opts.toggle
  M.pick_function = parsed_opts.statusline.pick_function
  require('edgy-group.stl').setup(parsed_opts.groups, parsed_opts.statusline)
  require('edgy-group.highlights').setup(parsed_opts.groups, parsed_opts.statusline.colors)
  require('edgy-group.commands').setup()
end

---@class EdgyGroup.Indexed
---@field position Edgy.Pos position of the group
---@field index number index of the group at position
---@field group EdgyGroup

-- Get list of EdgyGroup with position by key
---@param key string key to pick a group
---@param position? Edgy.Pos position of the group
---@return EdgyGroup.Indexed[]
function M.get_groups_by_key(key, position)
  local groups_with_pos = {}
  for pos, indexed_groups in pairs(M.groups_by_pos) do
    if position == nil or pos == position then
      for i, group in ipairs(indexed_groups.groups) do
        if group.pick_key == key then table.insert(groups_with_pos, { position = pos, group = group, index = i }) end
      end
    end
  end
  return groups_with_pos
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
-- Do not open a view if at least one window is already open
---@param pos Edgy.Pos
---@param titles string[]
function M.open_edgebar_views_by_titles(pos, titles)
  local edgebar = Config.layout[pos]
  if edgebar ~= nil then
    local views = filter_by_titles(edgebar.views, titles)
    for _, view in ipairs(views) do
      -- Skip already open views
      local is_open = vim.tbl_contains(view.wins, function(win)
        return win:is_valid()
      end, { predicate = true })
      if not is_open then open(view) end
    end
  end
end

-- Check if at least one window is open for the given position and titles
---@param pos Edgy.Pos
---@param titles string[]
---@return boolean is_open true if at least one window is open
function M.is_one_window_open(pos, titles)
  local edgebar = Config.layout[pos]
  local views = edgebar and edgebar.views or {}
  return vim.tbl_contains(filter_by_titles(views, titles), function(view)
    return vim.tbl_contains(view.wins, function(win)
      return win:is_valid()
    end, { predicate = true })
  end, { predicate = true })
end

-- Open group at index at given position
---@param pos Edgy.Pos
---@param index number Index relative to the group at given position
---@param toggle? boolean either to toggle already selected group or not
function M.open_group_index(pos, index, toggle)
  local g = M.groups_by_pos[pos]
  local indexed_group = g and g.groups[index]
  if indexed_group then
    -- Close all windows if at least one window of the currently selection group is open
    local toggle_edgebar = toggle == nil and M.toggle or toggle
    if toggle_edgebar and index == g.selected_index and M.is_one_window_open(pos, indexed_group.titles) then
      M.close_edgebar_views_by_titles(pos, indexed_group.titles)
    else
      local other_groups = vim.tbl_filter(function(group)
        return group.icon ~= indexed_group.icon
      end, g.groups)
      local other_groups_titles = vim.tbl_map(function(group)
        return group.titles
      end, other_groups)

      M.open_edgebar_views_by_titles(pos, indexed_group.titles)
      M.close_edgebar_views_by_titles(pos, vim.iter(other_groups_titles):flatten():totable())
      g.selected_index = index
    end
  end
end

-- Open group relative to the currently selected group for the given position
---@param pos Edgy.Pos
---@param offset number
function M.open_group_offset(pos, offset)
  local g = M.groups_by_pos[pos]
  if g then M.open_group_index(pos, g:get_offset_index(offset)) end
end

---@class EdgyGroup.OpenOpts
---@field position? Edgy.Pos position of the group
---@field toggle? boolean toggle a group if at least one window in the group is open

-- Open groups by key, this might open on or multiple groups sharing the same key
---@param key string
---@param opts? EdgyGroup.OpenOpts option to open a group
function M.open_groups_by_key(key, opts)
  local opts = opts or {}
  local toggle_group = opts.toggle == nil and M.toggle or opts.toggle
  vim.iter(M.get_groups_by_key(key, opts.position)):each(function(group)
    pcall(M.open_group_index, group.position, group.index, toggle_group)
  end)
end

-- Get the currently selected group for the given position
---@param pos Edgy.Pos
---@return EdgyGroup?
function M.selected(pos)
  local g = M.groups_by_pos[pos]
  return g and g:get_selected_group()
end

return M
