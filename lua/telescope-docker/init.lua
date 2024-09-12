local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local config = require('telescope.config').values

local M = {}

M.show_docker_images = function(opts)
  pickers.new(opts, {
    finder = finders.new_table({
      "Yes", "No", "Maybe", "4,20:69"
    }),
    sorter = config.generic_sorter(opts),
  }):find()
  print("Showing docker images")
end

M.show_docker_images()

return M
