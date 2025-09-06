---@class EdgyGroup.Highlights
local M = {}

local categories = {
  'Active',
  'Inactive',
  'PickActive',
  'PickInactive',
  'SeparatorActive',
  'SeparatorInactive',
}
local positions = { 'Left', 'Right', 'Bottom', 'Top' }

--- Convert PascalCase to snake_case
---@private
---@param str string input string in PascalCase
---@return string
local function to_snake_case(str)
  return str
    :gsub('(%u)', function(s)
      return '_' .. s:lower()
    end)
    :gsub('^_', '')
end

local function decapitalize(str)
  return str:sub(1, 1):lower() .. str:sub(2)
end

--- Check if a highlight group already exists (defined by colorscheme or user)
---@private
---@param group_name string
---@return boolean
local function highlight_exists(group_name)
  local exists = false
  pcall(function()
    local hl = vim.api.nvim_get_hl(0, { name = group_name })
    exists = next(hl) ~= nil
  end)
  return exists
end

--- Create a highlight link if the target group doesn't already exist
---@private
---@param from_group string
---@param to_group string
local function create_highlight_link(from_group, to_group)
  if not highlight_exists(from_group) then vim.api.nvim_set_hl(0, from_group, { link = to_group }) end
end

--- Create highlight group name with EdgyGroup prefix
--- such as 'EdgyGroupActive', 'EdgyGroupActiveLeft' or 'EdgyGroupActiveLeft1'
---@private
---@param kind string
---@param position? string
---@param level? number
---@return string
local function get_highlight_group_name(kind, position, level)
  return 'EdgyGroup' .. kind .. (position or '') .. (level or '')
end

--- Create all highlight groups and link to user-provided colors if they exist
---@private
---@param groups table<Edgy.Pos, EdgyGroup.IndexedGroups>
---@param colors EdgyGroup.Statusline.Colors
function M.set_highlight_groups(groups, colors)
  -- Create base highlight groups and link to user-provided colors if they exist
  vim.iter(categories):each(function(category)
    local group_name = get_highlight_group_name(category)
    create_highlight_link(group_name, colors[to_snake_case(category)] or 'Normal')

    -- Create position and index specific highlight groups
    vim.iter(positions):each(function(position)
      local nb_groups = #groups[decapitalize(position)].groups
      local position_group_name = get_highlight_group_name(category, position)
      create_highlight_link(position_group_name, group_name)
      vim.iter(vim.fn.range(1, nb_groups)):each(function(index)
        create_highlight_link(get_highlight_group_name(category, position, index), position_group_name)
      end)
    end)
  end)
end

--- Setup highlight groups and autocommand to reset on colorscheme change
---@public
---@param groups table<Edgy.Pos, EdgyGroup.IndexedGroups>
---@param colors EdgyGroup.Statusline.Colors
function M.setup(groups, colors)
  M.set_highlight_groups(groups, colors)

  vim.api.nvim_create_autocmd('ColorScheme', {
    callback = function()
      vim.schedule(function()
        M.set_highlight_groups(groups, colors)
      end)
    end,
  })
end

return M
