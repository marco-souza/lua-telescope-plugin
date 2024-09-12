local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local config = require('telescope.config').values

local M = {}

M.show_docker_images = function(opts)
  pickers.new(opts, {
    finder = finders.new_table({
      results = {
        { name = "Brazil",    value = { 1, 2, 3, 5, 45 } },
        { name = "Peru",      value = { 1, 2, 3, 5, 45 } },
        { name = "Argentina", value = { 1, 2, 3, 5, 45 } },
      },
      entry_maker = function(entry)
        return {
          -- value = entry,
          display = entry.name, -- display key
          ordinal = entry.name, -- sorting key
        }
      end
    }),
    sorter = config.generic_sorter(opts),
  }):find()
  print("Showing docker images")
end

M.show_docker_images()

return M
