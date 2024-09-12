local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local previewers = require('telescope.previewers')
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
    previewer = previewers.new_buffer_previewer({
      title = "Docker Image Details",
      define_preview = function(self, entry)
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, {
          "Name: " .. entry.display,
          "Ordinal: " .. entry.ordinal,
          -- "Value: ", vim.inspect(entry),
        })
      end
    }),
  }):find()
  print("Showing docker images")
end

M.show_docker_images()

return M
