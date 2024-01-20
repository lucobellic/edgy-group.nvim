local Group = require('edgy-group')
local M = {}

function M.on_left_click(index)
  Group.open_group_index('left', index)
end

function M.on_right_click(index)
  Group.open_group_index('right', index)
end

function M.on_bottom_click(index)
  Group.open_group_index('bottom', index)
end

function M.on_top_click(index)
  Group.open_group_index('top', index)
end

return M
