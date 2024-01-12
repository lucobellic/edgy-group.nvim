local M = {}

function M.setup()
  local user_command_opts = {
    nargs = 1,
    complete = function() return { 'right', 'left', 'top', 'bottom' } end,
  }

  vim.api.nvim_create_user_command(
    'EdgyGroupNext',
    function(opts) require('edgy-group').open_group(opts.args, 1) end,
    user_command_opts
  )

  vim.api.nvim_create_user_command(
    'EdgyGroupPrev',
    function(opts) require('edgy-group').open_group(opts.args, -1) end,
    user_command_opts
  )

  vim.api.nvim_create_user_command('EdgyGroupSelect', function()
    vim.ui.select(
      require('edgy-group').groups,
      {
        prompt = 'Select Edgy Group:',
        format_item = function(group)
          return group.icon .. ': ' .. group.pos .. ' - ' .. table.concat(group.titles, ', ')
        end,
        kind = 'edgy.group',
      },
      ---@param group? EdgyGroup
      function(group)
        if group then
          require('edgy-group').open_edgebar_views_by_titles(group.pos, group.titles)
        end
      end
    )
  end, {})
end

return M
